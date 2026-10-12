-- =================================================================
-- BAMI TOEIC: 5 BỘ ĐỀ MINI TEST 25 CÂU ĐỦ 7 PART (SEED DATA)
-- Dành cho Supabase Dashboard -> SQL Editor -> Run
-- =================================================================

BEGIN;

-- Xóa dữ liệu cũ của các đề Mini Test 25Q nếu có
DELETE FROM public.tests WHERE title LIKE 'Mini Test 25Q - Đề %';

-- -------------------------------------------------------------
-- BỘ ĐỀ: Mini Test 25Q - Đề 01
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Mini Test 25Q - Đề 01',
    'Bami TOEIC - Mini Test 25Q',
    'Đề thi 25 câu rút gọn chuẩn format TOEIC, bao quát cả 7 phần: Nghe hiểu tranh ảnh, Hỏi đáp, Hội thoại, Độc thoại & Đọc hiểu ngữ pháp, đoạn văn.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Group #1 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    1,
    NULL,
    '(A) A woman is organizing files in a cabinet. (B) A laptop has been left open on a wooden desk. (C) Some armchairs are arranged around a rug. (D) A coffee cup is being cleaned in the sink.',
    'tests/mini_test01/p1_q1.m4a',
    'tests/mini_test01/p1_q1.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 1
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    1,
    'Choose the statement that best describes the picture.',
    '["A woman is organizing files in a cabinet.","A laptop has been left open on a wooden desk.","Some armchairs are arranged around a rug.","A coffee cup is being cleaned in the sink."]'::jsonb,
    'B',
    'Trong bức tranh miêu tả một chiếc máy tính xách tay đang mở trên bàn gỗ cùng một tách cà phê và chậu cây nhỏ → Chọn (B).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #2 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    2,
    NULL,
    '(A) Several bicycles are parked in front of a wooden fence. (B) A cyclist is pedaling down a busy avenue. (C) Vehicles are waiting at a traffic intersection. (D) A wooden barrier is being constructed by carpenters.',
    'tests/mini_test01/p1_q2.m4a',
    'tests/mini_test01/p1_q2.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 2
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    2,
    'Choose the statement that best describes the picture.',
    '["Several bicycles are parked in front of a wooden fence.","A cyclist is pedaling down a busy avenue.","Vehicles are waiting at a traffic intersection.","A wooden barrier is being constructed by carpenters."]'::jsonb,
    'A',
    'Những chiếc xe đạp được xếp thành hàng phía trước hàng rào gỗ → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #3 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    3,
    NULL,
    'M: Where is the annual shareholder meeting taking place this year?
W: (A) In the third-floor auditorium. (B) Yes, every twelve months. (C) Mr. Davis delivered a great talk.',
    'tests/mini_test01/p2_q7.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 7
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    7,
    'Where is the annual shareholder meeting taking place this year?',
    '["In the third-floor auditorium.","Yes, every twelve months.","Mr. Davis delivered a great talk."]'::jsonb,
    'A',
    'Câu hỏi bắt đầu bằng "Where" hỏi địa điểm → phương án chỉ nơi chốn (A) "In the third-floor auditorium" là đáp án chính xác.',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #4 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    4,
    NULL,
    'W: When will the updated project schedule be distributed to the team?
M: (A) Across the street from the clinic. (B) Later this afternoon by email. (C) Thirty team members in total.',
    'tests/mini_test01/p2_q8.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 8
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    8,
    'When will the updated project schedule be distributed to the team?',
    '["Across the street from the clinic.","Later this afternoon by email.","Thirty team members in total."]'::jsonb,
    'B',
    'Câu hỏi bắt đầu bằng "When" hỏi thời gian hoàn thành → chọn (B) "Later this afternoon by email".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #5 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    5,
    NULL,
    'M: Would you like me to book your train tickets for the regional conference?
W: (A) Thanks, but I have already arranged them. (B) The express train was delayed. (C) Yes, at station platform three.',
    'tests/mini_test01/p2_q9.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 9
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    9,
    'Would you like me to book your train tickets for the regional conference?',
    '["Thanks, but I have already arranged them.","The express train was delayed.","Yes, at station platform three."]'::jsonb,
    'A',
    'Lời đề nghị giúp đỡ "Would you like me to..." → phản hồi lịch sự từ chối khéo (A) "Cảm ơn, nhưng tôi đã tự thu xếp rồi".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #6 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    3,
    6,
    NULL,
    'W: Good morning, Robert. Has the logistics company delivered our shipment of promotional brochures yet? The marketing expo starts tomorrow morning.
M: I checked with the front desk ten minutes ago, Brenda, and the delivery driver said the truck was caught in severe highway traffic. They expect to arrive by 2:00 P.M.
W: That gives us very little time to assemble the welcome packets before our booth opens.
M: Don''t worry. I will ask two interns from human resources to help us organize and fold the materials as soon as the boxes arrive.',
    'tests/mini_test01/p3_q32-34.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 32
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    32,
    'What problem are the speakers discussing?',
    '["A shipment of promotional brochures is delayed.","An exhibition booth reservation was cancelled.","A presentation room is too small for attendees.","The budget for marketing materials was cut."]'::jsonb,
    'A',
    'Người phụ nữ hỏi về tài liệu quảng cáo và người nam giải thích xe tải giao hàng bị kẹt xe trên cao tốc đến 2h chiều mới tới → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 33
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    33,
    'When does the marketing expo begin?',
    '["This afternoon at 2:00 P.M.","Tomorrow morning","Next Monday","At the end of this month"]'::jsonb,
    'B',
    'Người phụ nữ nói: "The marketing expo starts tomorrow morning" → Chọn (B).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 34
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    34,
    'How does the man propose to solve the schedule problem?',
    '["By printing new brochures in the office","By rescheduling the client presentation","By recruiting interns to help assemble packets","By contacting a different shipping vendor"]'::jsonb,
    'C',
    'Người nam nói: "I will ask two interns from human resources to help us organize and fold the materials..." → Chọn (C).',
    ARRAY['listening', 'conversation']::text[]
  );

  -- Group #7 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    4,
    7,
    NULL,
    'Attention all transit passengers traveling on the Silverline Express to Riverside Station. We regret to inform you that track maintenance between Oakfield and Pinecrest will temporarily suspend through-train service this weekend, starting Saturday at 6:00 A.M. Complimentary shuttle buses will operate outside Oakfield Station every ten minutes to transport passengers directly to Pinecrest. Standard train service will resume regular operations on Monday morning at 5:00 A.M. For real-time updates and alternative route suggestions, please visit our official website at www.metrorail.org or speak with a station agent.',
    'tests/mini_test01/p4_q71-73.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 71
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    71,
    'Where is this announcement most likely being broadcast?',
    '["Inside an airport departure lounge","At a passenger train station","At an automotive repair center","Inside a regional ferry terminal"]'::jsonb,
    'B',
    'Thông báo nhắc tới "transit passengers", "Silverline Express", "track maintenance", "train service" → phát tại ga tàu hỏa (B).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 72
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    72,
    'What will occur this weekend?',
    '["Train ticket fares will increase by five percent.","Train service between two stations will be temporarily suspended.","A new express route to Riverside will open.","Station parking lots will be closed for repaving."]'::jsonb,
    'B',
    'Thông báo nói: "track maintenance between Oakfield and Pinecrest will temporarily suspend through-train service this weekend" → Chọn (B).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 73
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    73,
    'What alternative transportation is provided for passengers?',
    '["Free shuttle buses every ten minutes","Discounted taxi vouchers","Bicycle rental stations","Ferry transit vouchers"]'::jsonb,
    'A',
    'Thông báo nêu: "Complimentary shuttle buses will operate outside Oakfield Station every ten minutes..." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );

  -- Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
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
    'All invoice receipts must be forwarded ------- to the accounts payable division to ensure prompt processing.',
    '["promptly","prompt","promptness","prompted"]'::jsonb,
    'A',
    'Bổ nghĩa cho động từ thể bị động "must be forwarded" cần một trạng từ chỉ cách thức → chọn "promptly" (kịp thời, ngay lập tức).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #9 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    9,
    NULL,
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
    'Ms. Kowalski demonstrated remarkable ------- when resolving the overseas client''s shipping dispute.',
    '["professionalism","professionally","professional","profess"]'::jsonb,
    'A',
    'Sau tính từ "remarkable" cần một danh từ làm tân ngữ cho động từ "demonstrated" → chọn danh từ "professionalism" (tác phong chuyên nghiệp).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #10 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    10,
    NULL,
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
    'Dr. Chen scheduled a virtual briefing to introduce ------- research proposal to the executive board.',
    '["his","him","himself","he"]'::jsonb,
    'A',
    'Đứng trước cụm danh từ "research proposal" cần một tính từ sở hữu bổ nghĩa → chọn "his" (của ông ấy).',
    ARRAY['reading', 'pronoun']::text[]
  );

  -- Group #11 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    11,
    NULL,
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
    'The company offered all staff members flexible hours ------- commuter traffic could be minimized during rush hour.',
    '["so that","because of","in order to","as if"]'::jsonb,
    'A',
    'Theo sau chỗ trống là mệnh đề có chủ ngữ và trợ động từ ("commuter traffic could be minimized...") biểu thị mục đích → chọn liên từ "so that" (để mà).',
    ARRAY['reading', 'conjunction']::text[]
  );

  -- Group #12 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    12,
    NULL,
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
    'Protective eyeglasses and earplugs are mandatory at all times ------- the manufacturing plant floor.',
    '["throughout","between","against","onto"]'::jsonb,
    'A',
    'Giới từ "throughout" đi kèm địa điểm mang nghĩa "trên toàn bộ khuôn viên / khắp mặt sàn nhà máy sản xuất".',
    ARRAY['reading', 'preposition']::text[]
  );

  -- Group #13 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    13,
    'MEMORANDUM
To: All Headquarters Personnel
From: Facilities & Operations Committee
Date: October 14
Subject: Scheduled Corporate Office Relocation

As previously communicated, our headquarters will transition to the modern Diamond Tower complex over the upcoming weekend. The relocation procedures will begin on Friday at 5:00 P.M. and continue [131] ------- Sunday evening.

All team members are requested to pack their personal desktop items and sensitive documents into the provided blue plastic crates before departing on Friday afternoon. [132] -------. Cardboard boxes and color-coded destination labels will be distributed by the facilities team starting tomorrow at 9:00 A.M.

Please note that our new facility features an automated optical card reader system. You will receive your new permanent access badge [133] ------- upon checking in with the security desk on Monday morning. We sincerely appreciate your patience and [134] ------- as we finalize this exciting corporate transition.',
    NULL,
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
    'Cụm diễn tả hành động liên tục đến hết một mốc thời gian: "continue through Sunday evening" (tiếp diễn liên tục xuyên suốt đến hết tối Chủ Nhật).',
    ARRAY['reading', 'preposition']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["Please ensure all storage crates are securely locked and clearly labeled.","The cafeteria will launch a new seasonal lunch menu next month.","Annual health insurance renewal documents must be signed by noon.","Parking tickets can be validated at the front information counter."]'::jsonb,
    'A',
    'Câu trước nói về việc đóng gói đồ đạc vào thùng nhựa được cung cấp. Câu (A) nối tiếp dặn dò khóa và dán nhãn thùng chứa đồ một cách logic.',
    ARRAY['reading', 'context']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best adverb to fill in blank [133].',
    '["promptly","prompt","promptness","prompting"]'::jsonb,
    'A',
    'Bổ nghĩa cho cụm động từ "will receive your new permanent access badge" cần trạng từ → chọn "promptly" (ngay lập tức khi điểm danh sáng thứ Hai).',
    ARRAY['reading', 'word-form']::text[]
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
    'Sau tính từ sở hữu "your" và đi liền sau danh từ "patience and..." cần một danh từ đồng vị → chọn "cooperation" (sự hợp tác).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #14 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    14,
    'OFFICEPRO EQUIPMENT DIRECT
Order Confirmation & Delivery Schedule
Order Number: OP-92481
Recipient: Ms. Laura Chen, Operations Director, Apex Studio
Order Date: October 12

Items Purchased:
• 12 Ergonomic Mesh Executive Chairs (Model EC-200): $2,400.00
• 6 Motorized Adjustable Standing Desks (Model SD-50): $1,800.00
Subtotal: $4,200.00
Corporate Volume Discount (10% on orders above $3,000): -$420.00
Freight Delivery: Complimentary
Total Paid: $3,780.00

Delivery Instructions:
Your items will be transported by Apex Freight and are slated to arrive at your facility on Thursday, October 16, between 9:00 A.M. and 1:00 P.M. An authorized company representative must be present to inspect items and sign the cargo bill of lading.

Need to modify your delivery window?
Please email our dispatch unit at logistics@officepro.com at least 24 hours prior to the scheduled delivery date to reschedule without incurring an administrative restocking penalty.',
    NULL,
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
    'Why did Ms. Chen''s order qualify for a 10% discount?',
    '["Because she placed an order exceeding $3,000 in total value","Because she paid the entire balance using a corporate charge card","Because she agreed to accept an afternoon delivery slot","Because she enrolled in an annual equipment maintenance plan"]'::jsonb,
    'A',
    'Dòng chiết khấu nêu rõ: "Corporate Volume Discount (10% on orders above $3,000)" → Đơn hàng vượt $3,000 nên được giảm giá 10% (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'What must Ms. Chen do to reschedule delivery without incurring a penalty fee?',
    '["Email customer support at least 24 hours before the delivery date","Visit the regional distribution warehouse in person","Return half of the ordered standing desks","Pay an expedited shipping surcharge upon driver arrival"]'::jsonb,
    'A',
    'Đoạn cuối: "Please email our dispatch unit at logistics@officepro.com at least 24 hours prior to the scheduled delivery date..." → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

  -- Group #15 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    15,
    'E-MAIL 1
From: Martin Vance <mvance@vancestrat.com>
To: Clara Higgins <chiggins@brightonhotel.com>
Date: November 4
Subject: Annual Leadership Retreat Reservation

Dear Ms. Higgins,
On behalf of Vance Strategy Group, I would like to reserve the Horizon Conference Room at the Brighton Hotel for our upcoming Executive Leadership Retreat on December 15. We anticipate 35 attendees and will require an audiovisual setup with dual projection screens and wireless lapel microphones. Additionally, we would like a hot buffet luncheon served at 12:30 P.M. Could you please send me a cost estimate and confirm availability?

Sincerely,
Martin Vance, Senior Partner

────────────────────────────────────────────────────────

E-MAIL 2
From: Clara Higgins <chiggins@brightonhotel.com>
To: Martin Vance <mvance@vancestrat.com>
Date: November 5
Subject: RE: Annual Leadership Retreat Reservation

Dear Mr. Vance,
Thank you for choosing the Brighton Hotel! I am happy to confirm that the Horizon Conference Room is available on December 15. We have reserved the room from 8:00 A.M. to 5:00 P.M. Our standard audiovisual conference package includes the dual projection screens and wireless microphones you requested.

However, our culinary team will be hosting a large holiday banquet in the main ballroom that afternoon. Therefore, luncheon service in the Horizon Suite will need to be served thirty minutes earlier, at 12:00 P.M. Please review the attached banquet contract and return a signed copy along with a 20% deposit by November 20 to secure the booking.

Warm regards,
Clara Higgins, Events Manager',
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 152
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    152,
    'What is the purpose of Mr. Vance''s email?',
    '["To reserve meeting space and catering for a company retreat","To file a formal complaint regarding faulty audiovisual equipment","To apply for a vacant event coordinator position","To cancel an existing conference room reservation"]'::jsonb,
    'A',
    'Mr. Vance viết thư để đặt phòng Horizon và dịch vụ ăn uống tiệc trưa cho 35 người tham gia kỳ nghỉ dưỡng ban lãnh đạo → Chọn (A).',
    ARRAY['reading', 'main-idea']::text[]
  );
  -- Question 153
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    153,
    'What adjustment does Ms. Higgins propose regarding lunch?',
    '["Serving the luncheon thirty minutes earlier at 12:00 P.M.","Moving the dining area to an outdoor terrace","Replacing the hot buffet with cold sandwich platters","Postponing lunch service until 1:30 P.M."]'::jsonb,
    'A',
    'Ms. Higgins giải thích khách sạn có tiệc lớn ở đại sảnh nên: "luncheon service in the Horizon Suite will need to be served thirty minutes earlier, at 12:00 P.M." → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 154
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    154,
    'What must Mr. Vance do by November 20?',
    '["Submit a signed contract and a 20% deposit","Confirm the dietary restrictions of all 35 attendees","Pay the full rental balance in advance","Inspect the Horizon Conference Room in person"]'::jsonb,
    'A',
    'Đoạn cuối e-mail 2: "Please review the attached banquet contract and return a signed copy along with a 20% deposit by November 20..." → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Mini Test 25Q - Đề 02
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Mini Test 25Q - Đề 02',
    'Bami TOEIC - Mini Test 25Q',
    'Chủ đề Tuyển dụng, Đào tạo nhân sự & Phát triển nghề nghiệp: 25 câu đủ 7 phần kiểm tra năng lực phản xạ nghe và đọc hiểu TOEIC.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Group #1 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    1,
    NULL,
    '(A) A speaker is standing near a whiteboard. (B) Some chairs are stacked against the back wall. (C) Documents are being passed around the boardroom. (D) A technician is replacing a ceiling projector bulb.',
    'tests/mini_test02/p1_q1.m4a',
    'tests/mini_test02/p1_q1.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 1
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    1,
    'Choose the statement that best describes the picture.',
    '["A speaker is standing near a whiteboard.","Some chairs are stacked against the back wall.","Documents are being passed around the boardroom.","A technician is replacing a ceiling projector bulb."]'::jsonb,
    'A',
    'Bức tranh miêu tả một người đang đứng thuyết trình cạnh bảng trắng trong phòng hội thảo → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #2 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    2,
    NULL,
    '(A) Shelves in a library are stocked with reference books. (B) A customer is paying at a retail checkout counter. (C) Boxes are being unloaded from a cargo van. (D) A ladder is leaning against a brick wall.',
    'tests/mini_test02/p1_q2.m4a',
    'tests/mini_test02/p1_q2.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 2
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    2,
    'Choose the statement that best describes the picture.',
    '["Shelves in a library are stocked with reference books.","A customer is paying at a retail checkout counter.","Boxes are being unloaded from a cargo van.","A ladder is leaning against a brick wall."]'::jsonb,
    'A',
    'Các kệ sách được sắp xếp ngay ngắn đầy các cuốn sách → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #3 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    3,
    NULL,
    'W: Who will be conducting the orientation for our incoming software engineers?
M: (A) David from the talent acquisition team. (B) In the fourth-floor seminar room. (C) It starts tomorrow at nine.',
    'tests/mini_test02/p2_q7.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 7
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    7,
    'Who will be conducting the orientation for our incoming software engineers?',
    '["David from the talent acquisition team.","In the fourth-floor seminar room.","It starts tomorrow at nine."]'::jsonb,
    'A',
    'Hỏi "Who" về người phụ trách → Chọn (A) "David from the talent acquisition team".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #4 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    4,
    NULL,
    'M: Did you send the revised job description to the hiring manager?
W: (A) Yes, I emailed it first thing this morning. (B) He was hired as a systems analyst. (C) About thirty applicants applied.',
    'tests/mini_test02/p2_q8.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 8
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    8,
    'Did you send the revised job description to the hiring manager?',
    '["Yes, I emailed it first thing this morning.","He was hired as a systems analyst.","About thirty applicants applied."]'::jsonb,
    'A',
    'Câu hỏi Yes/No trong quá khứ → xác nhận đã gửi qua email vào đầu giờ sáng nay (A).',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #5 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    5,
    NULL,
    'W: Shouldn''t we order more copies of the employee benefits booklet?
M: (A) We still have three unopened boxes in storage. (B) The human resources office is on level two. (C) Yes, she received the benefit.',
    'tests/mini_test02/p2_q9.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 9
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    9,
    'Shouldn''t we order more copies of the employee benefits booklet?',
    '["We still have three unopened boxes in storage.","The human resources office is on level two.","Yes, she received the benefit."]'::jsonb,
    'A',
    'Câu hỏi phủ định gợi ý đặt thêm tài liệu → trả lời gián tiếp là trong kho vẫn còn 3 thùng chưa mở (A).',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #6 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    3,
    6,
    NULL,
    'M: Rebecca, have you finalized the interview schedule for the senior graphic designer candidates?
W: Almost, Kevin. We have three interviews lined up for Thursday, but one candidate, Alex Mercer, called to ask if we could reschedule his meeting to Friday morning due to a family emergency.
M: That shouldn''t be an issue. Room 302 is reserved for our creative team all day Friday. Let''s confirm the new time with him.
W: Great. I''ll send him a confirmation email right away and notify the panel interviewers.',
    'tests/mini_test02/p3_q32-34.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 32
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    32,
    'What position are the speakers interviewing candidates for?',
    '["Senior graphic designer","Software quality tester","Human resources director","Financial risk analyst"]'::jsonb,
    'A',
    'Người nam hỏi: "have you finalized the interview schedule for the senior graphic designer candidates?" → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 33
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    33,
    'Why did Alex Mercer request a schedule change?',
    '["Because of a family emergency","Because his train was cancelled","Because he accepted another job offer","Because he lost his portfolio files"]'::jsonb,
    'A',
    'Người phụ nữ nói: "...ask if we could reschedule his meeting to Friday morning due to a family emergency" → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 34
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    34,
    'What will Rebecca do next?',
    '["Send a confirmation email to the applicant","Reserve conference room 302","Print copies of the applicant''s resume","Interview another prospective designer"]'::jsonb,
    'A',
    'Rebecca nói: "I''ll send him a confirmation email right away..." → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );

  -- Group #7 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    4,
    7,
    NULL,
    'Good morning, everyone, and welcome to Crestview Technologies. My name is Brian Foster from the employee development department, and I will be leading your orientation session today. Over the next three days, you will receive in-depth training on our internal software platforms, workplace safety standards, and corporate compliance policies. Before we begin our first module on cyber security protocols, please take a moment to log in to the tablets placed on your desks and complete the electronic emergency contact form. If you encounter any technical difficulty logging in, please raise your hand and a facilitator will assist you.',
    'tests/mini_test02/p4_q71-73.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 71
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    71,
    'Who most likely are the listeners?',
    '["Newly hired company employees","Visiting international tourists","College students touring a computer laboratory","Customers testing new tablet devices"]'::jsonb,
    'A',
    'Người nói chào mừng nhân viên mới ("welcome to Crestview Technologies... leading your orientation session today") → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 72
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    72,
    'How long will the training program last?',
    '["Three days","One week","Two hours","Four months"]'::jsonb,
    'A',
    'Người nói nêu rõ: "Over the next three days, you will receive in-depth training..." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 73
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    73,
    'What are listeners instructed to do before the first module?',
    '["Complete an electronic emergency contact form on their tablets","Introduce themselves to the executive vice president","Submit original college diploma certificates","Take a written English comprehension examination"]'::jsonb,
    'A',
    'Người nói dặn: "...please take a moment to log in to the tablets placed on your desks and complete the electronic emergency contact form" → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );

  -- Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
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
    'All job applicants must fill out the employment history form ------- prior to entering the interview room.',
    '["completely","complete","completing","completion"]'::jsonb,
    'A',
    'Bổ nghĩa cho cụm động từ vị ngữ "fill out the employment history form" cần một phó từ (adverb) chỉ thể cách → chọn "completely" (một cách đầy đủ, hoàn chỉnh).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #9 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    9,
    NULL,
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
    'The human resources committee expressed great ------- with the high caliber of candidate applications.',
    '["satisfaction","satisfactory","satisfy","satisfying"]'::jsonb,
    'A',
    'Sau tính từ "great" cần danh từ làm tân ngữ trực tiếp cho động từ "expressed" → chọn "satisfaction" (sự hài lòng).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #10 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    10,
    NULL,
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
    'Ms. Sterling commended the summer interns for ------- outstanding contribution to the database migration.',
    '["their","they","them","theirs"]'::jsonb,
    'A',
    'Đứng trước cụm danh từ "outstanding contribution" cần tính từ sở hữu số nhiều tương ứng với "summer interns" → chọn "their" (của họ).',
    ARRAY['reading', 'pronoun']::text[]
  );

  -- Group #11 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    11,
    NULL,
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
    'Applicants will not be invited for an executive interview ------- their background check passes scrutiny.',
    '["unless","despite","because of","without"]'::jsonb,
    'A',
    'Theo sau là một mệnh đề hoàn chỉnh mang nghĩa điều kiện phủ định ("trừ phi việc xác minh lý lịch được thông qua") → chọn liên từ "unless" (= if not).',
    ARRAY['reading', 'conjunction']::text[]
  );

  -- Group #12 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    12,
    NULL,
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
    'The newly adopted corporate dress policy will remain in effect ------- the upcoming fiscal year.',
    '["throughout","between","against","onto"]'::jsonb,
    'A',
    'Giới từ "throughout" đi với khoảng thời gian mang nghĩa "xuyên suốt / trong toàn bộ năm tài chính sắp tới".',
    ARRAY['reading', 'preposition']::text[]
  );

  -- Group #13 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    13,
    'MEMORANDUM
To: All Department Directors
From: Eleanor Vance, Human Resources Vice President
Date: September 8
Subject: Promotion Announcement

We take tremendous pride in announcing the promotion of Daniel Thorne to the position of Senior Talent Acquisition Director, effective October 1. Over the last four years, Mr. Thorne has demonstrated outstanding leadership and strategic vision in modernizing our global hiring workflows. [131] ------- his tenure, our average onboarding time decreased by thirty-five percent.

In his expanded capacity, Mr. Thorne will spearhead executive recruitment initiatives and coordinate university internship partnerships. He will be directly [132] ------- for aligning our staffing roadmap with international branch targets. [133] -------. We are confident that his analytical acumen will continue to strengthen our workforce.

Please join us in the fifth-floor reception lounge this Friday at 4:30 P.M. to celebrate his promotion. Complimentary beverages and light hors d''oeuvres will be [134] ------- by the corporate hospitality team.',
    NULL,
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
    '["During","Above","Between","Against"]'::jsonb,
    'A',
    'Cụm từ chỉ khoảng thời gian nhiệm kỳ: "During his tenure" = Trong suốt nhiệm kỳ của ông ấy.',
    ARRAY['reading', 'preposition']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best word to fill in blank [132].',
    '["responsible","responsibly","responsibility","responsive"]'::jsonb,
    'A',
    'Cấu trúc cố định "be directly responsible for + V-ing/N" (chịu trách nhiệm trực tiếp cho...) → chọn tính từ "responsible".',
    ARRAY['reading', 'word-form']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best sentence to fill in blank [133].',
    '["He will also mentor incoming recruiters across our European regional offices.","The company budget for international travel was drastically reduced.","All employees must renew their parking garage passes before Friday.","The flight to Frankfurt was delayed due to winter storms."]'::jsonb,
    'A',
    'Câu trước nói về trách nhiệm mới của Daniel Thorne. Câu (A) bổ sung thêm trách nhiệm phù hợp ("Anh ấy cũng sẽ hướng dẫn các chuyên viên tuyển dụng mới...").',
    ARRAY['reading', 'context']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best verb form to fill in blank [134].',
    '["provided","provides","providing","provision"]'::jsonb,
    'A',
    'Cấu trúc bị động tương lai: "will be + V3/ed" → chọn "provided" (sẽ được cung cấp bởi đội ngũ lễ tân).',
    ARRAY['reading', 'grammar']::text[]
  );

  -- Group #14 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    14,
    'SUMMIT ENTERPRISE SOLUTIONS
Career Opportunity: Senior Cloud Systems Architect
Location: Austin, Texas (Hybrid: 3 days in office, 2 days remote)

Position Overview:
Summit Enterprise Solutions is seeking a driven Senior Cloud Systems Architect to design, optimize, and maintain our high-throughput distributed infrastructure. The successful applicant will lead cross-functional engineering teams and implement scalable microservices solutions.

Minimum Qualifications:
• Bachelor''s degree in Computer Science, Software Engineering, or equivalent practical experience.
• At least 6 years of hands-on experience managing AWS or Google Cloud enterprise deployments.
• Demonstrated proficiency in infrastructure automation tools (Terraform, Ansible, Kubernetes).

Compensation & Benefits:
We offer an industry-competitive base salary ($135,000–$155,000), 100% employer-covered health and dental insurance, and a $3,000 annual professional training allowance. Qualified applicants should email a cover letter, resume, and public code repository link to careers@summitenterprise.com no later than November 15.',
    NULL,
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
    '["To announce an open employment position","To promote an upcoming cloud computing seminar","To inform customers about scheduled server maintenance","To request bids from external software contractors"]'::jsonb,
    'A',
    'Tiêu đề "Career Opportunity: Senior Cloud Systems Architect" và nội dung miêu tả công việc, yêu cầu tuyển dụng cho thấy mục đích chính là đăng tin tuyển dụng (A).',
    ARRAY['reading', 'main-idea']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'What is NOT stated as a required qualification for the role?',
    '["A Master''s degree in Business Administration","A Bachelor''s degree in Computer Science or related field","At least 6 years managing enterprise cloud deployments","Experience using infrastructure automation tools"]'::jsonb,
    'A',
    'Yêu cầu chỉ ghi "Bachelor''s degree in Computer Science...", không hề yêu cầu bằng thạc sĩ kinh doanh (MBA) → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

  -- Group #15 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    15,
    'MEMORANDUM 1
To: All Engineering Staff
From: Derek Ward, VP of Product Engineering
Date: August 10
Subject: Professional Certification Reimbursement Program

To foster continuous technical innovation, Summit Enterprise will now sponsor employees pursuing industry-recognized certifications (e.g., AWS Certified Solutions Architect, CISSP, PMP). The company will reimburse 100% of exam registration fees and study materials up to $1,500 per calendar year.

To be eligible, employees must have completed at least six months of continuous service and receive written approval from their department head prior to purchasing courses or exam vouchers. Invoices and passing certificates must be submitted to HR within 30 days of exam completion.

────────────────────────────────────────────────────────

MEMORANDUM 2
To: Derek Ward, VP of Product Engineering
From: Priya Patel, Senior Systems Analyst
Date: August 12
Subject: Certification Approval Request

Dear Mr. Ward,
I am writing to formally request sponsorship under our new Professional Certification Reimbursement Program. I have been with Summit Enterprise for over two years in the cloud infrastructure unit. I intend to sit for the AWS Certified DevOps Engineer exam scheduled on October 20. The preparation course and official exam voucher cost $650 in total. My supervisor, Sandra Bullock, has already reviewed my application and endorsed my participation. Please let me know if you require any additional documentation.

Best regards,
Priya Patel',
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 152
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    152,
    'What benefit does the new company policy introduce?',
    '["Financial reimbursement for approved professional certification expenses","Additional paid vacation days for employees completing training","Complimentary laptop computers for home office use","Free membership to a local athletic health club"]'::jsonb,
    'A',
    'Chính sách công ty tài trợ 100% lệ phí thi và tài liệu ôn tập chứng chỉ chuyên môn lên tới $1,500/năm → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 153
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    153,
    'Why is Priya Patel eligible for the program?',
    '["She has worked at the company for more than six months","She is the head of the human resources division","She scored the highest mark on a corporate quiz","She already passed the DevOps exam in August"]'::jsonb,
    'A',
    'Điều kiện chính sách là làm việc ít nhất 6 tháng; Priya Patel cho biết cô đã làm việc tại công ty hơn hai năm ("over two years") → Chọn (A).',
    ARRAY['reading', 'inference']::text[]
  );
  -- Question 154
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    154,
    'How much funding is Priya requesting for her certification?',
    '["$650","$1,500","$3,000","$250"]'::jsonb,
    'A',
    'Priya nêu rõ: "The preparation course and official exam voucher cost $650 in total" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Mini Test 25Q - Đề 03
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Mini Test 25Q - Đề 03',
    'Bami TOEIC - Mini Test 25Q',
    'Chủ đề Tiếp thị, Dịch vụ khách hàng, Bán lẻ & Quản lý bảo trì: Đề thi mini 25 câu chất lượng cao rèn luyện cả kỹ năng Listening và Reading.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Group #1 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    1,
    NULL,
    '(A) A cashier is scanning merchandise at a register. (B) Clothing racks have been pushed against the glass door. (C) Customers are dining at an outdoor bistro table. (D) Mannequins are displayed in a storefront showcase.',
    'tests/mini_test03/p1_q1.m4a',
    'tests/mini_test03/p1_q1.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 1
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    1,
    'Choose the statement that best describes the picture.',
    '["A cashier is scanning merchandise at a register.","Clothing racks have been pushed against the glass door.","Customers are dining at an outdoor bistro table.","Mannequins are displayed in a storefront showcase."]'::jsonb,
    'A',
    'Tranh vẽ cảnh thu ngân đang đứng tại quầy thanh toán với máy quét và hàng hóa → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #2 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    2,
    NULL,
    '(A) Outdoor dining tables are shaded by large umbrellas. (B) Waitstaff are polishing wine glasses at the counter. (C) Street performers are gathering an audience. (D) Pedestrians are sheltering under a bus canopy.',
    'tests/mini_test03/p1_q2.m4a',
    'tests/mini_test03/p1_q2.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 2
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    2,
    'Choose the statement that best describes the picture.',
    '["Outdoor dining tables are shaded by large umbrellas.","Waitstaff are polishing wine glasses at the counter.","Street performers are gathering an audience.","Pedestrians are sheltering under a bus canopy."]'::jsonb,
    'A',
    'Những chiếc bàn ăn ngoài trời được che bóng mát bởi những cây dù lớn → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #3 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    3,
    NULL,
    'M: When does our promotional campaign for the autumn apparel line launch?
W: (A) Early next month on social media. (B) Yes, autumn is my favorite season. (C) A twenty percent discount coupon.',
    'tests/mini_test03/p2_q7.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 7
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    7,
    'When does our promotional campaign for the autumn apparel line launch?',
    '["Early next month on social media.","Yes, autumn is my favorite season.","A twenty percent discount coupon."]'::jsonb,
    'A',
    'Hỏi "When" về thời điểm ra mắt chiến dịch tiếp thị → Chọn (A) "Early next month on social media".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #4 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    4,
    NULL,
    'W: Where can shoppers redeem their reward loyalty points?
M: (A) At any checkout counter or online. (B) It earned five stars in reviews. (C) About forty reward points.',
    'tests/mini_test03/p2_q8.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 8
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    8,
    'Where can shoppers redeem their reward loyalty points?',
    '["At any checkout counter or online.","It earned five stars in reviews.","About forty reward points."]'::jsonb,
    'A',
    'Hỏi "Where" về địa điểm đổi điểm tích lũy → Chọn (A) "Tại bất kỳ quầy thu ngân nào hoặc trực tuyến".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #5 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    5,
    NULL,
    'M: Could you please review the draft of the press release before five o''clock?
W: (A) Certainly, I will read it right after lunch. (B) The printing press broke down. (C) Yes, exactly five copies.',
    'tests/mini_test03/p2_q9.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 9
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    9,
    'Could you please review the draft of the press release before five o''clock?',
    '["Certainly, I will read it right after lunch.","The printing press broke down.","Yes, exactly five copies."]'::jsonb,
    'A',
    'Lời đề nghị xem xét thông cáo báo chí "Could you please review..." → đồng ý sẵn lòng "Chắc chắn rồi, tôi sẽ đọc ngay sau bữa trưa" (A).',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #6 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    3,
    6,
    NULL,
    'W: Hello, Mark. I was reviewing our customer satisfaction ratings for the third quarter, and while our delivery speed received glowing reviews, our online returns process scored below average.
M: I noticed that as well, Hannah. Several customers left comments stating that printing physical return labels and finding drop-off lockers was cumbersome.
W: Perhaps we should partner with a courier that provides QR-code drop-offs where customers don''t need to print labels at home.
M: That''s a fantastic idea. I will contact Swift Logistics this afternoon to check their integration pricing.',
    'tests/mini_test03/p3_q32-34.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 32
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    32,
    'What aspect of the company''s service received low ratings?',
    '["The online returns process","The product packaging quality","The speed of domestic delivery","The accuracy of inventory counts"]'::jsonb,
    'A',
    'Người phụ nữ nhận xét: "...our online returns process scored below average" → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 33
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    33,
    'What problem did customers mention in their reviews?',
    '["Printing return labels was inconvenient","Replacement items arrived damaged","Customer service phone lines were busy","The return window of 14 days was too short"]'::jsonb,
    'A',
    'Người nam cho biết khách hàng phản ánh việc in nhãn đổi trả và tìm tủ nhận hàng phiền phức ("printing physical return labels ... was cumbersome") → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 34
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    34,
    'What will Mark do this afternoon?',
    '["Contact a logistics courier about QR-code drop-offs","Redesign the company''s mobile shopping application","Issue refunds to unsatisfied shoppers","Survey retail store managers"]'::jsonb,
    'A',
    'Mark nói: "I will contact Swift Logistics this afternoon to check their integration pricing" → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );

  -- Group #7 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    4,
    7,
    NULL,
    'Attention Greenfield Mall shoppers. Thank you for visiting us this weekend. To celebrate the grand opening of our newly renovated East Wing, select fashion boutiques and tech stores are offering storewide discounts of up to thirty percent today only. Also, be sure to stop by the central atrium where our complimentary artisan coffee bar will be serving hot espresso drinks until 4:00 P.M. If you spend over fifty dollars at any participating store today, present your receipt at the customer service booth near Entrance B to receive a free canvas shopping tote.',
    'tests/mini_test03/p4_q71-73.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 71
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    71,
    'What is being celebrated at Greenfield Mall?',
    '["The grand opening of a renovated wing","The mall''s twentieth anniversary","A national public holiday festival","A regional student fashion competition"]'::jsonb,
    'A',
    'Thông báo nêu: "To celebrate the grand opening of our newly renovated East Wing..." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 72
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    72,
    'What is available in the central atrium until 4:00 P.M.?',
    '["Complimentary artisan coffee drinks","Live acoustic musical performances","Automotive test drive bookings","Free smartphone repair assessments"]'::jsonb,
    'A',
    'Thông báo: "...complimentary artisan coffee bar will be serving hot espresso drinks until 4:00 P.M." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 73
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    73,
    'How can shoppers qualify for a free canvas tote bag?',
    '["By spending over fifty dollars at participating stores","By signing up for an email newsletter","By filling out a customer satisfaction survey","By applying for a department store credit card"]'::jsonb,
    'A',
    'Thông báo: "If you spend over fifty dollars at any participating store today, present your receipt ... to receive a free canvas shopping tote" → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );

  -- Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
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
    'Participants found the interactive workshop on digital marketing analytics extremely -------.',
    '["informative","inform","informatively","information"]'::jsonb,
    'A',
    'Cấu trúc "find + O + adj" (nhận thấy cái gì như thế nào) → sau phó từ chỉ mức độ "extremely" cần tính từ "informative" (bổ ích, hữu ích).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #9 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    9,
    NULL,
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
    'Hotel guests dining at the seaside restaurant are entitled to a complimentary breakfast ------- every morning.',
    '["buffet","permit","contract","voucher"]'::jsonb,
    'A',
    'Cụm danh từ cố định trong ngành khách sạn "breakfast buffet" (bữa ăn sáng tự chọn).',
    ARRAY['reading', 'vocabulary']::text[]
  );

  -- Group #10 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    10,
    NULL,
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
    'Delegates attending the summit are requested to register ------- on the official event portal.',
    '["themselves","they","them","theirs"]'::jsonb,
    'A',
    'Hành động đăng ký tác động lên chính chủ ngữ "Delegates" → dùng đại từ phản thân "themselves" (tự đăng ký).',
    ARRAY['reading', 'pronoun']::text[]
  );

  -- Group #11 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    11,
    NULL,
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
    'The technical seminar was rescheduled ------- the keynote speaker missed his connecting flight.',
    '["because","due to","in spite of","as though"]'::jsonb,
    'A',
    'Theo sau là một mệnh đề hoàn chỉnh có chủ ngữ và động từ ("the keynote speaker missed his connecting flight") chỉ nguyên nhân → chọn liên từ "because".',
    ARRAY['reading', 'conjunction']::text[]
  );

  -- Group #12 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    12,
    NULL,
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
    'Customer parking spaces are situated directly ------- the primary supermarket entrance.',
    '["behind","into","onto","during"]'::jsonb,
    'A',
    'Vị trí không gian của bãi đỗ xe so với cổng vào siêu thị → chọn giới từ nơi chốn "behind" (phía sau).',
    ARRAY['reading', 'preposition']::text[]
  );

  -- Group #13 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    13,
    'NOTICE TO ALL SYSTEM USERS
From: IT Infrastructure & Operations
Date: September 5
Subject: Scheduled CRM System Maintenance

Please be advised that our central Customer Relationship Management (CRM) platform will undergo routine system maintenance this Saturday, September 9, beginning at 11:00 P.M. and concluding at 4:00 A.M. on Sunday morning.

During this five-hour maintenance window, the database will be temporarily [131] ------- to all personnel. This maintenance is essential to deploy critical security patches and enhance server performance. [132] -------. We advise all sales and support representatives to finalize and save all active transaction records before logging off on Friday afternoon.

If you require urgent client contact records during the maintenance outage, please export the necessary files [133] ------- Saturday noon. Regular database operations will resume [134] ------- at 4:30 A.M. on Sunday.',
    NULL,
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
    '["inaccessible","accessible","accessibility","accessing"]'::jsonb,
    'A',
    'Trong thời gian hệ thống bảo trì máy chủ, cơ sở dữ liệu sẽ tạm thời "không thể truy cập được" → chọn tính từ phủ định "inaccessible".',
    ARRAY['reading', 'vocabulary']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["These enhancements will ensure faster query times and improved data safety.","The marketing campaign proposal was rejected by our overseas partner.","All international travel receipts must be turned in by Thursday.","The executive dining lounge will be closed during the holidays."]'::jsonb,
    'A',
    'Câu trước nói về mục đích nâng cấp bảo mật và hiệu năng. Câu (A) tiếp nối mạch logic: "Những nâng cấp này sẽ đảm bảo thời gian truy vấn nhanh hơn và dữ liệu an toàn hơn".',
    ARRAY['reading', 'context']::text[]
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
    'Chỉ mốc thời gian phải hoàn tất trước khi sự kiện xảy ra: "before Saturday noon" (trước trưa Thứ Bảy).',
    ARRAY['reading', 'preposition']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best adverb to fill in blank [134].',
    '["promptly","prompt","promptness","prompted"]'::jsonb,
    'A',
    'Bổ nghĩa cho động từ "will resume" tại mốc thời gian cụ thể cần phó từ (adverb) → chọn "promptly" (đúng giờ, kịp thời).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #14 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    14,
    'APEX AUTOMOTIVE REPAIR
Customer Feedback & Service Evaluation
Date of Service: August 18
Customer: David Miller
Vehicle: 2021 Silverton Sedan

Service Evaluation:
• Punctuality: Excellent (5/5)
• Work Quality: Excellent (5/5)
• Facility Comfort: Average (3/5)
• Pricing Transparency: Excellent (5/5)

Customer Remarks:
"I brought my sedan in for the scheduled 30,000-mile inspection and front brake pad replacement. Technician Carlos did a wonderful job walking me through the rotor measurements and finished the job thirty minutes ahead of schedule. My only minor suggestion pertains to the customer lounge: seating was limited, and the guest Wi-Fi was quite spotty. Aside from that, the mechanical work was top-notch, and I will certainly return for future oil changes."

Manager Response:
Date: August 20
From: Brenda Larson, Service Manager

Dear Mr. Miller,
Thank you for sharing your experience. We are delighted that Carlos provided prompt, transparent service for your brake inspection. Regarding our waiting area, we are scheduled to expand the customer lounge next month with extra workstations and high-speed fiber internet. To show our appreciation for your loyalty, please present coupon code APEX-15OFF during your next visit to receive 15% off any standard maintenance service.',
    NULL,
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
    '["For a scheduled inspection and brake pad replacement","To repair severe collision body damage","To test-drive a newly arrived Silverton sedan","To install high-performance audio speakers"]'::jsonb,
    'A',
    'Khách hàng viết: "I brought my sedan in for the scheduled 30,000-mile inspection and front brake pad replacement" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'What will Apex Automotive do next month?',
    '["Expand the waiting lounge and install faster internet","Relocate the auto repair shop to a new facility","Discontinue the promotional discount coupon program","Hire additional mechanical technicians"]'::jsonb,
    'A',
    'Người quản lý phản hồi: "...we are scheduled to expand the customer lounge next month with extra workstations and high-speed fiber internet" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

  -- Group #15 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    15,
    'ANNOUNCEMENT
GREENVALE BOTANICAL GARDENS
Annual Plant Sale & Horticultural Exhibition
Dates: May 20–22 | Hours: 9:00 A.M. – 6:00 P.M. Daily

Greenvale Botanical Gardens is thrilled to host our 15th Annual Plant Sale! Browse thousands of rare perennial flowers, indigenous shrubs, and organic vegetable seedlings cultivated by our master gardeners.

Event Highlights:
• Free 30-minute gardening workshops held daily at 11:00 A.M. and 2:00 P.M. in the glass conservatory.
• Members-Only Early Access: Garden members enjoy exclusive admission on Friday, May 20 from 8:00 A.M. to 10:00 A.M., plus an extra 15% discount on all plant purchases.
• Soil testing station: Bring a cup of backyard soil for immediate mineral analysis ($5 per sample; free for members).

Admission is $12 for adults, $6 for students, and free for children under six and current garden members. Parking is free in the North Lot.

────────────────────────────────────────────────────────

REVIEW POSTING
User: Sarah Jenkins | Date: May 23
Rating: ★★★★★

"I attended the Greenvale Plant Sale on Saturday morning with my family. The variety of heirloom tomato seedlings was astonishing, and the staff at the soil testing booth gave us practical tips on improving our garden soil. Even though the North Lot was full by 10:30 A.M., parking attendants directed us smoothly to the overflow lot at the adjacent middle school. We also attended the 2:00 P.M. indoor gardening talk, which was incredibly insightful. We definitely plan to purchase a family membership before next year''s sale!"',
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 152
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    152,
    'What benefit do garden members receive on Friday, May 20?',
    '["Exclusive early admission and a 15% plant discount","Free admission for up to ten non-member guests","A complimentary pair of professional gardening shears","Reserved parking stalls in the overflow lot"]'::jsonb,
    'A',
    'Thông báo nêu: "Garden members enjoy exclusive admission on Friday, May 20 from 8:00 A.M. to 10:00 A.M., plus an extra 15% discount on all plant purchases" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 153
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    153,
    'Where did Sarah Jenkins park her car during her visit?',
    '["At an overflow parking lot at a nearby school","In the garden''s primary North Lot","On an adjacent residential neighborhood street","In an underground parking facility"]'::jsonb,
    'A',
    'Sarah viết: "...the North Lot was full by 10:30 A.M., parking attendants directed us smoothly to the overflow lot at the adjacent middle school" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 154
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    154,
    'What does Sarah Jenkins indicate she will do before next year?',
    '["Buy a garden family membership","Volunteer as a parking attendant","Donate plant seeds to the conservatory","Host a gardening workshop in her backyard"]'::jsonb,
    'A',
    'Câu cuối bài review: "We definitely plan to purchase a family membership before next year''s sale!" → Chọn (A).',
    ARRAY['reading', 'inference']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Mini Test 25Q - Đề 04
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Mini Test 25Q - Đề 04',
    'Bami TOEIC - Mini Test 25Q',
    'Chủ đề Tài chính, Ngân sách, Mua sắm trang thiết bị & Hợp đồng dịch vụ: 25 câu đủ 7 phần kiểm tra ngữ pháp, phản xạ nghe và đọc hiểu chuyên sâu.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Group #1 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    1,
    NULL,
    '(A) An accountant is reviewing spreadsheets on multiple monitors. (B) File cabinets are being loaded into an elevator. (C) An office desk is being disassembled by movers. (D) A banker is counting cash at a teller window.',
    'tests/mini_test04/p1_q1.m4a',
    'tests/mini_test04/p1_q1.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 1
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    1,
    'Choose the statement that best describes the picture.',
    '["An accountant is reviewing spreadsheets on multiple monitors.","File cabinets are being loaded into an elevator.","An office desk is being disassembled by movers.","A banker is counting cash at a teller window."]'::jsonb,
    'A',
    'Bàn làm việc với nhiều màn hình hiển thị bảng tính tài chính → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #2 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    2,
    NULL,
    '(A) Guests are seated in rows facing a conference podium. (B) Banquet tables are being folded and stored away. (C) Microphones are being installed on the ceiling. (D) Waiters are clearing dinner plates from tables.',
    'tests/mini_test04/p1_q2.m4a',
    'tests/mini_test04/p1_q2.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 2
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    2,
    'Choose the statement that best describes the picture.',
    '["Guests are seated in rows facing a conference podium.","Banquet tables are being folded and stored away.","Microphones are being installed on the ceiling.","Waiters are clearing dinner plates from tables."]'::jsonb,
    'A',
    'Người tham dự ngồi theo hàng hướng về bục phát biểu của phòng hội nghị → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #3 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    3,
    NULL,
    'W: Where should I submit my travel reimbursement form?
M: (A) Directly to the accounting department on the second floor. (B) Yes, the flight was fully reimbursed. (C) Within thirty calendar days.',
    'tests/mini_test04/p2_q7.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 7
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    7,
    'Where should I submit my travel reimbursement form?',
    '["Directly to the accounting department on the second floor.","Yes, the flight was fully reimbursed.","Within thirty calendar days."]'::jsonb,
    'A',
    'Hỏi "Where" về nơi nộp đơn hoàn tiền công tác → Chọn (A) "Trực tiếp cho phòng kế toán tại tầng 2".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #4 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    4,
    NULL,
    'M: Has the finance director approved our revised quarterly budget yet?
W: (A) She is still reviewing the travel line items. (B) In the corporate conference room. (C) About fifteen percent higher.',
    'tests/mini_test04/p2_q8.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 8
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    8,
    'Has the finance director approved our revised quarterly budget yet?',
    '["She is still reviewing the travel line items.","In the corporate conference room.","About fifteen percent higher."]'::jsonb,
    'A',
    'Câu hỏi trạng thái phê duyệt ngân sách → trả lời tình trạng bà ấy vẫn đang xem xét các mục công tác phí (A).',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #5 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    5,
    NULL,
    'W: Would you prefer paying with a company credit card or via wire transfer?
M: (A) A wire transfer will be much easier for our audit records. (B) The card expired last month. (C) Yes, twenty percent off.',
    'tests/mini_test04/p2_q9.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 9
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    9,
    'Would you prefer paying with a company credit card or via wire transfer?',
    '["A wire transfer will be much easier for our audit records.","The card expired last month.","Yes, twenty percent off."]'::jsonb,
    'A',
    'Câu hỏi lựa chọn (Credit card hay Wire transfer) → chọn hình thức chuyển khoản (A) "A wire transfer will be much easier...".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #6 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    3,
    6,
    NULL,
    'W: Good afternoon, Jason. Have you received the updated catering invoice from Grand Oak Convention Center for our awards banquet?
M: Yes, Lisa, but I noticed they charged us for two hundred dinner plates when our confirmed attendee count was only one hundred and seventy.
W: Oh, that''s a difference of over one thousand dollars. Did you call their banquet manager to verify the count?
M: I called her office twenty minutes ago, and she apologized for the administrative error. She promised to send an amended invoice with the correct amount before 4:00 P.M.',
    'tests/mini_test04/p3_q32-34.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 32
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    32,
    'What discrepancy did Jason discover on the banquet invoice?',
    '["The company was charged for thirty extra dinner plates","The event hall rental fee was doubled","The date of the awards banquet was incorrect","A mandatory gratuity fee was omitted"]'::jsonb,
    'A',
    'Jason phát hiện hóa đơn tính tiền 200 suất trong khi chỉ có 170 khách (chênh lệch 30 suất) → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 33
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    33,
    'How much is the cost discrepancy approximately?',
    '["Over one thousand dollars","Five hundred dollars","Two hundred dollars","Three thousand dollars"]'::jsonb,
    'A',
    'Lisa nói: "Oh, that''s a difference of over one thousand dollars" → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 34
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    34,
    'What did the banquet manager promise to do before 4:00 P.M.?',
    '["Send an amended invoice with the correct figure","Cancel the banquet reservation","Provide free floral centerpieces for all tables","Visit the company headquarters in person"]'::jsonb,
    'A',
    'Jason cho biết quản lý hứa gửi hóa đơn sửa đổi trước 4 giờ chiều ("She promised to send an amended invoice with the correct amount before 4:00 P.M.") → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );

  -- Group #7 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    4,
    7,
    NULL,
    'Good morning, department supervisors. This is Gregory Simmons from corporate finance with an important announcement regarding our year-end budgeting deadlines. All department heads must submit their finalized budget proposals for the upcoming fiscal year no later than Friday, November 18 at 5:00 P.M. Please remember to use the updated spreadsheet template available in the corporate intranet portal, as legacy formats will not be accepted by our automated accounting system. In addition, the executive board will host an open financial briefing on Wednesday morning to answer questions regarding capital expenditure limits. Attendance is strongly recommended.',
    'tests/mini_test04/p4_q71-73.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 71
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    71,
    'What is the speaker mainly announcing?',
    '["Deadlines for year-end budget proposals","A reduction in travel reimbursement rates","A transition to a new corporate banking partner","The election of a new board of directors"]'::jsonb,
    'A',
    'Người nói thông báo về thời hạn nộp đề xuất ngân sách cuối năm ("important announcement regarding our year-end budgeting deadlines") → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 72
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    72,
    'What must supervisors use when preparing their submissions?',
    '["The updated spreadsheet template on the intranet","A printed physical ledger from accounting","A proprietary mobile banking application","An external audit evaluation software"]'::jsonb,
    'A',
    'Người nói nhắc: "Please remember to use the updated spreadsheet template available in the corporate intranet portal..." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 73
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    73,
    'What event is scheduled for Wednesday morning?',
    '["An open financial briefing with the executive board","An annual shareholder voting session","A software training workshop on accounting tools","A retirement luncheon for senior accountants"]'::jsonb,
    'A',
    'Người nói nêu: "...the executive board will host an open financial briefing on Wednesday morning..." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );

  -- Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
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
    'Sau tính từ "managerial" cần một danh từ để tạo thành cụm danh từ "managerial approval" (sự phê duyệt của cấp quản lý).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #9 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    9,
    NULL,
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
    'The auditing committee emphasized that all client financial records must remain strictly -------.',
    '["confidential","confidentially","confidence","confident"]'::jsonb,
    'A',
    'Động từ nối "remain" đi với tính từ chỉ tính chất. Sau phó từ bổ nghĩa "strictly" cần tính từ mang nghĩa bảo mật → chọn "confidential" (bảo mật, bí mật).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #10 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    10,
    NULL,
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
    'The chief financial officer reviewed the balance sheet figures ------- before distributing them to investors.',
    '["himself","he","his","him"]'::jsonb,
    'A',
    'Câu đã đầy đủ chủ ngữ, vị ngữ và tân ngữ. Đại từ phản thân "himself" đứng cuối mệnh đề để nhấn mạnh chính ông CFO làm hành động kiểm tra.',
    ARRAY['reading', 'pronoun']::text[]
  );

  -- Group #11 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    11,
    NULL,
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
    'Employees will be reimbursed for allowable travel expenses ------- they submit original itemized receipts.',
    '["provided that","as well as","in case of","regardless of"]'::jsonb,
    'A',
    'Liên từ điều kiện "Provided that" mang nghĩa "với điều kiện là / miễn là" đi kèm một mệnh đề hoàn chỉnh.',
    ARRAY['reading', 'conjunction']::text[]
  );

  -- Group #12 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    12,
    NULL,
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
    'Reimbursement checks will be deposited into employees'' bank accounts ------- ten business days.',
    '["within","among","toward","along"]'::jsonb,
    'A',
    'Giới từ "within" + khoảng thời gian mang nghĩa "trong vòng / không quá mười ngày làm việc".',
    ARRAY['reading', 'preposition']::text[]
  );

  -- Group #13 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    13,
    'MEMORANDUM
To: All Department Supervisors
From: Gregory Simmons, Chief Financial Officer
Date: November 3
Subject: Updated Corporate Travel Guidelines

Effective December 1, all staff members traveling on corporate business must adhere strictly to our revised travel reimbursement guidelines. Under this updated protocol, all flight and hotel arrangements must be booked [131] ------- our designated corporate travel management portal to secure negotiated corporate rates.

Employees will no longer receive reimbursement for personal incidental charges, such as hotel minibar purchases or dry-cleaning services. [132] -------. Itemized expense claims, accompanied by scanned copies of official receipts, must be submitted within 14 calendar days of returning from travel.

Failure to provide documented receipts on time will lead to reimbursement [133] -------. Should you have questions regarding allowable per-diem meals, please check the intranet directory or [134] ------- the finance department directly.',
    NULL,
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
    'Giới từ "through" mang nghĩa "thông qua cổng quản lý công tác được chỉ định" ("through our designated corporate travel management portal").',
    ARRAY['reading', 'preposition']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["Such personal charges must be settled directly by the individual traveler.","Our annual product demonstration was well attended by international guests.","The customer service hotline operates twenty-four hours a day.","Parking permits will be issued at the security booth tomorrow."]'::jsonb,
    'A',
    'Câu trước nói về việc công ty không hoàn tiền cho chi phí cá nhân (mini-bar, giặt ủi). Câu (A) nối tiếp logic: "Các chi phí cá nhân như vậy phải do chính người đi công tác thanh toán".',
    ARRAY['reading', 'context']::text[]
  );
  -- Question 133
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    133,
    'Choose the best noun form to fill in blank [133].',
    '["delays","delayed","deliberate","delaying"]'::jsonb,
    'A',
    'Sau danh từ "reimbursement" cần danh từ để tạo thành cụm danh từ ghép "reimbursement delays" (sự chậm trễ trong hoàn trả chi phí).',
    ARRAY['reading', 'word-form']::text[]
  );
  -- Question 134
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    134,
    'Choose the best verb form to fill in blank [134].',
    '["contact","contacting","contacted","contactable"]'::jsonb,
    'A',
    'Cấu trúc song hành với động từ nguyên mẫu đứng trước liên từ "or": "please check ... or contact ... directly".',
    ARRAY['reading', 'grammar']::text[]
  );

  -- Group #14 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    14,
    'GRAND OAK CONVENTION CENTER
Event Catering Agreement & Banquet Confirmation
Client: Pinnacle Financial Group | Event: Annual Corporate Honors Banquet
Event Date: December 12 | Client Contact: Ms. Rachel Adams, Events Director

Event Specifications:
• Venue: Grand Ballroom (Third Floor)
• Confirmed Guests: 180 attendees
• Service Package: Executive Three-Course Plated Banquet
• Staff Setup: 4:30 P.M. | Guest Arrival: 6:00 P.M. | Meal Service: 7:00 P.M.

Financial Terms & Payment Schedule:
• Total Contract Value: $14,400 (includes catering, audio-visual suite, and service gratuity)
• Initial Deposit: $4,000 (received October 5)
• Remaining Balance Due: $10,400 payable on or before November 28

Cancellation Policy:
Cancellations received at least 30 calendar days prior to December 12 will receive a full deposit refund, less a standard $250 administrative fee. Cancellations made within 30 days are non-refundable. Final meal selections and dietary requirements (vegetarian, kosher, gluten-free) must be submitted in writing to catering coordinator Mark Evans by December 1.',
    NULL,
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
    'What type of event is being held at the Grand Oak Convention Center?',
    '["An annual corporate honors banquet","A computer hardware manufacturing expo","A public shareholder election meeting","A software engineering certification class"]'::jsonb,
    'A',
    'Mục tiêu đề hợp đồng: "Event: Annual Corporate Honors Banquet" (tiệc vinh danh doanh nghiệp hàng năm) → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'When must the remaining balance of $10,400 be settled?',
    '["On or before November 28","On October 5","By December 1","On December 12"]'::jsonb,
    'A',
    'Trong mục Financial Terms: "Remaining Balance Due: $10,400 payable on or before November 28" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

  -- Group #15 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    15,
    'MEMORANDUM 1
To: Senior Management Team
From: Teresa Alvarez, Chief Procurement Officer
Date: October 15
Subject: Office Printer Fleet Replacement Bids

Our current leasing contract for multi-function office copiers with Lexmark Office Solutions expires on December 31. Over the past three months, the procurement committee solicited bids from three commercial vendors to replace our fleet of 24 copiers across three regional branches.

After evaluating print quality, monthly maintenance turnaround, and volume pricing, the committee recommends partnering with Apex Imaging Services. Apex offers high-speed laser printers with integrated cloud scanning at a monthly lease rate of $3,800, which is 12% lower than our current contract. In addition, Apex guarantees a four-hour on-site maintenance response time.

────────────────────────────────────────────────────────

MEMORANDUM 2
To: Teresa Alvarez, Chief Procurement Officer
From: Marcus Sterling, Chief Executive Officer
Date: October 17
Subject: RE: Office Printer Fleet Replacement Bids

Dear Teresa,
Thank you for the thorough comparative analysis. Given the cost savings and the four-hour service response guarantee, I fully approve the committee''s recommendation to award the leasing contract to Apex Imaging Services.

Please proceed with drafting the formal five-year agreement with their legal team. Prior to signing, ensure that the contract includes complimentary installation and staff training during the first week of January so our daily workflow remains uninterrupted.

Best regards,
Marcus Sterling',
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 152
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    152,
    'Why did the procurement committee recommend Apex Imaging Services?',
    '["Lower monthly lease pricing and a rapid maintenance guarantee","They are the only vendor offering color photocopy machines","Their corporate headquarters is located next to Apex Studio","They agreed to buy back old office furniture"]'::jsonb,
    'A',
    'Ủy ban đề xuất Apex vì chi phí thuê hàng tháng thấp hơn 12% và cam kết phản hồi kỹ thuật trong vòng 4 tiếng ("monthly lease rate ... 12% lower ... guarantees a four-hour on-site maintenance response time") → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 153
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    153,
    'What condition does Mr. Sterling require before signing the agreement?',
    '["Complimentary installation and staff training in early January","A further five percent discount on paper supplies","Replacement of all office desktop computers","An option to terminate the lease within six months"]'::jsonb,
    'A',
    'CEO Marcus Sterling yêu cầu: "ensure that the contract includes complimentary installation and staff training during the first week of January" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 154
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    154,
    'What is the duration of the proposed contract?',
    '["Five years","Three months","One year","Twelve months"]'::jsonb,
    'A',
    'CEO chỉ đạo: "Please proceed with drafting the formal five-year agreement..." → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

END $$;

-- -------------------------------------------------------------
-- BỘ ĐỀ: Mini Test 25Q - Đề 05
-- -------------------------------------------------------------
DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'Mini Test 25Q - Đề 05',
    'Bami TOEIC - Mini Test 25Q',
    'Chủ đề Kho vận, Chuỗi cung ứng, Vận tải biển & Quản lý cơ sở vật chất: Đề thi mini 25 câu chất lượng cao hoàn thiện toàn bộ các phần TOEIC.',
    true
  )
  RETURNING id INTO v_test_id;

  -- Group #1 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    1,
    NULL,
    '(A) A warehouse worker is operating a forklift truck. (B) Boxes are stacked neatly on wooden shipping pallets. (C) An overhead industrial crane is lowering a shipping container. (D) Workers are painting safety lines on the warehouse floor.',
    'tests/mini_test05/p1_q1.m4a',
    'tests/mini_test05/p1_q1.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 1
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    1,
    'Choose the statement that best describes the picture.',
    '["A warehouse worker is operating a forklift truck.","Boxes are stacked neatly on wooden shipping pallets.","An overhead industrial crane is lowering a shipping container.","Workers are painting safety lines on the warehouse floor."]'::jsonb,
    'B',
    'Các thùng hàng được xếp gọn gàng trên pallet gỗ vận chuyển → Chọn (B).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #2 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    1,
    2,
    NULL,
    '(A) Cargo containers are stacked along the seaport dock. (B) A cruise ship is boarding passengers at the terminal. (C) Fishermen are casting nets into the harbor. (D) Seamen are coiling ropes on the wooden pier.',
    'tests/mini_test05/p1_q2.m4a',
    'tests/mini_test05/p1_q2.png'
  )
  RETURNING id INTO v_group_id;

  -- Question 2
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    1,
    2,
    'Choose the statement that best describes the picture.',
    '["Cargo containers are stacked along the seaport dock.","A cruise ship is boarding passengers at the terminal.","Fishermen are casting nets into the harbor.","Seamen are coiling ropes on the wooden pier."]'::jsonb,
    'A',
    'Các thùng container hàng hóa nhiều màu sắc được xếp chồng dọc bến cảng biển → Chọn (A).',
    ARRAY['listening', 'photographs']::text[]
  );

  -- Group #3 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    3,
    NULL,
    'M: When will the freight cargo from Kaohsiung arrive at our port terminal?
W: (A) Early Thursday morning according to the shipping agent. (B) Forty metric tons of precision parts. (C) Yes, it has already been loaded.',
    'tests/mini_test05/p2_q7.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 7
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    7,
    'When will the freight cargo from Kaohsiung arrive at our port terminal?',
    '["Early Thursday morning according to the shipping agent.","Forty metric tons of precision parts.","Yes, it has already been loaded."]'::jsonb,
    'A',
    'Hỏi "When" về thời gian hàng cập bến cảng → Chọn (A) "Sáng sớm thứ Năm theo đại lý vận chuyển".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #4 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    4,
    NULL,
    'W: Who is inspecting the automated sorting conveyor in building C?
M: (A) Senior technician Martinez and his apprentice. (B) It operates at high speeds. (C) Next to the freight loading bay.',
    'tests/mini_test05/p2_q8.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 8
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    8,
    'Who is inspecting the automated sorting conveyor in building C?',
    '["Senior technician Martinez and his apprentice.","It operates at high speeds.","Next to the freight loading bay."]'::jsonb,
    'A',
    'Hỏi "Who" về người kiểm tra băng chuyền tự động → Chọn (A) "Kỹ thuật viên trưởng Martinez và phụ tá".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #5 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    2,
    5,
    NULL,
    'M: Would you like me to reserve the freight elevator for the furniture delivery tomorrow?
W: (A) That would be wonderful, thank you so much. (B) On the twelfth floor executive suite. (C) Yes, three heavy mahogany desks.',
    'tests/mini_test05/p2_q9.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 9
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    2,
    9,
    'Would you like me to reserve the freight elevator for the furniture delivery tomorrow?',
    '["That would be wonderful, thank you so much.","On the twelfth floor executive suite.","Yes, three heavy mahogany desks."]'::jsonb,
    'A',
    'Lời đề nghị đặt trước thang máy chở hàng "Would you like me to reserve..." → nhận lời cảm ơn (A) "That would be wonderful, thank you so much".',
    ARRAY['listening', 'question-response']::text[]
  );

  -- Group #6 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    3,
    6,
    NULL,
    'W: Hello, Carlos. Has the fleet maintenance crew finished inspecting our delivery vans? We have thirty express shipments scheduled for delivery this afternoon.
M: Good news, Elena. All five refrigerated vans passed their safety brake checks and are ready for loading. However, Van Number 3 needs a headlight bulb replaced before evening.
W: That''s a quick fix. I''ll ask our mechanic to replace the bulb right now while the drivers load the parcels.
M: Perfect. That way all drivers will be on the road before 1:00 P.M.',
    'tests/mini_test05/p3_q32-34.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 32
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    32,
    'What are the speakers discussing?',
    '["The safety inspection of company delivery vans","The purchase of new freight transport vehicles","A delay in manufacturing automotive replacement parts","A customer complaint regarding late package deliveries"]'::jsonb,
    'A',
    'Người phụ nữ hỏi: "Has the fleet maintenance crew finished inspecting our delivery vans?" → Cuộc hội thoại nói về việc kiểm định xe tải giao hàng (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 33
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    33,
    'What minor issue does Carlos mention regarding Van Number 3?',
    '["A headlight bulb needs to be replaced","Its refrigeration compressor is broken","Its side cargo door cannot be locked","Its windshield has a visible crack"]'::jsonb,
    'A',
    'Carlos cho biết: "Van Number 3 needs a headlight bulb replaced before evening" → Cần thay bóng đèn pha (A).',
    ARRAY['listening', 'conversation']::text[]
  );
  -- Question 34
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    3,
    34,
    'When do the speakers expect drivers to depart?',
    '["Before 1:00 P.M.","Tomorrow morning at 8:00 A.M.","At 5:00 P.M.","Next Friday"]'::jsonb,
    'A',
    'Carlos nói: "That way all drivers will be on the road before 1:00 P.M." → Chọn (A).',
    ARRAY['listening', 'conversation']::text[]
  );

  -- Group #7 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    4,
    7,
    NULL,
    'Attention all distribution center staff. This is a safety announcement from Facilities Operations. Beginning tomorrow morning at 7:00 A.M., contractors will be repainting safety pedestrian walkways and installing heavy-duty safety railings along the southern loading bays. As a result, Loading Bays 4 through 7 will be temporarily closed until Friday afternoon. All incoming freight carriers should be routed to Loading Bays 1 through 3 on the northern concourse. Please remember that high-visibility reflective vests and steel-toe work boots are mandatory in all active staging areas. Thank you for your continued dedication to workplace safety.',
    'tests/mini_test05/p4_q71-73.m4a',
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 71
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    71,
    'What work will contractors begin tomorrow morning?',
    '["Repainting pedestrian walkways and installing safety railings","Replacing automated sorting conveyors","Re-roofing the primary distribution warehouse","Installing digital inventory scanning monitors"]'::jsonb,
    'A',
    'Thông báo nêu: "contractors will be repainting safety pedestrian walkways and installing heavy-duty safety railings..." → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 72
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    72,
    'Which loading bays will be closed until Friday afternoon?',
    '["Loading Bays 4 through 7","Loading Bays 1 through 3","All bays on the northern concourse","Only the underground freight bay"]'::jsonb,
    'A',
    'Thông báo: "As a result, Loading Bays 4 through 7 will be temporarily closed until Friday afternoon" → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );
  -- Question 73
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    4,
    73,
    'What safety equipment must all staff wear in staging areas?',
    '["High-visibility vests and steel-toe boots","Full-face protective shields and earplugs","Waterproof rubber aprons and gloves","Insulated winter thermal jackets"]'::jsonb,
    'A',
    'Thông báo nhắc: "...high-visibility reflective vests and steel-toe work boots are mandatory in all active staging areas" → Chọn (A).',
    ARRAY['listening', 'talks']::text[]
  );

  -- Group #8 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    8,
    NULL,
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
    'Warehouse safety regulations will be ------- enforced across all regional logistics hubs beginning next Monday.',
    '["strictly","strict","strictness","strictest"]'::jsonb,
    'A',
    'Đứng giữa trợ động từ "will be" và động từ phân từ hai "enforced" cần một phó từ (adverb) chỉ mức độ → chọn "strictly" (một cách nghiêm ngặt).',
    ARRAY['reading', 'word-form']::text[]
  );

  -- Group #9 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    9,
    NULL,
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
    'The certified inspector will ------- the automated conveyor belt before regular production shifts resume.',
    '["inspect","inspection","inspector","inspects"]'::jsonb,
    'A',
    'Sau động từ khuyết thiếu "will" cần một động từ nguyên mẫu không "to" (bare infinitive) → chọn "inspect" (thanh tra, kiểm tra).',
    ARRAY['reading', 'grammar']::text[]
  );

  -- Group #10 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    10,
    NULL,
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
    'Commercial truck drivers must submit ------- daily delivery mileage logs to dispatch every evening.',
    '["their","they","them","theirs"]'::jsonb,
    'A',
    'Đứng trước cụm danh từ "daily delivery mileage logs" cần tính từ sở hữu số nhiều tương ứng với "Commercial truck drivers" → chọn "their" (của họ).',
    ARRAY['reading', 'pronoun']::text[]
  );

  -- Group #11 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    11,
    NULL,
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
    'The container vessel remained anchored outside the harbor ------- port customs officials reviewed the shipping manifests.',
    '["while","during","despite","between"]'::jsonb,
    'A',
    'Theo sau là mệnh đề ("port customs officials reviewed the shipping manifests") diễn tả hành động diễn ra đồng thời → chọn liên từ thời gian "while" (trong khi).',
    ARRAY['reading', 'conjunction']::text[]
  );

  -- Group #12 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    5,
    12,
    NULL,
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
    'Perishable food supplies arriving at the fulfillment center must be placed ------- designated refrigeration rooms.',
    '["inside","above","along","onto"]'::jsonb,
    'A',
    'Giới từ chỉ vị trí bên trong phòng lạnh bảo quản hàng tươi sống → chọn "inside" (bên trong).',
    ARRAY['reading', 'preposition']::text[]
  );

  -- Group #13 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    6,
    13,
    'PACIFIC CARGO LOGISTICS
Customer Advisory: Shipment Tracking #PC-884920
Date: October 18
Recipient: Starlight Electronics Ltd.

Dear Valued Client,

We are writing to provide an important update regarding your shipment of precision semiconductor components (Tracking ID: PC-884920). Due to severe weather conditions along the Western Pacific maritime corridor, your container vessel was required to seek temporary anchorage outside Kaohsiung Harbor for maritime safety.

As a direct consequence of this necessary detour, the estimated arrival at the Port of Long Beach has been [131] ------- from October 22 to October 27. [132] -------. Our customs brokerage unit has already pre-filed all electronic import documentation to ensure cargo is discharged rapidly upon berthing.

Once the container is unloaded, our certified transport partner will deliver the freight [133] ------- to your Irvine assembly facility. We sincerely regret any inconvenience caused by this unavoidable maritime delay. For continuous real-time container updates, please log in to your account dashboard or [134] ------- with your dedicated client manager.',
    NULL,
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
    'Cấu trúc bị động thì hiện tại hoàn thành: "has been + V3/ed" → chọn "rescheduled" (đã được dời lịch từ 22 sang 27 tháng 10).',
    ARRAY['reading', 'grammar']::text[]
  );
  -- Question 132
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    6,
    132,
    'Choose the best sentence to fill in blank [132].',
    '["We are monitoring maritime advisories closely and will alert you to further updates.","Our corporate headquarters will host an executive banquet this weekend.","Please ensure all personal luggage is tagged before boarding the flight.","The annual software subscription fee has already been deducted."]'::jsonb,
    'A',
    'Câu trước vừa thông báo lùi ngày giao hàng do bão. Câu (A) nối tiếp thông tin trấn an và theo dõi sát sao ("Chúng tôi đang theo dõi sát sao và sẽ thông báo cho bạn").',
    ARRAY['reading', 'context']::text[]
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
    'Bổ nghĩa cho động từ "will deliver the freight" cần phó từ chỉ thể cách → chọn "directly" (giao hàng trực tiếp tới cơ sở lắp ráp của bạn).',
    ARRAY['reading', 'word-form']::text[]
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
    ARRAY['reading', 'grammar']::text[]
  );

  -- Group #14 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    14,
    'METRO TOWER MANAGEMENT
Tenant Advisory: Ground Lobby & Passenger Elevator Modernization
Date: July 15
To: All Building Occupants & Visitors

Please be advised that Metro Tower Management will begin comprehensive modernization work on our ground-floor entrance lobby and high-rise passenger elevator system starting Saturday, August 1.

Project Phases & Work Scope:
• Phase 1 (August 1 – August 14): Lobby flooring replacement and energy-efficient lighting installation. The main revolving entrance will be inaccessible; all tenants and guests must enter through the West Plaza side doors.
• Phase 2 (August 15 – August 31): High-rise elevator cab overhaul. Elevators 1 and 2 will be temporarily suspended, while Elevators 3 and 4 will operate express service servicing floors 12 through 25.

Noise & After-Hours Schedule:
To minimize business disruption, all noisy tile drilling and structural removal will occur strictly between 7:00 P.M. and 5:00 A.M. on weekdays, and throughout the weekend. Security officers will remain on duty at the West Plaza entrance 24 hours a day to assist guests and verify electronic access cards.',
    NULL,
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
    '["To inform tenants about scheduled lobby and elevator renovations","To announce an increase in monthly parking stall fees","To invite building occupants to an annual social reception","To warn employees about unexpected electrical power cuts"]'::jsonb,
    'A',
    'Tiêu đề và nội dung thông báo đều tập trung vào việc hiện đại hóa sảnh chính tầng trệt và thang máy tòa nhà Metro Tower → Chọn (A).',
    ARRAY['reading', 'main-idea']::text[]
  );
  -- Question 148
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    148,
    'Where must tenants enter the building during Phase 1?',
    '["Through the West Plaza side doors","Through the main revolving entrance","Via the underground parking loading dock","Through the fire escape stairwell"]'::jsonb,
    'A',
    'Mục Phase 1: "The main revolving entrance will be inaccessible; all tenants and guests must enter through the West Plaza side doors" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

  -- Group #15 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (
    v_test_id,
    7,
    15,
    'MEMORANDUM 1
To: Distribution Center Personnel
From: Kenji Sato, Operations Director, QuickFreight Logistics
Date: November 10
Subject: Implementation of Autonomous Guided Vehicles (AGVs)

Beginning December 1, our primary fulfillment center in Indianapolis will integrate twelve Autonomous Guided Vehicles (AGVs) into our warehouse pallet transport operations. These robotic units are engineered to transport loaded pallets from the packaging lines directly to the dispatch staging lanes, reducing manual forklift transit by forty percent.

To ensure smooth integration and maintain workplace safety, all warehouse associates must attend a mandatory 45-minute training session on AGV navigation sensors and emergency-stop protocols. Training sessions will be held daily in the main training room from November 20 to November 24.

────────────────────────────────────────────────────────

MEMORANDUM 2
To: Kenji Sato, Operations Director
From: Maria Hernandez, Shift Supervisor
Date: November 25
Subject: AGV Training Attendance Completion

Dear Kenji,
I am pleased to report that 100% of our 85 shift workers have completed the AGV safety certification course as of this morning. Technician Davis from the robotics supplier conducted thorough demonstrations on battery charging docks and safety beacon indicators.

Our shift leads noted that the designated transit lanes for the AGVs along Corridor B are somewhat narrow. We suggest repainting the floor markings to give human foot traffic an extra two feet of clearance before the robots go live on December 1. Please let me know if maintenance can proceed with this adjustment over the holiday weekend.

Best regards,
Maria Hernandez',
    NULL,
    NULL,
    NULL
  )
  RETURNING id INTO v_group_id;

  -- Question 152
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    152,
    'What is the purpose of introducing Autonomous Guided Vehicles (AGVs)?',
    '["To transport pallets from packaging lines to dispatch staging areas","To replace the warehouse security guard personnel","To package delicate glass items for international air freight","To inspect incoming freight delivery vehicles"]'::jsonb,
    'A',
    'Mục đích AGVs: "transport loaded pallets from the packaging lines directly to the dispatch staging lanes" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 153
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    153,
    'What did Maria Hernandez report regarding the safety training?',
    '["All 85 shift associates successfully completed the course","The training sessions were postponed until December","The robotics technician failed to attend the demonstration","Half of the workers requested additional training sessions"]'::jsonb,
    'A',
    'Maria Hernandez báo cáo: "100% of our 85 shift workers have completed the AGV safety certification course as of this morning" → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );
  -- Question 154
  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)
  VALUES (
    v_test_id,
    v_group_id,
    7,
    154,
    'What modification did Maria suggest before December 1?',
    '["Repainting floor markings in Corridor B to widen pedestrian clearance","Purchasing six additional robotic units from the supplier","Canceling the forklift maintenance contracts","Extending the battery charging time of the vehicles"]'::jsonb,
    'A',
    'Maria đề xuất: "We suggest repainting the floor markings to give human foot traffic an extra two feet of clearance..." → Chọn (A).',
    ARRAY['reading', 'detail']::text[]
  );

END $$;

COMMIT;

-- Báo cáo tổng số câu hỏi theo từng đề:
SELECT t.title, COUNT(q.id) AS total_questions
FROM public.tests t
LEFT JOIN public.questions q ON q.test_id = t.id
WHERE t.title LIKE 'Mini Test 25Q - Đề %'
GROUP BY t.id, t.title
ORDER BY t.title;
