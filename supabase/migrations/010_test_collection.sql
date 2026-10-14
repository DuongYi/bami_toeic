-- 010: cột tests.collection – gán bộ đề tường minh cho thư viện đề.
-- Chạy trong Supabase → SQL Editor. Chạy lại nhiều lần vẫn an toàn.
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
