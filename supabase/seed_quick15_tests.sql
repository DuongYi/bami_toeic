-- =================================================================
-- BAMI TOEIC: 5 BỘ ĐỀ QUICK TEST 15 PHÚT (SEED DATA)
-- Hướng dẫn: Dán toàn bộ file này vào Supabase Dashboard -> SQL Editor -> Run
-- =================================================================

BEGIN;

-- Xóa dữ liệu cũ nếu đã từng import để đảm bảo tính idempotent
DELETE FROM public.tests WHERE title LIKE 'Quick Test 15m - Đề %';

-- -------------------------------------------------------------
-- BỘ ĐỀ: Quick Test 15m - Đề 01
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  -- 1. Tạo test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Quick Test 15m - Đề 01',
    'Bami TOEIC - Quick 15m',
    'Thử thách 15 phút: 15 câu chọn lọc Part 5 (8 câu), Part 6 (4 câu), Part 7 (3 câu) rèn luyện phản xạ và tốc độ làm bài.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Tạo Group #1 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    1,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 101
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    101,
    'All expense invoices must be submitted ------- to the accounting department for prompt reimbursement.',
    '["promptly","prompt","promptness","prompted"]'::jsonb,
    'A',
    'Sau động từ bị động "must be submitted" cần một trạng từ (adverb) bổ nghĩa cho hành động nộp → chọn "promptly" (ngay lập tức, kịp thời).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #2 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    2,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 102
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    102,
    'Ms. Gomez confirmed her flight ------- for the upcoming international marketing summit in Tokyo.',
    '["reservation","reserve","reserved","reserving"]'::jsonb,
    'A',
    'Cụm danh từ "flight reservation" = việc đặt chỗ chuyến bay. Sau danh từ "flight" đóng vai trò định ngữ cần danh từ chính → "reservation".',
    ARRAY['word-form', 'vocabulary']::text[]
  );

  -- Tạo Group #3 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    3,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 103
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    103,
    'Mr. Henderson presented ------- quarterly sales report during the regional executive meeting.',
    '["he","him","his","himself"]'::jsonb,
    'C',
    'Đứng trước cụm danh từ "quarterly sales report" cần tính từ sở hữu bổ nghĩa → chọn "his" (của anh ấy).',
    ARRAY['pronoun']::text[]
  );

  -- Tạo Group #4 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    4,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 104
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    104,
    'The outdoor ribbon-cutting ceremony was delayed ------- unexpected inclement weather in the harbor area.',
    '["because","due to","although","in spite"]'::jsonb,
    'B',
    'Theo sau chỗ trống là cụm danh từ ("unexpected inclement weather") chỉ lý do → chọn giới từ "due to" (bởi vì). "Because" cần mệnh đề; "in spite" thiếu "of".',
    ARRAY['preposition']::text[]
  );

  -- Tạo Group #5 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    5,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 105
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    105,
    'Apex Solutions ------- a lucrative multi-year contract to modernize the city''s mass transit system.',
    '["was awarded","awarded","awarding","were awarded"]'::jsonb,
    'A',
    'Chủ ngữ số ít "Apex Solutions" (tên công ty) được trao hợp đồng → dùng dạng bị động số ít thì quá khứ đơn: "was awarded".',
    ARRAY['grammar']::text[]
  );

  -- Tạo Group #6 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    6,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 106
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    106,
    'To maintain customer trust, the firm needs to partner with a more ------- logistics provider.',
    '["reliable","reliant","relying","reliably"]'::jsonb,
    'A',
    'Trước danh từ "logistics provider" cần tính từ mang nghĩa "đáng tin cậy" → chọn "reliable". "Reliant" mang nghĩa phụ thuộc vào ai đó.',
    ARRAY['vocabulary', 'word-form']::text[]
  );

  -- Tạo Group #7 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    7,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 107
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    107,
    '------- the renovation budget was finalized late, the construction crew completed the lobby ahead of schedule.',
    '["Although","Despite","However","Therefore"]'::jsonb,
    'A',
    'Theo sau là mệnh đề đầy đủ (S + V) có ý nghĩa tương phản đối lập → chọn liên từ "Although" (Mặc dù). "Despite" cần danh từ/cụm danh từ.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 108
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    108,
    'The regional director commended the hospitality team for providing consistently ------- service to guests.',
    '["exceptional","exceptionally","exception","excepting"]'::jsonb,
    'A',
    'Bổ nghĩa cho danh từ "service" đứng sau và được bổ nghĩa bởi trạng từ "consistently" cần một tính từ → chọn "exceptional" (xuất sắc, đặc biệt tốt).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #9 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    9,
    'MEMORANDUM

To: All Headquarters Staff
From: Facilities & Operations
Date: October 14
Subject: Upcoming Corporate Relocation

As previously announced, our headquarters will be relocating to the new Diamond Tower complex over the upcoming weekend. The moving process will begin on Friday at 5:00 PM and continue ---(131)--- Sunday evening.

All personnel are requested to pack their desktop computers and personal belongings into the provided crates before departing on Friday. ---(132)--- by the facilities team in the third-floor conference room starting tomorrow morning.

Please note that the new building features an automated security badge system. You ---(133)--- your new access card from the reception desk upon arrival on Monday morning. We appreciate your ---(134)--- and patience during this transition.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 131
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    131,
    'Choose the best preposition to fill in blank [131].',
    '["through","across","between","among"]'::jsonb,
    'A',
    'Cụm "continue through + mốc thời gian" = tiếp diễn liên tục suốt đến tận (chủ nhật).',
    ARRAY['preposition']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["Cardboard boxes and color-coded labels will be distributed","The cafeteria menu will be upgraded next month","Parking permits must be renewed annually by all drivers","Annual vacation requests should be submitted via the portal"]'::jsonb,
    'A',
    'Câu trước nhắc đến việc nhân viên đóng gói đồ đạc ("pack their desktop computers..."), do đó câu nối phù hợp nhất là phát hộp và nhãn dán.',
    ARRAY['context']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best verb tense to fill in blank [133].',
    '["will receive","received","have received","are receiving"]'::jsonb,
    'A',
    'Diễn tả hành động sẽ xảy ra trong tương lai vào sáng thứ Hai ("on Monday morning") → chọn thì tương lai đơn "will receive".',
    ARRAY['grammar']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best word form to fill in blank [134].',
    '["cooperation","cooperate","cooperative","cooperatively"]'::jsonb,
    'A',
    'Sau tính từ sở hữu "your" và trước liên từ "and patience" (danh từ) cần một danh từ song hành → chọn "cooperation" (sự hợp tác).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #10 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    10,
    'ORDER CONFIRMATION
OfficePro Equipment Ltd.
104 Broadway, New York, NY

Order Number: OP-84920
Customer: Laura Chen, Operations Manager, Apex Design
Date: October 12

Items Ordered:
- 12 Ergonomic Mesh Office Chairs (Model EC-200): $2,400.00
- 6 Adjustable Standing Desks (Model SD-50): $1,800.00
Subtotal: $4,200.00
Corporate Discount (10% on orders over $3,000): -$420.00
Standard Delivery: Free
Total Paid: $3,780.00

Delivery Information:
Your order will be shipped via Metro Freight and is scheduled to arrive at your office on Thursday, October 16, between 9:00 AM and 1:00 PM. An authorized representative must be present to sign the delivery manifest.

Need to reschedule?
Please notify our dispatch department at support@officepro.com at least 24 hours prior to the scheduled delivery time to avoid a rescheduling fee.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 147
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    147,
    'Why was the corporate discount applied to this order?',
    '["The customer purchased standing desks","The total order value exceeded $3,000","The order was placed before October 10","The items were paid for in cash"]'::jsonb,
    'B',
    'Trong hoá đơn ghi rõ: "Corporate Discount (10% on orders over $3,000)" → đơn hàng trên 3,000 USD được giảm giá.',
    ARRAY['detail']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'What is required at the time of delivery?',
    '["Payment of remaining balance","Assembly of all office furniture","A signature from an authorized representative","Inspection by a certified technician"]'::jsonb,
    'C',
    'Văn bản nêu: "An authorized representative must be present to sign the delivery manifest."',
    ARRAY['detail']::text[]
  );
  -- Question 149
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    149,
    'What should Ms. Chen do if she wants to change the delivery date without a penalty?',
    '["Call the driver directly on Thursday morning","Email customer support at least 24 hours in advance","Return the items within 30 business days","Submit a written request by postal mail"]'::jsonb,
    'B',
    'Mục ''Need to reschedule?'' yêu cầu: "Please notify our dispatch department at support@officepro.com at least 24 hours prior to the scheduled delivery time".',
    ARRAY['inference']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Quick Test 15m - Đề 02
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  -- 1. Tạo test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Quick Test 15m - Đề 02',
    'Bami TOEIC - Quick 15m',
    'Thử thách 15 phút: 15 câu chọn lọc Part 5 (8 câu), Part 6 (4 câu), Part 7 (3 câu) chủ đề Tuyển dụng, Nhân sự & Môi trường làm việc.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Tạo Group #1 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    1,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 101
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    101,
    'All prospective candidates must review the employment policies ------- before signing the contract.',
    '["thoroughly","thorough","thoroughness","thoroughfare"]'::jsonb,
    'A',
    'Đứng sau động từ vị ngữ "review the employment policies" cần một phó từ (adverb) chỉ thể cách bổ nghĩa cho hành động xem xét → chọn "thoroughly" (một cách cẩn thận, kỹ lưỡng).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #2 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    2,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 102
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    102,
    'The Human Resources department commended Ms. Sullivan for her exceptional ------- in handling staff inquiries.',
    '["efficiency","efficient","efficiently","efficiencies"]'::jsonb,
    'A',
    'Sau tính từ "exceptional" (xuất sắc) cần một danh từ số ít / không đếm được làm tân ngữ cho giới từ "for" → chọn danh từ trừu tượng "efficiency" (sự hiệu quả).',
    ARRAY['word-form', 'vocabulary']::text[]
  );

  -- Tạo Group #3 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    3,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 103
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    103,
    'Dr. Vance offered ------- assistance to the junior researchers preparing the laboratory proposal.',
    '["she","her","herself","hers"]'::jsonb,
    'B',
    'Đứng trước danh từ "assistance" (sự giúp đỡ) cần tính từ sở hữu để bổ nghĩa → chọn "her" (của cô ấy).',
    ARRAY['pronoun']::text[]
  );

  -- Tạo Group #4 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    4,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 104
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    104,
    'The production team worked extra shifts ------- they could fulfill the overseas orders ahead of schedule.',
    '["so that","because of","in order to","as if"]'::jsonb,
    'A',
    'Sau chỗ trống là một mệnh đề hoàn chỉnh có trợ động từ ("they could fulfill...") chỉ mục đích → chọn liên từ "so that" (để mà). "In order to" theo sau bởi V nguyên mẫu.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #5 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    5,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 105
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    105,
    'Visitors must wear safety helmets and reflective vests at all times ------- the manufacturing warehouse.',
    '["throughout","between","among","against"]'::jsonb,
    'A',
    'Giới từ "throughout" + địa điểm mang nghĩa "trên khắp / trong toàn bộ khuôn viên kho sản xuất".',
    ARRAY['preposition']::text[]
  );

  -- Tạo Group #6 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    6,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 106
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    106,
    'The tech firm adopted ------- work hours to accommodate engineers commuting from suburban districts.',
    '["flexible","flexibility","flexibly","flex"]'::jsonb,
    'A',
    'Trước cụm danh từ "work hours" (giờ làm việc) cần tính từ bổ nghĩa → chọn "flexible" (linh hoạt, linh động).',
    ARRAY['word-form', 'vocabulary']::text[]
  );

  -- Tạo Group #7 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    7,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 107
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    107,
    'Should you experience system errors during the online assessment, please notify technical support -------.',
    '["immediately","frequently","mutually","rarely"]'::jsonb,
    'A',
    'Xét ngữ cảnh câu điều kiện ("nếu bạn gặp lỗi hệ thống..."), thông báo cần được gửi ngay lập tức → chọn "immediately" (ngay lập tức).',
    ARRAY['vocabulary']::text[]
  );

  -- Tạo Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 108
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    108,
    'Job applicants will not be scheduled for a formal panel interview ------- they submit verifiable references.',
    '["unless","without","despite","whereas"]'::jsonb,
    'A',
    'Theo sau là mệnh đề "they submit verifiable references" và mang nghĩa phủ định điều kiện ("trừ khi họ nộp người tham chiếu xác thực") → chọn liên từ "unless" (= if not).',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #9 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    9,
    'MEMORANDUM
To: All Department Staff
From: Eleanor Vance, Human Resources Director
Date: October 14
Subject: Staff Promotion

We are delighted to announce the promotion of Marcus Bennett to the position of Senior Marketing Strategist, effective November 1. Over the past three years, Mr. Bennett has demonstrated extraordinary creativity and initiative in spearheading our digital outreach initiatives. [131] ------- his leadership, our corporate social media engagement expanded by forty percent.

In his new capacity, Mr. Bennett will oversee all cross-regional campaigns and mentor incoming digital media associates. He will be directly [132] ------- for aligning quarterly promotional objectives with regional sales managers. [133] -------. We are confident that his analytical capabilities will continue to drive organizational growth.

Please join us in the executive lounge on Friday at 4:00 P.M. to celebrate this milestone. Light appetizers and beverages will be [134] ------- by the hospitality team.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 131
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    131,
    'Choose the best word or phrase to fill in blank [131].',
    '["Under","Above","Between","Against"]'::jsonb,
    'A',
    'Cụm thành ngữ cố định phổ biến trong TOEIC: "Under someone''s leadership" = dưới sự lãnh đạo / dẫn dắt của ai đó.',
    ARRAY['preposition']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best word to fill in blank [132].',
    '["responsible","responsibly","responsibility","response"]'::jsonb,
    'A',
    'Cấu trúc "be directly responsible for + V-ing/N": chịu trách nhiệm trực tiếp cho việc gì → chọn tính từ "responsible".',
    ARRAY['word-form']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best sentence to fill in blank [133].',
    '["He will also participate in the upcoming executive strategy retreat.","His relocation request has been postponed until next spring.","The client rejected the revised campaign proposal.","All attendees must validate their parking passes at the front desk."]'::jsonb,
    'A',
    'Câu trước nói về các nhiệm vụ mới của Marcus Bennett. Câu (A) tiếp nối mạch bổ sung trách nhiệm mới ("Anh ấy cũng sẽ tham gia kỳ hội nghị chiến lược sắp tới"). Các câu khác không liên quan hoặc mang nội dung tiêu cực/lạc đề.',
    ARRAY['context']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best form of the verb to fill in blank [134].',
    '["provided","provides","providing","provision"]'::jsonb,
    'A',
    'Cấu trúc bị động thì tương lai đơn: "will be + V3/ed" → chọn "provided" (sẽ được cung cấp bởi đội ngũ lễ tân).',
    ARRAY['grammar']::text[]
  );

  -- Tạo Group #10 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    10,
    'CRESTVIEW SOFTWARE SOLUTIONS
Career Opportunity: Senior Database Administrator
Location: Denver, Colorado (Hybrid: 2 days in-office, 3 days remote)

Position Summary:
Crestview Software Solutions is seeking an accomplished Senior Database Administrator to architect, safeguard, and scale our enterprise data infrastructure. The successful applicant will bring at least five years of hands-on experience tuning high-throughput PostgreSQL and cloud-native databases.

Core Responsibilities:
• Monitor performance metrics, implement automated query indexing, and maintain sub-second response times.
• Design robust automated backup protocols and lead semi-annual disaster recovery simulations.
• Collaborate closely with security engineers to ensure strict compliance with international privacy protocols (SOC 2, GDPR).

Required Qualifications:
• Bachelor’s degree in Computer Science, Software Engineering, or equivalent practical background.
• Minimum five years managing production relational database clusters in enterprise settings.
• Experience with container orchestration (Docker, Kubernetes) is preferred.

Compensation & Application:
We offer a competitive compensation package ($120,000–$140,000 base salary), health benefits, and a $2,500 annual education stipend. Interested professionals should submit a cover letter, an updated resume, and a project portfolio to careers@crestviewsoftware.com no later than November 20. Preliminary virtual interviews will take place during the first week of December.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 147
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    147,
    'What is the primary purpose of the notice?',
    '["To advertise an available employment position","To announce a scheduled server upgrade","To outline privacy compliance requirements","To promote an IT training certification course"]'::jsonb,
    'A',
    'Tiêu đề "Career Opportunity: Senior Database Administrator" và nội dung mô tả vị trí, trách nhiệm, phúc lợi cho thấy mục đích chính là đăng tin tuyển dụng việc làm → chọn A.',
    ARRAY['main-idea']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'What is NOT stated as a responsibility for the role?',
    '["Conducting disaster recovery tests","Optimizing database response times","Collaborating with security engineers","Designing user-facing mobile interfaces"]'::jsonb,
    'D',
    'Bài đọc liệt kê quản lý database, backup, hợp tác với security engineers; không hề đề cập đến việc thiết kế giao diện di động (mobile interfaces) → chọn D.',
    ARRAY['detail']::text[]
  );
  -- Question 149
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    149,
    'What are applicants required to submit by November 20?',
    '["A cover letter, resume, and project portfolio","Two letters of academic recommendation","A certified college diploma copy","An official background check verification"]'::jsonb,
    'A',
    'Đoạn cuối nêu rõ: "Interested professionals should submit a cover letter, an updated resume, and a project portfolio to careers@crestviewsoftware.com no later than November 20." → chọn A.',
    ARRAY['detail']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Quick Test 15m - Đề 03
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  -- 1. Tạo test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Quick Test 15m - Đề 03',
    'Bami TOEIC - Quick 15m',
    'Thử thách 15 phút: 15 câu chọn lọc Part 5 (8 câu), Part 6 (4 câu), Part 7 (3 câu) chủ đề Tiếp thị, Dịch vụ khách hàng & Hoạt động bảo trì.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Tạo Group #1 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    1,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 101
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    101,
    'Attendees found the keynote presentation on sustainable architecture extremely -------.',
    '["informative","inform","information","informatively"]'::jsonb,
    'A',
    'Cấu trúc "find + O + adj": nhận thấy cái gì như thế nào. Sau phó từ chỉ mức độ "extremely" cần tính từ → chọn "informative" (bổ ích, nhiều thông tin).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #2 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    2,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 102
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    102,
    'Registered hotel guests are entitled to a complimentary breakfast ------- every morning in the dining hall.',
    '["buffet","permit","remedy","appliance"]'::jsonb,
    'A',
    'Cụm danh từ thông dụng trong khách sạn: "breakfast buffet" = tiệc ăn sáng tự chọn. Các từ khác không phù hợp ngữ cảnh.',
    ARRAY['vocabulary']::text[]
  );

  -- Tạo Group #3 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    3,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 103
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    103,
    'Conference delegates are urged to register ------- on the official event portal prior to Friday noon.',
    '["themselves","they","them","theirs"]'::jsonb,
    'A',
    'Hành động đăng ký áp dụng lên chính chủ thể "delegates" (đại biểu tự đăng ký) → chọn đại từ phản thân "themselves".',
    ARRAY['pronoun']::text[]
  );

  -- Tạo Group #4 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    4,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 104
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    104,
    'The technical workshop was rescheduled ------- the guest lecturer experienced unexpected flight delays.',
    '["because","due to","in spite of","as though"]'::jsonb,
    'A',
    'Theo sau là một mệnh đề chỉ nguyên nhân có chủ ngữ và động từ ("the guest lecturer experienced...") → chọn liên từ "because". "Due to" chỉ đi với cụm danh từ.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #5 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    5,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 105
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    105,
    'Dedicated customer parking spaces are situated directly ------- the main supermarket entrance.',
    '["behind","into","onto","during"]'::jsonb,
    'A',
    'Vị trí không gian của bãi đậu xe so với cổng siêu thị → chọn giới từ nơi chốn "behind" (phía sau). Các giới từ khác không chỉ vị trí tĩnh phù hợp.',
    ARRAY['preposition']::text[]
  );

  -- Tạo Group #6 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    6,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 106
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    106,
    'The marketing agency submitted a revised cost ------- before commencing production on the television advertisement.',
    '["estimate","estimating","estimated","estimable"]'::jsonb,
    'A',
    'Cụm danh từ ghép "cost estimate" = bảng ước tính chi phí / dự toán chi phí. Cần danh từ sau tính từ "revised".',
    ARRAY['word-form', 'vocabulary']::text[]
  );

  -- Tạo Group #7 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    7,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 107
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    107,
    'Customer satisfaction scores have risen ------- since the company launched its 24-hour instant messaging support.',
    '["significantly","significant","significance","signify"]'::jsonb,
    'A',
    'Bổ nghĩa cho nội động từ ở thì hiện tại hoàn thành "have risen" cần phó từ (adverb) → chọn "significantly" (một cách đáng kể).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 108
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    108,
    'Both the chief executive officer ------- the board of directors endorsed the expansion strategy.',
    '["and","or","nor","but"]'::jsonb,
    'A',
    'Cặp liên từ tương quan bắt buộc: "Both A and B" = cả A và B.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #9 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    9,
    'NOTICE TO ALL SYSTEM USERS
From: IT Infrastructure Team
Date: September 5
Subject: Scheduled CRM System Maintenance

Please be advised that our central Customer Relationship Management (CRM) platform will undergo routine maintenance this Saturday, September 9, beginning at 11:00 P.M. and concluding at 4:00 A.M. on Sunday morning.

During this five-hour period, the platform will be temporarily [131] ------- to all personnel. This maintenance is essential to deploy critical security patches and enhance server performance. [132] -------. We advise all sales and support representatives to finalize and save all active transaction records before logging off on Friday afternoon.

If you require client contact records during the outage, please export the necessary files [133] ------- Saturday noon. Regular database operations will resume [134] ------- at 4:30 A.M. on Sunday.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 131
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    131,
    'Choose the best word to fill in blank [131].',
    '["inaccessible","accessible","inaccessibility","accessing"]'::jsonb,
    'A',
    'Trong thời gian bảo trì máy chủ, nền tảng sẽ tạm thời "không thể truy cập được" → chọn tính từ có tiền tố phủ định "inaccessible".',
    ARRAY['vocabulary']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["These enhancements will ensure faster query times and improved data safety.","The client rejected our proposal for the advertising campaign.","All flight reservations must be confirmed two weeks in advance.","Parking permits are available at the human resources office."]'::jsonb,
    'A',
    'Câu trước nói về mục đích nâng cấp (bảo mật và hiệu năng máy chủ). Câu (A) nối tiếp logic nêu kết quả tích cực ("Những cải tiến này sẽ đảm bảo thời gian truy vấn nhanh hơn và an toàn dữ liệu hơn").',
    ARRAY['context']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best preposition to fill in blank [133].',
    '["before","among","between","toward"]'::jsonb,
    'A',
    'Chỉ mốc thời gian hoàn thành trước khi diễn ra sự kiện → chọn "before Saturday noon" (trước trưa Thứ Bảy).',
    ARRAY['preposition']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best adverb to fill in blank [134].',
    '["promptly","prompt","prompting","promptness"]'::jsonb,
    'A',
    'Bổ nghĩa cho động từ "will resume" ở mốc thời gian cụ thể cần trạng từ → chọn "promptly" (đúng giờ, lập tức).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #10 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    10,
    'APEX AUTOMOTIVE REPAIR
Customer Feedback & Service Evaluation
Date of Service: August 18
Customer: David Miller
Vehicle: 2021 Silverton Sedan

Service Ratings:
• Punctuality: Excellent (5/5)
• Work Quality: Excellent (5/5)
• Facility Comfort: Good (3/5)
• Pricing Transparency: Excellent (5/5)

Customer Remarks:
"I brought my sedan in for the scheduled 30,000-mile inspection and front brake pad replacement. Technician Carlos did a wonderful job walking me through the rotor measurements and finished the job thirty minutes ahead of schedule. My only minor suggestion pertains to the customer lounge: seating was limited, and the guest Wi-Fi was quite spotty. Aside from that, the mechanical work was top-notch, and I will certainly return for future oil changes."

Manager Response:
Date: August 20
From: Brenda Larson, Service Manager

Dear Mr. Miller,
Thank you for sharing your experience. We are delighted that Carlos provided prompt, transparent service for your brake inspection. Regarding our waiting area, we are actually scheduled to expand the customer lounge next month with extra workstations and high-speed fiber internet. To show our appreciation for your loyalty, please present the coupon code APEX-15OFF during your next visit to receive 15% off any standard maintenance service.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 147
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    147,
    'Why did Mr. Miller bring his vehicle to Apex Automotive?',
    '["For a 30,000-mile inspection and brake pad replacement","To repair severe body damage caused by an accident","To purchase a newly released 2021 Silverton sedan","To replace an old battery and install new tires"]'::jsonb,
    'A',
    'Trong phần nhận xét của khách: "I brought my sedan in for the scheduled 30,000-mile inspection and front brake pad replacement" → chọn A.',
    ARRAY['detail']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'What area of improvement did Mr. Miller suggest?',
    '["The technician''s communication style","The customer lounge seating and wireless connection","The warranty policy on installed brake pads","The pricing of routine oil change services"]'::jsonb,
    'B',
    'Mr. Miller nhận xét: "My only minor suggestion pertains to the customer lounge: seating was limited, and the guest Wi-Fi was quite spotty" → chọn B.',
    ARRAY['detail']::text[]
  );
  -- Question 149
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    149,
    'What will Apex Automotive do next month?',
    '["Enlarge the waiting area and install faster internet","Hire additional certified automotive technicians","Permanently close the service center for remodeling","Offer complimentary rental cars to all customers"]'::jsonb,
    'A',
    'Quản lý Brenda Larson phản hồi: "we are actually scheduled to expand the customer lounge next month with extra workstations and high-speed fiber internet" → chọn A.',
    ARRAY['detail']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Quick Test 15m - Đề 04
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  -- 1. Tạo test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Quick Test 15m - Đề 04',
    'Bami TOEIC - Quick 15m',
    'Thử thách 15 phút: 15 câu chọn lọc Part 5 (8 câu), Part 6 (4 câu), Part 7 (3 câu) chủ đề Tài chính, Ngân sách, Thu mua & Hợp đồng thương mại.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Tạo Group #1 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    1,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 101
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    101,
    'All travel expense reports must be submitted for managerial ------- by the final business day of the month.',
    '["approval","approve","approving","approved"]'::jsonb,
    'A',
    'Sau tính từ "managerial" (thuộc về quản lý) cần một danh từ để tạo thành cụm danh từ "managerial approval" (sự phê duyệt của cấp quản lý) làm tân ngữ cho giới từ "for".',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #2 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    2,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 102
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    102,
    'The auditing team emphasized that all client taxation records must remain strictly -------.',
    '["confidential","confidentially","confidence","confident"]'::jsonb,
    'A',
    'Động từ liên kết "remain" đi với tính từ để chỉ trạng thái. Sau phó từ bổ nghĩa "strictly" cần tính từ mang nghĩa bảo mật → chọn "confidential" (bí mật, bảo mật).',
    ARRAY['vocabulary', 'word-form']::text[]
  );

  -- Tạo Group #3 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    3,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 103
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    103,
    'The chief financial officer reviewed the quarterly financial statements ------- before the shareholder meeting.',
    '["himself","he","his","him"]'::jsonb,
    'A',
    'Chủ ngữ là "The chief financial officer", câu đã đầy đủ chủ ngữ, động từ, tân ngữ. Cần đại từ phản thân "himself" đứng ở cuối mệnh đề để nhấn mạnh chính ông ấy làm hành động đó.',
    ARRAY['pronoun']::text[]
  );

  -- Tạo Group #4 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    4,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 104
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    104,
    'Employees will be reimbursed for conference lodging costs ------- they provide itemized original receipts.',
    '["provided that","as well as","in case of","regardless of"]'::jsonb,
    'A',
    '"Provided that" là liên từ điều kiện mang nghĩa "với điều kiện là / miễn là" theo sau là mệnh đề. Các phương án khác là giới từ / liên từ nối không phù hợp ngữ pháp.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #5 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    5,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 105
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    105,
    'Approved travel reimbursements will be deposited into employees'' bank accounts ------- ten business days.',
    '["within","among","toward","along"]'::jsonb,
    'A',
    'Giới từ "within" + khoảng thời gian ("within ten business days") biểu thị hành động diễn ra trong vòng / không quá khoảng thời gian đó.',
    ARRAY['preposition']::text[]
  );

  -- Tạo Group #6 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    6,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 106
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    106,
    'Due to recent market volatility, procurement agents are negotiating more ------- pricing agreements with vendors.',
    '["favorable","favorably","favorite","favoritism"]'::jsonb,
    'A',
    'Trước danh từ "pricing agreements" cần tính từ bổ nghĩa cho hợp đồng giá cả thuận lợi, có lợi → chọn "favorable" (thuận lợi).',
    ARRAY['word-form', 'vocabulary']::text[]
  );

  -- Tạo Group #7 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    7,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 107
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    107,
    'Corporate revenue grew ------- following the successful deployment of the cloud subscription service.',
    '["substantially","substantial","substance","substantiate"]'::jsonb,
    'A',
    'Bổ nghĩa cho nội động từ quá khứ đơn "grew" cần một phó từ (adverb) → chọn "substantially" (một cách đáng kể, vượt bậc).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 108
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    108,
    'Neither the procurement manager ------- the inventory supervisor anticipated the unexpected delivery delay.',
    '["nor","and","or","either"]'::jsonb,
    'A',
    'Cặp liên từ tương quan bắt buộc: "Neither ... nor" = Cả ... và ... đều không.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #9 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    9,
    'MEMORANDUM
To: All Department Supervisors
From: Gregory Simmons, Chief Financial Officer
Date: November 3
Subject: Updated Corporate Travel Policy

Effective December 1, all staff members traveling on corporate business must adhere strictly to our revised travel reimbursement guidelines. Under this updated protocol, all flight and hotel arrangements must be booked [131] ------- our designated corporate travel management portal to secure corporate discount rates.

Employees will no longer receive reimbursement for personal incidental charges, such as hotel mini-bar purchases or laundry services. [132] -------. Itemized expense claims, accompanied by scanned copies of official receipts, must be submitted within 14 calendar days of returning from travel.

Failure to provide documented receipts on time will lead to reimbursement [133] -------. Should you have questions regarding allowable per-diem meals, please check the intranet directory or [134] ------- the finance department directly.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 131
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    131,
    'Choose the best preposition to fill in blank [131].',
    '["through","across","between","toward"]'::jsonb,
    'A',
    'Giới từ "through" mang nghĩa "thông qua cổng thông tin / qua đối tác được chỉ định" ("through our designated corporate travel management portal").',
    ARRAY['preposition']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["Such non-essential expenses must be settled directly by the individual traveler.","Our annual product demonstration attracted hundreds of international investors.","The customer service hotline operates twenty-four hours a day.","Parking permits will be issued at the main security booth tomorrow."]'::jsonb,
    'A',
    'Câu trước nêu rõ công ty sẽ không hoàn tiền cho chi phí cá nhân (mini-bar, giặt ủi). Câu (A) nối tiếp hoàn hảo: "Các chi phí không thiết yếu như vậy phải do chính người đi công tác thanh toán trực tiếp".',
    ARRAY['context']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best word to fill in blank [133].',
    '["delays","deliberate","delayed","delaying"]'::jsonb,
    'A',
    'Sau danh từ "reimbursement" cần một danh từ để tạo thành cụm danh từ kép "reimbursement delays" (sự chậm trễ trong việc hoàn tiền).',
    ARRAY['word-form']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best form of the verb to fill in blank [134].',
    '["contact","contacting","contacted","contactable"]'::jsonb,
    'A',
    'Cấu trúc song hành với động từ nguyên mẫu đứng trước liên từ "or": "please check ... or contact ... directly".',
    ARRAY['grammar']::text[]
  );

  -- Tạo Group #10 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    10,
    'GRAND OAK CONVENTION CENTER
Event Catering Agreement & Banquet Confirmation
Client: Pinnacle Financial Group
Event: Annual Corporate Honors Banquet
Event Date: December 12
Client Contact: Ms. Rachel Adams, Events Director

Event Specifications:
• Venue: Grand Ballroom (Level 3)
• Confirmed Guests: 180 attendees
• Service Package: Executive Three-Course Plated Banquet
• Staff Setup: 4:30 P.M. | Guest Arrival: 6:00 P.M. | Meal Service: 7:00 P.M.

Financial Terms & Payment Schedule:
• Total Contract Value: $14,400 (includes catering, audio-visual suite, and 18% service gratuity)
• Initial Deposit: $4,000 (received October 5)
• Remaining Balance Due: $10,400 payable on or before November 28

Cancellation & Modification Terms:
Cancellations received at least 30 calendar days prior to December 12 will receive a full deposit refund, less a standard $250 administrative fee. Cancellations made within 30 days are non-refundable. Final meal selections and dietary requirements (vegetarian, kosher, gluten-free) must be submitted in writing to catering coordinator Mark Evans by December 1.

Authorizations:
Client Representative: Rachel Adams (Signed Oct 6)
Banquet General Manager: Teresa Moreno (Signed Oct 6)',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 147
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    147,
    'What type of event is being hosted at the Grand Oak Convention Center?',
    '["An annual corporate honors banquet","An international computer technology expo","A public shareholder voting assembly","A quarterly regional sales training workshop"]'::jsonb,
    'A',
    'Mục "Event: Annual Corporate Honors Banquet" trong hợp đồng thể hiện rõ đây là tiệc tôn vinh vinh danh doanh nghiệp hàng năm → chọn A.',
    ARRAY['detail']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'When must the remaining payment of $10,400 be settled?',
    '["On or before November 28","On October 5","By December 1","On December 12"]'::jsonb,
    'A',
    'Trong phần Financial Terms: "Remaining Balance Due: $10,400 payable on or before November 28" → chọn A.',
    ARRAY['detail']::text[]
  );
  -- Question 149
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    149,
    'What deadline is set for submitting special dietary preferences?',
    '["December 1","November 28","October 6","December 12"]'::jsonb,
    'A',
    'Đoạn Cancellation & Modification Terms: "Final meal selections and dietary requirements ... must be submitted in writing to catering coordinator Mark Evans by December 1" → chọn A.',
    ARRAY['detail']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Quick Test 15m - Đề 05
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  -- 1. Tạo test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Quick Test 15m - Đề 05',
    'Bami TOEIC - Quick 15m',
    'Thử thách 15 phút: 15 câu chọn lọc Part 5 (8 câu), Part 6 (4 câu), Part 7 (3 câu) chủ đề Vận chuyển, Chuỗi cung ứng, Kho vận & Quản lý cơ sở vật chất.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Tạo Group #1 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    1,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 101
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    101,
    'Warehouse safety regulations will be ------- enforced across all regional fulfillment centers beginning next Monday.',
    '["strictly","strict","strictness","strictest"]'::jsonb,
    'A',
    'Đứng giữa trợ động từ "will be" và phân từ hai "enforced" cần một phó từ (adverb) chỉ mức độ / thể cách → chọn "strictly" (một cách nghiêm ngặt).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #2 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    2,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 102
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    102,
    'The certified technician will ------- the automated conveyor belt before regular factory operations resume.',
    '["inspect","inspection","inspector","inspects"]'::jsonb,
    'A',
    'Sau động từ khuyết thiếu "will" cần động từ nguyên mẫu không ''to'' (bare infinitive) → chọn "inspect" (kiểm tra, thanh tra).',
    ARRAY['word-form', 'grammar']::text[]
  );

  -- Tạo Group #3 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    3,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 103
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    103,
    'Freight drivers must submit ------- daily delivery mileage logs to the fleet dispatcher every evening.',
    '["their","they","them","theirs"]'::jsonb,
    'A',
    'Đứng trước cụm danh từ "daily delivery mileage logs" cần tính từ sở hữu số nhiều tương ứng với "Freight drivers" → chọn "their" (của họ).',
    ARRAY['pronoun']::text[]
  );

  -- Tạo Group #4 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    4,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 104
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    104,
    'The cargo vessel remained docked at the terminal ------- port customs officers examined the shipping manifests.',
    '["while","during","despite","between"]'::jsonb,
    'A',
    'Theo sau là một mệnh đề ("port customs officers examined...") diễn tả hành động xảy ra đồng thời trong quá khứ → chọn liên từ thời gian "while" (trong khi). "During" chỉ đi với cụm danh từ.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #5 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    5,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 105
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    105,
    'Perishable food supplies arriving at the depot must be stored ------- designated refrigeration compartments.',
    '["inside","above","along","onto"]'::jsonb,
    'A',
    'Giới từ chỉ vị trí bên trong khoang chứa hàng / tủ đông lạnh → chọn "inside" (bên trong).',
    ARRAY['preposition']::text[]
  );

  -- Tạo Group #6 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    6,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 106
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    106,
    'Due to unexpected congestion at the seaport, customers should anticipate minor ------- in shipment deliveries.',
    '["delays","permits","supplies","receipts"]'::jsonb,
    'A',
    'Do cảng biển bị tắc nghẽn (congestion), khách hàng cần lường trước sự chậm trễ trong giao hàng → chọn danh từ phù hợp ngữ cảnh "delays" (sự chậm trễ).',
    ARRAY['vocabulary']::text[]
  );

  -- Tạo Group #7 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    7,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 107
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    107,
    'The newly installed optical sorting machines process parcel routing much more ------- than older manual systems.',
    '["efficiently","efficient","efficiency","efficacious"]'::jsonb,
    'A',
    'Bổ nghĩa cho động từ hành động "process parcel routing" ở dạng so sánh hơn ("much more ... than") cần một phó từ → chọn "efficiently" (một cách hiệu quả).',
    ARRAY['word-form']::text[]
  );

  -- Tạo Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 108
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    5,
    108,
    'Either the main logistics hub in Seattle ------- the satellite depot in Portland will fulfill the urgent component order.',
    '["or","and","nor","both"]'::jsonb,
    'A',
    'Cặp liên từ tương quan bắt buộc: "Either A or B" = Hoặc A hoặc B.',
    ARRAY['conjunction']::text[]
  );

  -- Tạo Group #9 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    9,
    'PACIFIC CARGO LOGISTICS
Customer Advisory: Shipment Tracking #PC-884920
Date: October 18
Recipient: Starlight Electronics Ltd.

Dear Valued Client,

We are writing to provide an important update regarding your shipment of precision semiconductor components (Tracking ID: PC-884920). Due to severe weather conditions along the Western Pacific maritime corridor, your container vessel was required to seek temporary anchorage outside Kaohsiung Harbor for maritime safety.

As a direct result of this necessary detour, the estimated arrival at the Port of Long Beach has been [131] ------- from October 22 to October 27. [132] -------. Our customs brokerage unit has already pre-filed all electronic import documentation to ensure cargo is discharged rapidly upon berthing.

Once the container is unloaded, our certified transport partner will deliver the freight [133] ------- to your Irvine assembly facility. We sincerely regret any inconvenience caused by this unavoidable maritime delay. For continuous real-time container updates, please log in to your account dashboard or [134] ------- with your dedicated client manager.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 131
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    131,
    'Choose the best verb form to fill in blank [131].',
    '["rescheduled","rescheduling","reschedule","reschedules"]'::jsonb,
    'A',
    'Cấu trúc bị động thì hiện tại hoàn thành: "has been + V3/ed" → chọn "rescheduled" (đã được dời lại lịch từ 22 sang 27 tháng 10).',
    ARRAY['grammar']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["We are monitoring maritime advisories closely and will alert you to further updates.","Our corporate office will host an executive banquet this weekend.","Please ensure all personal luggage is tagged before boarding the flight.","The annual software subscription fee has already been deducted."]'::jsonb,
    'A',
    'Câu trước vừa thông báo lùi ngày giao hàng do thời tiết xấu. Câu (A) nối tiếp thông tin trấn an và theo dõi tình hình vận chuyển ("Chúng tôi đang theo dõi sát sao các cảnh báo hàng hải và sẽ thông báo cho bạn nếu có cập nhật mới").',
    ARRAY['context']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best adverb to fill in blank [133].',
    '["directly","direct","direction","directness"]'::jsonb,
    'A',
    'Bổ nghĩa cho động từ "will deliver the freight" cần một phó từ chỉ cách thức → chọn "directly" (giao hàng trực tiếp tới cơ sở lắp ráp của bạn).',
    ARRAY['word-form']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best verb to fill in blank [134].',
    '["consult","consulting","consultation","consulted"]'::jsonb,
    'A',
    'Cấu trúc song hành với động từ nguyên mẫu đứng trước liên từ "or": "please log in ... or consult with ...".',
    ARRAY['grammar']::text[]
  );

  -- Tạo Group #10 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    10,
    'METRO TOWER MANAGEMENT
Tenant Advisory: Ground Lobby & Passenger Elevator Modernization
Date: July 15
To: All Building Occupants & Visitors

Please be advised that Metro Tower Management will begin comprehensive modernization work on our ground-floor entrance lobby and high-rise passenger elevator system starting Saturday, August 1.

Project Phases & Work Scope:
• Phase 1 (August 1 – August 14): Lobby flooring replacement and energy-efficient lighting installation. The main revolving entrance will be inaccessible; all tenants and guests must enter through the West Plaza side doors.
• Phase 2 (August 15 – August 31): High-rise elevator cab overhaul. Elevators 1 and 2 will be temporarily suspended, while Elevators 3 and 4 will operate express service servicing floors 12 through 25.

Noise & After-Hours Schedule:
To minimize business disruption, all noisy tile drilling and structural removal will occur strictly between 7:00 P.M. and 5:00 A.M. on weekdays, and throughout the weekend. Security officers will remain on duty at the West Plaza entrance 24 hours a day to assist guests and verify electronic access cards.

We appreciate your understanding and cooperation as we enhance our facility. For freight elevator reservations or special access inquiries, please reach out to Facilities Coordinator Samuel Rivera at srivera@metrotowermanagement.com or extension 408.',
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 147
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    147,
    'What is the primary objective of this notice?',
    '["To inform tenants about scheduled lobby and elevator renovations","To invite building occupants to an annual social reception","To announce an upcoming increase in monthly parking fees","To warn employees about unexpected electrical outages"]'::jsonb,
    'A',
    'Tiêu đề và nội dung thông báo đều tập trung vào việc hiện đại hóa sảnh chính tầng trệt và hệ thống thang máy của tòa nhà Metro Tower → chọn A.',
    ARRAY['main-idea']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'Where must tenants enter the building during Phase 1?',
    '["Through the West Plaza side doors","Through the main revolving doors","Via the underground parking loading dock","Through the temporary emergency stairwell"]'::jsonb,
    'A',
    'Trong mục Phase 1: "The main revolving entrance will be inaccessible; all tenants and guests must enter through the West Plaza side doors" → chọn A.',
    ARRAY['detail']::text[]
  );
  -- Question 149
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    149,
    'When is loud construction work scheduled to take place?',
    '["Between 7:00 P.M. and 5:00 A.M. on weekdays and on weekends","During regular weekday business hours from 9:00 A.M. to 5:00 P.M.","Only on the first Saturday of each month","During the early afternoon lunch break"]'::jsonb,
    'A',
    'Mục Noise & After-Hours Schedule: "all noisy tile drilling and structural removal will occur strictly between 7:00 P.M. and 5:00 A.M. on weekdays, and throughout the weekend" → chọn A.',
    ARRAY['detail']::text[]
  );

END $$;

COMMIT;

-- Kiểm tra lại số lượng câu hỏi và bộ đề đã thêm:
SELECT t.title, COUNT(q.id) AS total_questions
FROM public.tests t
LEFT JOIN public.questions q ON q.test_id = t.id
WHERE t.title LIKE 'Quick Test 15m - Đề %'
GROUP BY t.id, t.title
ORDER BY t.title;
