-- 012: Thi trực tiếp Chủ nhật + Đấu 1 vs 1.
-- Chạy trong Supabase → SQL Editor. Chạy lại nhiều lần vẫn an toàn.
-- Mọi thao tác đi qua hàm security definer: đề phát ra KHÔNG kèm đáp án, chấm điểm trên server,
-- câu đánh số 1..N thay vì id thật (khó tra ngược đáp án trong bảng questions).
-- ---------- 012: Thi Chủ nhật, Đấu 1 vs 1 ----------

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
