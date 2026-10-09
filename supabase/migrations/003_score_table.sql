-- 003: bảng quy đổi điểm riêng từng đề (E6).
-- Định dạng: {"listening": [[minĐúng, maxĐúng, minĐiểm, maxĐiểm], ...], "reading": [...]}
-- null = app dùng công thức ước tính.
alter table public.tests add column if not exists score_table jsonb;
