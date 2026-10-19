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

-- ---------- 006: Gói Free / PRO, công cụ admin, xoá tài khoản, mùa giải tuần ----------
-- • Free: đề có tests.is_free + từ vựng. PRO (hoặc admin): mọi đề.
-- • Quyền PRO nằm ở user_plans (user chỉ được ĐỌC dòng của mình); chỉ admin cấp qua admin_grant_pro().
-- • Danh sách đề (tests) ai đăng nhập cũng xem được để hiện đề bị khoá; câu hỏi / nhóm câu thì RLS chặn.
-- Chạy lại nhiều lần vẫn an toàn.

-- Vá bảo mật: cố định search_path, không cho anon gọi hàm security definer.
create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.app_admins where user_id = (select auth.uid()));
$$;
revoke all on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated;

alter function public.bump_study_day(date, int, int, int, int) set search_path = '';

-- ---------- Đề miễn phí ----------
alter table public.tests add column if not exists is_free boolean not null default false;
update public.tests set is_free = true where title = 'Sample Full Test 01 (đủ 7 Part)';

-- Số câu của đề: đếm được cả khi đề bị khoá (RLS ẩn câu hỏi). PostgREST: select=question_total
create or replace function public.question_total(t public.tests) returns int
language sql stable security definer set search_path = '' as $$
  select count(*)::int from public.questions q where q.test_id = t.id;
$$;
revoke all on function public.question_total(public.tests) from public, anon;
grant execute on function public.question_total(public.tests) to authenticated;

-- ---------- Gói ----------
create table if not exists public.user_plans (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  pro_until  timestamptz,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);
alter table public.user_plans enable row level security;
drop policy if exists "read own plan" on public.user_plans;
create policy "read own plan" on public.user_plans for select to authenticated
  using (user_id = (select auth.uid()));
-- Không có policy ghi: chỉ đổi qua admin_grant_pro().

create or replace function public.is_pro() returns boolean
language sql stable security definer set search_path = '' as $$
  select public.is_admin() or exists (
    select 1 from public.user_plans
    where user_id = (select auth.uid()) and pro_until > now()
  );
$$;
revoke all on function public.is_pro() from public, anon;
grant execute on function public.is_pro() to authenticated;

create or replace function public.my_plan()
returns table (is_pro boolean, is_admin boolean, pro_until timestamptz)
language sql stable security definer set search_path = '' as $$
  select public.is_pro(), public.is_admin(),
         (select p.pro_until from public.user_plans p where p.user_id = (select auth.uid()));
$$;
revoke all on function public.my_plan() from public, anon;
grant execute on function public.my_plan() to authenticated;

-- Câu hỏi / nhóm câu: đề miễn phí hoặc PRO mới đọc được (admin vẫn ghi qua "admin write").
do $$
declare t text;
begin
  foreach t in array array['question_groups','questions'] loop
    execute format('drop policy if exists "auth read" on public.%I', t);
    execute format('drop policy if exists "read free or pro" on public.%I', t);
    execute format($p$create policy "read free or pro" on public.%I for select to authenticated
      using ((select public.is_pro()) or test_id in (select x.id from public.tests x where x.is_free))$p$, t);
  end loop;
end $$;

-- ---------- Công cụ admin ----------
create or replace function public.admin_list_users(p_query text default null)
returns table (
  user_id         uuid,
  email           text,
  created_at      timestamptz,
  last_sign_in_at timestamptz,
  is_admin        boolean,
  pro_until       timestamptz
)
language plpgsql stable security definer set search_path = '' as $$
#variable_conflict use_column
begin
  if not public.is_admin() then
    raise exception 'Chỉ admin được dùng chức năng này' using errcode = '42501';
  end if;
  return query
    select u.id, u.email::text, u.created_at, u.last_sign_in_at,
           exists (select 1 from public.app_admins a where a.user_id = u.id),
           p.pro_until
    from auth.users u
    left join public.user_plans p on p.user_id = u.id
    where coalesce(trim(p_query), '') = ''
       or strpos(lower(u.email), lower(trim(p_query))) > 0
    order by u.created_at desc
    limit 200;
end $$;
revoke all on function public.admin_list_users(text) from public, anon;
grant execute on function public.admin_list_users(text) to authenticated;

-- Cộng thêm p_days ngày PRO (tính từ hạn hiện tại nếu còn hạn); p_days <= 0 → thu hồi ngay.
create or replace function public.admin_grant_pro(p_user_id uuid, p_days int)
returns timestamptz
language plpgsql security definer set search_path = '' as $$
declare v_until timestamptz;
begin
  if not public.is_admin() then
    raise exception 'Chỉ admin được dùng chức năng này' using errcode = '42501';
  end if;
  insert into public.user_plans as up (user_id, pro_until, updated_at, updated_by)
  values (p_user_id,
          case when p_days > 0 then now() + make_interval(days => p_days) end,
          now(), (select auth.uid()))
  on conflict (user_id) do update set
    pro_until  = case when p_days > 0
                      then greatest(now(), coalesce(up.pro_until, now())) + make_interval(days => p_days)
                 end,
    updated_at = now(),
    updated_by = (select auth.uid())
  returning up.pro_until into v_until;
  return v_until;
end $$;
revoke all on function public.admin_grant_pro(uuid, int) from public, anon;
grant execute on function public.admin_grant_pro(uuid, int) to authenticated;

-- ---------- Xoá tài khoản (Apple yêu cầu với app có đăng ký) ----------
-- Dữ liệu học có on delete cascade theo auth.users nên bị xoá theo.
create or replace function public.delete_my_account() returns void
language sql security definer set search_path = '' as $$
  delete from auth.users where id = (select auth.uid());
$$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- ---------- Thương Khung Bảng v2 ----------
-- p_board: 'score' (điểm full test cao nhất) | 'week' (số câu tuần này, tính từ thứ Hai giờ VN)
--        | 'streak' (chuỗi ngày học hiện tại).
-- last_week_rank: hạng 1–3 của mùa tuần trước (bảng 'week'), null nếu ngoài top 3.
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
  week_correct   int,
  streak         int,
  last_week_rank int
)
language sql stable security definer set search_path = '' as $$
  with me as (select auth.uid() as id),
  clock as (
    select (now() at time zone 'Asia/Ho_Chi_Minh')::date as today,
           date_trunc('week', now() at time zone 'Asia/Ho_Chi_Minh') at time zone 'Asia/Ho_Chi_Minh' as week_start
  ),
  players as (
    select a.user_id from public.attempts a
    union
    select d.user_id from public.study_days d
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
    select a.user_id,
           sum(a.total_questions) filter (where a.finished_at >= c.week_start)::int as q,
           sum(a.listening_correct + a.reading_correct)
             filter (where a.finished_at >= c.week_start)::int as c,
           sum(a.total_questions) filter (where a.finished_at < c.week_start)::int as pq,
           sum(a.listening_correct + a.reading_correct)
             filter (where a.finished_at < c.week_start)::int as pc
    from public.attempts a, clock c
    where a.finished_at >= c.week_start - interval '7 days'
    group by a.user_id
  ),
  last_week as (
    select w.user_id, rank() over (order by w.pq desc, w.pc desc)::int as rk
    from week w
    join visible v on v.user_id = w.user_id
    where w.pq > 0
  ),
  -- Ngày liên tiếp: trong 1 chuỗi, day + số thứ tự (giảm dần) là hằng số.
  active as (
    select d.user_id, d.day,
           d.day + (row_number() over (partition by d.user_id order by d.day desc))::int as grp
    from public.study_days d
    where d.questions + d.mistakes + d.words + d.dictations > 0
  ),
  streaks as (
    select s.user_id, count(*)::int as n
    from active s, clock c
    group by s.user_id, s.grp, c.today
    having max(s.day) >= c.today - 1
  ),
  board as (
    select v.user_id, v.display_name, v.user_id = (select id from me) as is_me,
           b.total, b.l, b.r, coalesce(b.n, 0) as n,
           coalesce(w.q, 0) as q, coalesce(w.c, 0) as c,
           coalesce(s.n, 0) as st,
           case when lw.rk <= 3 then lw.rk end as lwr,
           case p_board
             when 'week'   then coalesce(w.q, 0)
             when 'streak' then coalesce(s.n, 0)
             else coalesce(b.total, 0)
           end as metric,
           case p_board
             when 'week'   then coalesce(w.c, 0)
             when 'streak' then coalesce(w.q, 0)
             else coalesce(b.n, 0)
           end as tiebreak
    from visible v
    left join best b       on b.user_id = v.user_id
    left join week w       on w.user_id = v.user_id
    left join streaks s    on s.user_id = v.user_id
    left join last_week lw on lw.user_id = v.user_id
  ),
  ranked as (
    select *, case when metric > 0
                   then rank() over (order by metric > 0 desc, metric desc, tiebreak desc)::int
              end as rk
    from board
  )
  select rk, user_id, display_name, is_me, total, l, r, n, q, c, st, lwr
  from ranked
  where (select id from me) is not null
    and ((rk is not null and rk <= least(greatest(p_limit, 1), 200)) or is_me)
  order by rk nulls last, display_name;
$$;
revoke all on function public.leaderboard(text, int) from public, anon;
grant execute on function public.leaderboard(text, int) to authenticated;

-- ---------- 007: Từ vựng – chỉ admin ghi, nguồn đề ETS, "đã biết", ngày bắt đầu học ----------
-- • vocab: chỉ admin thêm/sửa/xoá (bộ chung). Từ riêng cũ (nếu có) vẫn đọc được, không tạo mới.
-- • vocab.source: "ETS 2026 Test 3 · câu 147" → bộ từ theo đề + thứ tự học theo đề.
-- • vocab_reviews.known: người học đánh dấu "đã biết" → bỏ khỏi phiên học.
-- • vocab_reviews.learned_at: lần đầu học từ (giới hạn số từ mới mỗi ngày).
-- Chạy lại nhiều lần vẫn an toàn.

alter table public.vocab add column if not exists source text;
alter table public.vocab alter column user_id drop default;

drop policy if exists "write own or admin shared" on public.vocab;
drop policy if exists "admin write vocab" on public.vocab;
create policy "admin write vocab" on public.vocab for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()) and user_id is null);

alter table public.vocab_reviews add column if not exists known boolean not null default false;
alter table public.vocab_reviews add column if not exists learned_at timestamptz not null default now();
create index if not exists vocab_reviews_vocab_idx on public.vocab_reviews (vocab_id);
-- Nguồn của bộ từ ETS 2026 được ghi bằng tool/import_vocab.dart (cột source).

-- ---------- 008: Từ điển Anh–Việt + sổ từ riêng ----------
-- • dict_entries: từ điển Anh–Việt dùng chung (~105k mục), chỉ đọc; import bằng tool/import_dictionary.dart.
--   Nguồn: skypediacode/english-vietnamese-dictionary (CC BY-SA 4.0).
-- • dict_suggest: gợi ý khi gõ (khớp đầu từ, không có thì tìm gần đúng bằng trigram).
-- • dict_lookup: tra chính xác theo danh sách dạng từ (app gửi kèm dạng gốc: invoices → invoice).
-- • vocab: user lưu từ tra được vào sổ riêng (user_id = mình, topic 'Dictionary') → ôn SRS như từ ETS.
-- Chạy lại nhiều lần vẫn an toàn.

create extension if not exists pg_trgm with schema extensions;

create table if not exists public.dict_entries (
  word_key text primary key,      -- chữ thường, dùng để tra
  word     text not null,         -- dạng hiển thị
  ipa      text,
  senses   jsonb not null         -- [{"p": "n", "m": "nghĩa", "e": "câu ví dụ"}] theo thứ tự nghĩa
);
create index if not exists dict_entries_prefix_idx on public.dict_entries (word_key text_pattern_ops);
create index if not exists dict_entries_trgm_idx on public.dict_entries using gin (word_key extensions.gin_trgm_ops);

alter table public.dict_entries enable row level security;
drop policy if exists "auth read dict" on public.dict_entries;
create policy "auth read dict" on public.dict_entries for select to authenticated using (true);
drop policy if exists "admin write dict" on public.dict_entries;
create policy "admin write dict" on public.dict_entries for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

create or replace function public.dict_suggest(p_query text, p_limit int default 20)
returns table (word text, ipa text, meaning text, fuzzy boolean)
language sql stable set search_path = public, extensions as $$
  with q as (
    select lower(btrim(regexp_replace(p_query, '\s+', ' ', 'g'))) as k,
           least(greatest(p_limit, 1), 50) as n
  ),
  prefix as (
    select e.word, e.ipa, e.senses -> 0 ->> 'm' as meaning,
           row_number() over (order by length(e.word_key), e.word_key) as ord
    from dict_entries e, q
    where q.k <> ''
      and e.word_key like replace(replace(replace(q.k, '\', '\\'), '%', '\%'), '_', '\_') || '%'
    order by length(e.word_key), e.word_key
    limit (select n from q)
  ),
  near as (
    select e.word, e.ipa, e.senses -> 0 ->> 'm' as meaning,
           row_number() over (order by similarity(e.word_key, q.k) desc, e.word_key) as ord
    from dict_entries e, q
    where length(q.k) >= 3 and not exists (select 1 from prefix) and e.word_key % q.k
    order by similarity(e.word_key, q.k) desc, e.word_key
    limit 8
  )
  select word, ipa, meaning, false from (select * from prefix order by ord) p
  union all
  select word, ipa, meaning, true from (select * from near order by ord) n;
$$;

create or replace function public.dict_lookup(p_words text[])
returns setof public.dict_entries
language sql stable set search_path = public as $$
  select * from dict_entries where word_key = any (p_words);
$$;

revoke all on function public.dict_suggest(text, int) from public, anon;
grant execute on function public.dict_suggest(text, int) to authenticated;
revoke all on function public.dict_lookup(text[]) from public, anon;
grant execute on function public.dict_lookup(text[]) to authenticated;

-- Sổ từ riêng: mỗi user thêm / sửa / xoá từ của chính mình (bộ chung vẫn chỉ admin ghi).
drop policy if exists "own words" on public.vocab;
create policy "own words" on public.vocab for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- ---------- 009: Thời gian làm bài riêng của đề ----------
-- null = app tự tính 120 phút × số câu / 200. Đặt khi đề có thời lượng riêng (vd. Quick Test 15 phút).
alter table public.tests add column if not exists time_limit_minutes int
  check (time_limit_minutes between 1 and 240);

-- ---------- 010: Bộ đề (thư viện đề ở màn chủ) ----------
-- Khoá bộ đề: 'ets-2026', 'extreme', 'quick-15', 'mini', 'listening', 'part-5'… (chữ thường, số, gạch ngang).
-- null = app tự suy ra từ source + title (lib/module/test/data/test_catalog.dart). Chạy lại nhiều lần vẫn an toàn.
alter table public.tests add column if not exists collection text
  check (collection ~ '^[a-z0-9-]+$');

update public.tests set collection = case
    when source ~ '^ETS [0-9]{4}$'                   then 'ets-' || substring(source from 5)
    when source like '%Extreme%'                     then 'extreme'
    when source like '%Quick%' or time_limit_minutes = 15 then 'quick-15'
    when source like '%Mini%' or title like 'Sample%' then 'mini'
    when title like 'Luyện nghe%'                    then 'listening'
    when title like 'Luyện Part 5%'                  then 'part-5'
    when title like 'Luyện Part 6%'                  then 'part-6'
    when title like 'Luyện Part 7%'                  then 'part-7'
  end
  where collection is null;

-- ---------- 011: Ôn câu sai theo lịch, lưu câu hỏi, nhịp làm bài ----------

-- Thời gian làm từng câu (ms). null = bài làm trước khi có tính năng này.
alter table public.attempt_answers add column if not exists time_spent_ms int
  check (time_spent_ms between 0 and 86400000);

-- Lịch ôn câu đã từng sai, tính thẳng từ lịch sử làm bài (không cần app ghi riêng):
-- • streak = số NGÀY (giờ VN) làm đúng sau lần sai gần nhất, không tính ngày làm sai;
-- • hạn ôn = lần làm gần nhất + 1 / 3 / 7 / 21 ngày theo streak 0 / 1 / 2 / ≥3;
-- • mastered khi đúng ở ≥ 3 ngày khác nhau → ra khỏi sổ câu sai.
drop view if exists public.question_reviews;
create view public.question_reviews with (security_invoker = true) as
with h as (
  select aa.question_id, aa.chosen, aa.is_correct, a.finished_at,
         (a.finished_at at time zone 'Asia/Ho_Chi_Minh')::date as day,
         row_number() over (partition by aa.question_id order by a.finished_at desc) as rn
  from public.attempt_answers aa
  join public.attempts a on a.id = aa.attempt_id
),
s as (
  select question_id,
         max(finished_at)                                  as last_at,
         max(finished_at) filter (where not is_correct)    as last_wrong_at,
         max(day)         filter (where not is_correct)    as last_wrong_day,
         bool_or(is_correct) filter (where rn = 1)         as last_correct,
         max(chosen)      filter (where rn = 1)            as chosen
  from h group by question_id
),
r as (
  select s.*,
         (select count(distinct h.day)::int from h
           where h.question_id = s.question_id and h.is_correct
             and h.finished_at > s.last_wrong_at and h.day > s.last_wrong_day) as streak
  from s
  where s.last_wrong_at is not null
)
select r.question_id, q.group_id, q.test_id, q.part, q.number, q.tags,
       r.chosen, r.last_correct as is_correct, r.last_at as finished_at,
       r.streak,
       r.last_at + case least(r.streak, 3)
                     when 0 then interval '1 day'
                     when 1 then interval '3 days'
                     when 2 then interval '7 days'
                     else interval '21 days' end as due_at,
       r.streak >= 3 as mastered
from r
join public.questions q on q.id = r.question_id;

-- Câu hỏi người học lưu lại để xem / luyện lại (riêng từng user).
create table if not exists public.saved_questions (
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, question_id)
);
alter table public.saved_questions enable row level security;
drop policy if exists "own saved questions" on public.saved_questions;
create policy "own saved questions" on public.saved_questions for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- Nhóm/đề của câu đã lưu (RLS của questions vẫn áp dụng: đề PRO bị khoá thì không thấy).
drop view if exists public.saved_question_info;
create view public.saved_question_info with (security_invoker = true) as
select s.question_id, s.created_at, q.group_id, q.test_id, q.part, q.number, q.tags
from public.saved_questions s
join public.questions q on q.id = s.question_id;

-- ---------- 012: Thi Chủ nhật, Đấu 1 vs 1 (xem migrations/012_contest_duel.sql) ----------
-- Tên hiển thị như bảng xếp hạng; người ẩn tên → "Ẩn danh" (trừ chính mình).
create or replace function public.player_name(p_user uuid)
returns text language sql stable security definer set search_path = '' as $$
  select case
    when p_user = (select auth.uid()) or coalesce(p.show_on_leaderboard, true)
      then coalesce(nullif(trim(p.display_name), ''), 'Học viên ' || upper(left(p_user::text, 4)))
    else 'Ẩn danh'
  end
  from (select 1) x
  left join public.profiles p on p.user_id = p_user;
$$;

-- Phát 1 nhóm câu (không đáp án), câu đánh số từ p_start. p_reveal: kèm transcript (xem lại).
drop function if exists public.paper_group(uuid, int);
create or replace function public.paper_group(p_group uuid, p_start int, p_reveal boolean default false)
returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object(
    'part', g.part, 'passage', g.passage, 'audio_url', g.audio_url, 'image_url', g.image_url,
    'transcript', case when p_reveal then g.transcript end,
    'questions', coalesce((
      select jsonb_agg(jsonb_build_object(
               'n', p_start + i - 1, 'part', q.part, 'content', q.content, 'options', q.options)
             order by i)
      from (select q.*, row_number() over (order by q.number) as i
              from public.questions q where q.group_id = g.id) q
    ), '[]'::jsonb))
  from public.question_groups g where g.id = p_group;
$$;

-- ===================== Thi trực tiếp Chủ nhật =====================

create table if not exists public.contests (
  id             uuid primary key default gen_random_uuid(),
  starts_at      timestamptz not null unique,
  ends_at        timestamptz not null,
  title          text not null,
  group_ids      uuid[] not null,
  question_count int not null,
  created_at     timestamptz not null default now()
);
alter table public.contests enable row level security; -- không policy: chỉ đọc qua hàm

create table if not exists public.contest_entries (
  contest_id        uuid not null references public.contests on delete cascade,
  user_id           uuid not null references auth.users on delete cascade,
  joined_at         timestamptz not null default now(),
  submitted_at      timestamptz,
  answers           jsonb not null default '{}'::jsonb, -- {"1": "A", ...}
  correct           int,
  listening_correct int,
  reading_correct   int,
  duration_ms       int,
  primary key (contest_id, user_id)
);
alter table public.contest_entries enable row level security;
drop policy if exists "read own contest entries" on public.contest_entries;
create policy "read own contest entries" on public.contest_entries
  for select using (user_id = (select auth.uid()));
create index if not exists contest_entries_user on public.contest_entries (user_id);

-- Chủ nhật 20:00 giờ VN của tuần chứa p_now; đã qua giờ kết thúc thì sang tuần sau.
create or replace function public.contest_slot(p_now timestamptz default now())
returns timestamptz language sql stable set search_path = '' as $$
  with s as (
    select (date_trunc('week', p_now at time zone 'Asia/Ho_Chi_Minh') + interval '6 days 20 hours')
             at time zone 'Asia/Ho_Chi_Minh' as t
  )
  select case when p_now > t + interval '40 minutes' then t + interval '7 days' else t end from s;
$$;

-- ~50 câu từ ngân hàng: nghe P1 3 · P2 7 · P3 3 nhóm · P4 2 nhóm, đọc P5 13 · P6 1 nhóm · P7 3 nhóm
-- ngắn. Không lặp nhóm đã dùng ở kỳ trước; thứ tự Part như đề thật.
create or replace function public.contest_pick_groups()
returns uuid[] language sql volatile security definer set search_path = '' as $$
  with used as (select unnest(group_ids) as id from public.contests),
  sized as (
    select g.id, g.part, g.audio_url, g.image_url, count(q.id)::int as n
    from public.question_groups g join public.questions q on q.group_id = g.id
    where g.id not in (select id from used)
    group by g.id
  ),
  want(part, k, min_n, max_n) as (values (1, 3, 1, 1), (2, 7, 1, 1), (3, 3, 3, 3), (4, 2, 3, 3),
                                         (5, 13, 1, 1), (6, 1, 4, 4), (7, 3, 2, 3)),
  pick as (
    select s.id, s.part, row_number() over (partition by s.part order by random()) as rn, w.k
    from sized s join want w on w.part = s.part and s.n between w.min_n and w.max_n
    where (s.part > 4 or s.audio_url is not null) and (s.part <> 1 or s.image_url is not null)
  )
  select array_agg(id order by part, rn) from pick where rn <= k;
$$;

-- Kỳ thi sắp tới / đang diễn ra (tự tạo nếu chưa có) + kỳ gần nhất đã kết thúc.
create or replace function public.contest_overview()
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare
  v_me uuid := auth.uid();
  v_slot timestamptz := public.contest_slot();
  v_groups uuid[];
  v_cur public.contests;
  v_prev public.contests;
begin
  if v_me is null then raise exception 'Cần đăng nhập' using errcode = '42501'; end if;
  select * into v_cur from public.contests where starts_at = v_slot;
  if not found then
    v_groups := public.contest_pick_groups();
    insert into public.contests (starts_at, ends_at, title, group_ids, question_count)
    values (v_slot, v_slot + interval '40 minutes',
            'Thi Chủ nhật ' || to_char(v_slot at time zone 'Asia/Ho_Chi_Minh', 'DD/MM'),
            v_groups,
            (select count(*) from public.questions where group_id = any (v_groups)))
    on conflict (starts_at) do nothing;
    select * into v_cur from public.contests where starts_at = v_slot;
  end if;
  select * into v_prev from public.contests
   where ends_at < now() order by starts_at desc limit 1;

  return jsonb_build_object(
    'server_now', now(),
    'current', (
      select jsonb_build_object(
        'id', c.id, 'title', c.title, 'starts_at', c.starts_at, 'ends_at', c.ends_at,
        'question_count', c.question_count,
        'participants', (select count(*) from public.contest_entries e where e.contest_id = c.id),
        'joined', e.user_id is not null, 'submitted', e.submitted_at is not null,
        'correct', e.correct)
      from public.contests c
      left join public.contest_entries e on e.contest_id = c.id and e.user_id = v_me
      where c.id = v_cur.id),
    'previous', case when v_prev.id is not null then (
      select jsonb_build_object(
        'id', c.id, 'title', c.title, 'starts_at', c.starts_at, 'ends_at', c.ends_at,
        'question_count', c.question_count,
        'participants', (select count(*) from public.contest_entries x
                          where x.contest_id = c.id and x.submitted_at is not null),
        'joined', e.user_id is not null, 'submitted', e.submitted_at is not null,
        'correct', e.correct)
      from public.contests c
      left join public.contest_entries e on e.contest_id = c.id and e.user_id = v_me
      where c.id = v_prev.id) end);
end $$;

-- Vào phòng thi (chỉ trong giờ thi) → trả đề không đáp án. Vào lại thì trả đề + bài đang làm.
create or replace function public.contest_join(p_contest uuid)
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare
  v_me uuid := auth.uid();
  c public.contests;
  e public.contest_entries;
  v_groups jsonb := '[]'::jsonb;
  v_n int := 1;
  g uuid;
  v_g jsonb;
begin
  select * into c from public.contests where id = p_contest;
  if not found then raise exception 'Không tìm thấy kỳ thi'; end if;
  if v_me is null then raise exception 'Cần đăng nhập' using errcode = '42501'; end if;
  if now() < c.starts_at then raise exception 'Phòng thi chưa mở'; end if;
  if now() >= c.ends_at then raise exception 'Kỳ thi đã kết thúc'; end if;
  insert into public.contest_entries (contest_id, user_id) values (c.id, v_me)
  on conflict do nothing;
  select * into e from public.contest_entries where contest_id = c.id and user_id = v_me;
  if e.submitted_at is not null then raise exception 'Bạn đã nộp bài kỳ thi này'; end if;
  foreach g in array c.group_ids loop
    v_g := public.paper_group(g, v_n);
    v_n := v_n + jsonb_array_length(v_g -> 'questions');
    v_groups := v_groups || jsonb_build_array(v_g);
  end loop;
  return jsonb_build_object('id', c.id, 'title', c.title, 'ends_at', c.ends_at,
                            'server_now', now(), 'joined_at', e.joined_at,
                            'answers', e.answers, 'groups', v_groups);
end $$;

-- Đáp án theo số câu 1..N của kỳ thi (dùng nội bộ).
create or replace function public.contest_key(p_contest uuid)
returns table (n int, question_id uuid, part int, answer text, explanation text, group_id uuid)
language sql stable security definer set search_path = '' as $$
  select (row_number() over (order by gi, q.number))::int, q.id, q.part::int, q.answer::text,
         q.explanation, q.group_id
  from public.contests c,
       unnest(c.group_ids) with ordinality as u(gid, gi)
       join public.questions q on q.group_id = u.gid
  where c.id = p_contest;
$$;
revoke execute on function public.contest_key(uuid) from public, anon, authenticated;

-- Lưu nháp đáp án trong giờ thi (thoát app vào lại không mất bài).
create or replace function public.contest_save(p_contest uuid, p_answers jsonb)
returns void language sql volatile security definer set search_path = '' as $$
  update public.contest_entries e set answers = p_answers
  from public.contests c
  where c.id = e.contest_id and e.contest_id = p_contest and e.user_id = (select auth.uid())
    and e.submitted_at is null and now() < c.ends_at + interval '2 minutes'
    and jsonb_typeof(p_answers) = 'object';
$$;

-- Nộp bài: chấm trên server. Hết giờ (kèm 2 phút trễ mạng) thì không nhận nữa.
create or replace function public.contest_submit(p_contest uuid, p_answers jsonb)
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare
  v_me uuid := auth.uid();
  c public.contests;
  e public.contest_entries;
  v_l int; v_r int;
begin
  select * into c from public.contests where id = p_contest;
  select * into e from public.contest_entries where contest_id = p_contest and user_id = v_me
    for update;
  if not found then raise exception 'Bạn chưa vào phòng thi'; end if;
  if e.submitted_at is not null then raise exception 'Bạn đã nộp bài kỳ thi này'; end if;
  if now() > c.ends_at + interval '2 minutes' then raise exception 'Đã hết giờ nộp bài'; end if;
  if jsonb_typeof(p_answers) <> 'object' then raise exception 'Bài làm không hợp lệ'; end if;

  select count(*) filter (where k.part <= 4 and upper(p_answers ->> k.n::text) = k.answer),
         count(*) filter (where k.part >= 5 and upper(p_answers ->> k.n::text) = k.answer)
    into v_l, v_r
  from public.contest_key(p_contest) k;

  update public.contest_entries set
    answers = p_answers, submitted_at = now(),
    listening_correct = v_l, reading_correct = v_r, correct = v_l + v_r,
    duration_ms = (extract(epoch from least(now(), c.ends_at) - e.joined_at) * 1000)::int
  where contest_id = p_contest and user_id = v_me;

  return jsonb_build_object('correct', v_l + v_r, 'listening_correct', v_l,
                            'reading_correct', v_r, 'question_count', c.question_count);
end $$;

-- Bảng xếp hạng (người đã nộp): đúng nhiều hơn → làm nhanh hơn. Kèm phân vị của mình.
create or replace function public.contest_board(p_contest uuid, p_limit int default 50)
returns table (rank int, display_name text, is_me boolean, correct int, duration_ms int,
               total int, percentile int)
language sql stable security definer set search_path = '' as $$
  with r as (
    select e.user_id, e.correct, e.duration_ms,
           rank() over (order by e.correct desc, e.duration_ms asc)::int as rk,
           count(*) over ()::int as n
    from public.contest_entries e
    where e.contest_id = p_contest and e.submitted_at is not null
  ),
  me as (select * from r where user_id = (select auth.uid()))
  select r.rk, public.player_name(r.user_id), r.user_id = (select auth.uid()), r.correct,
         r.duration_ms, r.n,
         -- % người thi có thứ hạng kém hơn mình
         (select case when me.n <= 1 then 100
                      else round(100.0 * (select count(*) from r x where x.rk > me.rk) / (me.n - 1))::int
                 end from me)
  from r
  where (select auth.uid()) is not null
    and (r.rk <= least(greatest(p_limit, 1), 200) or r.user_id = (select auth.uid()))
  order by r.rk, r.duration_ms;
$$;

-- Xem lại chi tiết sau khi kỳ thi kết thúc: dành cho PRO.
create or replace function public.contest_review(p_contest uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  c public.contests;
  e public.contest_entries;
  v_groups jsonb := '[]'::jsonb;
  v_n int := 1;
  g uuid;
  v_g jsonb;
begin
  select * into c from public.contests where id = p_contest;
  if not found then raise exception 'Không tìm thấy kỳ thi'; end if;
  if now() < c.ends_at then raise exception 'Kỳ thi chưa kết thúc'; end if;
  if not public.is_pro() then
    raise exception 'Xem lại chi tiết bài thi Chủ nhật dành cho tài khoản PRO' using errcode = '42501';
  end if;
  select * into e from public.contest_entries where contest_id = c.id and user_id = auth.uid();
  foreach g in array c.group_ids loop
    v_g := public.paper_group(g, v_n, true);
    v_n := v_n + jsonb_array_length(v_g -> 'questions');
    v_groups := v_groups || jsonb_build_array(v_g);
  end loop;
  return jsonb_build_object(
    'id', c.id, 'title', c.title, 'groups', v_groups,
    'answers', coalesce(e.answers, '{}'::jsonb),
    'key', (select jsonb_object_agg(k.n::text, jsonb_build_object('a', k.answer, 'e', k.explanation))
              from public.contest_key(c.id) k));
end $$;

-- ===================== Đấu 1 vs 1 =====================

create table if not exists public.duels (
  id           uuid primary key default gen_random_uuid(),
  code         text unique,          -- mã mời bạn; null = ghép ngẫu nhiên
  question_ids uuid[] not null,      -- 10 câu Part 5
  status       text not null default 'waiting'
                 check (status in ('waiting', 'active', 'finished', 'cancelled')),
  bot          boolean not null default false, -- không ai ghép → đấu với Bami Bot
  created_by   uuid not null references auth.users on delete cascade,
  created_at   timestamptz not null default now(),
  started_at   timestamptz,
  finished_at  timestamptz
);
alter table public.duels enable row level security; -- không policy: chỉ qua hàm
create index if not exists duels_waiting on public.duels (created_at) where status = 'waiting';

create table if not exists public.duel_players (
  duel_id     uuid not null references public.duels on delete cascade,
  user_id     uuid not null references auth.users on delete cascade,
  answers     jsonb not null default '{}'::jsonb, -- {"1": {"c": "A", "ok": true}}
  answered    int not null default 0,
  correct     int not null default 0,
  time_ms     int not null default 0,
  finished_at timestamptz,
  primary key (duel_id, user_id)
);
alter table public.duel_players enable row level security;
create index if not exists duel_players_user on public.duel_players (user_id);

-- Luật trận: 10 câu, tối đa 20 giây/câu, trận tự kết thúc sau 4 phút. Free 3 trận/ngày.
create or replace function public.duel_rules()
returns jsonb language sql immutable set search_path = '' as $$
  select jsonb_build_object('questions', 10, 'seconds_per_question', 20, 'max_seconds', 240,
                            'free_per_day', 3, 'bot_seconds_per_question', 9, 'bot_accuracy', 70);
$$;

create or replace function public.duel_played_today(p_user uuid)
returns int language sql stable security definer set search_path = '' as $$
  select count(*)::int from public.duel_players p join public.duels d on d.id = p.duel_id
  where p.user_id = p_user and d.started_at is not null
    and (d.started_at at time zone 'Asia/Ho_Chi_Minh')::date
        = (now() at time zone 'Asia/Ho_Chi_Minh')::date;
$$;

create or replace function public.duel_check_quota()
returns void language plpgsql stable security definer set search_path = '' as $$
begin
  if auth.uid() is null then raise exception 'Cần đăng nhập' using errcode = '42501'; end if;
  if not public.is_pro()
     and public.duel_played_today(auth.uid()) >= (public.duel_rules() ->> 'free_per_day')::int then
    raise exception 'Hôm nay bạn đã đấu đủ % trận miễn phí. Nâng cấp PRO để đấu không giới hạn.',
      public.duel_rules() ->> 'free_per_day' using errcode = 'P0001';
  end if;
end $$;

create or replace function public.duel_new(p_code text)
returns uuid language plpgsql volatile security definer set search_path = '' as $$
declare v_id uuid;
begin
  insert into public.duels (code, question_ids, created_by)
  values (p_code,
          (select array_agg(id) from (
             select q.id from public.questions q
             where q.part = 5 and q.content is not null and jsonb_array_length(q.options) = 4
             order by random() limit (public.duel_rules() ->> 'questions')::int) x),
          auth.uid())
  returning id into v_id;
  insert into public.duel_players (duel_id, user_id) values (v_id, auth.uid());
  return v_id;
end $$;
revoke execute on function public.duel_new(text) from public, anon, authenticated;

-- Ghép ngẫu nhiên: vào phòng đang chờ của người khác (≤ 30 giây), không có thì mở phòng mới.
drop function if exists public.duel_find();
create or replace function public.duel_find()
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare v_id uuid;
begin
  perform public.duel_check_quota();
  update public.duels set status = 'cancelled'
   where created_by = auth.uid() and status = 'waiting';
  select id into v_id from public.duels
   where status = 'waiting' and code is null and created_by <> auth.uid()
     and created_at > now() - interval '30 seconds'
   order by created_at limit 1
   for update skip locked;
  if v_id is not null then
    insert into public.duel_players (duel_id, user_id) values (v_id, auth.uid());
    update public.duels set status = 'active', started_at = now() + interval '3 seconds'
     where id = v_id;
    return jsonb_build_object('id', v_id);
  end if;
  return jsonb_build_object('id', public.duel_new(null));
end $$;

-- Mời bạn: tạo phòng có mã 6 ký tự, gửi link cho bạn.
create or replace function public.duel_invite()
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare v_code text; v_id uuid;
begin
  perform public.duel_check_quota();
  update public.duels set status = 'cancelled'
   where created_by = auth.uid() and status = 'waiting';
  loop
    v_code := upper(substr(translate(encode(extensions.gen_random_bytes(6), 'base64'), '+/=0O1I', ''), 1, 6));
    exit when length(v_code) = 6 and not exists (select 1 from public.duels where code = v_code);
  end loop;
  v_id := public.duel_new(v_code);
  return jsonb_build_object('id', v_id, 'code', v_code);
end $$;

drop function if exists public.duel_join(text);
create or replace function public.duel_join(p_code text)
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare d public.duels;
begin
  perform public.duel_check_quota();
  select * into d from public.duels where code = upper(trim(p_code)) for update;
  if not found then raise exception 'Mã thách đấu không đúng'; end if;
  if d.created_by = auth.uid() then return jsonb_build_object('id', d.id); end if;
  if exists (select 1 from public.duel_players where duel_id = d.id and user_id = auth.uid()) then
    return jsonb_build_object('id', d.id);
  end if;
  if d.status <> 'waiting' or d.created_at < now() - interval '30 minutes' then
    raise exception 'Lời thách đấu đã hết hạn hoặc đã có người nhận';
  end if;
  insert into public.duel_players (duel_id, user_id) values (d.id, auth.uid());
  update public.duels set status = 'active', started_at = now() + interval '3 seconds'
   where id = d.id;
  return jsonb_build_object('id', d.id);
end $$;

-- Chờ lâu không ai vào → đấu với Bami Bot (máy, ~70% đúng, 9 giây/câu).
create or replace function public.duel_vs_bot(p_duel uuid)
returns void language sql volatile security definer set search_path = '' as $$
  update public.duels set status = 'active', bot = true, started_at = now() + interval '3 seconds'
  where id = p_duel and created_by = (select auth.uid()) and status = 'waiting';
$$;

create or replace function public.duel_cancel(p_duel uuid)
returns void language sql volatile security definer set search_path = '' as $$
  update public.duels set status = 'cancelled'
  where id = p_duel and created_by = (select auth.uid()) and status = 'waiting';
$$;

-- Tiến độ của Bami Bot tính theo thời gian đã trôi (không cần tiến trình chạy nền).
create or replace function public.duel_bot_progress(d public.duels, p_at timestamptz)
returns table (answered int, correct int, time_ms int)
language sql stable set search_path = '' as $$
  with r as (select public.duel_rules() as j),
  a as (
    select least(cardinality(d.question_ids),
                 greatest(0, floor(extract(epoch from p_at - d.started_at)
                                   / (r.j ->> 'bot_seconds_per_question')::int))::int) as n,
           (r.j ->> 'bot_seconds_per_question')::int as s,
           (r.j ->> 'bot_accuracy')::int as acc
    from r
  )
  select a.n,
         (select count(*)::int from unnest(d.question_ids[1:a.n]) as q(id)
           where abs(hashtext(d.id::text || q.id::text)) % 100 < a.acc),
         a.n * a.s * 1000
  from a;
$$;

-- Trạng thái trận (gọi 1–2 giây/lần). Tự kết thúc khi cả hai xong hoặc quá 4 phút.
create or replace function public.duel_state(p_duel uuid)
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare
  v_me uuid := auth.uid();
  d public.duels;
  m public.duel_players;
  o public.duel_players;
  b record;
  v_total int;
  v_max interval := make_interval(secs => (public.duel_rules() ->> 'max_seconds')::int);
  v_opp jsonb;
  v_winner text;
  o_ans int; o_cor int; o_ms int; o_done boolean;
begin
  select * into d from public.duels where id = p_duel;
  select * into m from public.duel_players where duel_id = p_duel and user_id = v_me;
  if d.id is null or m.user_id is null then raise exception 'Không tìm thấy trận đấu'; end if;
  v_total := cardinality(d.question_ids);
  select * into o from public.duel_players where duel_id = p_duel and user_id <> v_me;

  if d.bot and d.started_at is not null then
    select * into b from public.duel_bot_progress(d, least(now(), d.started_at + v_max));
    o_ans := b.answered; o_cor := b.correct; o_ms := b.time_ms; o_done := b.answered >= v_total;
  elsif o.user_id is not null then
    o_ans := o.answered; o_cor := o.correct; o_ms := o.time_ms; o_done := o.finished_at is not null;
  end if;

  if d.status = 'active'
     and ((m.finished_at is not null and coalesce(o_done, false)) or now() > d.started_at + v_max) then
    update public.duels set status = 'finished', finished_at = now() where id = d.id
    returning * into d;
  end if;

  if d.bot or o.user_id is not null then
    v_opp := jsonb_build_object(
      'name', case when d.bot then 'Bami Bot' else public.player_name(o.user_id) end,
      'is_bot', d.bot, 'answered', o_ans, 'correct', o_cor, 'time_ms', o_ms, 'finished', o_done);
  end if;
  if d.status = 'finished' and v_opp is not null then
    v_winner := case
      when m.correct > o_cor then 'me' when m.correct < o_cor then 'opp'
      when m.answered > o_ans then 'me' when m.answered < o_ans then 'opp'
      when m.time_ms < o_ms then 'me' when m.time_ms > o_ms then 'opp'
      else 'draw' end;
  end if;

  return jsonb_build_object(
    'id', d.id, 'status', d.status, 'code', d.code, 'server_now', now(),
    'started_at', d.started_at, 'question_count', v_total, 'rules', public.duel_rules(),
    'me', jsonb_build_object('name', public.player_name(v_me), 'answered', m.answered,
                             'correct', m.correct, 'time_ms', m.time_ms,
                             'finished', m.finished_at is not null),
    'opponent', v_opp, 'winner', v_winner);
end $$;

-- Đề của trận (không đáp án), chỉ người chơi và khi trận đã bắt đầu.
create or replace function public.duel_questions(p_duel uuid)
returns jsonb language sql stable security definer set search_path = '' as $$
  select coalesce(jsonb_agg(jsonb_build_object('n', u.i, 'content', q.content, 'options', q.options)
                            order by u.i), '[]'::jsonb)
  from public.duels d
  cross join unnest(d.question_ids) with ordinality as u(qid, i)
  join public.questions q on q.id = u.qid
  where d.id = p_duel and d.status in ('active', 'finished')
    and exists (select 1 from public.duel_players p
                 where p.duel_id = d.id and p.user_id = (select auth.uid()));
$$;

-- Trả lời 1 câu: chấm ngay, trả đáp án đúng + giải thích. Mỗi câu chỉ trả lời 1 lần.
create or replace function public.duel_answer(p_duel uuid, p_n int, p_chosen text, p_ms int)
returns jsonb language plpgsql volatile security definer set search_path = '' as $$
declare
  d public.duels;
  m public.duel_players;
  q public.questions;
  v_ok boolean;
  v_cap int := (public.duel_rules() ->> 'seconds_per_question')::int * 1000;
begin
  select * into d from public.duels where id = p_duel;
  select * into m from public.duel_players where duel_id = p_duel and user_id = auth.uid() for update;
  if d.id is null or m.user_id is null then raise exception 'Không tìm thấy trận đấu'; end if;
  if p_n < 1 or p_n > cardinality(d.question_ids) then raise exception 'Câu không hợp lệ'; end if;
  select * into q from public.questions where id = d.question_ids[p_n];
  if m.answers ? p_n::text then
    return jsonb_build_object('ok', (m.answers -> p_n::text ->> 'ok')::boolean,
                              'answer', q.answer, 'explanation', q.explanation);
  end if;
  if d.status <> 'active' or now() < d.started_at
     or now() > d.started_at + make_interval(secs => (public.duel_rules() ->> 'max_seconds')::int) then
    raise exception 'Trận đấu đã kết thúc';
  end if;
  v_ok := p_chosen is not null and upper(p_chosen) = q.answer;
  update public.duel_players set
    answers  = answers || jsonb_build_object(p_n::text, jsonb_build_object('c', p_chosen, 'ok', v_ok)),
    answered = answered + 1,
    correct  = correct + v_ok::int,
    time_ms  = time_ms + least(greatest(coalesce(p_ms, v_cap), 0), v_cap),
    finished_at = case when answered + 1 >= cardinality(d.question_ids) then now() end
  where duel_id = p_duel and user_id = auth.uid();
  return jsonb_build_object('ok', v_ok, 'answer', q.answer, 'explanation', q.explanation);
end $$;

-- Thành tích đấu của mình + lượt còn lại hôm nay (null = không giới hạn).
create or replace function public.duel_stats()
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare v_w int := 0; v_l int := 0; v_d int := 0; r record;
begin
  for r in
    select m.correct as mc, m.answered as ma, m.time_ms as mt,
           coalesce(o.correct, b.correct) as oc, coalesce(o.answered, b.answered) as oa,
           coalesce(o.time_ms, b.time_ms) as ot
    from public.duel_players m
    join public.duels d on d.id = m.duel_id and d.status = 'finished'
    left join public.duel_players o on o.duel_id = d.id and o.user_id <> m.user_id
    left join lateral public.duel_bot_progress(d, d.finished_at) b on d.bot
    where m.user_id = auth.uid()
  loop
    if r.oc is null then continue; end if;
    if r.mc > r.oc or (r.mc = r.oc and (r.ma > r.oa or (r.ma = r.oa and r.mt < r.ot))) then v_w := v_w + 1;
    elsif r.mc = r.oc and r.ma = r.oa and r.mt = r.ot then v_d := v_d + 1;
    else v_l := v_l + 1; end if;
  end loop;
  return jsonb_build_object(
    'wins', v_w, 'losses', v_l, 'draws', v_d,
    'played_today', public.duel_played_today(auth.uid()),
    'left_today', case when public.is_pro() then null
                       else greatest(0, (public.duel_rules() ->> 'free_per_day')::int
                                        - public.duel_played_today(auth.uid())) end);
end $$;

-- Hàm nội bộ không cho gọi trực tiếp qua API.
revoke execute on function public.contest_pick_groups() from public, anon, authenticated;
revoke execute on function public.paper_group(uuid, int, boolean) from public, anon, authenticated;
revoke execute on function public.duel_bot_progress(public.duels, timestamptz) from public, anon, authenticated;
revoke execute on function public.duel_check_quota() from public, anon, authenticated;
revoke execute on function public.duel_played_today(uuid) from public, anon, authenticated;
revoke execute on function public.player_name(uuid) from public, anon;
-- Hàm cho app: chỉ người đã đăng nhập.
revoke execute on function public.contest_overview(), public.contest_join(uuid),
  public.contest_save(uuid, jsonb), public.contest_submit(uuid, jsonb),
  public.contest_board(uuid, int), public.contest_review(uuid),
  public.duel_find(), public.duel_invite(), public.duel_join(text), public.duel_vs_bot(uuid),
  public.duel_cancel(uuid), public.duel_state(uuid), public.duel_questions(uuid),
  public.duel_answer(uuid, int, text, int), public.duel_stats()
  from public, anon;
grant execute on function public.contest_overview(), public.contest_join(uuid),
  public.contest_save(uuid, jsonb), public.contest_submit(uuid, jsonb),
  public.contest_board(uuid, int), public.contest_review(uuid),
  public.duel_find(), public.duel_invite(), public.duel_join(text), public.duel_vs_bot(uuid),
  public.duel_cancel(uuid), public.duel_state(uuid), public.duel_questions(uuid),
  public.duel_answer(uuid, int, text, int), public.duel_stats()
  to authenticated;
