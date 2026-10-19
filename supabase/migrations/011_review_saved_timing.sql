-- 011: lịch ôn câu sai (SRS), câu hỏi đã lưu, thời gian làm từng câu.
-- Chạy trong Supabase → SQL Editor. Chạy lại nhiều lần vẫn an toàn.
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
