-- 004: dữ liệu học riêng từng user + đồng bộ nhiều máy.
--   • app_admins: chỉ admin được sửa nội dung dùng chung (đề, media, bộ từ chung)
--   • user_goals, study_days, in_progress: mục tiêu, chuỗi ngày học, bài làm dở theo user
--   • vocab.user_id: null = bộ từ chung (ETS), có giá trị = từ riêng của user đó
-- Chạy lại nhiều lần vẫn an toàn.

-- ---------- Admin ----------
create table if not exists public.app_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.app_admins enable row level security;
drop policy if exists "read self admin" on public.app_admins;
create policy "read self admin" on public.app_admins for select to authenticated
  using (user_id = auth.uid());

-- Các tài khoản ĐANG có lúc chạy migration trở thành admin (app cá nhân: chính là bạn).
-- Tài khoản tạo sau là người học thường. Thêm admin: insert into public.app_admins values ('<uuid>');
insert into public.app_admins (user_id) select id from auth.users on conflict do nothing;

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.app_admins where user_id = auth.uid());
$$;

-- Nội dung đề: ai đăng nhập cũng đọc, chỉ admin ghi
do $$
declare t text;
begin
  foreach t in array array['tests','question_groups','questions'] loop
    execute format('drop policy if exists "auth full access" on public.%I', t);
    execute format('drop policy if exists "auth read" on public.%I', t);
    execute format('drop policy if exists "admin write" on public.%I', t);
    execute format('create policy "auth read" on public.%I for select to authenticated using (true)', t);
    execute format('create policy "admin write" on public.%I for all to authenticated using (public.is_admin()) with check (public.is_admin())', t);
  end loop;
end $$;

-- Media: ai đăng nhập cũng đọc (ký URL), chỉ admin upload/sửa/xoá
drop policy if exists "auth upload media" on storage.objects;
create policy "auth upload media" on storage.objects for insert to authenticated
  with check (bucket_id = 'media' and public.is_admin());
drop policy if exists "auth update media" on storage.objects;
create policy "auth update media" on storage.objects for update to authenticated
  using (bucket_id = 'media' and public.is_admin());
drop policy if exists "auth delete media" on storage.objects;
create policy "auth delete media" on storage.objects for delete to authenticated
  using (bucket_id = 'media' and public.is_admin());

-- ---------- Từ vựng: bộ chung + từ riêng ----------
alter table public.vocab add column if not exists user_id uuid references auth.users(id) on delete cascade;
-- Từ app thêm mặc định là của người thêm; tool import gửi user_id = null để vào bộ chung.
alter table public.vocab alter column user_id set default auth.uid();
alter table public.vocab drop constraint if exists vocab_word_topic_key;
alter table public.vocab drop constraint if exists vocab_owner_word_topic_key;
alter table public.vocab add constraint vocab_owner_word_topic_key unique nulls not distinct (user_id, word, topic);
create index if not exists vocab_user_idx on public.vocab (user_id);

drop policy if exists "auth full access" on public.vocab;
drop policy if exists "read shared or own" on public.vocab;
drop policy if exists "write own or admin shared" on public.vocab;
create policy "read shared or own" on public.vocab for select to authenticated
  using (user_id is null or user_id = auth.uid());
create policy "write own or admin shared" on public.vocab for all to authenticated
  using (user_id = auth.uid() or (user_id is null and public.is_admin()))
  with check (user_id = auth.uid() or (user_id is null and public.is_admin()));

-- ---------- Mục tiêu ----------
create table if not exists public.user_goals (
  user_id          uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  target_score     int check (target_score between 10 and 990),
  exam_date        date,
  daily_questions  int not null default 20,
  daily_words      int not null default 15,
  daily_dictations int not null default 3,
  reminder_minutes int check (reminder_minutes between 0 and 1439),
  updated_at       timestamptz not null default now()
);
alter table public.user_goals enable row level security;
drop policy if exists "own goals" on public.user_goals;
create policy "own goals" on public.user_goals for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------- Nhật ký học theo ngày (chuỗi ngày, nhiệm vụ) ----------
create table if not exists public.study_days (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  day        date not null,
  questions  int not null default 0,
  mistakes   int not null default 0,
  words      int not null default 0,
  dictations int not null default 0,
  primary key (user_id, day)
);
alter table public.study_days enable row level security;
drop policy if exists "own study days" on public.study_days;
create policy "own study days" on public.study_days for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Cộng dồn nguyên tử (nhiều máy cùng ghi không đè nhau). Ngày theo giờ máy người dùng.
create or replace function public.bump_study_day(
  p_day date, p_questions int default 0, p_mistakes int default 0,
  p_words int default 0, p_dictations int default 0
) returns void language sql security invoker as $$
  insert into public.study_days (user_id, day, questions, mistakes, words, dictations)
  values (auth.uid(), p_day, p_questions, p_mistakes, p_words, p_dictations)
  on conflict (user_id, day) do update set
    questions  = study_days.questions  + excluded.questions,
    mistakes   = study_days.mistakes   + excluded.mistakes,
    words      = study_days.words      + excluded.words,
    dictations = study_days.dictations + excluded.dictations;
$$;

-- ---------- Bài làm dở ----------
create table if not exists public.in_progress (
  user_id  uuid not null default auth.uid() references auth.users(id) on delete cascade,
  test_id  uuid not null references public.tests(id) on delete cascade,
  snapshot jsonb not null,
  saved_at timestamptz not null,
  primary key (user_id, test_id)
);
alter table public.in_progress enable row level security;
drop policy if exists "own in progress" on public.in_progress;
create policy "own in progress" on public.in_progress for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
