-- =============================================================
-- BAMI TOEIC - Supabase schema
-- Chạy toàn bộ file này trong Supabase Dashboard → SQL Editor → Run
-- Chạy lại nhiều lần vẫn an toàn (idempotent).
-- =============================================================

-- ---------- NỘI DUNG (đề thi) ----------

create table if not exists public.tests (
  id          uuid primary key default gen_random_uuid(),
  title       text not null unique,
  source      text,
  description text,
  created_at  timestamptz not null default now()
);

-- Nhóm câu hỏi: Part 1/2 mỗi câu 1 nhóm; Part 3/4/6/7 một nhóm = 1 đoạn hội thoại / bài đọc
create table if not exists public.question_groups (
  id         uuid primary key default gen_random_uuid(),
  test_id    uuid not null references public.tests(id) on delete cascade,
  part       smallint not null check (part between 1 and 7),
  order_no   int not null,
  passage    text,          -- đoạn văn (Part 6, 7)
  image_url  text,          -- ảnh (Part 1, biểu đồ Part 3/4/7)
  audio_url  text,          -- audio (Part 1-4)
  transcript text,          -- lời thoại, hiện khi xem lại
  unique (test_id, order_no)
);

create table if not exists public.questions (
  id          uuid primary key default gen_random_uuid(),
  test_id     uuid not null references public.tests(id) on delete cascade,
  group_id    uuid not null references public.question_groups(id) on delete cascade,
  part        smallint not null check (part between 1 and 7),
  number      int not null,                       -- số câu 1..200
  content     text,                               -- nội dung câu hỏi (Part 1, 2 có thể null)
  options     jsonb not null default '[]'::jsonb, -- ["text A", "text B", ...] (có thể rỗng cho Part 1/2)
  answer      char(1) not null check (answer in ('A','B','C','D')),
  explanation text,
  unique (test_id, number)
);
create index if not exists questions_group_idx on public.questions(group_id);

-- ---------- NỘI DUNG (từ vựng) ----------

create table if not exists public.vocab (
  id              uuid primary key default gen_random_uuid(),
  word            text not null,
  ipa             text,
  pos             text,          -- loại từ: n, v, adj...
  meaning         text not null,
  example         text,
  example_meaning text,
  topic           text not null default 'General',
  audio_url       text,
  created_at      timestamptz not null default now(),
  unique (word, topic)
);

-- ---------- DỮ LIỆU HỌC CỦA NGƯỜI DÙNG ----------

create table if not exists public.attempts (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null default auth.uid() references auth.users(id) on delete cascade,
  test_id           uuid not null references public.tests(id) on delete cascade,
  mode              text not null check (mode in ('practice','exam')),
  parts             smallint[] not null,
  started_at        timestamptz not null,
  finished_at       timestamptz not null default now(),
  total_questions   int not null,
  listening_correct int not null default 0,
  reading_correct   int not null default 0
);
create index if not exists attempts_user_idx on public.attempts(user_id, finished_at desc);

create table if not exists public.attempt_answers (
  attempt_id  uuid not null references public.attempts(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete cascade,
  chosen      char(1) check (chosen in ('A','B','C','D')),
  is_correct  boolean not null,
  primary key (attempt_id, question_id)
);

-- Lịch ôn từ vựng (thuật toán SM-2)
create table if not exists public.vocab_reviews (
  user_id          uuid not null default auth.uid() references auth.users(id) on delete cascade,
  vocab_id         uuid not null references public.vocab(id) on delete cascade,
  ease             real not null default 2.5,
  interval_days    int  not null default 0,
  repetitions      int  not null default 0,
  due_at           timestamptz not null default now(),
  last_reviewed_at timestamptz,
  primary key (user_id, vocab_id)
);

-- Thống kê độ chính xác theo Part (RLS của bảng gốc vẫn áp dụng nhờ security_invoker)
create or replace view public.part_stats with (security_invoker = true) as
select q.part,
       count(*)::int                           as total,
       count(*) filter (where aa.is_correct)::int as correct
from public.attempt_answers aa
join public.attempts a  on a.id = aa.attempt_id
join public.questions q on q.id = aa.question_id
group by q.part;

-- ---------- ROW LEVEL SECURITY ----------
-- Nội dung: mọi user đã đăng nhập được đọc/ghi (app cá nhân, đã tắt đăng ký mới).
-- Dữ liệu học: chỉ chủ sở hữu.

alter table public.tests           enable row level security;
alter table public.question_groups enable row level security;
alter table public.questions       enable row level security;
alter table public.vocab           enable row level security;
alter table public.attempts        enable row level security;
alter table public.attempt_answers enable row level security;
alter table public.vocab_reviews   enable row level security;

do $$
declare t text;
begin
  foreach t in array array['tests','question_groups','questions','vocab'] loop
    execute format('drop policy if exists "auth full access" on public.%I', t);
    execute format('create policy "auth full access" on public.%I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

drop policy if exists "own attempts" on public.attempts;
create policy "own attempts" on public.attempts for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "own attempt answers" on public.attempt_answers;
create policy "own attempt answers" on public.attempt_answers for all to authenticated
  using (exists (select 1 from public.attempts a where a.id = attempt_id and a.user_id = auth.uid()))
  with check (exists (select 1 from public.attempts a where a.id = attempt_id and a.user_id = auth.uid()));

drop policy if exists "own reviews" on public.vocab_reviews;
create policy "own reviews" on public.vocab_reviews for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------- STORAGE (audio, ảnh) ----------
-- Bucket public để app phát audio bằng URL trực tiếp; chỉ user đăng nhập mới được upload/xoá.

insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

drop policy if exists "auth upload media" on storage.objects;
create policy "auth upload media" on storage.objects for insert to authenticated
  with check (bucket_id = 'media');

drop policy if exists "auth update media" on storage.objects;
create policy "auth update media" on storage.objects for update to authenticated
  using (bucket_id = 'media');

drop policy if exists "auth delete media" on storage.objects;
create policy "auth delete media" on storage.objects for delete to authenticated
  using (bucket_id = 'media');

-- cần cho upload với upsert = true
drop policy if exists "auth read media" on storage.objects;
create policy "auth read media" on storage.objects for select to authenticated
  using (bucket_id = 'media');


-- =============================================================
-- 002 – Sổ câu sai, thẻ dạng câu hỏi, media riêng tư
-- Chạy trong Supabase → SQL Editor. Chạy lại nhiều lần vẫn an toàn.
-- =============================================================

-- Thẻ dạng câu hỏi (vd: 'word-form', 'vocabulary', 'inference', 'graphic')
alter table public.questions add column if not exists tags text[] not null default '{}';
create index if not exists questions_tags_idx on public.questions using gin (tags);

-- Nguồn lượt làm: làm đề ('test') hay luyện lại sổ câu sai ('mistakes')
alter table public.attempts add column if not exists source text not null default 'test';
alter table public.attempts drop constraint if exists attempts_source_check;
alter table public.attempts add constraint attempts_source_check check (source in ('test', 'mistakes'));

-- Lần trả lời GẦN NHẤT của mỗi câu (RLS của bảng gốc vẫn áp dụng nhờ security_invoker).
-- Câu "sai" = sai/bỏ trống ở lần gần nhất → làm đúng lần sau sẽ tự ra khỏi sổ.
drop view if exists public.latest_answers;
create view public.latest_answers with (security_invoker = true) as
select distinct on (aa.question_id)
       aa.question_id, aa.chosen, aa.is_correct, a.finished_at,
       q.test_id, q.group_id, q.part, q.number, q.tags
from public.attempt_answers aa
join public.attempts a  on a.id = aa.attempt_id
join public.questions q on q.id = aa.question_id
order by aa.question_id, a.finished_at desc;

-- Thống kê theo thẻ dạng câu
create or replace view public.tag_stats with (security_invoker = true) as
select t.tag,
       count(*)::int                                  as total,
       count(*) filter (where aa.is_correct)::int     as correct
from public.attempt_answers aa
join public.attempts a  on a.id = aa.attempt_id
join public.questions q on q.id = aa.question_id
cross join lateral unnest(q.tags) as t(tag)
group by t.tag;

-- Media riêng tư: tắt truy cập công khai; chỉ user đăng nhập đọc được
-- (policy "auth read media" cho authenticated đã có trong schema.sql).
update storage.buckets set public = false where id = 'media';

-- ---------- 003: bảng quy đổi điểm riêng từng đề ----------
alter table public.tests add column if not exists score_table jsonb;

-- ---------- 004: dữ liệu học theo user + đồng bộ nhiều máy ----------
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

-- ---------- 005: Thương Khung Bảng (bảng xếp hạng) ----------
-- • profiles: tên hiển thị + tuỳ chọn ẩn khỏi bảng. Chỉ chủ sở hữu đọc/ghi trực tiếp.
-- • leaderboard(): hàm security definer chỉ trả số liệu TỔNG HỢP (điểm full test cao nhất,
--   số câu 7 ngày) + tên hiển thị, không lộ bài làm chi tiết hay email của người khác.
-- Chạy lại nhiều lần vẫn an toàn.

create table if not exists public.profiles (
  user_id             uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  display_name        text check (char_length(trim(display_name)) between 2 and 24),
  show_on_leaderboard boolean not null default true,
  updated_at          timestamptz not null default now()
);
alter table public.profiles enable row level security;
drop policy if exists "own profile" on public.profiles;
create policy "own profile" on public.profiles for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- Quy đổi điểm 1 phần (giống ToeicScore trong lib/helper/score.dart):
-- có bảng quy đổi → điểm giữa khoảng, làm tròn 5; không có → ước tính tuyến tính.
create or replace function public.toeic_section_score(p_table jsonb, p_section text, p_correct int)
returns int language sql immutable set search_path = '' as $$
  select coalesce(
    (select (round(((r->>2)::numeric + (r->>3)::numeric) / 2 / 5) * 5)::int
       from jsonb_array_elements(
              case when jsonb_typeof(p_table -> p_section) = 'array' then p_table -> p_section
                   else '[]'::jsonb end
            ) with ordinality as e(r, i)
      where jsonb_typeof(r) = 'array' and jsonb_array_length(r) = 4
        and p_correct between (r->>0)::numeric and (r->>1)::numeric
      order by i
      limit 1),
    case when p_correct <= 0 then 5
         else least(495, greatest(5, (round(
           (p_correct * 4.9 + case when p_section = 'listening' then 10 else -5 end) / 5
         ) * 5)::int))
    end);
$$;

-- p_board: 'score' = điểm full test cao nhất; 'week' = số câu đã làm 7 ngày qua.
-- rank = null: chưa đủ dữ liệu để xếp hạng (luôn trả dòng của chính mình để hiện "Bạn").
drop function if exists public.leaderboard(text, int);
create or replace function public.leaderboard(p_board text default 'score', p_limit int default 100)
returns table (
  rank           int,
  user_id        uuid,
  display_name   text,
  is_me          boolean,
  best_score     int,
  best_listening int,
  best_reading   int,
  full_tests     int,
  week_questions int,
  week_correct   int
)
language sql stable security definer set search_path = '' as $$
  with me as (select auth.uid() as id),
  players as (
    select a.user_id from public.attempts a
    union
    select id from me where id is not null
  ),
  visible as (
    select pl.user_id,
           coalesce(nullif(trim(p.display_name), ''),
                    'Học viên ' || upper(left(pl.user_id::text, 4))) as display_name
    from players pl
    left join public.profiles p on p.user_id = pl.user_id
    where coalesce(p.show_on_leaderboard, true) or pl.user_id = (select id from me)
  ),
  full_scores as (
    select a.user_id,
           public.toeic_section_score(t.score_table, 'listening', a.listening_correct) as l,
           public.toeic_section_score(t.score_table, 'reading', a.reading_correct)     as r
    from public.attempts a
    join public.tests t on t.id = a.test_id
    where a.source <> 'mistakes' and cardinality(a.parts) = 7 and a.total_questions = 200
  ),
  best as (
    select distinct on (user_id) user_id, l, r, l + r as total,
           count(*) over (partition by user_id)::int as n
    from full_scores
    order by user_id, l + r desc
  ),
  week as (
    select user_id, sum(total_questions)::int as q,
           sum(listening_correct + reading_correct)::int as c
    from public.attempts
    where finished_at >= now() - interval '7 days'
    group by user_id
  ),
  board as (
    select v.user_id, v.display_name, v.user_id = (select id from me) as is_me,
           b.total, b.l, b.r, coalesce(b.n, 0) as n,
           coalesce(w.q, 0) as q, coalesce(w.c, 0) as c,
           case when p_board = 'week' then coalesce(w.q, 0) else coalesce(b.total, 0) end as metric,
           case when p_board = 'week' then coalesce(w.c, 0) else coalesce(b.n, 0) end as tiebreak
    from visible v
    left join best b on b.user_id = v.user_id
    left join week w on w.user_id = v.user_id
  ),
  ranked as (
    select *, case when metric > 0
                   then rank() over (order by metric > 0 desc, metric desc, tiebreak desc)::int
              end as rk
    from board
  )
  select rk, user_id, display_name, is_me, total, l, r, n, q, c
  from ranked
  where (select id from me) is not null
    and ((rk is not null and rk <= least(greatest(p_limit, 1), 200)) or is_me)
  order by rk nulls last, display_name;
$$;

revoke all on function public.leaderboard(text, int) from public, anon;
grant execute on function public.leaderboard(text, int) to authenticated;
