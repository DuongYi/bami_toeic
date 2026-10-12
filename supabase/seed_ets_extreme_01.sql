-- =============================================================================
-- BAMI TOEIC - MASTER SEED: ETS Extreme Hard Test 01 (200 Questions - Target 990)
-- Dành cho Supabase Dashboard -> SQL Editor -> Run
-- =============================================================================
BEGIN;

-- 1. Xóa dữ liệu cũ nếu đã tồn tại
DELETE FROM public.tests WHERE title = 'ETS Extreme Hard Test 01 (Target 990)';

DO $$
DECLARE
  v_test_id uuid;
  v_group_id uuid;
BEGIN
  -- Insert test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    'ETS Extreme Hard Test 01 (Target 990)',
    'Bami TOEIC Extreme Series',
    'Bộ đề thi 200 câu siêu khó (Target 850-990) gồm 100 câu Listening và 100 câu Reading với đầy đủ bẫy ngữ pháp C1, câu hỏi hàm ý gián tiếp và 3 bài đoạn ba Triple Passages suy luận phức hợp.',
    false
  )
  RETURNING id INTO v_test_id;

  -- Group #1 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 1, 1, NULL, '(A) Blueprints have been rolled up and stored in tubes. (B) Architectural drawings are spread across a drafting table. (C) An engineer is adjusting a computer workstation. (D) Drafting equipment is being packed into crates.', 'tests/ets_extreme_01/p1_q1.m4a', 'tests/ets_extreme_01/p1_q1.png')
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 1, 1, 'Choose the statement that best describes the picture.', '["Blueprints have been rolled up and stored in tubes.","Architectural drawings are spread across a drafting table.","An engineer is adjusting a computer workstation.","Drafting equipment is being packed into crates."]'::jsonb, 'B', 'Bức tranh chụp các bản vẽ kiến trúc đang được trải rộng trên mặt bàn vẽ kỹ thuật mà không có người → Chọn (B). Bẫy (A) dùng "rolled up" (đang cuộn lại) trái ngược với thực tế; (C) và (D) bẫy hành động có người hoặc đang đóng thùng.', '["listening","photographs"]'::jsonb);

  -- Group #2 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 1, 2, NULL, '(A) Scaffolding has been erected along the exterior of a structure. (B) Construction workers are operating heavy excavators. (C) Building materials are being hoisted by an overhead crane. (D) A commercial brick wall has been demolished.', 'tests/ets_extreme_01/p1_q2.m4a', 'tests/ets_extreme_01/p1_q2.png')
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 1, 2, 'Choose the statement that best describes the picture.', '["Scaffolding has been erected along the exterior of a structure.","Construction workers are operating heavy excavators.","Building materials are being hoisted by an overhead crane.","A commercial brick wall has been demolished."]'::jsonb, 'A', 'Giàn giáo kim loại (scaffolding) đã được dựng đứng dọc theo mặt tiền ngoài của tòa nhà đá đang sửa chữa → Chọn (A). Bẫy (B), (C) dùng hành động đang diễn ra của con người/máy móc không có trong ảnh.', '["listening","photographs"]'::jsonb);

  -- Group #3 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 1, 3, NULL, '(A) Decorative glassware is perched on floating wooden shelves. (B) Plates are being dried in an industrial dishwasher. (C) A cabinet door has been removed for repairs. (D) Dining ware is stacked precariously on a countertop.', 'tests/ets_extreme_01/p1_q3.m4a', 'tests/ets_extreme_01/p1_q3.png')
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 1, 3, 'Choose the statement that best describes the picture.', '["Decorative glassware is perched on floating wooden shelves.","Plates are being dried in an industrial dishwasher.","A cabinet door has been removed for repairs.","Dining ware is stacked precariously on a countertop."]'::jsonb, 'A', 'Đồ sành sứ và thủy tinh trang trí được đặt ngay ngắn trên kệ gỗ treo tường (floating shelves) → Chọn (A). "Perched on" là cách diễn đạt tĩnh nâng cao chỉ vị trí đặt.', '["listening","photographs"]'::jsonb);

  -- Group #4 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 1, 4, NULL, '(A) Umbrellas have been set up over outdoor dining tables. (B) Customers are placing orders with a cashier. (C) Patio furniture is being loaded onto a truck. (D) Dining menus are being handed to arriving patrons.', 'tests/ets_extreme_01/p1_q4.m4a', 'tests/ets_extreme_01/p1_q4.png')
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 1, 4, 'Choose the statement that best describes the picture.', '["Umbrellas have been set up over outdoor dining tables.","Customers are placing orders with a cashier.","Patio furniture is being loaded onto a truck.","Dining menus are being handed to arriving patrons."]'::jsonb, 'A', 'Những chiếc ô che nắng (umbrellas) đã được dựng phía trên các bàn ăn ngoài trời (outdoor dining tables) → Chọn (A).', '["listening","photographs"]'::jsonb);

  -- Group #5 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 1, 5, NULL, '(A) Cargo boxes are stacked on wooden pallets in a warehouse. (B) A forklift is unloading materials from a shipping trailer. (C) Shelves are being assembled by logistics workers. (D) Safety helmets are being distributed at a loading bay.', 'tests/ets_extreme_01/p1_q5.m4a', 'tests/ets_extreme_01/p1_q5.png')
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 1, 5, 'Choose the statement that best describes the picture.', '["Cargo boxes are stacked on wooden pallets in a warehouse.","A forklift is unloading materials from a shipping trailer.","Shelves are being assembled by logistics workers.","Safety helmets are being distributed at a loading bay."]'::jsonb, 'A', 'Các thùng hàng (cargo boxes) được xếp chồng ngay ngắn trên các pallet gỗ (wooden pallets) trong nhà kho → Chọn (A).', '["listening","photographs"]'::jsonb);

  -- Group #6 (Part 1)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 1, 6, NULL, '(A) Cargo containers are stacked at a maritime shipping terminal. (B) A freight train is departing from a railway junction. (C) Vessels are being refueled at a harbor dock. (D) Commercial trucks are lined up at an inspection gate.', 'tests/ets_extreme_01/p1_q6.m4a', 'tests/ets_extreme_01/p1_q6.png')
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 1, 6, 'Choose the statement that best describes the picture.', '["Cargo containers are stacked at a maritime shipping terminal.","A freight train is departing from a railway junction.","Vessels are being refueled at a harbor dock.","Commercial trucks are lined up at an inspection gate."]'::jsonb, 'A', 'Các container hàng hóa (cargo containers) được xếp tầng cao tại khu bãi cảng hàng hải (maritime shipping terminal) → Chọn (A).', '["listening","photographs"]'::jsonb);

  -- Group #7 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 7, NULL, 'Aren''t we supposed to review the third-quarter fiscal deficit this morning? (A) Mr. Vance called in sick unexpectedly. (B) Yes, it was a substantial surplus. (C) At the quarterly branch meeting.', 'tests/ets_extreme_01/p2_q7.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 7, 'Aren''t we supposed to review the third-quarter fiscal deficit this morning?', '["Mr. Vance called in sick unexpectedly.","Yes, it was a substantial surplus.","At the quarterly branch meeting."]'::jsonb, 'A', 'Câu hỏi phủ định gián tiếp ("Chẳng phải chúng ta phải xem xét thâm hụt tài khóa sáng nay sao?"). Đáp án (A) trả lời gián tiếp: "Ông Vance bất ngờ báo ốm" nên buổi xem xét bị hoãn.', '["listening","question-response"]'::jsonb);

  -- Group #8 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 8, NULL, 'Who authorized the purchase requisition for the laboratory spectrometers? (A) That was signed off prior to my transfer to this branch. (B) They are calibrated twice a month. (C) About twenty-five thousand dollars.', 'tests/ets_extreme_01/p2_q8.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 8, 'Who authorized the purchase requisition for the laboratory spectrometers?', '["That was signed off prior to my transfer to this branch.","They are calibrated twice a month.","About twenty-five thousand dollars."]'::jsonb, 'A', 'Câu hỏi "Who" nhưng câu trả lời gián tiếp phủ nhận thông tin: "Khoản đó đã được phê duyệt trước khi tôi chuyển về chi nhánh này" (A). (B) bẫy từ spectrometers.', '["listening","question-response"]'::jsonb);

  -- Group #9 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 9, NULL, 'Why hasn''t the overseas logistics shipment arrived at the freight terminal? (A) Have you checked the maritime weather advisory for the Pacific corridor? (B) Yes, it arrived thirty minutes ago. (C) At loading dock number four.', 'tests/ets_extreme_01/p2_q9.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 9, 'Why hasn''t the overseas logistics shipment arrived at the freight terminal?', '["Have you checked the maritime weather advisory for the Pacific corridor?","Yes, it arrived thirty minutes ago.","At loading dock number four."]'::jsonb, 'A', 'Câu hỏi nguyên nhân "Why" được trả lời bằng một câu hỏi ngược lại (Counter-question) chỉ bão hàng hải ở hành lang Thái Bình Dương (A).', '["listening","question-response"]'::jsonb);

  -- Group #10 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 10, NULL, 'Should we reserve the executive boardroom or conduct the briefing virtually? (A) Several overseas board members couldn''t secure flight visas. (B) Yes, the boardroom is reserved. (C) The briefing lasted forty-five minutes.', 'tests/ets_extreme_01/p2_q10.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 10, 'Should we reserve the executive boardroom or conduct the briefing virtually?', '["Several overseas board members couldn''t secure flight visas.","Yes, the boardroom is reserved.","The briefing lasted forty-five minutes."]'::jsonb, 'A', 'Câu hỏi lựa chọn (phòng họp trực tiếp hay trực tuyến). Đáp án (A) đưa ra lý do gián tiếp chọn trực tuyến: "Nhiều thành viên hội đồng ở nước ngoài không xin được visa".', '["listening","question-response"]'::jsonb);

  -- Group #11 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 11, NULL, 'Where can I locate the compliance handbook for hazardous chemical disposal? (A) It''s pinned to the top of the internal safety intranet portal. (B) All industrial chemicals are sealed. (C) No, we disposed of the containers.', 'tests/ets_extreme_01/p2_q11.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 11, 'Where can I locate the compliance handbook for hazardous chemical disposal?', '["It''s pinned to the top of the internal safety intranet portal.","All industrial chemicals are sealed.","No, we disposed of the containers."]'::jsonb, 'A', 'Hỏi vị trí cuốn sổ tay hướng dẫn → (A) "Nó được ghim ở đầu cổng thông tin an toàn nội bộ".', '["listening","question-response"]'::jsonb);

  -- Group #12 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 12, NULL, 'The graphic design team hasn''t submitted their revised promotional drafts yet. (A) They were granted an extension until Friday noon. (B) I prefer the blue color palette. (C) Yes, the draft was submitted yesterday.', 'tests/ets_extreme_01/p2_q12.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 12, 'The graphic design team hasn''t submitted their revised promotional drafts yet.', '["They were granted an extension until Friday noon.","I prefer the blue color palette.","Yes, the draft was submitted yesterday."]'::jsonb, 'A', 'Câu trần thuật ngụ ý phàn nàn việc nộp muộn → phản hồi giải thích gián tiếp: "Họ đã được gia hạn thời gian đến trưa thứ Sáu" (A).', '["listening","question-response"]'::jsonb);

  -- Group #13 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 13, NULL, 'When is the deadline for submitting competitive tender bids for the city transit project? (A) Didn''t you receive the addendum from the municipal council? (B) By municipal train or subway. (C) Yes, our bid was very competitive.', 'tests/ets_extreme_01/p2_q13.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 13, 'When is the deadline for submitting competitive tender bids for the city transit project?', '["Didn''t you receive the addendum from the municipal council?","By municipal train or subway.","Yes, our bid was very competitive."]'::jsonb, 'A', 'Hỏi thời hạn nộp hồ sơ thầu → phản hồi bằng câu hỏi ngược lại: "Bạn không nhận được văn bản phụ lục từ hội đồng thành phố à?" (chỉ ra thời hạn đã thay đổi trong phụ lục) (A).', '["listening","question-response"]'::jsonb);

  -- Group #14 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 14, NULL, 'Would you mind inspecting the sound baffling in conference hall B before the keynote? (A) The audiovisual technicians are already in there. (B) I didn''t mind the keynote address at all. (C) In the primary auditorium.', 'tests/ets_extreme_01/p2_q14.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 14, 'Would you mind inspecting the sound baffling in conference hall B before the keynote?', '["The audiovisual technicians are already in there.","I didn''t mind the keynote address at all.","In the primary auditorium."]'::jsonb, 'A', 'Lời yêu cầu kiểm tra cách âm → phản hồi gián tiếp: "Kỹ thuật viên âm thanh ánh sáng đang ở trong đó rồi" (A). (B) bẫy lặp từ mind và keynote.', '["listening","question-response"]'::jsonb);

  -- Group #15 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 15, NULL, 'How did the executive committee react to our divestment proposal? (A) Their feedback will be summarized in tomorrow''s board communique. (B) Yes, they reacted very strongly. (C) We proposed divesting three subsidiaries.', 'tests/ets_extreme_01/p2_q15.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 15, 'How did the executive committee react to our divestment proposal?', '["Their feedback will be summarized in tomorrow''s board communique.","Yes, they reacted very strongly.","We proposed divesting three subsidiaries."]'::jsonb, 'A', 'Hỏi về phản ứng của ban điều hành đối với đề xuất thoái vốn → phản hồi gián tiếp hoãn thông tin: "Ý kiến của họ sẽ được tóm tắt trong thông cáo ngày mai" (A).', '["listening","question-response"]'::jsonb);

  -- Group #16 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 16, NULL, 'Has the corporate counsel reviewed the indemnity clause in the acquisition contract? (A) She requested two minor revisions to the warranty terms. (B) No, the corporation was founded in 2010. (C) Yes, counsel is available on floor five.', 'tests/ets_extreme_01/p2_q16.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 16, 'Has the corporate counsel reviewed the indemnity clause in the acquisition contract?', '["She requested two minor revisions to the warranty terms.","No, the corporation was founded in 2010.","Yes, counsel is available on floor five."]'::jsonb, 'A', 'Hỏi luật sư đã duyệt điều khoản bồi thường chưa → trả lời gián tiếp xác nhận đã xem và đưa ra góp ý chỉnh sửa: "Bà ấy đã yêu cầu hai sửa đổi nhỏ" (A).', '["listening","question-response"]'::jsonb);

  -- Group #17 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 17, NULL, 'Which catering vendor did we contract for the annual honors gala? (A) Didn''t Eleanor circulate the vendor agreement yesterday? (B) Yes, it was a tremendous honor. (C) About one hundred and fifty dinner guests.', 'tests/ets_extreme_01/p2_q17.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 17, 'Which catering vendor did we contract for the annual honors gala?', '["Didn''t Eleanor circulate the vendor agreement yesterday?","Yes, it was a tremendous honor.","About one hundred and fifty dinner guests."]'::jsonb, 'A', 'Hỏi nhà cung cấp tiệc nào được chọn → trả lời bằng câu hỏi phản bác: "Chẳng phải Eleanor đã gửi thỏa thuận nhà cung cấp hôm qua rồi sao?" (A).', '["listening","question-response"]'::jsonb);

  -- Group #18 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 18, NULL, 'I thought the server migration was scheduled for this coming weekend. (A) The database architect requested an additional round of stress tests. (B) Yes, the weekend weather was wonderful. (C) Over two thousand gigabytes of data.', 'tests/ets_extreme_01/p2_q18.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 18, 'I thought the server migration was scheduled for this coming weekend.', '["The database architect requested an additional round of stress tests.","Yes, the weekend weather was wonderful.","Over two thousand gigabytes of data."]'::jsonb, 'A', 'Câu trần thuật hoài nghi về lịch chuyển đổi server → giải thích lý do trì hoãn: "Kiến trúc sư cơ sở dữ liệu đã yêu cầu thêm một đợt kiểm thử chịu tải" (A).', '["listening","question-response"]'::jsonb);

  -- Group #19 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 19, NULL, 'Can you provide a preliminary estimate for the structural lobby refurbishment? (A) The general contractor hasn''t inspected the load-bearing pillars yet. (B) The lobby is open twenty-four hours. (C) Yes, I refurbished the old furniture.', 'tests/ets_extreme_01/p2_q19.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 19, 'Can you provide a preliminary estimate for the structural lobby refurbishment?', '["The general contractor hasn''t inspected the load-bearing pillars yet.","The lobby is open twenty-four hours.","Yes, I refurbished the old furniture."]'::jsonb, 'A', 'Hỏi dự toán sơ bộ chi phí sửa sảnh → trả lời gián tiếp chưa thể đưa ra con số vì nhà thầu chưa kiểm tra các trụ chịu lực (A).', '["listening","question-response"]'::jsonb);

  -- Group #20 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 20, NULL, 'Why was the quarterly dividend payout lower than market analysts anticipated? (A) A substantial portion of earnings was reinvested into research and development. (B) Every three months according to corporate bylaws. (C) Yes, dividends will increase shortly.', 'tests/ets_extreme_01/p2_q20.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 20, 'Why was the quarterly dividend payout lower than market analysts anticipated?', '["A substantial portion of earnings was reinvested into research and development.","Every three months according to corporate bylaws.","Yes, dividends will increase shortly."]'::jsonb, 'A', 'Hỏi tại sao cổ tức chi trả thấp hơn dự báo → giải thích tài chính hợp lý: "Một phần đáng kể lợi nhuận đã được tái đầu tư vào R&D" (A). (B) bẫy quarterly.', '["listening","question-response"]'::jsonb);

  -- Group #21 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 21, NULL, 'Do you prefer flying business class to Frankfurt, or taking the overnight express train? (A) Corporate policy restricts flights for journeys under four hours. (B) Yes, Frankfurt is a major financial hub. (C) The overnight train leaves at eleven.', 'tests/ets_extreme_01/p2_q21.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 21, 'Do you prefer flying business class to Frankfurt, or taking the overnight express train?', '["Corporate policy restricts flights for journeys under four hours.","Yes, Frankfurt is a major financial hub.","The overnight train leaves at eleven."]'::jsonb, 'A', 'Hỏi lựa chọn máy bay hay tàu → đưa ra quy định công ty loại trừ phương án bay: "Quy định công ty hạn chế bay đối với các chuyến dưới bốn tiếng" (A).', '["listening","question-response"]'::jsonb);

  -- Group #22 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 22, NULL, 'Isn''t the patent filing for the synthetic enzyme due by the end of business today? (A) Our legal team filed for an expedited grace period. (B) Yes, enzymes speed up biological reactions. (C) In the central patent filing cabinet.', 'tests/ets_extreme_01/p2_q22.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 22, 'Isn''t the patent filing for the synthetic enzyme due by the end of business today?', '["Our legal team filed for an expedited grace period.","Yes, enzymes speed up biological reactions.","In the central patent filing cabinet."]'::jsonb, 'A', 'Câu hỏi thời hạn nộp bằng sáng chế → trả lời gián tiếp đội pháp lý đã nộp đơn xin ân hạn đặc biệt (A).', '["listening","question-response"]'::jsonb);

  -- Group #23 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 23, NULL, 'Who was appointed to succeed Dr. Thornton as chair of the ethics committee? (A) The nomination ballots are still being tabulated by the secretary. (B) Dr. Thornton served for five years. (C) In the ethics conference suite.', 'tests/ets_extreme_01/p2_q23.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 23, 'Who was appointed to succeed Dr. Thornton as chair of the ethics committee?', '["The nomination ballots are still being tabulated by the secretary.","Dr. Thornton served for five years.","In the ethics conference suite."]'::jsonb, 'A', 'Hỏi ai được bổ nhiệm thay thế → trả lời gián tiếp kết quả bỏ phiếu vẫn đang được kiểm đếm (A).', '["listening","question-response"]'::jsonb);

  -- Group #24 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 24, NULL, 'Could you walk the prospective investors through the manufacturing cleanroom? (A) All visitors must undergo mandatory sanitization clearance first. (B) We walked about three miles yesterday. (C) Yes, cleanrooms are very sanitary.', 'tests/ets_extreme_01/p2_q24.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 24, 'Could you walk the prospective investors through the manufacturing cleanroom?', '["All visitors must undergo mandatory sanitization clearance first.","We walked about three miles yesterday.","Yes, cleanrooms are very sanitary."]'::jsonb, 'A', 'Yêu cầu dẫn khách đầu tư đi xem phòng sạch → đưa ra điều kiện tiên quyết cần làm trước: "Mọi khách thăm đều phải trải qua thủ tục khử trùng bắt buộc trước đã" (A).', '["listening","question-response"]'::jsonb);

  -- Group #25 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 25, NULL, 'The ventilation system in the southern cleanroom is emitting an irregular hum. (A) I''ll alert facilities engineering immediately. (B) Yes, the air is very clean. (C) About twenty degrees Celsius.', 'tests/ets_extreme_01/p2_q25.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 25, 'The ventilation system in the southern cleanroom is emitting an irregular hum.', '["I''ll alert facilities engineering immediately.","Yes, the air is very clean.","About twenty degrees Celsius."]'::jsonb, 'A', 'Câu trần thuật báo sự cố máy thông gió phát tiếng kêu bất thường → phản hồi hành động tức thì: "Tôi sẽ báo ngay cho bộ phận kỹ thuật cơ sở vật chất" (A).', '["listening","question-response"]'::jsonb);

  -- Group #26 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 26, NULL, 'Where did you file the confidential non-disclosure agreements from the buyout talks? (A) They are stored in the encrypted cloud repository. (B) Yes, the buyout talks went smoothly. (C) Under no circumstances whatsoever.', 'tests/ets_extreme_01/p2_q26.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 26, 'Where did you file the confidential non-disclosure agreements from the buyout talks?', '["They are stored in the encrypted cloud repository.","Yes, the buyout talks went smoothly.","Under no circumstances whatsoever."]'::jsonb, 'A', 'Hỏi nơi lưu trữ tài liệu bảo mật thỏa thuận mua lại → (A) "Chúng được lưu trữ trong kho lưu trữ đám mây mã hóa".', '["listening","question-response"]'::jsonb);

  -- Group #27 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 27, NULL, 'Why didn''t you mention the supply chain bottleneck during the regional managers'' briefing? (A) I was waiting for concrete dispatch confirmations from Kaohsiung. (B) The bottleneck is made of tempered glass. (C) Yes, all regional managers attended.', 'tests/ets_extreme_01/p2_q27.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 27, 'Why didn''t you mention the supply chain bottleneck during the regional managers'' briefing?', '["I was waiting for concrete dispatch confirmations from Kaohsiung.","The bottleneck is made of tempered glass.","Yes, all regional managers attended."]'::jsonb, 'A', 'Hỏi lý do không đề cập ách tắc chuỗi cung ứng trong cuộc họp → giải thích chiến lược: "Tôi đang chờ xác nhận điều động cụ thể từ Kaohsiung" (A). (B) bẫy nghĩa đen của bottleneck.', '["listening","question-response"]'::jsonb);

  -- Group #28 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 28, NULL, 'Should we hire an external forensic accounting firm, or perform the compliance audit internally? (A) Our internal audit division is already operating at maximum capacity. (B) Yes, forensic audits are very expensive. (C) The accounting firm was founded in 1995.', 'tests/ets_extreme_01/p2_q28.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 28, 'Should we hire an external forensic accounting firm, or perform the compliance audit internally?', '["Our internal audit division is already operating at maximum capacity.","Yes, forensic audits are very expensive.","The accounting firm was founded in 1995."]'::jsonb, 'A', 'Hỏi lựa chọn thuê ngoài hay tự kiểm toán nội bộ → loại trừ phương án tự làm: "Bộ phận kiểm toán nội bộ của chúng ta đang hoạt động hết công suất rồi" (ngụ ý phải thuê ngoài) (A).', '["listening","question-response"]'::jsonb);

  -- Group #29 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 29, NULL, 'I don''t think we can finalize the marketing budget without input from the regional vice president. (A) She is currently on a transatlantic flight until tomorrow morning. (B) The marketing budget grew by ten percent. (C) No, I don''t think so either.', 'tests/ets_extreme_01/p2_q29.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 29, 'I don''t think we can finalize the marketing budget without input from the regional vice president.', '["She is currently on a transatlantic flight until tomorrow morning.","The marketing budget grew by ten percent.","No, I don''t think so either."]'::jsonb, 'A', 'Ý kiến cần ý kiến của phó chủ tịch khu vực → đưa ra rào cản thực tế: "Bà ấy hiện đang trên chuyến bay xuyên Đại Tây Dương cho đến sáng mai" (A).', '["listening","question-response"]'::jsonb);

  -- Group #30 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 30, NULL, 'Was the commercial lease for the suburban distribution depot renewed? (A) Negotiations stalled over property tax indemnification. (B) Yes, it is leased for three years. (C) In the northern suburban industrial park.', 'tests/ets_extreme_01/p2_q30.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 30, 'Was the commercial lease for the suburban distribution depot renewed?', '["Negotiations stalled over property tax indemnification.","Yes, it is leased for three years.","In the northern suburban industrial park."]'::jsonb, 'A', 'Hỏi hợp đồng thuê kho ngoại ô đã được gia hạn chưa → trả lời gián tiếp trở ngại: "Đàm phán đang bế tắc vì điều khoản bồi hoàn thuế bất động sản" (A).', '["listening","question-response"]'::jsonb);

  -- Group #31 (Part 2)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 2, 31, NULL, 'Doesn''t the municipal zoning code prohibit commercial billboards along the harbor boulevard? (A) An exception was granted for civic and cultural events. (B) Yes, the harbor water is very deep. (C) Commercial zoning codes are updated annually.', 'tests/ets_extreme_01/p2_q31.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 2, 31, 'Doesn''t the municipal zoning code prohibit commercial billboards along the harbor boulevard?', '["An exception was granted for civic and cultural events.","Yes, the harbor water is very deep.","Commercial zoning codes are updated annually."]'::jsonb, 'A', 'Câu hỏi quy hoạch đô thị có cấm biển quảng cáo không → trả lời giải thích ngoại lệ được cấp phép: "Một ngoại lệ đã được cấp cho các sự kiện văn hóa và cộng đồng" (A).', '["listening","question-response"]'::jsonb);

  -- Group #32 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 32, NULL, 'W: Mr. Sterling, I have reviewed the draft commercial lease for our new regional design studio on Fifth Avenue, and I noticed the landlord inserted a clause holding us liable for all structural roof repairs.
M: That is completely contrary to standard commercial leasing practices in Manhattan. Did you bring this up with their broker?
W: I sent an inquiry this morning, but their representative stated that the property owner is unwilling to renegotiate due to high tenant demand.
M: In that case, instruct our corporate real estate agent to resume talks with the building on Madison Avenue. We cannot accept open-ended structural liabilities.', 'tests/ets_extreme_01/p3_q32-34.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 32, 'What problem does the woman identify in the commercial lease agreement?', '["A clause assigns roof repair costs to the tenant","The monthly rent increases by twenty percent annually","The move-in date was postponed by three months","Subleasing office space is strictly prohibited"]'::jsonb, 'A', 'Người phụ nữ phát hiện chủ nhà chèn điều khoản buộc bên thuê chịu trách nhiệm sửa chữa kết cấu mái ("holding us liable for all structural roof repairs") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 33, 'Why did the landlord''s representative refuse to modify the lease terms?', '["High tenant demand for the property","The building is designated a historical landmark","Renovation permits have not been issued","The broker was out of the country"]'::jsonb, 'A', 'Đại diện bên cho thuê từ chối vì nhu cầu thuê tại khu vực đó quá cao ("property owner is unwilling to renegotiate due to high tenant demand") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 34, 'What does the man decide to do?', '["Reopen negotiations for a different property","Accept the landlord''s revised terms","File a complaint with the municipal housing authority","Hire an independent structural engineer"]'::jsonb, 'A', 'Người nam chỉ đạo: "instruct our corporate real estate agent to resume talks with the building on Madison Avenue" (nối lại đàm phán với tòa nhà khác) → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #33 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 33, NULL, 'M: Brenda, have we received the semiconductor controller units from our Taiwanese manufacturer? Our assembly line in Michigan is scheduled to commence production on Monday.
W: Unfortunately, no, David. Customs clearance at the Port of Long Beach has been backed up for over a week due to terminal automation upgrades.
M: That will cause a major bottleneck for our automotive client contracts. Can we airfreight an emergency batch directly from Taipei?
W: Air cargo rates are currently at an all-time peak, but given our contractual liquidated damages penalties for late vehicle delivery, it is undeniably the more economical option.', 'tests/ets_extreme_01/p3_q35-37.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 35, 'What component is delayed in transit?', '["Semiconductor controller units","Refrigerated vehicle batteries","Hydraulic brake lines","Industrial assembly robotic arms"]'::jsonb, 'A', 'Linh kiện bị chậm trễ là bộ điều khiển bán dẫn ("semiconductor controller units") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 36, 'What caused the delivery delay at the seaport?', '["Terminal automation modernization upgrades","A maritime typhoon warning in the Pacific","A labor dispute among dockworkers","Severe damage to container packaging"]'::jsonb, 'A', 'Hải quan cảng bị ùn ứ do nâng cấp tự động hóa bến bãi ("due to terminal automation upgrades") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 37, 'Why does the woman support shipping an emergency batch by airfreight?', '["To avoid severe financial penalties for delayed delivery","Airfreight shipping rates recently dropped by half","The client offered to cover all transportation surcharges","The maritime shipment was permanently lost at sea"]'::jsonb, 'A', 'Người phụ nữ đồng ý vì tiền phạt bồi thường vi phạm hợp đồng do giao chậm còn đắt hơn ("contractual liquidated damages penalties for late vehicle delivery") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #34 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 34, NULL, 'W: Marcus, several regional sales managers have reported that the newly migrated enterprise resource platform is duplicating client invoices.
M: That is concerning. The software vendor assured us that their data reconciliation algorithm had achieved ninety-nine percent accuracy during beta testing.
W: Well, several of our key enterprise clients received double billing statements yesterday and their procurement officers are demanding an explanation.
M: I will convene an emergency conference with the vendor''s chief technical architect in fifteen minutes and roll back the database transaction ledger to yesterday morning''s backup.', 'tests/ets_extreme_01/p3_q38-40.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 38, 'What technical malfunction has occurred with the new enterprise platform?', '["Client billing invoices are being duplicated","Customer passwords were leaked online","Sales representatives cannot log into mobile devices","Transaction currencies are calculating erroneously"]'::jsonb, 'A', 'Hệ thống ERP mới bị lỗi nhân bản hóa đơn khách hàng ("duplicating client invoices") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 39, 'Who does Marcus intend to meet with shortly?', '["The software vendor''s chief technical architect","The company''s chief financial officer","An external corporate forensic auditor","Frustrated enterprise client representatives"]'::jsonb, 'A', 'Marcus thông báo sẽ họp khẩn cấp với kiến trúc sư trưởng kỹ thuật của nhà cung cấp phần mềm ("the vendor''s chief technical architect") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 40, 'What immediate remedial action will Marcus implement?', '["Revert the transaction ledger to a previous backup","Permanently terminate the vendor''s software contract","Offer affected customers a twenty percent service discount","Shut down the corporate data center for the entire week"]'::jsonb, 'A', 'Hành động khôi phục dữ liệu: "roll back the database transaction ledger to yesterday morning''s backup" → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #35 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 35, NULL, 'M: Dr. Alvarez, the clinical trial results for our cardiovascular medication, Corasol, have exceeded our efficacy targets in Phase Three.
W: That is fantastic news, Gregory! However, we still have to clear the federal regulatory compliance panel before establishing manufacturing timelines.
M: Our legal team has already assembled the comprehensive documentation dossier. Do you think we can schedule the submission briefing for November?
W: Given the agency''s recent staffing shortages, I would advise budgeting an additional eight weeks for review.', 'tests/ets_extreme_01/p3_q41-43.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 41, 'What milestone has the pharmaceutical research team achieved?', '["Exceeded efficacy targets in clinical trial Phase Three","Received unconditional marketing approval from the government","Signed an overseas licensing distribution agreement","Reduced manufacturing costs by fifty percent"]'::jsonb, 'A', 'Nhóm nghiên cứu vượt mục tiêu hiệu quả thử nghiệm lâm sàng giai đoạn 3 ("exceeded our efficacy targets in Phase Three") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 42, 'What hurdle must the team overcome before manufacturing begins?', '["Federal regulatory agency compliance clearance","Constructing a cleanroom laboratory facility","Recruiting additional medical trial volunteers","Securing venture capital funding"]'::jsonb, 'A', 'Rào cản là phải vượt qua kiểm định của cơ quan quản lý liên bang ("clear the federal regulatory compliance panel") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 43, 'What does Dr. Alvarez recommend regarding the project schedule?', '["Allowing an extra eight weeks for regulatory review","Canceling the submission briefing in November","Hiring external consultants to draft the dossier","Delaying clinical trials until next spring"]'::jsonb, 'A', 'Bác sĩ Alvarez khuyên: "budgeting an additional eight weeks for review" do cơ quan quản lý thiếu nhân sự → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #36 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 36, NULL, 'W: Jonathan, the merger acquisition committee wants our corporate valuation of Nexa Robotics completed by Thursday afternoon.
M: By Thursday? That''s a rather optimistic timeline. We haven''t even received their audited intellectual property portfolio yet.
W: I understand, but the board of directors is meeting with Nexa''s executive founders on Friday morning to negotiate final share allocations.
M: Well, in that case, I will have our junior financial analysts focus exclusively on their balance sheets, while I examine their patent liabilities tonight.', 'tests/ets_extreme_01/p3_q44-46.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 44, 'What task has Jonathan been assigned to complete?', '["A corporate financial valuation of Nexa Robotics","An intellectual property patent renewal application","An employee compensation review for robotic engineers","A marketing launch campaign for autonomous drones"]'::jsonb, 'A', 'Jonathan được giao thẩm định giá trị doanh nghiệp Nexa Robotics ("corporate valuation of Nexa Robotics") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 45, 'What does the man imply when he says: "That''s a rather optimistic timeline"?', '["The requested deadline is practically unrealistic","He believes the merger will be overwhelmingly successful","He expects the project to conclude ahead of schedule","The client company has an exceptionally bright financial future"]'::jsonb, 'A', 'Câu ngụ ý kinh điển: "That''s a rather optimistic timeline" (Lịch đó quá lạc quan đấy) ám chỉ thời hạn thứ Năm được giao là phi thực tế và quá gấp gáp ("The requested deadline is practically unrealistic") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 46, 'How will Jonathan manage the remaining workload?', '["By dividing tasks between junior analysts and himself","By requesting a formal two-week deadline extension","By outsourcing patent evaluations to an independent law firm","By skipping the analysis of intellectual property records"]'::jsonb, 'A', 'Người nam giải quyết bằng cách phân chia: các chuyên viên cấp dưới làm bảng cân đối kế toán, còn ông tự kiểm tra nghĩa vụ bằng sáng chế đêm nay → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #37 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 37, NULL, 'M: Sandra, have you seen the user feedback on app stores following yesterday''s mobile banking update? Our app rating plummeted from four point eight to two point nine stars.
W: Yes, Kevin. Users are experiencing session timeouts whenever they attempt biometric face recognition login on older smartphone operating systems.
M: Our customer support call center is inundated with complaints, and wait times are exceeding forty minutes.
W: Our mobile engineering squad has already pushed a hotfix patch to app stores this morning. We should post an immediate advisory on our social media channels explaining how users can download the update.', 'tests/ets_extreme_01/p3_q47-49.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 47, 'What is causing user complaints regarding the mobile banking application?', '["Biometric face authentication fails on older operating systems","Online wire transfers are charging double transaction fees","Account balances are displaying incorrect currencies","The app font size cannot be adjusted"]'::jsonb, 'A', 'Nguyên nhân gây phàn nàn là lỗi đăng nhập nhận diện khuôn mặt sinh trắc học trên các hệ điều hành cũ ("session timeouts whenever they attempt biometric face recognition login on older smartphone operating systems") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 48, 'What consequence does the man mention?', '["Customer support call center wait times have surged","Several corporate banking clients closed their accounts","The app was permanently removed from app stores","The bank incurred financial fines from regulators"]'::jsonb, 'A', 'Hệ quả: Trung tâm hỗ trợ khách hàng ngập tràn cuộc gọi, thời gian chờ vượt 40 phút ("wait times are exceeding forty minutes") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 49, 'What does Sandra suggest doing next?', '["Publishing an advisory notice on social media platforms","Reverting the mobile banking app to the previous version","Providing complimentary gift cards to dissatisfied callers","Hiring temporary call center operators"]'::jsonb, 'A', 'Sandra đề xuất đăng thông báo hướng dẫn tải bản vá lỗi trên mạng xã hội ("post an immediate advisory on our social media channels") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #38 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 38, NULL, 'W: Robert, the industrial engineering report estimates that deploying autonomous guided vehicles in our Louisville distribution center will cut operational transit costs by thirty-two percent.
M: The figures look compelling, Elena, but the initial capital expenditure for twenty robotic units and inductive floor charging docks exceeds one point eight million dollars.
W: That''s true, but the robotics manufacturer offers a five-year leasing structure with comprehensive hardware maintenance included, which spreads the cost into manageable monthly operating expenses.
M: That changes the financial calculus considerably. Let''s draft a board proposal highlighting the leasing model for next Tuesday''s capital allocation review.', 'tests/ets_extreme_01/p3_q50-52.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 50, 'What technology is the distribution center considering implementing?', '["Autonomous guided robotic vehicles","Automated drone parcel delivery systems","Solar panel rooftop generation arrays","Barcode scanning wristbands"]'::jsonb, 'A', 'Công nghệ được cân nhắc là robot tự hành AGVs trong nhà kho ("deploying autonomous guided vehicles") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 51, 'What concern does Robert raise initially?', '["The high initial capital expense of the machinery","The lack of floor space in the warehouse aisles","A potential strike by warehouse forklift operators","Unreliable battery performance in cold weather"]'::jsonb, 'A', 'Mối lo ngại ban đầu là chi phí đầu tư ban đầu quá cao lên tới 1.8 triệu đô ("initial capital expenditure ... exceeds one point eight million dollars") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 52, 'What solution makes the project financially feasible?', '["A five-year equipment leasing program with maintenance included","A government green technology innovation tax credit","Sharing equipment with a neighboring distribution facility","Purchasing pre-owned refurbished robotic models"]'::jsonb, 'A', 'Giải pháp khả thi là gói thuê máy 5 năm bao gồm bảo trì ("five-year leasing structure with comprehensive hardware maintenance included") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #39 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 39, NULL, 'M: Victoria, the brand strategy division is concerned about the draft video advertisements for our organic skincare line. They feel the tone is overly technical and fails to connect emotionally with millennial consumers.
W: I understand their feedback, Martin, but our primary competitive advantage over mass-market brands is our clinical dermatological data. If we dilute the scientific evidence, we risk looking like every other generic beauty brand.
M: What if we adopt a hybrid approach? The first thirty seconds can showcase real consumer lifestyle testimonials, followed by an animated breakdown of our patented peptide formulation.
W: That strikes a sound balance. I will ask the creative director to storyboard that hybrid concept before our client presentation on Thursday.', 'tests/ets_extreme_01/p3_q53-55.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 53, 'What criticism was made regarding the draft skincare video advertisements?', '["The tone was excessively technical and lacked emotional connection","The production budget exceeded approved financial limits","The featured actors were unfamiliar to international audiences","The video length was too long for television broadcast"]'::jsonb, 'A', 'Bộ phận thương hiệu phê bình video quá mang tính học thuật kỹ thuật và thiếu kết nối cảm xúc ("tone is overly technical and fails to connect emotionally") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 54, 'Why does Victoria defend including scientific data in the campaign?', '["Clinical evidence differentiates the product from competitors","Government regulations require proof of all cosmetic claims","The company CEO holds a doctorate in biochemistry","Testimonial advertisements have declining viewer engagement"]'::jsonb, 'A', 'Victoria bảo vệ dữ liệu khoa học vì đó là lợi thế cạnh tranh cốt lõi ("our primary competitive advantage ... is our clinical dermatological data") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 55, 'What compromise does Martin propose?', '["Combining consumer testimonials with scientific animation","Halving the marketing budget for digital advertising","Postponing the campaign launch until the holiday season","Focusing advertisements solely on professional dermatologists"]'::jsonb, 'A', 'Giải pháp dung hòa là kết hợp cảm xúc người dùng 30 giây đầu và phân tích khoa học hoạt chất ở phần sau ("hybrid approach: consumer lifestyle testimonials, followed by an animated breakdown") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #40 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 40, NULL, 'W: Alan, Professor Lindqvist just called from Stockholm. Severe snowstorms across Northern Europe have grounded all transatlantic flights out of Arlanda Airport. He cannot deliver the opening keynote at our biotechnology symposium tomorrow.
M: That is disastrous! He was our marquee speaker, and over four hundred delegates registered specifically to hear his gene-editing findings. Is there any chance he can board a flight later tonight?
W: The airport authorities have shut down runways until tomorrow afternoon.
M: I wouldn''t count on it. We must set up high-definition video conferencing in the grand auditorium immediately so he can present remotely from Sweden.', 'tests/ets_extreme_01/p3_q56-58.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 56, 'Why is Professor Lindqvist unable to attend the symposium in person?', '["Severe winter weather grounded his flight out of Stockholm","He contracted a sudden contagious respiratory illness","His presentation slides were corrupted during file transfer","He was denied a foreign entry visa"]'::jsonb, 'A', 'Giáo sư Lindqvist không thể đến vì bão tuyết khiến toàn bộ chuyến bay bị hủy ("Severe snowstorms across Northern Europe have grounded all transatlantic flights") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 57, 'Why does the man say: "I wouldn''t count on it"?', '["To indicate that an in-person arrival is hopeless","To question the official weather forecast accuracy","To dispute the delegate registration figures","To suggest hiring a different keynote speaker"]'::jsonb, 'A', 'Câu nói: "I wouldn''t count on it" (Tôi sẽ không trông mong vào điều đó đâu) nhằm nhấn mạnh rằng việc giáo sư bay kịp là điều hoàn toàn vô vọng và không nên chờ đợi nữa ("indicate that an in-person arrival is hopeless") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 58, 'What solution does Alan propose?', '["Arranging for the speaker to deliver his talk via video conference","Canceling the opening morning session of the symposium","Rerouting the speaker''s itinerary through London Heathrow","Refunding registration tickets to all 400 delegates"]'::jsonb, 'A', 'Alan đưa ra giải pháp thuyết trình từ xa qua cầu truyền hình ("set up high-definition video conferencing ... so he can present remotely from Sweden") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #41 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 41, NULL, 'M: Teresa, the regional environmental protection agency conducted an unannounced inspection of our industrial wastewater treatment plant yesterday afternoon.
W: Did the inspectors identify any compliance violations, Harold? We recently overhauled our filtration membranes.
M: The chemical purification levels passed with distinction, but they issued a formal citation regarding our hazardous sludge storage containment basins. The containment berms are six inches below the revised municipal flood-risk threshold.
W: We cannot risk an environmental shutdown fine. I will contact Apex Civil Engineering right away to submit blueprints for elevating the containment berms before the sixty-day compliance deadline.', 'tests/ets_extreme_01/p3_q59-61.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 59, 'What facility was subjected to an unannounced government inspection?', '["An industrial wastewater treatment plant","A commercial dairy processing facility","A hazardous chemical synthesis laboratory","An automated container manufacturing depot"]'::jsonb, 'A', 'Cơ sở bị thanh tra đột xuất là nhà máy xử lý nước thải công nghiệp ("industrial wastewater treatment plant") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 60, 'What deficiency resulted in a formal citation?', '["Containment berms failed to meet updated flood-risk height standards","Chemical filtration membranes were clogged with debris","Employee safety training logs were missing signatures","Wastewater discharge valves were leaking into the river"]'::jsonb, 'A', 'Lỗi bị phạt cảnh cáo: bờ bao chứa bùn thải thấp hơn 6 inch so với quy chuẩn chống lũ mới của thành phố ("containment berms are six inches below the revised municipal flood-risk threshold") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 61, 'What will Teresa do to resolve the citation?', '["Engage a civil engineering firm to elevate the containment berms","Appeal the environmental agency''s ruling in municipal court","Shut down the chemical processing plant indefinitely","Request an exemption from local flood zoning regulations"]'::jsonb, 'A', 'Teresa sẽ thuê công ty kỹ thuật xây dựng để nâng cao bờ bao chống lũ trước hạn 60 ngày ("contact Apex Civil Engineering right away to submit blueprints for elevating the containment berms") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #42 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 42, NULL, 'W: Gregory, our human resources analytics reveal that attrition among senior software developers has increased by eighteen percent over the past two quarters.
M: Competitors in the Silicon Valley area are offering aggressive equity packages and flexible remote working stipends that our current compensation structure cannot match.
W: If we lose our lead AI architects, the development schedule for our next-generation autonomous drone platform will slip by at least six months.
M: I will present a revised retention compensation model to the executive compensation committee on Friday, proposing performance-based restricted stock grants and a quarterly home-office technology allowance.', 'tests/ets_extreme_01/p3_q62-64.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 62, 'What workplace trend are the speakers addressing?', '["Rising employee turnover among senior software developers","Declining productivity in remote engineering teams","A lack of qualified applicants for entry-level internships","Increasing healthcare insurance costs across departments"]'::jsonb, 'A', 'Vấn đề được bàn thảo là tỷ lệ thôi việc của lập trình viên cấp cao tăng 18% ("attrition among senior software developers has increased by eighteen percent") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 63, 'What potential consequence does the woman highlight?', '["A six-month delay in the autonomous drone project timeline","The loss of multi-million dollar defense contract bids","A mandatory reduction in overall company staffing","Cancellation of the annual shareholder dividend payment"]'::jsonb, 'A', 'Hậu quả nếu mất kỹ sư AI trưởng là dự án drone tự hành sẽ bị trễ 6 tháng ("autonomous drone platform will slip by at least six months") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 64, 'What does Gregory plan to propose to the compensation committee?', '["Performance-based stock grants and home-office allowances","An immediate fifteen percent across-the-board salary raise","A mandatory four-day in-office working policy","Free corporate gym memberships and catered lunches"]'::jsonb, 'A', 'Gregory đề xuất cấp cổ phiếu hạn chế dựa trên hiệu suất và phụ cấp công nghệ làm việc tại nhà ("performance-based restricted stock grants and a quarterly home-office technology allowance") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #43 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 43, NULL, 'M: Angela, we need to finalize our carrier partner for exporting perishable organic seafood to premium supermarket chains across East Asia.
W: We narrowed the proposals down to TransPacific ColdChain and Pacific Marine Cargo. While Pacific Marine is eight percent cheaper, TransPacific utilizes smart container monitoring that logs temperature fluctuations via satellite every five minutes.
M: Given that a single compromised refrigeration failure can ruin three hundred thousand dollars worth of sashimi-grade salmon, real-time satellite telemetry is indispensable.
W: I agree wholeheartedly. I will notify TransPacific''s commercial director that we are accepting their proposal and request their standard service-level agreement.', 'tests/ets_extreme_01/p3_q65-67.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 65, 'What type of cargo are the speakers preparing to export?', '["Perishable organic seafood","Frozen agricultural beef products","Precision medical pharmaceuticals","Vintage bottled European wines"]'::jsonb, 'A', 'Hàng hóa xuất khẩu là hải sản hữu cơ tươi sống dễ hỏng ("perishable organic seafood") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 66, 'What advantage does TransPacific ColdChain offer over its competitor?', '["Satellite-based real-time container temperature tracking","Significantly lower freight rates per shipping container","Direct maritime access to inland river distribution ports","A fleet of zero-emission electric cargo vessels"]'::jsonb, 'A', 'Lợi thế của TransPacific là hệ thống giám sát nhiệt độ container thông minh qua vệ tinh 5 phút/lần ("logs temperature fluctuations via satellite every five minutes") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 67, 'What will Angela do next?', '["Inform TransPacific that their proposal has been accepted","Request a revised price discount from Pacific Marine Cargo","Schedule an on-site inspection of the seaport cold storage depot","Purchase independent maritime cargo insurance policies"]'::jsonb, 'A', 'Angela sẽ thông báo cho giám đốc thương mại của TransPacific rằng công ty chấp nhận hợp tác ("notify TransPacific''s commercial director that we are accepting their proposal") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #44 (Part 3)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 3, 44, NULL, 'W: David, our security operations center detected unauthorized data extraction from our legacy customer loyalty database at two o''clock this morning.
M: Have our security engineers isolated the compromised server cluster, Clara? 
W: Yes, the servers were disconnected from the internet within twelve minutes, but preliminary logs show that approximately forty-five thousand email addresses and encrypted password hashes were exfiltrated.
M: Under data privacy compliance regulations, we are legally mandated to notify affected consumers and relevant regulatory commissioners within seventy-two hours. Let''s convene our crisis communications team and draft the disclosure notice immediately.', 'tests/ets_extreme_01/p3_q68-70.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 3, 68, 'What security incident occurred early this morning?', '["Unauthorized data extraction from a customer loyalty database","A physical break-in at the corporate data center","A denial-of-service attack crashing online payment gateways","Accidental deletion of annual accounting balance records"]'::jsonb, 'A', 'Sự cố an ninh mạng: trích xuất dữ liệu trái phép từ cơ sở dữ liệu khách hàng thân thiết ("unauthorized data extraction from our legacy customer loyalty database") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 69, 'How quickly was the affected server cluster disconnected from the network?', '["Within twelve minutes","Within seventy-two hours","In two hours","After thirty minutes"]'::jsonb, 'A', 'Máy chủ bị cô lập trong vòng 12 phút ("disconnected from the internet within twelve minutes") → Chọn (A).', '["listening","conversation"]'::jsonb),
    (v_test_id, v_group_id, 3, 70, 'What legal requirement must the company fulfill within seventy-two hours?', '["Notify affected consumers and regulatory commissioners","Pay restitution compensation to bank card issuers","Appear before a federal legislative oversight hearing","Replace all corporate network routers and firewalls"]'::jsonb, 'A', 'Nghĩa vụ pháp lý theo luật bảo mật dữ liệu: phải thông báo cho người dùng bị ảnh hưởng và cơ quan quản lý trong 72 giờ ("notify affected consumers and relevant regulatory commissioners within seventy-two hours") → Chọn (A).', '["listening","conversation"]'::jsonb);

  -- Group #45 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 45, NULL, 'Attention all passengers booked on TransAir Flight 840 with non-stop service to London Heathrow. Due to heavy crosswinds and freezing rain along our flight path, ground operations have temporarily delayed departure. Furthermore, due to gate congestion in Terminal B, our departure gate has been relocated from Gate B14 to Gate C22 in the international concourse. Passengers requiring wheelchair assistance or traveling with small children are invited to begin boarding at Gate C22 at 4:15 P.M. Standard boarding will commence fifteen minutes thereafter. Please have your passport and boarding pass ready for biometric scanning at the gate.', 'tests/ets_extreme_01/p4_q71-73.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 71, 'Why has TransAir Flight 840 experienced a delay?', '["Adverse weather conditions along the flight corridor","Mechanical maintenance on the aircraft''s left engine","A nationwide shortage of certified flight attendants","Delayed arrival of catering delivery trucks"]'::jsonb, 'A', 'Chuyến bay bị chậm trễ do thời tiết xấu (gió giật mạnh và mưa tuyết đóng băng) dọc đường bay ("heavy crosswinds and freezing rain along our flight path") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 72, 'Where should passengers now proceed for departure?', '["Gate C22 in the international concourse","Gate B14 in Terminal B","The central baggage claim customer counter","The airport medical clinic lounge"]'::jsonb, 'A', 'Cổng lên máy bay được chuyển sang Cổng C22 khu quốc tế ("relocated from Gate B14 to Gate C22") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 73, 'What must travelers present at the boarding gate?', '["A passport and boarding pass for biometric scanning","A printed vaccination certification document","A luggage weight receipt from baggage check","A stamped customs declaration form"]'::jsonb, 'A', 'Hành khách cần chuẩn bị hộ chiếu và thẻ lên máy bay để quét sinh trắc học ("passport and boarding pass ready for biometric scanning") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #46 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 46, NULL, 'Good morning, esteemed shareholders and members of the board. I am delighted to welcome you to the thirty-fourth annual general assembly of Apex Healthcare Solutions. Over the past twelve months, our strategic pivot toward AI-assisted clinical diagnostic tools has generated record annual revenue of four point six billion dollars, representing a nineteen percent increase year over year. More importantly, I am proud to announce that earlier this morning, our board approved the definitive acquisition of BioGenix Diagnostics for eight hundred and fifty million dollars in cash and equity. This landmark acquisition doubles our proprietary patents in oncology biomarker detection and solidifies our leadership in precision oncology across North America and Europe.', 'tests/ets_extreme_01/p4_q74-76.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 74, 'Who is most likely addressing the audience?', '["The chief executive officer of Apex Healthcare Solutions","A municipal public health commissioner","A financial journalist reporting on stock movements","An investment bank merger and acquisition advisor"]'::jsonb, 'A', 'Người phát biểu là CEO chào mừng đại hội đồng cổ đông của tập đoàn y tế ("welcome you to the thirty-fourth annual general assembly of Apex Healthcare Solutions") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 75, 'By what percentage did company revenue increase over the past year?', '["Nineteen percent","Thirty-four percent","Twelve percent","Fifty percent"]'::jsonb, 'A', 'Doanh thu tăng 19% so với cùng kỳ năm ngoái ("representing a nineteen percent increase year over year") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 76, 'What major corporate announcement was revealed this morning?', '["The acquisition of BioGenix Diagnostics for $850 million","The divestment of European manufacturing assets","The resignation of the chief financial officer","A secondary public offering of preferred shares"]'::jsonb, 'A', 'Thông báo sáp nhập mua lại công ty BioGenix Diagnostics giá 850 triệu đô ("approved the definitive acquisition of BioGenix Diagnostics for eight hundred and fifty million dollars") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #47 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 47, NULL, 'Attention all chemical processing technicians on Shift B. Before commencing maintenance on Reactor Vessel Four, please review our updated protocols for handling high-pressure catalyst transfers. Following last month''s valve calibration audit, all technicians entering the catalytic containment vault must wear positive-pressure respiratory helmets and chemical-resistant vulcanized boots. Under no circumstances should manual pressure relief valves be actuated without verbal authorization from the shift engineering supervisor. In the event of an automated nitrogen purge alarm, all personnel must evacuate immediately through Emergency Exit South and assemble at Muster Point D. Safety checklists must be signed and submitted before five o''clock.', 'tests/ets_extreme_01/p4_q77-79.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 77, 'Who is the intended audience for this briefing?', '["Chemical processing plant maintenance technicians","Administrative office assistants","Visiting environmental university students","Truck drivers delivering commercial fuels"]'::jsonb, 'A', 'Đối tượng lắng nghe là kỹ thuật viên bảo trì nhà máy hóa chất ca B ("chemical processing technicians on Shift B") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 78, 'What action is strictly forbidden without supervisor approval?', '["Actuating manual pressure relief valves","Wearing positive-pressure respiratory helmets","Exiting through Emergency Exit South","Reviewing updated safety checklists"]'::jsonb, 'A', 'Hành động bị nghiêm cấm khi chưa có lệnh: kích hoạt van xả áp suất thủ công ("Under no circumstances should manual pressure relief valves be actuated without verbal authorization") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 79, 'Where should workers assemble in the event of an automated alarm?', '["At Muster Point D","Inside the catalytic containment vault","In the administrative cafeteria","Outside the security guard booth"]'::jsonb, 'A', 'Khi có chuông báo động, công nhân phải tập hợp tại Điểm tập kết D ("assemble at Muster Point D") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #48 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 48, NULL, 'Hello, Mr. Sterling. This is Brenda Walsh from Walsh and Sterling Intellectual Property Counsel. I am calling to update you on our trademark infringement claim against Zenith Apparel. Yesterday, we served their legal department with a formal cease-and-desist notice regarding their unauthorized use of our client''s geometric star logo on their autumn outerwear collection. We gave them forty-eight hours to remove the infringing merchandise from retail distribution channels and withdraw their pending patent application. The ball is in their court. If they refuse to comply by Thursday afternoon, we are prepared to file for an immediate preliminary federal injunction. Please call me back when you have reviewed the attached litigation filing.', 'tests/ets_extreme_01/p4_q80-82.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 80, 'What legal issue is Brenda Walsh handling?', '["A trademark infringement dispute regarding a corporate logo","A breach of contract claim by a commercial landlord","An employee discrimination lawsuit","A late tax filing penalty appeal"]'::jsonb, 'A', 'Luật sư xử lý tranh chấp xâm phạm thương hiệu logo ("trademark infringement claim ... unauthorized use of our client''s geometric star logo") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 81, 'What does the speaker mean when she says: "The ball is in their court"?', '["The competitor must now decide how to respond","The athletic footwear lawsuit has concluded","The legal dispute will be settled in arbitration court","The client is responsible for funding the trial"]'::jsonb, 'A', 'Thành ngữ kinh điển: "The ball is in their court" (Quả bóng đang ở phần sân của họ) có nghĩa là công ty đối thủ Zenith Apparel bây giờ phải đưa ra quyết định phản hồi ("The competitor must now decide how to respond") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 82, 'What will the law firm do if the competitor fails to comply by Thursday?', '["Seek a preliminary federal court injunction","Accept a financial settlement out of court","Withdraw the trademark application","Dismiss the commercial lawsuit entirely"]'::jsonb, 'A', 'Nếu đối thủ không tuân thủ trước thứ Năm, văn phòng luật sẽ nộp đơn xin lệnh cấm khẩn cấp của tòa án liên bang ("file for an immediate preliminary federal injunction") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #49 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 49, NULL, 'Welcome to Midday Market Pulse on National Business Radio. In early morning trading, global equity markets experienced pronounced volatility following the Federal Reserve''s surprise decision to increase the benchmark overnight lending rate by fifty basis points to curb persistent inflationary pressures. The tech-heavy composite index dropped two point four percent within the first hour of trading, driven by steep sell-offs in semiconductor and cloud computing equities. Conversely, institutional yields on sovereign ten-year bonds surged to their highest levels in over a decade. Analysts from Goldman Sachs predict that while corporate borrowing costs will rise considerably, financial institutions with substantial cash reserves stand to benefit from wider lending interest margins. Stay tuned for our sector breakdown following this commercial break.', 'tests/ets_extreme_01/p4_q83-85.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 83, 'What government action triggered market volatility this morning?', '["A fifty basis point increase in the benchmark interest rate","The imposition of import tariffs on foreign microchips","An emergency bailout for commercial mortgage lenders","A cut in federal corporate income tax rates"]'::jsonb, 'A', 'Biến động thị trường do quyết định bất ngờ của Fed tăng 50 điểm cơ bản lãi suất cho vay ("Federal Reserve''s surprise decision to increase the benchmark overnight lending rate by fifty basis points") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 84, 'Which industry sector experienced steep stock price declines?', '["Semiconductor and cloud computing companies","Commercial retail grocery chains","Sovereign bond underwriting firms","Precious metal mining companies"]'::jsonb, 'A', 'Ngành công nghệ bán dẫn và điện toán đám mây bị bán tháo mạnh ("steep sell-offs in semiconductor and cloud computing equities") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 85, 'What entity is projected to benefit from the policy change?', '["Financial institutions with significant cash reserves","Small startup businesses seeking bank loans","Real estate residential mortgage brokers","Commercial airlines purchasing aviation fuel"]'::jsonb, 'A', 'Các tổ chức tài chính dồi dào tiền mặt sẽ hưởng lợi từ biên lãi suất cho vay rộng hơn ("financial institutions with substantial cash reserves stand to benefit") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #50 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 50, NULL, 'Attention all assembly line personnel at the Fremont Electric Vehicle Manufacturing Complex. As part of our capital modernization initiative to integrate next-generation solid-state battery packs into our Model V sedans, Line Two will be suspended starting Friday at 6:00 P.M. through Monday morning. During this 48-hour downtime, certified industrial robotics technicians from Kuka Engineering will install twenty-four precision robotic welding arms and calibrate optical seam alignment sensors. Line Two technicians scheduled for weekend shifts will be reassigned to sub-assembly module preparation in Building D with standard overtime pay rates applying. Normal vehicle assembly operations will resume promptly at 6:00 A.M. on Tuesday.', 'tests/ets_extreme_01/p4_q86-88.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 86, 'Why is assembly Line Two being temporarily suspended?', '["To install robotic welding arms and battery integration equipment","Due to a severe shortage of automotive microcontrollers","Following an unannounced occupational safety inspection","To repair a damaged electrical power generator"]'::jsonb, 'A', 'Dây chuyền 2 tạm ngưng để lắp đặt cánh tay robot hàn và thiết bị tích hợp pin thể rắn ("install twenty-four precision robotic welding arms and calibrate optical seam alignment sensors") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 87, 'What will happen to Line Two technicians scheduled for the weekend?', '["They will be reassigned to Building D with overtime pay","They will receive unpaid mandatory furloughs","They will attend mandatory virtual software seminars","They will test-drive completed vehicles at the track"]'::jsonb, 'A', 'Công nhân ca cuối tuần được điều động sang Tòa nhà D làm modul phụ trợ và nhận lương ngoài giờ ("reassigned to sub-assembly module preparation in Building D with standard overtime pay rates") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 88, 'When will regular production resume on Line Two?', '["At 6:00 A.M. on Tuesday","At 6:00 P.M. on Friday","On Sunday afternoon","Next month"]'::jsonb, 'A', 'Dây chuyền hoạt động trở lại vào 6:00 sáng Thứ Ba ("resume promptly at 6:00 A.M. on Tuesday") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #51 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 51, NULL, 'Good afternoon, colleagues. I am Dr. Marcus Vance, Chief Information Security Officer at Vanguard Global Technologies. Today''s mandatory training module focuses on defending our organization against sophisticated spear-phishing campaigns. Recent threat intelligence reveals that criminal syndicates are utilizing generative artificial intelligence to produce highly convincing fraudulent emails that mimic the communication style of corporate executive directors. These emails typically urge recipient employees to wire emergency funds or click on malicious links under the guise of confidential acquisitions. Remember our cardinal rule: IT will never request password verification via email, and any financial wire transfer exceeding ten thousand dollars requires two-factor verbal authorization. Please complete the simulated phishing quiz on your terminals before logging off.', 'tests/ets_extreme_01/p4_q89-91.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 89, 'What primary threat does Dr. Vance discuss in the training seminar?', '["AI-generated spear-phishing fraudulent emails","Physical theft of corporate laptops from offices","Ransomware infecting backup storage hard drives","Distributed denial-of-service server crashes"]'::jsonb, 'A', 'Mối đe dọa an ninh mạng chính: email lừa đảo mạo danh giám đốc do AI tạo ra ("utilizing generative artificial intelligence to produce highly convincing fraudulent emails") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 90, 'What protocol is required for financial wire transfers exceeding $10,000?', '["Two-factor verbal authorization","Approval by the municipal banking commissioner","A written notary certificate delivered in person","Submitting original receipts via postal mail"]'::jsonb, 'A', 'Quy tắc vàng: lệnh chuyển tiền trên $10,000 yêu cầu xác thực bằng lời nói 2 lớp ("any financial wire transfer exceeding ten thousand dollars requires two-factor verbal authorization") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 91, 'What must attendees complete before logging off today?', '["A simulated phishing interactive quiz","A survey evaluating Dr. Vance''s presentation style","A software update for their company smartphones","An encrypted password reset procedure"]'::jsonb, 'A', 'Học viên phải hoàn thành bài trắc nghiệm giả lập câu cá lừa đảo ("complete the simulated phishing quiz on your terminals before logging off") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #52 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 52, NULL, 'Welcome, architectural society patrons, to the Modern Pavilion of the Metropol Museum of Design. My name is Elena, and I will be guiding you through our special exhibition entitled Sustainable Horizons: Architectural Innovation in the Urban Age. This gallery showcases full-scale architectural models and blueprints from world-renowned firms that are pioneering zero-carbon skyscraper design. Over the next hour, we will examine how geothermal foundation pilings, cross-laminated timber, and kinetic solar shading facades can reduce commercial building energy consumption by up to sixty-five percent. Please note that while personal photography is permitted, flash photography and tripods are strictly prohibited to protect the delicate light-sensitive blueprint inks. Let''s begin in Gallery Three with the scale model of the Copenhagen Bio-Tower.', 'tests/ets_extreme_01/p4_q92-94.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 92, 'What is the theme of the museum''s special exhibition?', '["Sustainable and zero-carbon architectural design","Ancient Greek and Roman structural engineering","Industrial interior furniture from the nineteenth century","Digital photography techniques in urban landscapes"]'::jsonb, 'A', 'Chủ đề triển lãm là kiến trúc bền vững không phát thải carbon ("Sustainable Horizons ... pioneering zero-carbon skyscraper design") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 93, 'By how much can the featured architectural innovations reduce building energy usage?', '["Up to sixty-five percent","Up to thirty percent","By ninety percent","Exactly forty percent"]'::jsonb, 'A', 'Các cải tiến có thể giảm tới 65% năng lượng tiêu thụ ("reduce commercial building energy consumption by up to sixty-five percent") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 94, 'What equipment is strictly prohibited inside the gallery?', '["Flash photography and camera tripods","Mobile smartphones and handheld audio recorders","Bottled water and plastic umbrellas","High-heeled shoes and bulky backpacks"]'::jsonb, 'A', 'Quy định cấm chụp ảnh có đèn flash và chân máy ảnh tripod ("flash photography and tripods are strictly prohibited") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #53 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 53, NULL, 'Good afternoon, Mr. Kensington. This is Melissa from corporate hospitality at the Grand Hyatt Tokyo. I am calling regarding your executive reservation for the Global Biotechnology Summit commencing on Wednesday. When our housekeeping staff inspected your assigned Presidential Suite on the thirty-second floor this morning, they discovered a burst water pipe in the adjoining HVAC service duct, causing minor ceiling water damage. Don''t unpack just yet. We have automatically upgraded your party to our two-story Imperial Penthouse Suite on the thirty-fifth floor at no additional charge. In addition, our executive private limousine will meet you at Narita Airport baggage claim upon your flight arrival tomorrow evening. Please contact our VIP guest relations desk if you require private conference room bookings during your stay.', 'tests/ets_extreme_01/p4_q95-97.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 95, 'What problem occurred in Mr. Kensington''s originally booked hotel suite?', '["A burst water pipe caused ceiling water damage","The electronic door lock malfunctioned repeatedly","The central air conditioning was completely offline","The suite was erroneously double-booked to another guest"]'::jsonb, 'A', 'Sự cố: vỡ đường ống nước ở hộp kỹ thuật gây thấm trần nhà ("discovered a burst water pipe ... causing minor ceiling water damage") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 96, 'Why does the caller say: "Don''t unpack just yet"?', '["To indicate humorously that the guest has been relocated to a far superior suite","To warn the traveler that his luggage was lost by the airline","To cancel the guest''s reservation due to hotel flooding","To advise him to check into a competing hotel facility"]'::jsonb, 'A', 'Câu nói ngụ ý: "Don''t unpack just yet" (Đừng vội dỡ hành lý) nhằm tạo bất ngờ thú vị thông báo khách được nâng cấp miễn phí lên căn hộ Penthouse 2 tầng cao cấp hơn nhiều ("indicate that the guest has been relocated to a far superior suite") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 97, 'What complimentary transportation service is provided to Mr. Kensington?', '["Private executive limousine pickup at Narita Airport","High-speed bullet train passes for Tokyo transit","Complimentary helicopter transfer to the convention center","A pre-paid rental sports car at the hotel lobby"]'::jsonb, 'A', 'Dịch vụ miễn phí: xe limousine đón riêng tại sân bay Narita ("private limousine will meet you at Narita Airport baggage claim") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #54 (Part 4)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 4, 54, NULL, 'Attention all salaried staff members of Pinnacle Financial Group. As part of our annual corporate benefits restructuring, our open enrollment window for healthcare, dental, and retirement plans will commence this coming Monday, November 14, and conclude promptly at midnight on December 2. This year, we are proud to introduce a high-deductible healthcare plan paired with a triple-tax-advantaged Health Savings Account, featuring an employer dollar-for-dollar seed contribution of up to twelve hundred dollars annually. Furthermore, our 401(k) retirement matching contribution has been increased from four percent to six percent of gross salary for employees with more than three years of tenure. Information webinars detailing these plan changes will take place daily via Zoom. Failure to submit selections by the December 2 deadline will result in automatic default enrollment into your previous year''s coverage tier.', 'tests/ets_extreme_01/p4_q98-100.m4a', NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 4, 98, 'What is the purpose of the announcement?', '["To outline annual open enrollment options for employee benefits","To inform employees about upcoming salary reductions","To announce the merger of two corporate financial subsidiaries","To schedule performance review appraisals for salaried managers"]'::jsonb, 'A', 'Mục đích: công bố kỳ đăng ký phúc lợi bảo hiểm y tế và quỹ hưu trí hàng năm ("annual corporate benefits restructuring ... open enrollment window") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 99, 'How has the company enhanced its 401(k) retirement matching program?', '["Increased the matching contribution rate to six percent for tenured staff","Doubled the annual cash bonus for all junior analysts","Offered company shares at a fifty percent discount","Eliminated the mandatory retirement age limit"]'::jsonb, 'A', 'Chính sách quỹ hưu trí 401(k) tăng mức đóng góp đối ứng của công ty từ 4% lên 6% cho nhân viên trên 3 năm thâm niên ("increased from four percent to six percent of gross salary for employees with more than three years of tenure") → Chọn (A).', '["listening","talks"]'::jsonb),
    (v_test_id, v_group_id, 4, 100, 'What happens if an employee fails to submit benefit choices by December 2?', '["Automatic default re-enrollment in their previous coverage plan","Immediate suspension of health insurance benefits","A standard administrative late penalty fee of $500","Disqualification from receiving year-end financial bonuses"]'::jsonb, 'A', 'Nếu không nộp trước 2/12, hệ thống sẽ tự động đăng ký lại theo gói bảo hiểm năm trước ("automatic default enrollment into your previous year''s coverage tier") → Chọn (A).', '["listening","talks"]'::jsonb);

  -- Group #55 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 55, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 101, 'Seldom ------- such unprecedented volatility in the foreign exchange markets within a single trading quarter.', '["have financial analysts witnessed","financial analysts have witnessed","are financial analysts witnessing","witnessing financial analysts"]'::jsonb, 'A', 'Cấu trúc đảo ngữ bắt buộc với phó từ phủ định đứng đầu câu: "Seldom + Trợ động từ + Chủ ngữ + Động từ chính" → Chọn "have financial analysts witnessed".', '["reading","grammar","inversion"]'::jsonb);

  -- Group #56 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 56, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 102, 'It is imperative that the lead regulatory compliance auditor ------- all clinical trial anomalies to the ethics board without delay.', '["report","reports","reported","reporting"]'::jsonb, 'A', 'Thức giả định (Subjunctive mood) sau cấu trúc mang tính cấp bách "It is imperative that + S + (should) bare infinitive" → động từ luôn ở dạng nguyên mẫu không "to" "report".', '["reading","grammar","subjunctive"]'::jsonb);

  -- Group #57 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 57, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 103, 'Following the annual executive summit, department heads were instructed to draft strategic roadmaps for their ------- divisions.', '["respective","respectful","respectable","respecting"]'::jsonb, 'A', 'Bẫy từ vựng cao cấp: "respective" = tương ứng của từng người/từng bộ phận; "respectful" = thể hiện sự tôn trọng; "respectable" = đáng kính. Cụm "their respective divisions" = các bộ phận tương ứng của họ → Chọn (A).', '["reading","vocabulary"]'::jsonb);

  -- Group #58 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 58, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 104, '------- the preliminary audit balance sheets thoroughly, the comptroller identified several unaccounted disbursements.', '["Having evaluated","Evaluated","To evaluate","Being evaluated"]'::jsonb, 'A', 'Rút gọn mệnh đề đồng chủ ngữ ở dạng phân từ hoàn thành (Perfect participle): "Having evaluated..." diễn tả hành động thẩm định đã hoàn tất trước khi phát hiện ra các khoản chi không có chứng từ.', '["reading","grammar","participle"]'::jsonb);

  -- Group #59 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 59, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 105, '------- persistent supply chain bottlenecks across the Pacific corridor, Apex Electronics fulfilled its overseas obligations on schedule.', '["Notwithstanding","Although","Despite of","Whereas"]'::jsonb, 'A', 'Theo sau là cụm danh từ ("persistent supply chain bottlenecks...") mang nghĩa nhượng bộ → chọn giới từ "Notwithstanding" (= Despite / In spite of). "Although/Whereas" cần mệnh đề; "Despite of" sai ngữ pháp.', '["reading","preposition"]'::jsonb);

  -- Group #60 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 60, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 106, 'Upgrading our fleet to hybrid commercial vans proved to be an remarkably ------- decision, reducing operational fuel expenditures by thirty percent.', '["economical","economic","economy","economize"]'::jsonb, 'A', 'Bẫy tính từ: "economical" = tiết kiệm chi phí; "economic" = thuộc về nền kinh tế vĩ mô. Quyết định giúp tiết kiệm chi phí nhiên liệu → chọn "economical" (A).', '["reading","vocabulary"]'::jsonb);

  -- Group #61 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 61, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 107, 'The chief legal officer demanded that the non-disclosure agreements be kept strictly ------- throughout the duration of the buyout negotiations.', '["confidential","confidentially","confidence","confiding"]'::jsonb, 'A', 'Cấu trúc "keep + O + adj" (giữ cái gì ở trạng thái như thế nào). Sau phó từ chỉ mức độ "strictly" cần tính từ → chọn "confidential" (bảo mật).', '["reading","word-form"]'::jsonb);

  -- Group #62 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 62, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 108, 'Under no circumstances ------- proprietary client datasets to be transferred onto unencrypted portable hard drives.', '["are","is","have","were"]'::jsonb, 'A', 'Đảo ngữ với cụm từ phủ định "Under no circumstances + are + datasets (danh từ số nhiều) + to be transferred..." (cấu trúc be to V thể hiện mệnh lệnh cấm đoán).', '["reading","grammar","inversion"]'::jsonb);

  -- Group #63 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 63, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 109, '------- the manufacturing consortium has exceeded its initial production quota, the board approved an additional incentive dividend.', '["Given that","In spite of","Regardless","Except that"]'::jsonb, 'A', 'Liên từ chỉ lý do/căn cứ: "Given that + clause" = xét thấy rằng / căn cứ vào việc... Phù hợp với mệnh đề chỉ lý do vì liên doanh đã vượt chỉ tiêu sản xuất.', '["reading","conjunction"]'::jsonb);

  -- Group #64 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 64, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 110, 'The proposed commercial zoning revision has generated ------- debate among municipal developers and neighborhood residents.', '["considerable","considerate","consideration","considerately"]'::jsonb, 'A', 'Bẫy từ vựng: "considerable" = đáng kể, to lớn; "considerate" = chu đáo, biết quan tâm người khác. Cuộc tranh luận to lớn/đáng kể → chọn "considerable" (A).', '["reading","vocabulary"]'::jsonb);

  -- Group #65 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 65, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 111, 'New environmental regulations mandate that every industrial chemical refinery ------- continuous smokestack monitoring telemetry.', '["install","installs","installed","installing"]'::jsonb, 'A', 'Động từ chỉ yêu cầu/mệnh lệnh "mandate that + S + bare V" → động từ nguyên thể không "to" "install".', '["reading","grammar","subjunctive"]'::jsonb);

  -- Group #66 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 66, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 112, 'The corporate restructuring was ------- implemented to reduce overhead expenses, although internal sources suggest it aimed to centralize executive decision-making.', '["ostensibly","authentically","reluctantly","subordinately"]'::jsonb, 'A', 'Phó từ chỉ bề ngoài/danh nghĩa: "ostensibly" = bề ngoài là / mang danh nghĩa là (tương phản với "although internal sources suggest..." vế sau).', '["reading","vocabulary"]'::jsonb);

  -- Group #67 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 67, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 113, 'All hazardous industrial waste containers must be labeled and manifested ------- municipal environmental protection statutes.', '["in accordance with","in spite of","contrary to","on behalf of"]'::jsonb, 'A', 'Cụm giới từ chỉ sự tuân thủ quy định pháp luật: "in accordance with" = theo đúng / phù hợp với các điều lệ bảo vệ môi trường.', '["reading","preposition"]'::jsonb);

  -- Group #68 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 68, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 114, 'Dr. Vance presented a remarkably ------- study analyzing cross-border pharmaceutical licensing agreements over the past two decades.', '["comprehensive","comprehensible","comprehend","comprehension"]'::jsonb, 'A', 'Bẫy từ vựng: "comprehensive" = toàn diện, sâu rộng; "comprehensible" = có thể hiểu được. Công trình nghiên cứu toàn diện, sâu rộng → chọn "comprehensive" (A).', '["reading","vocabulary"]'::jsonb);

  -- Group #69 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 69, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 115, 'Not only ------- the executive team to renegotiate the vendor contract, but they also secured a ten percent volume rebate.', '["did the committee manage","the committee managed","was the committee managing","managing the committee"]'::jsonb, 'A', 'Đảo ngữ với "Not only + Trợ động từ did + Chủ ngữ the committee + Động từ manage... but also...".', '["reading","grammar","inversion"]'::jsonb);

  -- Group #70 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 70, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 116, 'An entry-level data processing clerk ------- transmitted unredacted customer transaction records to an external testing server.', '["inadvertently","decisively","deliberately","punctually"]'::jsonb, 'A', 'Phó từ chỉ sự vô tình/sơ suất: "inadvertently" = sơ ý, vô ý, không cố ý. Thể hiện việc gửi nhầm dữ liệu chưa kiểm duyệt.', '["reading","vocabulary"]'::jsonb);

  -- Group #71 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 71, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 117, '------- finalizing the commercial merger, both banking entities must obtain explicit antitrust clearance from the federal trade commission.', '["Prior to","Apart from","In addition","Instead of"]'::jsonb, 'A', 'Cụm giới từ chỉ thời gian trước khi làm gì: "Prior to + V-ing/N" = Trước khi hoàn tất sáp nhập thương mại.', '["reading","preposition"]'::jsonb);

  -- Group #72 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 72, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 118, 'The ethics committee insisted that every prospective board member ------- any potential conflicts of interest before taking office.', '["disclose","discloses","disclosed","disclosing"]'::jsonb, 'A', 'Cấu trúc giả định "insisted that + S + (should) bare V" → động từ nguyên mẫu không chia "disclose".', '["reading","grammar","subjunctive"]'::jsonb);

  -- Group #73 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 73, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 119, 'Following the deployment of automated diagnostic sensors, the facility experienced an ------- reduction in unexpected equipment downtime.', '["appreciable","appreciative","appreciate","appreciating"]'::jsonb, 'A', 'Bẫy từ vựng cao cấp: "appreciable" = có thể thấy rõ, đáng kể; "appreciative" = biết ơn, trân trọng. Mức giảm đáng kể, rõ rệt → chọn "appreciable" (A).', '["reading","vocabulary"]'::jsonb);

  -- Group #74 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 74, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 120, 'The chief architect presented the preliminary stadium blueprints ------- the municipal permits had already been guaranteed.', '["as though","so that","in order that","even though"]'::jsonb, 'A', 'Liên từ chỉ sự giả định: "as though" = như thể là (với cấu trúc thì quá khứ hoàn thành "had already been guaranteed").', '["reading","conjunction"]'::jsonb);

  -- Group #75 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 75, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 121, 'Any commercial cargo ------- hazardous lithium-ion batteries must adhere strictly to international aviation transport containment protocols.', '["containing","contained","contains","containment"]'::jsonb, 'A', 'Mệnh đề quan hệ rút gọn dạng chủ động: "Any commercial cargo (which contains) → containing hazardous lithium-ion batteries".', '["reading","grammar","participle"]'::jsonb);

  -- Group #76 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 76, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 122, 'Only candidates who demonstrate ------- adherence to ethical research protocols will be certified for clinical laboratory trials.', '["rigorous","tentative","arbitrary","negligent"]'::jsonb, 'A', 'Tính từ chỉ sự nghiêm ngặt, khắt khe: "rigorous adherence" = sự tuân thủ nghiêm ngặt các quy chuẩn nghiên cứu đạo đức.', '["reading","vocabulary"]'::jsonb);

  -- Group #77 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 77, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 123, '------- the unexpected surge in raw lithium procurement costs, the automobile manufacturer adjusted the retail base price of its electric sedans.', '["In light of","Contrary to","As well as","In place of"]'::jsonb, 'A', 'Cụm giới từ chỉ lý do: "In light of + N" = Xét về / bởi vì / trước tình hình gia tăng giá nguyên liệu lithium.', '["reading","preposition"]'::jsonb);

  -- Group #78 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 78, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 124, 'The cloud security platform protects enterprise networks not only against unauthorized intrusion ------- against accidental data loss.', '["but also","and so","as well","nor yet"]'::jsonb, 'A', 'Cặp liên từ tương quan bắt buộc: "not only A but also B" = không những A mà còn B.', '["reading","conjunction"]'::jsonb);

  -- Group #79 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 79, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 125, 'The logistics firm achieved an ------- volume of international freight tonnage during the pre-holiday shipping season.', '["unprecedented","unprepared","unproven","unpopular"]'::jsonb, 'A', 'Tính từ cao cấp trong kinh doanh: "unprecedented volume" = khối lượng chưa từng có tiền lệ / kỷ lục từ trước đến nay.', '["reading","vocabulary"]'::jsonb);

  -- Group #80 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 80, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 126, '------- any discrepancy arise during the quarterly inventory reconciliation, the lead auditor must be notified immediately.', '["Should","Were","Had","Would"]'::jsonb, 'A', 'Đảo ngữ câu điều kiện loại 1: "Should + S + bare V" (= If any discrepancy arises...).', '["reading","grammar","inversion"]'::jsonb);

  -- Group #81 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 81, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 127, 'Human resources invited several ------- candidates for second-round panel interviews with the department director.', '["prospective","perspective","perspicuous","perceptive"]'::jsonb, 'A', 'Bẫy từ vựng: "prospective candidates" = các ứng viên tiềm năng / có triển vọng trong tương lai; "perspective" = góc nhìn, quan điểm (danh từ).', '["reading","vocabulary"]'::jsonb);

  -- Group #82 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 82, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 128, '------- the executive boardroom on the thirty-fifth floor, all conference rooms in the tower are equipped with smart projection glass.', '["With the exception of","In accordance to","In consequence of","On the occasion of"]'::jsonb, 'A', 'Cụm giới từ chỉ sự loại trừ: "With the exception of + N" = Ngoại trừ phòng họp ban giám đốc ở tầng 35.', '["reading","preposition"]'::jsonb);

  -- Group #83 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 83, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 129, 'The management consultancy strongly recommended that the manufacturing consortium ------- its automated supply chain infrastructure.', '["upgrade","upgrades","upgraded","upgrading"]'::jsonb, 'A', 'Thức giả định sau động từ khuyến nghị "recommended that + S + bare V" → động từ nguyên mẫu "upgrade".', '["reading","grammar","subjunctive"]'::jsonb);

  -- Group #84 (Part 5)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 5, 84, NULL, NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 5, 130, 'Before entering commercial clinical trials, all biomedical instrumentation must be ------- calibrated by certified technicians.', '["meticulously","haphazardly","reluctantly","subordinately"]'::jsonb, 'A', 'Phó từ chỉ sự tỉ mỉ, cẩn trọng: "meticulously calibrated" = được hiệu chuẩn một cách cực kỳ tỉ mỉ, chuẩn xác.', '["reading","vocabulary"]'::jsonb);

  -- Group #85 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 6, 85, 'POLICY DIRECTIVE: GLOBAL DATA PROTECTION AND ENCRYPTION PROTOCOLS
Effective Date: January 1
To: All Personnel and Contracted Associates

In light of updated international data protection regulations, Vanguard Financial Group has established rigorous data handling mandates across all global business units. Effective immediately, all electronic communications transmitting customer personal identifiable information must utilize AES-256 bit encryption. [131] -------, unencrypted storage of client records on unauthorized portable storage drives is strictly prohibited.

Department supervisors are directly [132] ------- for ensuring that all subordinate personnel complete the mandatory biometric security verification modules before the end of the current billing cycle. [133] -------. Failure to complete this required accreditation will result in the immediate revocation of internal enterprise system credentials.

Any discovered security breach or accidental transmission must be reported [134] ------- to the chief information security officer within two hours of identification.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 6, 131, 'Choose the best transition word to fill in blank [131].', '["Furthermore","Conversely","Nevertheless","Instead"]'::jsonb, 'A', 'Liên từ nối bổ sung thông tin tăng cường: "Furthermore" (Hơn nữa / Thêm vào đó, việc lưu trữ không mã hóa trên ổ đĩa di động bị nghiêm cấm).', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 132, 'Choose the best adjective form to fill in blank [132].', '["accountable","accountably","accountability","accounting"]'::jsonb, 'A', 'Cấu trúc "be directly accountable for + V-ing/N" (chịu trách nhiệm trực tiếp cho việc...) → chọn tính từ "accountable".', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 133, 'Choose the best sentence to fill in blank [133].', '["These interactive training modules are accessible via the compliance portal.","The executive dining room will remain closed during the winter holidays.","All international flight bookings must be processed by corporate travel.","Commercial real estate leases require three months of advance notice."]'::jsonb, 'A', 'Câu trước nhắc đến việc nhân viên phải hoàn thành các mô-đun xác minh bảo mật. Câu (A) nối tiếp cung cấp đường dẫn truy cập mô-đun học tập một cách chặt chẽ.', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 134, 'Choose the best adverb to fill in blank [134].', '["promptly","prompt","promptness","prompting"]'::jsonb, 'A', 'Bổ nghĩa cho động từ thể bị động "must be reported" cần một phó từ chỉ thời gian cấp bách → chọn "promptly" (kịp thời, ngay lập tức).', '["reading","text-completion"]'::jsonb);

  -- Group #86 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 6, 86, 'VALKYRIE AEROSPACE TECHNOLOGIES
Confidential Investor Communique
Date: October 14

Dear Shareholders,

We are writing to provide a transparent update regarding our scheduled Initial Public Offering (IPO) on the New York Stock Exchange. Following an extensive evaluation of macroeconomic conditions and recent interest rate adjustments by central banks, our board of directors has decided to [135] ------- our public listing until the second quarter of next year.

While our fundamental balance sheet and revenue growth remain exceptionally robust, current market volatility has depressed market valuations across the aerospace sector. [136] -------. By delaying the offering, we aim to protect long-term shareholder equity and ensure an optimal capital valuation upon market debut.

During this interim period, we will focus aggressively on fulfilling our multi-year defense satellite contracts. Our proprietary ion-propulsion thrusters have passed rigorous thermal vacuum endurance testing [137] ------- our internal engineering roadmap. We remain deeply [138] ------- for your continued confidence and partnership.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 6, 135, 'Choose the best verb to fill in blank [135].', '["postpone","accelerate","liquidate","terminate"]'::jsonb, 'A', 'Dựa vào ngữ cảnh câu và câu sau ("By delaying the offering"), ban giám đốc quyết định hoãn đợt IPO sang quý 2 năm sau → chọn "postpone" (trì hoãn).', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 136, 'Choose the best sentence to fill in blank [136].', '["Proceeding under current conditions would result in suboptimal share pricing.","Our corporate headquarters will relocate to Houston by the end of this month.","Several junior software developers have resigned to join competing firms.","All physical stock certificates must be surrendered to the city registrar."]'::jsonb, 'A', 'Câu trước nói về định giá ngành hàng không bị suy giảm do thị trường biến động. Câu (A) nối tiếp giải thích: việc tiếp tục IPO lúc này sẽ dẫn đến giá cổ phiếu thấp không như kỳ vọng.', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 137, 'Choose the best prepositional phrase to fill in blank [137].', '["in accordance with","contrary to","on behalf of","in place of"]'::jsonb, 'A', 'Cụm giới từ chỉ sự phù hợp với lộ trình kỹ thuật: "in accordance with our internal engineering roadmap" (đúng theo lộ trình kỹ thuật nội bộ).', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 138, 'Choose the best adjective form to fill in blank [138].', '["grateful","gratefully","gratitude","grating"]'::jsonb, 'A', 'Cấu trúc "remain deeply + adj" (vẫn luôn vô cùng biết ơn...) → chọn tính từ "grateful".', '["reading","text-completion"]'::jsonb);

  -- Group #87 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 6, 87, 'ENTERPRISE CLOUD INFRASTRUCTURE SLA
Section 14: Limitation of Liability and Indemnification

Except as expressly outlined in Section 8 regarding gross negligence, neither party shall be held liable under any circumstances for any indirect, incidental, or [139] ------- damages, including loss of profits, revenue, or business reputation.

The cloud hosting provider guarantees an annual server uptime threshold of ninety-nine point nine percent. [140] ------- this guaranteed threshold be breached during any calendar billing month, the customer shall be entitled to receive service credits as stipulated in Exhibit B. [141] -------. Such credits shall serve as the customer''s sole and exclusive remedy for service interruptions.

All claims for service performance credits must be submitted in writing within thirty calendar days of the alleged service outage, accompanied by detailed server [142] ------- records.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 6, 139, 'Choose the best adjective to fill in blank [139].', '["consequential","consequence","consequently","consequent"]'::jsonb, 'A', 'Thuật ngữ pháp lý kinh tế chuẩn mực: "consequential damages" = các thiệt hại gián tiếp phát sinh từ vi phạm hợp đồng.', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 140, 'Choose the best conditional inversion word to fill in blank [140].', '["Should","Were","Had","Unless"]'::jsonb, 'A', 'Đảo ngữ câu điều kiện loại 1 với "Should this guaranteed threshold be breached..." (= If this guaranteed threshold is breached...).', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 141, 'Choose the best sentence to fill in blank [141].', '["Service credits cannot be redeemed for physical currency under any circumstance.","Our corporate legal division was established over twenty-five years ago.","All annual employee parking permits must be validated at the front entrance.","Software developers should update their laptop operating systems today."]'::jsonb, 'A', 'Câu trước nói về việc khách hàng được nhận tín dụng dịch vụ (service credits). Câu (A) bổ sung quy định pháp lý: tín dụng này không được quy đổi thành tiền mặt.', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 142, 'Choose the best noun to fill in blank [142].', '["telemetry","telepathic","telephoned","teleconference"]'::jsonb, 'A', 'Dữ liệu đo đạc kỹ thuật máy chủ: "detailed server telemetry records" (hồ sơ đo đạc dữ liệu viễn trắc của máy chủ).', '["reading","text-completion"]'::jsonb);

  -- Group #88 (Part 6)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 6, 88, 'EXECUTIVE BOARD BULLETIN
Subject: Fostering Synergy and Integration Following the Apex-Nexa Merger

As we mark the completion of the formal corporate merger between Apex Solutions and Nexa Robotics, our overarching priority is aligning our organizational cultures to drive collaborative innovation. [143] ------- our individual histories of pioneering technological breakthroughs, our combined future demands a unified operational mindset.

To facilitate seamless cross-functional collaboration, a joint transformation steering taskforce has been [144] -------. This committee comprises leaders from product engineering, human resources, and business analytics. [145] -------. Beginning next week, the taskforce will host open town hall forums across all regional campuses to address employee inquiries directly.

We encourage every team member to participate actively and share constructive feedback as we [146] ------- on this transformative chapter in our corporate journey.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 6, 143, 'Choose the best preposition to fill in blank [143].', '["Notwithstanding","Although","Despite of","Whereas"]'::jsonb, 'A', 'Theo sau là cụm danh từ "our individual histories of pioneering..." mang nghĩa nhượng bộ → chọn "Notwithstanding" (= Dẫu cho lịch sử riêng biệt của mỗi bên...).', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 144, 'Choose the best verb form to fill in blank [144].', '["established","establishes","establishing","establishment"]'::jsonb, 'A', 'Cấu trúc bị động hiện tại hoàn thành: "has been + V3/ed" → chọn "established" (đã được thành lập).', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 145, 'Choose the best sentence to fill in blank [145].', '["Their mandate is to streamline internal workflows and harmonize workplace policies.","Our quarterly dividend payout was deposited into employee checking accounts.","Conference room bookings can be reserved via the receptionist mobile application.","The cafeteria will discontinue its specialty breakfast buffet next Tuesday."]'::jsonb, 'A', 'Câu trước giới thiệu ban đặc nhiệm chuyển đổi gồm các lãnh đạo chủ chốt. Câu (A) nối tiếp nêu nhiệm vụ của họ: tinh gọn quy trình làm việc nội bộ và hài hòa các chính sách công sở.', '["reading","text-completion"]'::jsonb),
    (v_test_id, v_group_id, 6, 146, 'Choose the best verb to fill in blank [146].', '["embark","embarks","embarked","embarking"]'::jsonb, 'A', 'Mệnh đề hiện tại đơn với chủ ngữ "we": "as we embark on this transformative chapter" (khi chúng ta dấn thân / bước vào chương chuyển mình mới này).', '["reading","text-completion"]'::jsonb);

  -- Group #89 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 89, 'PACIFIC MERIDIAN FREIGHT CONGLOMERATE
Bill of Lading & Commercial Shipping Manifest #PMF-88492
Shipper: Yokohama Advanced Robotics Ltd. | Consignee: Detroit Assembly Works
Vessel: MV Pacific Fortune (Voyage 408) | Port of Discharge: Port of Oakland

Cargo Description:
• 16 Forty-Foot High-Cube Containers: Precision Servo Motors and Industrial Gearing (Class 7 Hazardous Electronics)
• Declared Cargo Valuation: $3,450,000 USD
• Port Discharge Timestamp: October 8, 04:30 PST

Demurrage & Detention Terms:
Standard free time for container retrieval is four calendar days following customs clearance. Containers remaining on port premises after October 12, 17:00 PST will incur mandatory port demurrage surcharges of $350 per container per calendar day for the first three days, escalating to $650 per container per day thereafter. All demurrage balances must be settled in full prior to release by terminal gates.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 147, 'What cargo is being transported on the MV Pacific Fortune?', '["Precision servo motors and industrial gearing","Organic agricultural produce","Automotive consumer battery packs","Pre-fabricated steel building beams"]'::jsonb, 'A', 'Bản kê hàng hóa ghi rõ: "Precision Servo Motors and Industrial Gearing" → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 148, 'What penalty applies if containers are not retrieved before October 12?', '["Daily demurrage surcharges of at least $350 per container","Immediate seizure of the electronics by customs agents","Permanent cancellation of the company''s commercial import license","A mandatory forty percent tariff penalty on cargo valuation"]'::jsonb, 'A', 'Điều khoản lưu kho bến bãi: sau ngày 12/10 sẽ chịu phí phạt demurrage tối thiểu $350/ngày/container cho 3 ngày đầu → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #90 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 90, 'MEMORANDUM
To: All Regional Corporate Personnel
From: Evelyn Vance, Chief People Officer
Date: November 3
Subject: Revised Hybrid Attendance Framework for Q1

Following an extensive operational productivity assessment across our domestic campuses, the executive steering committee has revised our hybrid work policy, effective January 15.

All full-time salaried employees previously categorized as fully remote must now maintain a minimum in-office presence of three anchor days per week (Tuesdays, Wednesdays, and Thursdays). Mondays and Fridays will remain discretionary remote work days, provided that core team sprint deadlines are consistently achieved. Department directors possess limited discretionary latitude to grant individual medical or caregiver exemptions, which must be formally audited and renewed every six months. We believe this collaborative framework balances organizational synergy with professional flexibility.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 149, 'What does the updated attendance framework require of previously remote employees?', '["Working in the office on Tuesdays, Wednesdays, and Thursdays","Relocating to the corporate headquarters campus in Chicago","Attending weekly virtual town halls on Monday mornings","Logging out of enterprise software systems before 5:00 P.M."]'::jsonb, 'A', 'Quy định mới bắt buộc nhân viên từ xa trước đây phải có mặt tại văn phòng 3 ngày cố định (Thứ Ba, Thứ Tư, Thứ Năm) → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 150, 'How often must individual remote work exemptions be reviewed?', '["Every six months","Once every quarter","On an annual basis","Every two weeks"]'::jsonb, 'A', 'Các trường hợp miễn trừ y tế/chăm sóc gia đình phải được kiểm toán và gia hạn 6 tháng một lần ("renewed every six months") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #91 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 91, 'EXECUTIVE SEARCH: DIRECTOR OF CLINICAL PHARMACOLOGY
Apex BioPharma Laboratories | Location: Cambridge, Massachusetts

Apex BioPharma Laboratories is searching for an accomplished medical researcher to direct our clinical pharmacokinetics and toxicological discovery unit. The incumbent will oversee Phase One through Phase Three human trial protocols and interface directly with international regulatory agencies (FDA, EMA).

Prerequisites & Selection Criteria:
• M.D. or Ph.D. in Pharmacology, Bio-chemistry, or a cognate molecular biology field.
• Minimum eight years of progressive leadership within enterprise biotechnology environments.
• A distinguished record of first-author publications in peer-reviewed medical journals (minimum 10 publications in past five years).
• Demonstrated success filing Investigational New Drug (IND) applications.

Compensation spans $210,000–$250,000 base salary, complemented by performance-indexed equity grants and comprehensive executive benefits. Inquiries with curriculum vitae should be directed to executivecareers@apexbiopharma.com prior to December 1.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 151, 'What is NOT stated as a mandatory prerequisite for the director position?', '["Fluency in three or more European languages","An M.D. or Ph.D. in a relevant scientific discipline","At least eight years of biotechnology leadership experience","A publication track record in peer-reviewed medical journals"]'::jsonb, 'A', 'Yêu cầu tuyển dụng không hề nhắc tới việc phải thông thạo từ 3 ngôn ngữ châu Âu trở lên → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 152, 'What deadline is specified for submitting application materials?', '["Prior to December 1","By October 15","January 15","Within thirty calendar days"]'::jsonb, 'A', 'Hạn chót nộp hồ sơ được nêu rõ là trước ngày 1 tháng 12 ("prior to December 1") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #92 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 92, 'CONFIDENTIALITY AND NON-DISCLOSURE AGREEMENT
Paragraph 6: Permitted Disclosures and Compelled Judicial Process

Notwithstanding the strict non-disclosure obligations set forth in Section 3, the Receiving Party may disclose Proprietary Confidential Information solely to the extent that such disclosure is legally compelled by a valid subpoena, court order, or formal decree issued by a governmental regulatory agency possessing competent legal jurisdiction.

Provided, however, that in the event of such compelled disclosure, the Receiving Party shall: (a) provide immediate written notice to the Disclosing Party no later than three business days prior to disclosure; (b) consult in good faith with the Disclosing Party to seek a protective court order or confidential treatment; and (c) disclose only that portion of Proprietary Information that is strictly required by the judicial mandate. Any proprietary trade secrets disclosed pursuant to this section shall continue to remain confidential for all other commercial purposes.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 153, 'Under what condition is the Receiving Party permitted to disclose confidential information?', '["When legally compelled by a court order or government subpoena","Upon receiving written permission from competing industry partners","After five calendar years have elapsed from contract signing","Whenever quarterly financial reports are submitted to investors"]'::jsonb, 'A', 'Ngoại lệ cho phép tiết lộ: khi bị cơ quan tòa án hoặc cơ quan chính phủ có thẩm quyền bắt buộc bằng trát hầu tòa hoặc lệnh tòa ("legally compelled by a valid subpoena, court order...") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 154, 'What notice requirement must be met before compelled disclosure occurs?', '["Providing written notification at least three business days beforehand","Publishing a notice in the municipal legal newspaper","Notifying all company shareholders by certified postal courier","Securing approval from an independent arbitration panel"]'::jsonb, 'A', 'Nghĩa vụ thông báo: gửi thông báo bằng văn bản trước ít nhất 3 ngày làm việc ("written notice ... no later than three business days prior to disclosure") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 155, 'What amount of proprietary information may be shared during compelled process?', '["Only the precise portion strictly required by judicial decree","The entire corporate engineering database","All documentation generated during the previous fiscal year","Whatever materials the legal counsel deems publicly interesting"]'::jsonb, 'A', 'Phần tài liệu được tiết lộ: chỉ đúng phần mà trát lệnh tư pháp yêu cầu ("only that portion of Proprietary Information that is strictly required") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #93 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 93, 'NORTH SEA RENEWABLES CONGLOMERATE
Annual Sustainable Energy Infrastructure Report

During the preceding fiscal year, North Sea Renewables achieved commercial grid connection for Phase Two of the Dogger Bank Offshore Wind Array, situated eighty miles off the northeastern Yorkshire coastline. The installation of forty-eight high-capacity 14-megawatt Haliade-X turbines added 672 megawatts of zero-carbon generation capacity to the national electric grid, powering approximately 620,000 homes.

Despite severe winter gale disruptions that caused twenty-four days of subsea cabling downtime, capital expenditures were contained within two percent of our approved four point two billion pound budget. Our innovative acoustic bubble curtain technology reduced underwater pile-driving acoustic shockwaves by ninety percent, preserving marine mammal habitats in full compliance with North Sea conservation treaties. Phase Three installation of sixty additional deep-water floating turbines will commence in April.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 156, 'Where is the Dogger Bank Offshore Wind Array situated?', '["Eighty miles off the northeastern Yorkshire coastline","Twelve miles from downtown London","In a freshwater highland lake reservoir","Along the coastal harbor of Rotterdam"]'::jsonb, 'A', 'Vị trí trang trại gió ngoài khơi: 80 dặm ngoài khơi bờ biển đông bắc Yorkshire ("eighty miles off the northeastern Yorkshire coastline") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 157, 'What environmental mitigation technology was utilized during construction?', '["Acoustic bubble curtains to dampen underwater noise shockwaves","Solar-powered dredging barges to collect coastal sediment","Artificial coral reef concrete breakwaters","Satellite-guided radar beacons to deter migratory birds"]'::jsonb, 'A', 'Công nghệ bảo vệ môi trường: rèm bọt khí âm thanh giúp giảm 90% sóng âm khi đóng cọc đáy biển để bảo vệ sinh vật biển ("acoustic bubble curtain technology reduced underwater pile-driving acoustic shockwaves") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 158, 'When will Phase Three installation begin?', '["In April","Next winter","In twenty-four days","After two years"]'::jsonb, 'A', 'Giai đoạn 3 sẽ bắt đầu vào tháng Tư ("Phase Three installation ... will commence in April") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #94 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 94, 'THE KENSINGTON ROYALE HOTEL & RESIDENCES
Office of the General Manager | Date: October 20
To: Mr. Arthur Pendelton, Chief Investment Officer, Pendelton Capital

Dear Mr. Pendelton,

Thank you for contacting my office directly regarding your stay in the Sovereign Suite from October 14 through October 18. I was profoundly dismayed to learn that your experience fell far short of our royal service standards. Specifically, the intermittent failure of the smart climate control system and the unacceptable three-hour delay in laundry turnaround were completely inexcusable.

Our chief engineering officer determined that a faulty digital motherboard in the suite''s thermal regulation sub-station caused the persistent temperature fluctuations. The unit was replaced yesterday. Furthermore, our housekeeping leadership has instituted double-check dispatch manifests to eliminate laundry scheduling bottlenecks.

As a tangible gesture of our sincere remorse and in recognition of your Diamond Loyalty status, I have credited 150,000 reward points to your loyalty account and credited back the entirety of your four-night lodging charges ($6,800 USD). We hope to welcome you back on your next London visit.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 159, 'What issues prompted Mr. Pendelton''s dissatisfaction?', '["Erratic temperature controls and delayed laundry service","Unsanitary bathroom linens and noisy street traffic","Unpalatable room service dining and missing baggage","An incorrect room billing rate and rude desk staff"]'::jsonb, 'A', 'Khách hàng bức xúc vì lỗi điều hòa nhiệt độ phòng chập chờn và giặt ủi chậm trễ 3 tiếng ("intermittent failure of the smart climate control system and the unacceptable three-hour delay in laundry turnaround") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 160, 'What caused the climate control malfunction in the Sovereign Suite?', '["A defective digital motherboard in the thermal regulation unit","A citywide municipal electrical power blackout","An open window left unlatched by housekeeping","A severed water line beneath the marble flooring"]'::jsonb, 'A', 'Nguyên nhân kỹ thuật: bo mạch điều khiển kỹ thuật số bị lỗi ("faulty digital motherboard in the suite''s thermal regulation sub-station") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 161, 'How did the hotel compensate Mr. Pendelton for the inconvenience?', '["Refunded his $6,800 room charges and awarded 150,000 points","Offered a complimentary limousine ride to Heathrow Airport","Upgraded his reservation to the Imperial Penthouse","Presented a lifetime fifty percent dining voucher"]'::jsonb, 'A', 'Bồi thường: hoàn trả toàn bộ $6,800 tiền phòng 4 đêm và cộng 150,000 điểm tích lũy ("credited 150,000 reward points ... and credited back the entirety of your four-night lodging charges ($6,800 USD)") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #95 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 95, 'FRANKFURT INTERNATIONAL AUTOMOTIVE TECH EXPO (FIATE)
Exhibitor Manual: Structural Rigging and Heavy Equipment Regulations

All exhibitors constructing double-decker pavilions or suspending heavy audiovisual equipment from the hall ceiling rafters must adhere strictly to Messe Frankfurt Safety Directives.

Key Regulations:
1. Rigging Submissions: Detailed structural stress blueprints certified by a licensed professional civil engineer must be uploaded to the portal by August 1. Late submissions will incur a non-negotiable 500 Euro penalty fee.
2. Height Restrictions: Single-tier exhibits are limited to a maximum height of 4.5 meters. Multi-tier pavilions may reach 6.0 meters, provided they maintain an automatic emergency fire sprinkler system connected to the municipal water riser.
3. Heavy Vehicles: Fully electric vehicles displayed inside exhibition halls must have their battery charge depleted below twenty-five percent state of charge (SoC) for fire safety. Battery charging inside exhibit halls is strictly prohibited after 18:00.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 162, 'What document must exhibitors submit by August 1?', '["Structural stress blueprints certified by a licensed civil engineer","Proof of commercial liability insurance from an EU underwriter","A list of registered booth staff wearing formal uniform","Catering menus for evening reception guests"]'::jsonb, 'A', 'Tài liệu phải nộp trước 1/8: bản vẽ kết cấu chịu lực được kỹ sư xây dựng có chứng chỉ phê duyệt ("structural stress blueprints certified by a licensed professional civil engineer") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 163, 'What is the maximum permissible height for single-tier exhibit booths?', '["4.5 meters","6.0 meters","2.5 meters","8.0 meters"]'::jsonb, 'A', 'Chiều cao tối đa cho gian hàng 1 tầng: 4.5 mét ("Single-tier exhibits are limited to a maximum height of 4.5 meters") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 164, 'What fire safety regulation applies to electric vehicles displayed in halls?', '["Battery charge must remain below twenty-five percent","Vehicles must have all tires removed during the expo","Charging cords must remain plugged in twenty-four hours a day","Vehicles must be parked within five meters of emergency exits"]'::jsonb, 'A', 'Quy tắc an toàn chống cháy cho xe điện: pin phải duy trì dưới 25% dung lượng sạc ("battery charge depleted below twenty-five percent state of charge") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #96 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 96, 'FINANCIAL JOURNAL OF GLOBAL COMMERCE
Article: The Unintended Ripple Effects of Strategic Import Tariffs
By Senior Trade Economics Correspondent Julian Vance

While the implementation of a 25% blanket import tariff on foreign raw steel was ostensibly engineered to bolster domestic blast furnace foundries, downstream manufacturing industries are bearing the brunt of acute price shocks. Domestic commercial appliance and automotive fabricators have experienced a 38% surge in cold-rolled coil procurement costs over the preceding six months.

Consequently, operating margins for mid-market industrial machinery manufacturers contracted from 14.2% to a historic low of 6.8% in the third quarter. Unable to absorb these margin compressions indefinitely, major industrial exporters like Caterpillar and John Deere have instituted surcharge clauses on finished tractors, passing costs directly to agricultural buyers. Trade economists predict that unless tariff exemptions are granted for specialty automotive alloy grades by year-end, domestic manufacturers will relocate sub-assembly lines to Mexico or Canada.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 165, 'What was the stated objective of the 25% import tariff on raw steel?', '["To bolster domestic blast furnace foundries","To generate federal revenue to fund highway construction","To encourage automotive companies to switch to aluminum","To reduce consumer spending on imported household appliances"]'::jsonb, 'A', 'Mục tiêu danh nghĩa của thuế nhập khẩu 25% là thúc đẩy các xưởng luyện thép lò cao trong nước ("ostensibly engineered to bolster domestic blast furnace foundries") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 166, 'What has happened to operating margins for mid-market machinery manufacturers?', '["Contracted from 14.2% down to 6.8%","Expanded by thirty-eight percent","Remained completely unchanged throughout the quarter","Rose to an all-time record high of twenty-five percent"]'::jsonb, 'A', 'Biên lợi nhuận hoạt động bị teo tóp từ 14.2% xuống mức thấp kỷ lục 6.8% ("operating margins ... contracted from 14.2% to a historic low of 6.8%") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 167, 'What action might manufacturers take if specialty tariff exemptions are not granted?', '["Relocate sub-assembly operations to Mexico or Canada","Permanently discontinue finished tractor manufacturing","File an antitrust lawsuit against domestic foundries","Cease all retail agricultural sales worldwide"]'::jsonb, 'A', 'Nếu không được miễn trừ thuế, các nhà sản xuất có thể chuyển dây chuyền lắp ráp phụ sang Mexico hoặc Canada ("relocate sub-assembly lines to Mexico or Canada") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #97 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 97, 'GLOBAL CONSULTING GROUP
Internal Executive Memo: 360-Degree Leadership Performance Evaluation
From: Corporate Talent Committee | Date: November 12

Beginning next month, Global Consulting Group will transition from traditional annual supervisor reviews to a comprehensive 360-degree appraisal framework for all Senior Associates and Engagement Managers. Under this framework, performance ratings will be weighted across four distinct perspectives: Supervisor Assessment (40%), Peer Review (25%), Subordinate Team Feedback (20%), and Client Satisfaction NPS (15%).

Promotion to Partner Eligibility:
To be shortlisted for Junior Partner candidacy, candidates must maintain an aggregate composite score of at least 4.6 out of 5.0 over three consecutive evaluation cycles. Furthermore, candidates must have originated at least $2.5 million in new client billings and demonstrated verified sponsorship of at least two junior consultants from underrepresented backgrounds.

Confidential Evaluation Windows:
Peer and subordinate evaluations must be submitted via the anonymized portal between December 1 and December 15. The system utilizes automated sentiment masking to protect reviewer anonymity. Personal coaching briefings with managing partners will be scheduled throughout January.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 168, 'What evaluation perspective carries the highest weight in the new framework?', '["Supervisor Assessment (40%)","Peer Review (25%)","Subordinate Team Feedback (20%)","Client Satisfaction NPS (15%)"]'::jsonb, 'A', 'Trọng số cao nhất thuộc về Đánh giá của cấp trên trực tiếp (40%) → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 169, 'What minimum score is required over three cycles to qualify for Partner consideration?', '["4.6 out of 5.0","4.0 out of 5.0","3.5 out of 5.0","4.9 out of 5.0"]'::jsonb, 'A', 'Điểm tối thiểu yêu cầu qua 3 kỳ đánh giá là 4.6 trên 5.0 ("aggregate composite score of at least 4.6 out of 5.0") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 170, 'How much new client business must prospective partners have generated?', '["At least $2.5 million","Exactly $1.0 million","Over $10 million","$500,000"]'::jsonb, 'A', 'Chỉ tiêu doanh số đem về: ít nhất 2.5 triệu đô la ("originated at least $2.5 million in new client billings") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 171, 'How is reviewer anonymity protected on the evaluation portal?', '["Automated sentiment masking technology is applied","Reviews are hand-delivered in sealed envelopes","Only executive managing partners can read reviews","Evaluators use pseudonyms assigned by human resources"]'::jsonb, 'A', 'Công nghệ che giấu ẩn danh người đánh giá: hệ thống áp dụng công nghệ tự động làm mờ sắc thái biểu cảm ("automated sentiment masking to protect reviewer anonymity") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #98 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 98, 'BIORISK MANAGEMENT INSTITUTE
Biosafety Level 3 (BSL-3) High-Containment Cleanroom Standard Operating Procedure

Section 8: Negative Pressure Airflow Interlocks and Emergency Decontamination

Personnel entering BSL-3 biocontainment corridors must pass through a two-stage pneumatic airlock. Chamber One maintains an ambient pressure differential of -25 Pascals relative to outer hallways, while Chamber Two maintains -50 Pascals relative to active culture containment suites. At no point should both airlock doors be opened concurrently; an automated magnetic interlock prohibits opening the secondary door until the primary door has completed a twelve-second positive sealing cycle.

Emergency Spill Protocols:
In the event of an aerosolized liquid culture spill exceeding 50 milliliters:
1. Actuate the wall-mounted red pull-switch immediately to trigger localized HEPA filtration isolation and initiate the automated vaporized hydrogen peroxide (VHP) fogging cycle.
2. Evacuate through Emergency Exit West within ninety seconds. Do not attempt manual swab collection.
3. Report directly to Decontamination Station C for a mandatory fourteen-minute chemical disinfectant shower before changing into sterile hospital scrubs.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 172, 'What safety mechanism prevents both airlock doors from opening simultaneously?', '["An automated magnetic interlock system","A manual padlock combination code","A biometric fingerprint retinal scanner","A physical wooden barricade beam"]'::jsonb, 'A', 'Cơ chế an toàn ngăn mở 2 cửa cùng lúc: hệ thống khóa liên động từ tính tự động ("automated magnetic interlock prohibits opening the secondary door") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 173, 'How long is the sealing cycle between airlock chambers?', '["Twelve seconds","Fifty seconds","Two minutes","Ninety seconds"]'::jsonb, 'A', 'Chu kỳ khóa kín của cửa là 12 giây ("twelve-second positive sealing cycle") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 174, 'What volume of spilled culture requires triggering emergency evacuation?', '["Exceeding 50 milliliters","Over 500 liters","More than 1 gallon","Any droplet whatsoever"]'::jsonb, 'A', 'Thể tích tràn chất lỏng kích hoạt báo động: vượt quá 50 mililit ("culture spill exceeding 50 milliliters") → Chọn (A).', '["reading","detail"]'::jsonb),
    (v_test_id, v_group_id, 7, 175, 'What must personnel do immediately after evacuating to Decontamination Station C?', '["Take a fourteen-minute chemical disinfectant shower","Sign an incident accident indemnity release form","Drive themselves to the nearest municipal hospital","Call the federal environmental protection hotline"]'::jsonb, 'A', 'Nghĩa vụ ngay sau khi sơ tán tới Trạm C: tắm khử khuẩn bằng hóa chất trong 14 phút ("mandatory fourteen-minute chemical disinfectant shower") → Chọn (A).', '["reading","detail"]'::jsonb);

  -- Group #99 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 99, 'DOCUMENT 1: REQUEST FOR PROPOSALS (RFP)
Crownfield Real Estate Management | Date: August 5
Project: Complete Central HVAC Replacement at Lexington Tower

Crownfield Management invites competitive bids from certified commercial mechanical contractors to replace the legacy chiller and ducted air ventilation system at Lexington Tower (34 floors, 420,000 square feet). Proposals must include:
• Decommissioning and crane removal of two 450-ton roof-mounted centrifugal chillers.
• Installation of modern variable refrigerant flow (VRF) units achieving at least 30% reduction in annual electricity consumption.
• Smart building integration with BACnet automation protocols.
• Work must occur strictly over weekend windows (Friday 19:00 to Monday 05:00) to avoid interrupting corporate tenants.
• Submissions due by August 25. Projected budget cap: $1,800,000 USD.

────────────────────────────────────────────────────────

DOCUMENT 2: BID PROPOSAL
Apex Mechanical Contractors | Date: August 22
To: Selection Committee, Crownfield Real Estate Management

We are delighted to submit our tender for the Lexington Tower HVAC Modernization project. Apex Mechanical brings over thirty years of high-rise commercial retrofit expertise in downtown Manhattan.

Scope & Financial Terms:
• Equipment: Daikin Ultra-Efficiency VRF Modular Chiller System (guaranteed 34% energy savings, exceeding your 30% target).
• Automation: Native BACnet-compatible digital thermostats and remote mobile diagnostics.
• Crane Logistics: Heavy crane rigging permits pre-approved with the municipal transit authority for three consecutive weekends in October.
• Total Fixed-Cost Bid: $1,685,000 USD (inclusive of all equipment, labor, permits, and a five-year comprehensive parts warranty).
• Note on Timeline: Because our crane permits are scheduled for October 8–24, contract finalization must occur prior to September 10.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 176, 'What energy efficiency requirement did Crownfield specify in the RFP?', '["At least a thirty percent reduction in annual electricity usage","Complete conversion to rooftop solar power","A zero-emission geothermal ground loop system","A fifty percent decrease in municipal water consumption"]'::jsonb, 'A', 'Yêu cầu trong RFP: giảm ít nhất 30% mức tiêu thụ điện hàng năm ("at least 30% reduction in annual electricity consumption") → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 177, 'Why must installation work occur only during weekend windows?', '["To avoid disrupting commercial tenants during business hours","Because crane permits are only valid on Sundays","To comply with municipal noise ordinance statutes","Because building elevators are turned off on weekdays"]'::jsonb, 'A', 'Lý do chỉ thi công cuối tuần: tránh làm gián đoạn các công ty thuê văn phòng ("avoid interrupting corporate tenants") → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 178, 'How does Apex Mechanical''s bid compare to Crownfield''s budget cap?', '["It is $115,000 below the maximum budget cap","It exceeds the budget by twenty percent","It matches the exact budget cap of $1,800,000","It requires an additional $300,000 in contingency reserves"]'::jsonb, 'A', 'Câu hỏi suy luận chéo: Ngân sách tối đa của chủ nhà là $1,800,000; giá thầu trọn gói của Apex là $1,685,000 → Thấp hơn $115,000 ($1,800,000 - $1,685,000) → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 179, 'What warranty coverage does Apex Mechanical include in its fixed-cost price?', '["A five-year comprehensive parts warranty","Ten years of free filter replacement labor","A lifetime guarantee against roof leaks","One year of emergency electrical service"]'::jsonb, 'A', 'Bảo hành: bảo hành toàn diện phụ tùng trong 5 năm ("five-year comprehensive parts warranty") → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 180, 'By what date must Crownfield finalize the contract to secure Apex''s schedule?', '["Prior to September 10","By August 5","On August 25","By October 24"]'::jsonb, 'A', 'Thời hạn chốt hợp đồng để kịp giấy phép cẩu hàng: trước ngày 10 tháng 9 ("must occur prior to September 10") → Chọn (A).', '["reading","double-passage"]'::jsonb);

  -- Group #100 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 100, 'DOCUMENT 1: SYMPOSIUM SCHEDULE
International Macroeconomic Forum | Geneva Convention Palace
Date: Thursday, November 18 | Room: Auditorium Alpha (Level 2)

• 09:00 – 10:30: Opening Remarks & Global Trade Outlook (Dr. Henrik Lindqvist)
• 10:45 – 12:15: Sovereign Debt Restructuring in Emerging Markets (Prof. Claudia Rossi)
• 12:15 – 13:45: Executive Luncheon Banquet (Lake View Dining Hall)
• 14:00 – 15:30: Central Bank Digital Currencies and Cross-Border Settlements (Dr. Aris Thorne)
• 15:45 – 17:15: Panel Discussion: Supply Chain Geopolitics (Chaired by Dr. Thorne)

────────────────────────────────────────────────────────

DOCUMENT 2: URGENT EMAIL
From: Prof. Claudia Rossi <c.rossi@bocconi.it>
To: Program Coordinator <organizers@macroforum.org>
Date: Wednesday, November 17, 18:40 CET
Subject: Urgent Travel Disruption - Schedule Adjustment Request

Dear Forum Coordinators,

I am writing with deep regret to inform you that my connecting flight from Milan Malpensa to Geneva was abruptly cancelled due to an air traffic controller wildcat strike in Northern Italy. I have rebooked onto an express train departing Milan tomorrow morning at 08:30, which is scheduled to arrive at Geneva Central Station at 12:45 CET.

Consequently, I will be unable to deliver my morning presentation at 10:45. Would it be feasible to swap presentation slots with Dr. Aris Thorne? If Dr. Thorne can deliver his lecture on Central Bank Digital Currencies during the 10:45 morning window, I could take his 14:00 afternoon slot immediately following the luncheon banquet. I have spoken to Dr. Thorne briefly by phone, and he indicated he is agreeable to this exchange if audio-visual setups allow.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 181, 'What topic was Professor Rossi originally scheduled to address?', '["Sovereign Debt Restructuring in Emerging Markets","Central Bank Digital Currencies","Supply Chain Geopolitics","Global Trade Outlook in Northern Europe"]'::jsonb, 'A', 'Theo lịch trình Doc 1, bài giảng của Giáo sư Rossi lúc 10:45 là về tái cơ cấu nợ công ở các thị trường mới nổi ("Sovereign Debt Restructuring in Emerging Markets") → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 182, 'Why is Professor Rossi unable to arrive in Geneva before noon?', '["Her flight was cancelled due to an air traffic controller strike","She contracted a sudden illness requiring hospital treatment","Her train derailed outside Milan","She lost her passport at Malpensa Airport"]'::jsonb, 'A', 'Nguyên nhân: chuyến bay bị hủy đột ngột do cuộc đình công của kiểm soát viên không lưu ở Bắc Ý ("air traffic controller wildcat strike") → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 183, 'What adjustment does Professor Rossi propose?', '["Swapping presentation slots with Dr. Aris Thorne","Presenting her lecture remotely via Zoom video conference","Moving her talk to Friday morning","Canceling the afternoon panel discussion entirely"]'::jsonb, 'A', 'Đề xuất đổi ca: đổi khung giờ thuyết trình với Dr. Aris Thorne ("swap presentation slots with Dr. Aris Thorne") → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 184, 'If the proposal is accepted, what lecture will attendees hear at 10:45 A.M.?', '["Central Bank Digital Currencies and Cross-Border Settlements","Global Trade Outlook and Supply Chain Tariffs","Sovereign Debt Restructuring","Executive Luncheon Banquet Speeches"]'::jsonb, 'A', 'Suy luận chéo: Nếu hoán đổi thành công, Dr. Aris Thorne sẽ thuyết trình lúc 10:45 về chuyên đề của ông: "Central Bank Digital Currencies and Cross-Border Settlements" → Chọn (A).', '["reading","double-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 185, 'When does Professor Rossi''s train arrive in Geneva?', '["At 12:45 CET","At 08:30 CET","At 10:45 CET","At 14:00 CET"]'::jsonb, 'A', 'Tàu của Giáo sư Rossi đến Geneva lúc 12:45 CET ("scheduled to arrive at Geneva Central Station at 12:45 CET") → Chọn (A).', '["reading","double-passage"]'::jsonb);

  -- Group #101 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 101, 'DOCUMENT 1: CORPORATE POLICY DIRECTIVE
Vanguard Logistics Group | Policy 24-B: Fleet & Personal Electric Vehicle (EV) Subsidy
Effective Date: March 1

To incentivize green commuting, Vanguard reimburses field sales representatives who utilize personal electric vehicles for business client visitations:
1. Mileage Allowance: Reimbursed at $0.62 per mile for documented client travel exceeding 25 miles from the employee''s assigned regional office.
2. Charging Reimbursement: DC Fast Charging expenses incurred during active client travel are 100% reimbursable up to a monthly cap of $180. Overnight home-charging utility bills are strictly non-reimbursable.
3. Documentation Mandate: All expense reports must include GPS-stamped route logs and original digital receipts from certified charging networks (ChargePoint, EVgo, Electrify America). Claims must be submitted within 14 calendar days of month-end.

────────────────────────────────────────────────────────

DOCUMENT 2: EXPENSE CLAIM SUMMARY
Employee: Marcus Bennett | Department: Enterprise Field Sales (Cleveland Branch)
Billing Period: October | Submission Date: November 6

• Item 1 (Oct 4): Client visit to Akron Industrial Park (64 miles round-trip) -> Mileage claim: $39.68
• Item 2 (Oct 11): Client conference in Columbus (240 miles round-trip) -> Mileage claim: $148.80
• Item 3 (Oct 11): Electrify America Fast-Charge receipt (Columbus) -> $34.50
• Item 4 (Oct 22): Monthly residential home electricity utility statement -> $115.00
• Item 5 (Oct 28): Routine car wash and interior vacuuming -> $25.00
Total Claimed Reimbursement: $362.98

────────────────────────────────────────────────────────

DOCUMENT 3: INTERNAL AUDIT NOTIFICATION
From: Internal Expense Audit Division <audit@vanguardlogistics.com>
To: Marcus Bennett <mbennett@vanguardlogistics.com>
Date: November 9
Subject: Adjustment to October Travel Expense Claim #EXP-7721

Dear Mr. Bennett,

We have completed our compliance review of your October travel expense report. While Items 1, 2, and 3 fully comply with Policy 24-B guidelines and have been approved for disbursement, we must inform you that two items on your claim have been disallowed.

Specifically, under Section 2 of Policy 24-B, residential utility bills for home vehicle charging are strictly ineligible for corporate reimbursement. Furthermore, routine cosmetic maintenance such as car washes is not covered under our travel allowance. Consequently, your approved reimbursement amount has been revised down from $362.98 to $222.98. The approved sum will be deposited in your bank account on November 15.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 186, 'What requirement must employees meet to receive mileage reimbursement under Policy 24-B?', '["Travel must exceed 25 miles from their regional office","Vehicles must be less than two years old","Travel must occur during weekend hours","Drivers must carry commercial cargo insurance"]'::jsonb, 'A', 'Quy định trong Doc 1 nêu rõ: chỉ hoàn tiền số dặm khi chuyến đi vượt quá 25 dặm từ văn phòng chi nhánh ("exceeding 25 miles from the employee''s assigned regional office") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 187, 'Why was Marcus Bennett''s home electricity bill (Item 4) disallowed?', '["Policy 24-B expressly prohibits reimbursing residential home charging","The submission was filed after the 14-day deadline","Marcus failed to attach a photo of his electric meter","His monthly utility bill exceeded the $180 maximum cap"]'::jsonb, 'A', 'Khoản tiền điện sạc tại nhà ($115) bị từ chối vì chính sách quy định rõ: "Overnight home-charging utility bills are strictly non-reimbursable" → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 188, 'What total amount was Marcus originally seeking to claim?', '["$362.98","$222.98","$180.00","$148.80"]'::jsonb, 'A', 'Số tiền ban đầu Marcus yêu cầu hoàn là $362.98 trong Doc 2 ("Total Claimed Reimbursement: $362.98") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 189, 'What was the total dollar value of the two disallowed items combined?', '["$140.00","$115.00","$25.00","$34.50"]'::jsonb, 'A', 'Suy luận chéo: Hai mục bị loại là tiền điện nhà (Item 4: $115.00) và rửa xe (Item 5: $25.00). Tổng số tiền bị loại là $115.00 + $25.00 = $140.00 (khớp với mức giảm từ $362.98 xuống $222.98) → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 190, 'When will Marcus receive his approved reimbursement deposit?', '["On November 15","On November 6","On October 31","On December 1"]'::jsonb, 'A', 'Trong email Doc 3 nêu rõ: số tiền đã duyệt sẽ được chuyển vào tài khoản vào ngày 15 tháng 11 ("deposited in your bank account on November 15") → Chọn (A).', '["reading","triple-passage"]'::jsonb);

  -- Group #102 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 102, 'DOCUMENT 1: PRESS RELEASE
HARBOR VIEW HOSPITALITY GROUP
For Immediate Release: September 1
Subject: Grand Opening of L’Etoile Maritime at Pier 21

Harbor View Hospitality is proud to announce the grand opening of L’Etoile Maritime, a premier seafood culinary destination situated at the newly redeveloped historic Pier 21 waterfront pavilion in Boston. Led by Michelin-starred Executive Chef Jean-Luc Moreau, L’Etoile Maritime showcases sustainable wild-caught North Atlantic seafood paired with organic biodynamic wines.

Signature Offerings:
• Wood-Fired Maine Diver Scallops with saffron-infused parsnip puree.
• Poached Nova Scotia Lobster Tail served over handmade squid-ink tagliatelle.
• Panoramic 270-degree floor-to-ceiling glass dining room overlooking Boston Harbor.
Reservations are open exclusively via OpenTable starting September 15. Private banquet bookings available for corporate galas up to 120 guests.

────────────────────────────────────────────────────────

DOCUMENT 2: RESTAURANT REVIEW
THE METROPOLITAN DINING CHRONICLE
Headline: Splendid Views Overshadowed by Inconsistent Execution at L''Etoile Maritime
By Senior Food Critic Sebastian Drake | Published: October 10
Rating: ★★☆☆☆ (2 out of 5 Stars)

There is no denying that the breathtaking harbor sunset at L’Etoile Maritime provides one of the most stunning dining backdrops in New England. Regrettably, the culinary execution on my visit last Friday did not justify the eye-watering $240-per-person tasting menu.

While the poached lobster tail was masterfully tender and sweet, the wood-fired Maine diver scallops arrived at our table lukewarm and noticeably over-salted. Even more frustrating was the glacial dining room service: a forty-five minute lag transpired between our appetizer course and entrees, leaving our party waiting with empty water glasses. For a restaurant with Michelin pedigree, such operational lapses are inexcusable.

────────────────────────────────────────────────────────

DOCUMENT 3: CHEF''S LETTER TO THE EDITOR
To: The Editorial Board, The Metropolitan Dining Chronicle
From: Executive Chef Jean-Luc Moreau, L''Etoile Maritime
Published: October 14

Dear Mr. Drake and Editors,

I read Sebastian Drake''s review with genuine humility and professional concern. I take personal responsibility for the shortcomings highlighted during his visit on October 6.

Following his critique, we investigated our kitchen operations and identified a technical fault in our secondary wood-fired hearth ventilation hood, which caused uneven thermal circulation and delayed scallop preparation times. The ventilation system has been thoroughly re-engineered. Furthermore, our general manager has hired four additional floor sommeliers and food runners to guarantee seamless table service turnaround.

To demonstrate our unwavering commitment to culinary perfection, we invite Mr. Drake and his editorial colleagues to return as our personal guests to experience our newly launched autumn tasting menu.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 191, 'Where is L’Etoile Maritime located?', '["At Pier 21 waterfront pavilion in Boston","In downtown Manhattan near Fifth Avenue","On the historic docks of Portland, Maine","Inside a luxury hotel in Nova Scotia"]'::jsonb, 'A', 'Thông cáo báo chí Doc 1 nêu rõ nhà hàng tọa lạc tại Pier 21 ở Boston ("Pier 21 waterfront pavilion in Boston") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 192, 'Which dish did food critic Sebastian Drake praise during his visit?', '["The poached Nova Scotia lobster tail","The wood-fired Maine diver scallops","The saffron-infused parsnip soup","The house artisan sourdough bread"]'::jsonb, 'A', 'Nhà phê bình khen ngợi món tôm hùm luộc rất mềm và ngọt ("poached lobster tail was masterfully tender and sweet") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 193, 'What specific service failure did Mr. Drake criticize in his review?', '["A forty-five minute delay between appetizers and entrees","The sommelier recommended an overpriced wine bottle","The hostess cancelled his reservation without notice","The kitchen refused to accommodate dietary allergies"]'::jsonb, 'A', 'Lỗi phục vụ bị phê bình: khoảng trống chờ đợi tới 45 phút giữa món khai vị và món chính ("forty-five minute lag transpired between our appetizer course and entrees") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 194, 'What mechanical problem caused the uneven cooking of the scallops?', '["A fault in the wood-fired hearth ventilation hood","A broken electrical convection oven heating element","An unexpected municipal gas supply shutdown","A damaged digital refrigerator thermostat"]'::jsonb, 'A', 'Bếp trưởng Jean-Luc Moreau giải thích lỗi do chụp hút thông gió của bếp củi gây luân chuyển nhiệt không đều ("technical fault in our secondary wood-fired hearth ventilation hood") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 195, 'What staff adjustments did management implement in response to the critique?', '["Hired four additional sommeliers and food runners","Replaced the entire line cooking brigade","Appointed a new general manager from Paris","Transferred the executive chef to another restaurant"]'::jsonb, 'A', 'Biện pháp khắc phục: tuyển thêm 4 nhân viên phụ trách rượu và chạy bàn ("hired four additional floor sommeliers and food runners") → Chọn (A).', '["reading","triple-passage"]'::jsonb);

  -- Group #103 (Part 7)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, 7, 103, 'DOCUMENT 1: PURCHASE SPECIFICATION CONTRACT
Client: BioCare Pharmaceuticals (North Carolina)
Vendor: Krones Automated Packaging Systems (Stuttgart, Germany)
Order Date: May 12 | Contract Reference: PO-99382-K

Equipment Ordered:
• Model: Krones OptiSeal 4000 Ultra-Speed Pharmaceutical Blister Packaging Line
• Required Operating Speed: 400 sealed blister packs per minute with sub-millimeter thermal sealing tolerance.
• Inspection Criteria: Integrated high-resolution machine vision cameras to detect micro-cracks in foil backing.
• Delivery & Factory Acceptance: Certified factory inspection report must be furnished before air freight dispatch.
• Warranty: 24-month comprehensive replacement warranty with 48-hour on-site technician dispatch guarantee for tier-one malfunctions.

────────────────────────────────────────────────────────

DOCUMENT 2: FACTORY ACCEPTANCE TEST (FAT) CERTIFICATE
Krones Quality Assurance Division | Date: August 18
Equipment Serial Number: KS-4000-8819

Test Results:
• Motor Drive RPM Stability: PASS (Tested at 420 packs/minute for 8 continuous hours)
• Thermal Foil Sealing Integrity: PASS (Hermetic seal maintained at 185°C ± 0.5°C)
• Machine Vision Optical Reject Gate: PASS (100% detection of simulated 0.2mm foil fractures)
• Emergency Stop Deceleration: PASS (Complete inertia shutdown within 1.2 seconds)

Inspector Certification:
Certified by Lead Quality Engineer Klaus Weber. Equipment cleared for crating and international air cargo freight via Frankfurt Airport.

────────────────────────────────────────────────────────

DOCUMENT 3: URGENT TECHNICAL MALFUNCTION NOTICE
From: Dr. Rachel Adams, VP of Manufacturing, BioCare Pharmaceuticals
To: Krones Customer Support Engineering <support@krones-systems.de>
Date: September 22
Subject: Urgent Warranty Service Dispatch Request - Serial #KS-4000-8819

Dear Krones Technical Team,

The OptiSeal 4000 system arrived at our Raleigh facility on September 10 and was commissioned by your local installation contractors last week. However, during our initial commercial trial run yesterday, the machine vision optical reject arm repeatedly malfunctioned.

Specifically, whenever line throughput exceeded 300 packs per minute, the optical sensors generated false positive defect flags, causing the pneumatic reject gate to divert over eighteen percent of completely flawless blister packs into the scrap bin. This has halted our scheduled production of cardiovascular medication.

Under Section 5 of our contract (PO-99382-K), this qualifies as a critical tier-one defect. We formally request the immediate dispatch of a senior robotics optical specialist to our facility within the contractual 48-hour window.', NULL, NULL, NULL)
  RETURNING id INTO v_group_id;

  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES
    (v_test_id, v_group_id, 7, 196, 'What production speed was specified in the original purchase contract?', '["400 sealed blister packs per minute","185 packs per minute","420 packs per minute","300 packs per minute"]'::jsonb, 'A', 'Hợp đồng mua bán Doc 1 quy định tốc độ vận hành tiêu chuẩn: 400 vỉ thuốc đóng kín mỗi phút ("Required Operating Speed: 400 sealed blister packs per minute") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 197, 'What does the Factory Acceptance Test (Doc 2) indicate about the machinery in Germany?', '["It successfully passed all quality and speed performance tests","It failed the emergency stop deceleration safety test","It required a replacement motor drive before crating","The machine vision camera had to be recalibrated twice"]'::jsonb, 'A', 'Biên bản kiểm tra xuất xưởng FAT Doc 2 cho thấy máy vượt qua tất cả các bài kiểm tra chất lượng ("PASS on all tests") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 198, 'What problem occurred during the commercial trial run in North Carolina?', '["Flawless packs were mistakenly flagged as defective and discarded","The thermal heating element overheated and melted the foil","The motor drive completely jammed and stopped rotating","The blister packs were missing expiration date stampings"]'::jsonb, 'A', 'Sự cố thực tế Doc 3: cảm biến báo lỗi sai khiến 18% sản phẩm hoàn hảo bị gạt bỏ nhầm vào thùng rác ("generated false positive defect flags, causing the pneumatic reject gate to divert over eighteen percent of completely flawless blister packs") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 199, 'How soon is Krones contractually obligated to dispatch an on-site technician?', '["Within forty-eight hours","Within two business weeks","In twenty-four months","Within twelve calendar days"]'::jsonb, 'A', 'Nghĩa vụ bảo hành hợp đồng: cử kỹ thuật viên đến tận nơi trong vòng 48 giờ đối với sự cố cấp 1 ("48-hour on-site technician dispatch guarantee for tier-one malfunctions") → Chọn (A).', '["reading","triple-passage"]'::jsonb),
    (v_test_id, v_group_id, 7, 200, 'At what operating threshold did the optical sensor malfunction begin appearing?', '["Whenever throughput exceeded 300 packs per minute","Only when operating at maximum speed of 420 packs per minute","Immediately upon turning on the power switch","After eight continuous hours of running"]'::jsonb, 'A', 'Lỗi xuất hiện khi tốc độ vượt quá 300 vỉ/phút ("whenever line throughput exceeded 300 packs per minute") → Chọn (A).', '["reading","triple-passage"]'::jsonb);

END $$;

COMMIT;

-- =============================================================================
-- KIỂM TRA TÍNH TOÀN VẸN CỦA ĐỀ THI VỪA INSERT
-- =============================================================================
SELECT 
  t.title,
  COUNT(DISTINCT qg.id) AS total_groups,
  COUNT(q.id) AS total_questions,
  MIN(q.number) AS min_question_num,
  MAX(q.number) AS max_question_num
FROM public.tests t
LEFT JOIN public.question_groups qg ON qg.test_id = t.id
LEFT JOIN public.questions q ON q.test_id = t.id
WHERE t.title = 'ETS Extreme Hard Test 01 (Target 990)'
GROUP BY t.id, t.title;

