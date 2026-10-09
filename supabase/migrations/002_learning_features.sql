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
