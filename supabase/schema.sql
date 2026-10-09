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
