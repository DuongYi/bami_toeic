// Module Part 3 (Câu 32-70) & Part 4 (Câu 71-100) - ETS Extreme Hard Test 01 (Target 990)

List<Map<String, dynamic>> buildPart3() {
  final convs = [
    // Conv 1: Q32-34
    {
      'start': 32,
      'audio': 'p3_q32-34.m4a',
      'script': 'Questions 32 through 34 refer to the following conversation. '
          'W: Mr. Sterling, I have reviewed the draft commercial lease for our new regional design studio on Fifth Avenue, and I noticed the landlord inserted a clause holding us liable for all structural roof repairs. '
          'M: That is completely contrary to standard commercial leasing practices in Manhattan. Did you bring this up with their broker? '
          'W: I sent an inquiry this morning, but their representative stated that the property owner is unwilling to renegotiate due to high tenant demand. '
          'M: In that case, instruct our corporate real estate agent to resume talks with the building on Madison Avenue. We cannot accept open-ended structural liabilities.',
      'trans': 'W: Mr. Sterling, I have reviewed the draft commercial lease for our new regional design studio on Fifth Avenue, and I noticed the landlord inserted a clause holding us liable for all structural roof repairs.\n'
          'M: That is completely contrary to standard commercial leasing practices in Manhattan. Did you bring this up with their broker?\n'
          'W: I sent an inquiry this morning, but their representative stated that the property owner is unwilling to renegotiate due to high tenant demand.\n'
          'M: In that case, instruct our corporate real estate agent to resume talks with the building on Madison Avenue. We cannot accept open-ended structural liabilities.',
      'qs': [
        {
          'num': 32,
          'c': 'What problem does the woman identify in the commercial lease agreement?',
          'opts': ['A clause assigns roof repair costs to the tenant', 'The monthly rent increases by twenty percent annually', 'The move-in date was postponed by three months', 'Subleasing office space is strictly prohibited'],
          'a': 'A',
          'exp': 'Người phụ nữ phát hiện chủ nhà chèn điều khoản buộc bên thuê chịu trách nhiệm sửa chữa kết cấu mái ("holding us liable for all structural roof repairs") → Chọn (A).'
        },
        {
          'num': 33,
          'c': 'Why did the landlord\'s representative refuse to modify the lease terms?',
          'opts': ['High tenant demand for the property', 'The building is designated a historical landmark', 'Renovation permits have not been issued', 'The broker was out of the country'],
          'a': 'A',
          'exp': 'Đại diện bên cho thuê từ chối vì nhu cầu thuê tại khu vực đó quá cao ("property owner is unwilling to renegotiate due to high tenant demand") → Chọn (A).'
        },
        {
          'num': 34,
          'c': 'What does the man decide to do?',
          'opts': ['Reopen negotiations for a different property', 'Accept the landlord\'s revised terms', 'File a complaint with the municipal housing authority', 'Hire an independent structural engineer'],
          'a': 'A',
          'exp': 'Người nam chỉ đạo: "instruct our corporate real estate agent to resume talks with the building on Madison Avenue" (nối lại đàm phán với tòa nhà khác) → Chọn (A).'
        }
      ]
    },
    // Conv 2: Q35-37
    {
      'start': 35,
      'audio': 'p3_q35-37.m4a',
      'script': 'Questions 35 through 37 refer to the following conversation. '
          'M: Brenda, have we received the semiconductor controller units from our Taiwanese manufacturer? Our assembly line in Michigan is scheduled to commence production on Monday. '
          'W: Unfortunately, no, David. Customs clearance at the Port of Long Beach has been backed up for over a week due to terminal automation upgrades. '
          'M: That will cause a major bottleneck for our automotive client contracts. Can we airfreight an emergency batch directly from Taipei? '
          'W: Air cargo rates are currently at an all-time peak, but given our contractual liquidated damages penalties for late vehicle delivery, it is undeniably the more economical option.',
      'trans': 'M: Brenda, have we received the semiconductor controller units from our Taiwanese manufacturer? Our assembly line in Michigan is scheduled to commence production on Monday.\n'
          'W: Unfortunately, no, David. Customs clearance at the Port of Long Beach has been backed up for over a week due to terminal automation upgrades.\n'
          'M: That will cause a major bottleneck for our automotive client contracts. Can we airfreight an emergency batch directly from Taipei?\n'
          'W: Air cargo rates are currently at an all-time peak, but given our contractual liquidated damages penalties for late vehicle delivery, it is undeniably the more economical option.',
      'qs': [
        {
          'num': 35,
          'c': 'What component is delayed in transit?',
          'opts': ['Semiconductor controller units', 'Refrigerated vehicle batteries', 'Hydraulic brake lines', 'Industrial assembly robotic arms'],
          'a': 'A',
          'exp': 'Linh kiện bị chậm trễ là bộ điều khiển bán dẫn ("semiconductor controller units") → Chọn (A).'
        },
        {
          'num': 36,
          'c': 'What caused the delivery delay at the seaport?',
          'opts': ['Terminal automation modernization upgrades', 'A maritime typhoon warning in the Pacific', 'A labor dispute among dockworkers', 'Severe damage to container packaging'],
          'a': 'A',
          'exp': 'Hải quan cảng bị ùn ứ do nâng cấp tự động hóa bến bãi ("due to terminal automation upgrades") → Chọn (A).'
        },
        {
          'num': 37,
          'c': 'Why does the woman support shipping an emergency batch by airfreight?',
          'opts': ['To avoid severe financial penalties for delayed delivery', 'Airfreight shipping rates recently dropped by half', 'The client offered to cover all transportation surcharges', 'The maritime shipment was permanently lost at sea'],
          'a': 'A',
          'exp': 'Người phụ nữ đồng ý vì tiền phạt bồi thường vi phạm hợp đồng do giao chậm còn đắt hơn ("contractual liquidated damages penalties for late vehicle delivery") → Chọn (A).'
        }
      ]
    },
    // Conv 3: Q38-40
    {
      'start': 38,
      'audio': 'p3_q38-40.m4a',
      'script': 'Questions 38 through 40 refer to the following conversation. '
          'W: Marcus, several regional sales managers have reported that the newly migrated enterprise resource platform is duplicating client invoices. '
          'M: That is concerning. The software vendor assured us that their data reconciliation algorithm had achieved ninety-nine percent accuracy during beta testing. '
          'W: Well, several of our key enterprise clients received double billing statements yesterday and their procurement officers are demanding an explanation. '
          'M: I will convene an emergency conference with the vendor\'s chief technical architect in fifteen minutes and roll back the database transaction ledger to yesterday morning\'s backup.',
      'trans': 'W: Marcus, several regional sales managers have reported that the newly migrated enterprise resource platform is duplicating client invoices.\n'
          'M: That is concerning. The software vendor assured us that their data reconciliation algorithm had achieved ninety-nine percent accuracy during beta testing.\n'
          'W: Well, several of our key enterprise clients received double billing statements yesterday and their procurement officers are demanding an explanation.\n'
          'M: I will convene an emergency conference with the vendor\'s chief technical architect in fifteen minutes and roll back the database transaction ledger to yesterday morning\'s backup.',
      'qs': [
        {
          'num': 38,
          'c': 'What technical malfunction has occurred with the new enterprise platform?',
          'opts': ['Client billing invoices are being duplicated', 'Customer passwords were leaked online', 'Sales representatives cannot log into mobile devices', 'Transaction currencies are calculating erroneously'],
          'a': 'A',
          'exp': 'Hệ thống ERP mới bị lỗi nhân bản hóa đơn khách hàng ("duplicating client invoices") → Chọn (A).'
        },
        {
          'num': 39,
          'c': 'Who does Marcus intend to meet with shortly?',
          'opts': ['The software vendor\'s chief technical architect', 'The company\'s chief financial officer', 'An external corporate forensic auditor', 'Frustrated enterprise client representatives'],
          'a': 'A',
          'exp': 'Marcus thông báo sẽ họp khẩn cấp với kiến trúc sư trưởng kỹ thuật của nhà cung cấp phần mềm ("the vendor\'s chief technical architect") → Chọn (A).'
        },
        {
          'num': 40,
          'c': 'What immediate remedial action will Marcus implement?',
          'opts': ['Revert the transaction ledger to a previous backup', 'Permanently terminate the vendor\'s software contract', 'Offer affected customers a twenty percent service discount', 'Shut down the corporate data center for the entire week'],
          'a': 'A',
          'exp': 'Hành động khôi phục dữ liệu: "roll back the database transaction ledger to yesterday morning\'s backup" → Chọn (A).'
        }
      ]
    },
    // Conv 4: Q41-43
    {
      'start': 41,
      'audio': 'p3_q41-43.m4a',
      'script': 'Questions 41 through 43 refer to the following conversation. '
          'M: Dr. Alvarez, the clinical trial results for our cardiovascular medication, Corasol, have exceeded our efficacy targets in Phase Three. '
          'W: That is fantastic news, Gregory! However, we still have to clear the federal regulatory compliance panel before establishing manufacturing timelines. '
          'M: Our legal team has already assembled the comprehensive documentation dossier. Do you think we can schedule the submission briefing for November? '
          'W: Given the agency\'s recent staffing shortages, I would advise budgeting an additional eight weeks for review.',
      'trans': 'M: Dr. Alvarez, the clinical trial results for our cardiovascular medication, Corasol, have exceeded our efficacy targets in Phase Three.\n'
          'W: That is fantastic news, Gregory! However, we still have to clear the federal regulatory compliance panel before establishing manufacturing timelines.\n'
          'M: Our legal team has already assembled the comprehensive documentation dossier. Do you think we can schedule the submission briefing for November?\n'
          'W: Given the agency\'s recent staffing shortages, I would advise budgeting an additional eight weeks for review.',
      'qs': [
        {
          'num': 41,
          'c': 'What milestone has the pharmaceutical research team achieved?',
          'opts': ['Exceeded efficacy targets in clinical trial Phase Three', 'Received unconditional marketing approval from the government', 'Signed an overseas licensing distribution agreement', 'Reduced manufacturing costs by fifty percent'],
          'a': 'A',
          'exp': 'Nhóm nghiên cứu vượt mục tiêu hiệu quả thử nghiệm lâm sàng giai đoạn 3 ("exceeded our efficacy targets in Phase Three") → Chọn (A).'
        },
        {
          'num': 42,
          'c': 'What hurdle must the team overcome before manufacturing begins?',
          'opts': ['Federal regulatory agency compliance clearance', 'Constructing a cleanroom laboratory facility', 'Recruiting additional medical trial volunteers', 'Securing venture capital funding'],
          'a': 'A',
          'exp': 'Rào cản là phải vượt qua kiểm định của cơ quan quản lý liên bang ("clear the federal regulatory compliance panel") → Chọn (A).'
        },
        {
          'num': 43,
          'c': 'What does Dr. Alvarez recommend regarding the project schedule?',
          'opts': ['Allowing an extra eight weeks for regulatory review', 'Canceling the submission briefing in November', 'Hiring external consultants to draft the dossier', 'Delaying clinical trials until next spring'],
          'a': 'A',
          'exp': 'Bác sĩ Alvarez khuyên: "budgeting an additional eight weeks for review" do cơ quan quản lý thiếu nhân sự → Chọn (A).'
        }
      ]
    },
    // Conv 5: Q44-46 (Inference question)
    {
      'start': 44,
      'audio': 'p3_q44-46.m4a',
      'script': 'Questions 44 through 46 refer to the following conversation. '
          'W: Jonathan, the merger acquisition committee wants our corporate valuation of Nexa Robotics completed by Thursday afternoon. '
          'M: By Thursday? That\'s a rather optimistic timeline. We haven\'t even received their audited intellectual property portfolio yet. '
          'W: I understand, but the board of directors is meeting with Nexa\'s executive founders on Friday morning to negotiate final share allocations. '
          'M: Well, in that case, I will have our junior financial analysts focus exclusively on their balance sheets, while I examine their patent liabilities tonight.',
      'trans': 'W: Jonathan, the merger acquisition committee wants our corporate valuation of Nexa Robotics completed by Thursday afternoon.\n'
          'M: By Thursday? That\'s a rather optimistic timeline. We haven\'t even received their audited intellectual property portfolio yet.\n'
          'W: I understand, but the board of directors is meeting with Nexa\'s executive founders on Friday morning to negotiate final share allocations.\n'
          'M: Well, in that case, I will have our junior financial analysts focus exclusively on their balance sheets, while I examine their patent liabilities tonight.',
      'qs': [
        {
          'num': 44,
          'c': 'What task has Jonathan been assigned to complete?',
          'opts': ['A corporate financial valuation of Nexa Robotics', 'An intellectual property patent renewal application', 'An employee compensation review for robotic engineers', 'A marketing launch campaign for autonomous drones'],
          'a': 'A',
          'exp': 'Jonathan được giao thẩm định giá trị doanh nghiệp Nexa Robotics ("corporate valuation of Nexa Robotics") → Chọn (A).'
        },
        {
          'num': 45,
          'c': 'What does the man imply when he says: "That\'s a rather optimistic timeline"?',
          'opts': ['The requested deadline is practically unrealistic', 'He believes the merger will be overwhelmingly successful', 'He expects the project to conclude ahead of schedule', 'The client company has an exceptionally bright financial future'],
          'a': 'A',
          'exp': 'Câu ngụ ý kinh điển: "That\'s a rather optimistic timeline" (Lịch đó quá lạc quan đấy) ám chỉ thời hạn thứ Năm được giao là phi thực tế và quá gấp gáp ("The requested deadline is practically unrealistic") → Chọn (A).'
        },
        {
          'num': 46,
          'c': 'How will Jonathan manage the remaining workload?',
          'opts': ['By dividing tasks between junior analysts and himself', 'By requesting a formal two-week deadline extension', 'By outsourcing patent evaluations to an independent law firm', 'By skipping the analysis of intellectual property records'],
          'a': 'A',
          'exp': 'Người nam giải quyết bằng cách phân chia: các chuyên viên cấp dưới làm bảng cân đối kế toán, còn ông tự kiểm tra nghĩa vụ bằng sáng chế đêm nay → Chọn (A).'
        }
      ]
    },
    // Conv 6: Q47-49
    {
      'start': 47,
      'audio': 'p3_q47-49.m4a',
      'script': 'Questions 47 through 49 refer to the following conversation. '
          'M: Sandra, have you seen the user feedback on app stores following yesterday\'s mobile banking update? Our app rating plummeted from four point eight to two point nine stars. '
          'W: Yes, Kevin. Users are experiencing session timeouts whenever they attempt biometric face recognition login on older smartphone operating systems. '
          'M: Our customer support call center is inundated with complaints, and wait times are exceeding forty minutes. '
          'W: Our mobile engineering squad has already pushed a hotfix patch to app stores this morning. We should post an immediate advisory on our social media channels explaining how users can download the update.',
      'trans': 'M: Sandra, have you seen the user feedback on app stores following yesterday\'s mobile banking update? Our app rating plummeted from four point eight to two point nine stars.\n'
          'W: Yes, Kevin. Users are experiencing session timeouts whenever they attempt biometric face recognition login on older smartphone operating systems.\n'
          'M: Our customer support call center is inundated with complaints, and wait times are exceeding forty minutes.\n'
          'W: Our mobile engineering squad has already pushed a hotfix patch to app stores this morning. We should post an immediate advisory on our social media channels explaining how users can download the update.',
      'qs': [
        {
          'num': 47,
          'c': 'What is causing user complaints regarding the mobile banking application?',
          'opts': ['Biometric face authentication fails on older operating systems', 'Online wire transfers are charging double transaction fees', 'Account balances are displaying incorrect currencies', 'The app font size cannot be adjusted'],
          'a': 'A',
          'exp': 'Nguyên nhân gây phàn nàn là lỗi đăng nhập nhận diện khuôn mặt sinh trắc học trên các hệ điều hành cũ ("session timeouts whenever they attempt biometric face recognition login on older smartphone operating systems") → Chọn (A).'
        },
        {
          'num': 48,
          'c': 'What consequence does the man mention?',
          'opts': ['Customer support call center wait times have surged', 'Several corporate banking clients closed their accounts', 'The app was permanently removed from app stores', 'The bank incurred financial fines from regulators'],
          'a': 'A',
          'exp': 'Hệ quả: Trung tâm hỗ trợ khách hàng ngập tràn cuộc gọi, thời gian chờ vượt 40 phút ("wait times are exceeding forty minutes") → Chọn (A).'
        },
        {
          'num': 49,
          'c': 'What does Sandra suggest doing next?',
          'opts': ['Publishing an advisory notice on social media platforms', 'Reverting the mobile banking app to the previous version', 'Providing complimentary gift cards to dissatisfied callers', 'Hiring temporary call center operators'],
          'a': 'A',
          'exp': 'Sandra đề xuất đăng thông báo hướng dẫn tải bản vá lỗi trên mạng xã hội ("post an immediate advisory on our social media channels") → Chọn (A).'
        }
      ]
    },
    // Conv 7: Q50-52
    {
      'start': 50,
      'audio': 'p3_q50-52.m4a',
      'script': 'Questions 50 through 52 refer to the following conversation. '
          'W: Robert, the industrial engineering report estimates that deploying autonomous guided vehicles in our Louisville distribution center will cut operational transit costs by thirty-two percent. '
          'M: The figures look compelling, Elena, but the initial capital expenditure for twenty robotic units and inductive floor charging docks exceeds one point eight million dollars. '
          'W: That\'s true, but the robotics manufacturer offers a five-year leasing structure with comprehensive hardware maintenance included, which spreads the cost into manageable monthly operating expenses. '
          'M: That changes the financial calculus considerably. Let\'s draft a board proposal highlighting the leasing model for next Tuesday\'s capital allocation review.',
      'trans': 'W: Robert, the industrial engineering report estimates that deploying autonomous guided vehicles in our Louisville distribution center will cut operational transit costs by thirty-two percent.\n'
          'M: The figures look compelling, Elena, but the initial capital expenditure for twenty robotic units and inductive floor charging docks exceeds one point eight million dollars.\n'
          'W: That\'s true, but the robotics manufacturer offers a five-year leasing structure with comprehensive hardware maintenance included, which spreads the cost into manageable monthly operating expenses.\n'
          'M: That changes the financial calculus considerably. Let\'s draft a board proposal highlighting the leasing model for next Tuesday\'s capital allocation review.',
      'qs': [
        {
          'num': 50,
          'c': 'What technology is the distribution center considering implementing?',
          'opts': ['Autonomous guided robotic vehicles', 'Automated drone parcel delivery systems', 'Solar panel rooftop generation arrays', 'Barcode scanning wristbands'],
          'a': 'A',
          'exp': 'Công nghệ được cân nhắc là robot tự hành AGVs trong nhà kho ("deploying autonomous guided vehicles") → Chọn (A).'
        },
        {
          'num': 51,
          'c': 'What concern does Robert raise initially?',
          'opts': ['The high initial capital expense of the machinery', 'The lack of floor space in the warehouse aisles', 'A potential strike by warehouse forklift operators', 'Unreliable battery performance in cold weather'],
          'a': 'A',
          'exp': 'Mối lo ngại ban đầu là chi phí đầu tư ban đầu quá cao lên tới 1.8 triệu đô ("initial capital expenditure ... exceeds one point eight million dollars") → Chọn (A).'
        },
        {
          'num': 52,
          'c': 'What solution makes the project financially feasible?',
          'opts': ['A five-year equipment leasing program with maintenance included', 'A government green technology innovation tax credit', 'Sharing equipment with a neighboring distribution facility', 'Purchasing pre-owned refurbished robotic models'],
          'a': 'A',
          'exp': 'Giải pháp khả thi là gói thuê máy 5 năm bao gồm bảo trì ("five-year leasing structure with comprehensive hardware maintenance included") → Chọn (A).'
        }
      ]
    },
    // Conv 8: Q53-55
    {
      'start': 53,
      'audio': 'p3_q53-55.m4a',
      'script': 'Questions 53 through 55 refer to the following conversation. '
          'M: Victoria, the brand strategy division is concerned about the draft video advertisements for our organic skincare line. They feel the tone is overly technical and fails to connect emotionally with millennial consumers. '
          'W: I understand their feedback, Martin, but our primary competitive advantage over mass-market brands is our clinical dermatological data. If we dilute the scientific evidence, we risk looking like every other generic beauty brand. '
          'M: What if we adopt a hybrid approach? The first thirty seconds can showcase real consumer lifestyle testimonials, followed by an animated breakdown of our patented peptide formulation. '
          'W: That strikes a sound balance. I will ask the creative director to storyboard that hybrid concept before our client presentation on Thursday.',
      'trans': 'M: Victoria, the brand strategy division is concerned about the draft video advertisements for our organic skincare line. They feel the tone is overly technical and fails to connect emotionally with millennial consumers.\n'
          'W: I understand their feedback, Martin, but our primary competitive advantage over mass-market brands is our clinical dermatological data. If we dilute the scientific evidence, we risk looking like every other generic beauty brand.\n'
          'M: What if we adopt a hybrid approach? The first thirty seconds can showcase real consumer lifestyle testimonials, followed by an animated breakdown of our patented peptide formulation.\n'
          'W: That strikes a sound balance. I will ask the creative director to storyboard that hybrid concept before our client presentation on Thursday.',
      'qs': [
        {
          'num': 53,
          'c': 'What criticism was made regarding the draft skincare video advertisements?',
          'opts': ['The tone was excessively technical and lacked emotional connection', 'The production budget exceeded approved financial limits', 'The featured actors were unfamiliar to international audiences', 'The video length was too long for television broadcast'],
          'a': 'A',
          'exp': 'Bộ phận thương hiệu phê bình video quá mang tính học thuật kỹ thuật và thiếu kết nối cảm xúc ("tone is overly technical and fails to connect emotionally") → Chọn (A).'
        },
        {
          'num': 54,
          'c': 'Why does Victoria defend including scientific data in the campaign?',
          'opts': ['Clinical evidence differentiates the product from competitors', 'Government regulations require proof of all cosmetic claims', 'The company CEO holds a doctorate in biochemistry', 'Testimonial advertisements have declining viewer engagement'],
          'a': 'A',
          'exp': 'Victoria bảo vệ dữ liệu khoa học vì đó là lợi thế cạnh tranh cốt lõi ("our primary competitive advantage ... is our clinical dermatological data") → Chọn (A).'
        },
        {
          'num': 55,
          'c': 'What compromise does Martin propose?',
          'opts': ['Combining consumer testimonials with scientific animation', 'Halving the marketing budget for digital advertising', 'Postponing the campaign launch until the holiday season', 'Focusing advertisements solely on professional dermatologists'],
          'a': 'A',
          'exp': 'Giải pháp dung hòa là kết hợp cảm xúc người dùng 30 giây đầu và phân tích khoa học hoạt chất ở phần sau ("hybrid approach: consumer lifestyle testimonials, followed by an animated breakdown") → Chọn (A).'
        }
      ]
    },
    // Conv 9: Q56-58 (Inference quote)
    {
      'start': 56,
      'audio': 'p3_q56-58.m4a',
      'script': 'Questions 56 through 58 refer to the following conversation. '
          'W: Alan, Professor Lindqvist just called from Stockholm. Severe snowstorms across Northern Europe have grounded all transatlantic flights out of Arlanda Airport. He cannot deliver the opening keynote at our biotechnology symposium tomorrow. '
          'M: That is disastrous! He was our marquee speaker, and over four hundred delegates registered specifically to hear his gene-editing findings. Is there any chance he can board a flight later tonight? '
          'W: The airport authorities have shut down runways until tomorrow afternoon. '
          'M: I wouldn\'t count on it. We must set up high-definition video conferencing in the grand auditorium immediately so he can present remotely from Sweden.',
      'trans': 'W: Alan, Professor Lindqvist just called from Stockholm. Severe snowstorms across Northern Europe have grounded all transatlantic flights out of Arlanda Airport. He cannot deliver the opening keynote at our biotechnology symposium tomorrow.\n'
          'M: That is disastrous! He was our marquee speaker, and over four hundred delegates registered specifically to hear his gene-editing findings. Is there any chance he can board a flight later tonight?\n'
          'W: The airport authorities have shut down runways until tomorrow afternoon.\n'
          'M: I wouldn\'t count on it. We must set up high-definition video conferencing in the grand auditorium immediately so he can present remotely from Sweden.',
      'qs': [
        {
          'num': 56,
          'c': 'Why is Professor Lindqvist unable to attend the symposium in person?',
          'opts': ['Severe winter weather grounded his flight out of Stockholm', 'He contracted a sudden contagious respiratory illness', 'His presentation slides were corrupted during file transfer', 'He was denied a foreign entry visa'],
          'a': 'A',
          'exp': 'Giáo sư Lindqvist không thể đến vì bão tuyết khiến toàn bộ chuyến bay bị hủy ("Severe snowstorms across Northern Europe have grounded all transatlantic flights") → Chọn (A).'
        },
        {
          'num': 57,
          'c': 'Why does the man say: "I wouldn\'t count on it"?',
          'opts': ['To indicate that an in-person arrival is hopeless', 'To question the official weather forecast accuracy', 'To dispute the delegate registration figures', 'To suggest hiring a different keynote speaker'],
          'a': 'A',
          'exp': 'Câu nói: "I wouldn\'t count on it" (Tôi sẽ không trông mong vào điều đó đâu) nhằm nhấn mạnh rằng việc giáo sư bay kịp là điều hoàn toàn vô vọng và không nên chờ đợi nữa ("indicate that an in-person arrival is hopeless") → Chọn (A).'
        },
        {
          'num': 58,
          'c': 'What solution does Alan propose?',
          'opts': ['Arranging for the speaker to deliver his talk via video conference', 'Canceling the opening morning session of the symposium', 'Rerouting the speaker\'s itinerary through London Heathrow', 'Refunding registration tickets to all 400 delegates'],
          'a': 'A',
          'exp': 'Alan đưa ra giải pháp thuyết trình từ xa qua cầu truyền hình ("set up high-definition video conferencing ... so he can present remotely from Sweden") → Chọn (A).'
        }
      ]
    },
    // Conv 10: Q59-61
    {
      'start': 59,
      'audio': 'p3_q59-61.m4a',
      'script': 'Questions 59 through 61 refer to the following conversation. '
          'M: Teresa, the regional environmental protection agency conducted an unannounced inspection of our industrial wastewater treatment plant yesterday afternoon. '
          'W: Did the inspectors identify any compliance violations, Harold? We recently overhauled our filtration membranes. '
          'M: The chemical purification levels passed with distinction, but they issued a formal citation regarding our hazardous sludge storage containment basins. The containment berms are six inches below the revised municipal flood-risk threshold. '
          'W: We cannot risk an environmental shutdown fine. I will contact Apex Civil Engineering right away to submit blueprints for elevating the containment berms before the sixty-day compliance deadline.',
      'trans': 'M: Teresa, the regional environmental protection agency conducted an unannounced inspection of our industrial wastewater treatment plant yesterday afternoon.\n'
          'W: Did the inspectors identify any compliance violations, Harold? We recently overhauled our filtration membranes.\n'
          'M: The chemical purification levels passed with distinction, but they issued a formal citation regarding our hazardous sludge storage containment basins. The containment berms are six inches below the revised municipal flood-risk threshold.\n'
          'W: We cannot risk an environmental shutdown fine. I will contact Apex Civil Engineering right away to submit blueprints for elevating the containment berms before the sixty-day compliance deadline.',
      'qs': [
        {
          'num': 59,
          'c': 'What facility was subjected to an unannounced government inspection?',
          'opts': ['An industrial wastewater treatment plant', 'A commercial dairy processing facility', 'A hazardous chemical synthesis laboratory', 'An automated container manufacturing depot'],
          'a': 'A',
          'exp': 'Cơ sở bị thanh tra đột xuất là nhà máy xử lý nước thải công nghiệp ("industrial wastewater treatment plant") → Chọn (A).'
        },
        {
          'num': 60,
          'c': 'What deficiency resulted in a formal citation?',
          'opts': ['Containment berms failed to meet updated flood-risk height standards', 'Chemical filtration membranes were clogged with debris', 'Employee safety training logs were missing signatures', 'Wastewater discharge valves were leaking into the river'],
          'a': 'A',
          'exp': 'Lỗi bị phạt cảnh cáo: bờ bao chứa bùn thải thấp hơn 6 inch so với quy chuẩn chống lũ mới của thành phố ("containment berms are six inches below the revised municipal flood-risk threshold") → Chọn (A).'
        },
        {
          'num': 61,
          'c': 'What will Teresa do to resolve the citation?',
          'opts': ['Engage a civil engineering firm to elevate the containment berms', 'Appeal the environmental agency\'s ruling in municipal court', 'Shut down the chemical processing plant indefinitely', 'Request an exemption from local flood zoning regulations'],
          'a': 'A',
          'exp': 'Teresa sẽ thuê công ty kỹ thuật xây dựng để nâng cao bờ bao chống lũ trước hạn 60 ngày ("contact Apex Civil Engineering right away to submit blueprints for elevating the containment berms") → Chọn (A).'
        }
      ]
    },
    // Conv 11: Q62-64
    {
      'start': 62,
      'audio': 'p3_q62-64.m4a',
      'script': 'Questions 62 through 64 refer to the following conversation. '
          'W: Gregory, our human resources analytics reveal that attrition among senior software developers has increased by eighteen percent over the past two quarters. '
          'M: Competitors in the Silicon Valley area are offering aggressive equity packages and flexible remote working stipends that our current compensation structure cannot match. '
          'W: If we lose our lead AI architects, the development schedule for our next-generation autonomous drone platform will slip by at least six months. '
          'M: I will present a revised retention compensation model to the executive compensation committee on Friday, proposing performance-based restricted stock grants and a quarterly home-office technology allowance.',
      'trans': 'W: Gregory, our human resources analytics reveal that attrition among senior software developers has increased by eighteen percent over the past two quarters.\n'
          'M: Competitors in the Silicon Valley area are offering aggressive equity packages and flexible remote working stipends that our current compensation structure cannot match.\n'
          'W: If we lose our lead AI architects, the development schedule for our next-generation autonomous drone platform will slip by at least six months.\n'
          'M: I will present a revised retention compensation model to the executive compensation committee on Friday, proposing performance-based restricted stock grants and a quarterly home-office technology allowance.',
      'qs': [
        {
          'num': 62,
          'c': 'What workplace trend are the speakers addressing?',
          'opts': ['Rising employee turnover among senior software developers', 'Declining productivity in remote engineering teams', 'A lack of qualified applicants for entry-level internships', 'Increasing healthcare insurance costs across departments'],
          'a': 'A',
          'exp': 'Vấn đề được bàn thảo là tỷ lệ thôi việc của lập trình viên cấp cao tăng 18% ("attrition among senior software developers has increased by eighteen percent") → Chọn (A).'
        },
        {
          'num': 63,
          'c': 'What potential consequence does the woman highlight?',
          'opts': ['A six-month delay in the autonomous drone project timeline', 'The loss of multi-million dollar defense contract bids', 'A mandatory reduction in overall company staffing', 'Cancellation of the annual shareholder dividend payment'],
          'a': 'A',
          'exp': 'Hậu quả nếu mất kỹ sư AI trưởng là dự án drone tự hành sẽ bị trễ 6 tháng ("autonomous drone platform will slip by at least six months") → Chọn (A).'
        },
        {
          'num': 64,
          'c': 'What does Gregory plan to propose to the compensation committee?',
          'opts': ['Performance-based stock grants and home-office allowances', 'An immediate fifteen percent across-the-board salary raise', 'A mandatory four-day in-office working policy', 'Free corporate gym memberships and catered lunches'],
          'a': 'A',
          'exp': 'Gregory đề xuất cấp cổ phiếu hạn chế dựa trên hiệu suất và phụ cấp công nghệ làm việc tại nhà ("performance-based restricted stock grants and a quarterly home-office technology allowance") → Chọn (A).'
        }
      ]
    },
    // Conv 12: Q65-67
    {
      'start': 65,
      'audio': 'p3_q65-67.m4a',
      'script': 'Questions 65 through 67 refer to the following conversation. '
          'M: Angela, we need to finalize our carrier partner for exporting perishable organic seafood to premium supermarket chains across East Asia. '
          'W: We narrowed the proposals down to TransPacific ColdChain and Pacific Marine Cargo. While Pacific Marine is eight percent cheaper, TransPacific utilizes smart container monitoring that logs temperature fluctuations via satellite every five minutes. '
          'M: Given that a single compromised refrigeration failure can ruin three hundred thousand dollars worth of sashimi-grade salmon, real-time satellite telemetry is indispensable. '
          'W: I agree wholeheartedly. I will notify TransPacific\'s commercial director that we are accepting their proposal and request their standard service-level agreement.',
      'trans': 'M: Angela, we need to finalize our carrier partner for exporting perishable organic seafood to premium supermarket chains across East Asia.\n'
          'W: We narrowed the proposals down to TransPacific ColdChain and Pacific Marine Cargo. While Pacific Marine is eight percent cheaper, TransPacific utilizes smart container monitoring that logs temperature fluctuations via satellite every five minutes.\n'
          'M: Given that a single compromised refrigeration failure can ruin three hundred thousand dollars worth of sashimi-grade salmon, real-time satellite telemetry is indispensable.\n'
          'W: I agree wholeheartedly. I will notify TransPacific\'s commercial director that we are accepting their proposal and request their standard service-level agreement.',
      'qs': [
        {
          'num': 65,
          'c': 'What type of cargo are the speakers preparing to export?',
          'opts': ['Perishable organic seafood', 'Frozen agricultural beef products', 'Precision medical pharmaceuticals', 'Vintage bottled European wines'],
          'a': 'A',
          'exp': 'Hàng hóa xuất khẩu là hải sản hữu cơ tươi sống dễ hỏng ("perishable organic seafood") → Chọn (A).'
        },
        {
          'num': 66,
          'c': 'What advantage does TransPacific ColdChain offer over its competitor?',
          'opts': ['Satellite-based real-time container temperature tracking', 'Significantly lower freight rates per shipping container', 'Direct maritime access to inland river distribution ports', 'A fleet of zero-emission electric cargo vessels'],
          'a': 'A',
          'exp': 'Lợi thế của TransPacific là hệ thống giám sát nhiệt độ container thông minh qua vệ tinh 5 phút/lần ("logs temperature fluctuations via satellite every five minutes") → Chọn (A).'
        },
        {
          'num': 67,
          'c': 'What will Angela do next?',
          'opts': ['Inform TransPacific that their proposal has been accepted', 'Request a revised price discount from Pacific Marine Cargo', 'Schedule an on-site inspection of the seaport cold storage depot', 'Purchase independent maritime cargo insurance policies'],
          'a': 'A',
          'exp': 'Angela sẽ thông báo cho giám đốc thương mại của TransPacific rằng công ty chấp nhận hợp tác ("notify TransPacific\'s commercial director that we are accepting their proposal") → Chọn (A).'
        }
      ]
    },
    // Conv 13: Q68-70
    {
      'start': 68,
      'audio': 'p3_q68-70.m4a',
      'script': 'Questions 68 through 70 refer to the following conversation. '
          'W: David, our security operations center detected unauthorized data extraction from our legacy customer loyalty database at two o\'clock this morning. '
          'M: Have our security engineers isolated the compromised server cluster, Clara? '
          'W: Yes, the servers were disconnected from the internet within twelve minutes, but preliminary logs show that approximately forty-five thousand email addresses and encrypted password hashes were exfiltrated. '
          'M: Under data privacy compliance regulations, we are legally mandated to notify affected consumers and relevant regulatory commissioners within seventy-two hours. Let\'s convene our crisis communications team and draft the disclosure notice immediately.',
      'trans': 'W: David, our security operations center detected unauthorized data extraction from our legacy customer loyalty database at two o\'clock this morning.\n'
          'M: Have our security engineers isolated the compromised server cluster, Clara? \n'
          'W: Yes, the servers were disconnected from the internet within twelve minutes, but preliminary logs show that approximately forty-five thousand email addresses and encrypted password hashes were exfiltrated.\n'
          'M: Under data privacy compliance regulations, we are legally mandated to notify affected consumers and relevant regulatory commissioners within seventy-two hours. Let\'s convene our crisis communications team and draft the disclosure notice immediately.',
      'qs': [
        {
          'num': 68,
          'c': 'What security incident occurred early this morning?',
          'opts': ['Unauthorized data extraction from a customer loyalty database', 'A physical break-in at the corporate data center', 'A denial-of-service attack crashing online payment gateways', 'Accidental deletion of annual accounting balance records'],
          'a': 'A',
          'exp': 'Sự cố an ninh mạng: trích xuất dữ liệu trái phép từ cơ sở dữ liệu khách hàng thân thiết ("unauthorized data extraction from our legacy customer loyalty database") → Chọn (A).'
        },
        {
          'num': 69,
          'c': 'How quickly was the affected server cluster disconnected from the network?',
          'opts': ['Within twelve minutes', 'Within seventy-two hours', 'In two hours', 'After thirty minutes'],
          'a': 'A',
          'exp': 'Máy chủ bị cô lập trong vòng 12 phút ("disconnected from the internet within twelve minutes") → Chọn (A).'
        },
        {
          'num': 70,
          'c': 'What legal requirement must the company fulfill within seventy-two hours?',
          'opts': ['Notify affected consumers and regulatory commissioners', 'Pay restitution compensation to bank card issuers', 'Appear before a federal legislative oversight hearing', 'Replace all corporate network routers and firewalls'],
          'a': 'A',
          'exp': 'Nghĩa vụ pháp lý theo luật bảo mật dữ liệu: phải thông báo cho người dùng bị ảnh hưởng và cơ quan quản lý trong 72 giờ ("notify affected consumers and relevant regulatory commissioners within seventy-two hours") → Chọn (A).'
        }
      ]
    },
  ];

  return convs.map<Map<String, dynamic>>((c) {
    return <String, dynamic>{
      'part': 3,
      'audio': c['audio'] as String,
      'transcript': c['trans'] as String,
      '_speech': c['script'] as String,
      'questions': (c['qs'] as List).map<Map<String, dynamic>>((q) {
        final qm = q as Map<String, dynamic>;
        return <String, dynamic>{
          'number': qm['num'],
          'content': qm['c'],
          'options': qm['opts'],
          'answer': qm['a'],
          'explanation': qm['exp'],
          'tags': ['listening', 'conversation']
        };
      }).toList()
    };
  }).toList();
}

List<Map<String, dynamic>> buildPart4() {
  final talks = [
    // Talk 1: Q71-73
    {
      'start': 71,
      'audio': 'p4_q71-73.m4a',
      'script': 'Questions 71 through 73 refer to the following airport announcement. '
          'Attention all passengers booked on TransAir Flight 840 with non-stop service to London Heathrow. Due to heavy crosswinds and freezing rain along our flight path, ground operations have temporarily delayed departure. Furthermore, due to gate congestion in Terminal B, our departure gate has been relocated from Gate B14 to Gate C22 in the international concourse. Passengers requiring wheelchair assistance or traveling with small children are invited to begin boarding at Gate C22 at 4:15 P.M. Standard boarding will commence fifteen minutes thereafter. Please have your passport and boarding pass ready for biometric scanning at the gate.',
      'trans': 'Attention all passengers booked on TransAir Flight 840 with non-stop service to London Heathrow. Due to heavy crosswinds and freezing rain along our flight path, ground operations have temporarily delayed departure. Furthermore, due to gate congestion in Terminal B, our departure gate has been relocated from Gate B14 to Gate C22 in the international concourse. Passengers requiring wheelchair assistance or traveling with small children are invited to begin boarding at Gate C22 at 4:15 P.M. Standard boarding will commence fifteen minutes thereafter. Please have your passport and boarding pass ready for biometric scanning at the gate.',
      'qs': [
        {
          'num': 71,
          'c': 'Why has TransAir Flight 840 experienced a delay?',
          'opts': ['Adverse weather conditions along the flight corridor', 'Mechanical maintenance on the aircraft\'s left engine', 'A nationwide shortage of certified flight attendants', 'Delayed arrival of catering delivery trucks'],
          'a': 'A',
          'exp': 'Chuyến bay bị chậm trễ do thời tiết xấu (gió giật mạnh và mưa tuyết đóng băng) dọc đường bay ("heavy crosswinds and freezing rain along our flight path") → Chọn (A).'
        },
        {
          'num': 72,
          'c': 'Where should passengers now proceed for departure?',
          'opts': ['Gate C22 in the international concourse', 'Gate B14 in Terminal B', 'The central baggage claim customer counter', 'The airport medical clinic lounge'],
          'a': 'A',
          'exp': 'Cổng lên máy bay được chuyển sang Cổng C22 khu quốc tế ("relocated from Gate B14 to Gate C22") → Chọn (A).'
        },
        {
          'num': 73,
          'c': 'What must travelers present at the boarding gate?',
          'opts': ['A passport and boarding pass for biometric scanning', 'A printed vaccination certification document', 'A luggage weight receipt from baggage check', 'A stamped customs declaration form'],
          'a': 'A',
          'exp': 'Hành khách cần chuẩn bị hộ chiếu và thẻ lên máy bay để quét sinh trắc học ("passport and boarding pass ready for biometric scanning") → Chọn (A).'
        }
      ]
    },
    // Talk 2: Q74-76
    {
      'start': 74,
      'audio': 'p4_q74-76.m4a',
      'script': 'Questions 74 through 76 refer to the following address to shareholders. '
          'Good morning, esteemed shareholders and members of the board. I am delighted to welcome you to the thirty-fourth annual general assembly of Apex Healthcare Solutions. Over the past twelve months, our strategic pivot toward AI-assisted clinical diagnostic tools has generated record annual revenue of four point six billion dollars, representing a nineteen percent increase year over year. More importantly, I am proud to announce that earlier this morning, our board approved the definitive acquisition of BioGenix Diagnostics for eight hundred and fifty million dollars in cash and equity. This landmark acquisition doubles our proprietary patents in oncology biomarker detection and solidifies our leadership in precision oncology across North America and Europe.',
      'trans': 'Good morning, esteemed shareholders and members of the board. I am delighted to welcome you to the thirty-fourth annual general assembly of Apex Healthcare Solutions. Over the past twelve months, our strategic pivot toward AI-assisted clinical diagnostic tools has generated record annual revenue of four point six billion dollars, representing a nineteen percent increase year over year. More importantly, I am proud to announce that earlier this morning, our board approved the definitive acquisition of BioGenix Diagnostics for eight hundred and fifty million dollars in cash and equity. This landmark acquisition doubles our proprietary patents in oncology biomarker detection and solidifies our leadership in precision oncology across North America and Europe.',
      'qs': [
        {
          'num': 74,
          'c': 'Who is most likely addressing the audience?',
          'opts': ['The chief executive officer of Apex Healthcare Solutions', 'A municipal public health commissioner', 'A financial journalist reporting on stock movements', 'An investment bank merger and acquisition advisor'],
          'a': 'A',
          'exp': 'Người phát biểu là CEO chào mừng đại hội đồng cổ đông của tập đoàn y tế ("welcome you to the thirty-fourth annual general assembly of Apex Healthcare Solutions") → Chọn (A).'
        },
        {
          'num': 75,
          'c': 'By what percentage did company revenue increase over the past year?',
          'opts': ['Nineteen percent', 'Thirty-four percent', 'Twelve percent', 'Fifty percent'],
          'a': 'A',
          'exp': 'Doanh thu tăng 19% so với cùng kỳ năm ngoái ("representing a nineteen percent increase year over year") → Chọn (A).'
        },
        {
          'num': 76,
          'c': 'What major corporate announcement was revealed this morning?',
          'opts': ['The acquisition of BioGenix Diagnostics for \$850 million', 'The divestment of European manufacturing assets', 'The resignation of the chief financial officer', 'A secondary public offering of preferred shares'],
          'a': 'A',
          'exp': 'Thông báo sáp nhập mua lại công ty BioGenix Diagnostics giá 850 triệu đô ("approved the definitive acquisition of BioGenix Diagnostics for eight hundred and fifty million dollars") → Chọn (A).'
        }
      ]
    },
    // Talk 3: Q77-79
    {
      'start': 77,
      'audio': 'p4_q77-79.m4a',
      'script': 'Questions 77 through 79 refer to the following safety briefing. '
          'Attention all chemical processing technicians on Shift B. Before commencing maintenance on Reactor Vessel Four, please review our updated protocols for handling high-pressure catalyst transfers. Following last month\'s valve calibration audit, all technicians entering the catalytic containment vault must wear positive-pressure respiratory helmets and chemical-resistant vulcanized boots. Under no circumstances should manual pressure relief valves be actuated without verbal authorization from the shift engineering supervisor. In the event of an automated nitrogen purge alarm, all personnel must evacuate immediately through Emergency Exit South and assemble at Muster Point D. Safety checklists must be signed and submitted before five o\'clock.',
      'trans': 'Attention all chemical processing technicians on Shift B. Before commencing maintenance on Reactor Vessel Four, please review our updated protocols for handling high-pressure catalyst transfers. Following last month\'s valve calibration audit, all technicians entering the catalytic containment vault must wear positive-pressure respiratory helmets and chemical-resistant vulcanized boots. Under no circumstances should manual pressure relief valves be actuated without verbal authorization from the shift engineering supervisor. In the event of an automated nitrogen purge alarm, all personnel must evacuate immediately through Emergency Exit South and assemble at Muster Point D. Safety checklists must be signed and submitted before five o\'clock.',
      'qs': [
        {
          'num': 77,
          'c': 'Who is the intended audience for this briefing?',
          'opts': ['Chemical processing plant maintenance technicians', 'Administrative office assistants', 'Visiting environmental university students', 'Truck drivers delivering commercial fuels'],
          'a': 'A',
          'exp': 'Đối tượng lắng nghe là kỹ thuật viên bảo trì nhà máy hóa chất ca B ("chemical processing technicians on Shift B") → Chọn (A).'
        },
        {
          'num': 78,
          'c': 'What action is strictly forbidden without supervisor approval?',
          'opts': ['Actuating manual pressure relief valves', 'Wearing positive-pressure respiratory helmets', 'Exiting through Emergency Exit South', 'Reviewing updated safety checklists'],
          'a': 'A',
          'exp': 'Hành động bị nghiêm cấm khi chưa có lệnh: kích hoạt van xả áp suất thủ công ("Under no circumstances should manual pressure relief valves be actuated without verbal authorization") → Chọn (A).'
        },
        {
          'num': 79,
          'c': 'Where should workers assemble in the event of an automated alarm?',
          'opts': ['At Muster Point D', 'Inside the catalytic containment vault', 'In the administrative cafeteria', 'Outside the security guard booth'],
          'a': 'A',
          'exp': 'Khi có chuông báo động, công nhân phải tập hợp tại Điểm tập kết D ("assemble at Muster Point D") → Chọn (A).'
        }
      ]
    },
    // Talk 4: Q80-82 (Inference quote)
    {
      'start': 80,
      'audio': 'p4_q80-82.m4a',
      'script': 'Questions 80 through 82 refer to the following voicemail message. '
          'Hello, Mr. Sterling. This is Brenda Walsh from Walsh and Sterling Intellectual Property Counsel. I am calling to update you on our trademark infringement claim against Zenith Apparel. Yesterday, we served their legal department with a formal cease-and-desist notice regarding their unauthorized use of our client\'s geometric star logo on their autumn outerwear collection. We gave them forty-eight hours to remove the infringing merchandise from retail distribution channels and withdraw their pending patent application. The ball is in their court. If they refuse to comply by Thursday afternoon, we are prepared to file for an immediate preliminary federal injunction. Please call me back when you have reviewed the attached litigation filing.',
      'trans': 'Hello, Mr. Sterling. This is Brenda Walsh from Walsh and Sterling Intellectual Property Counsel. I am calling to update you on our trademark infringement claim against Zenith Apparel. Yesterday, we served their legal department with a formal cease-and-desist notice regarding their unauthorized use of our client\'s geometric star logo on their autumn outerwear collection. We gave them forty-eight hours to remove the infringing merchandise from retail distribution channels and withdraw their pending patent application. The ball is in their court. If they refuse to comply by Thursday afternoon, we are prepared to file for an immediate preliminary federal injunction. Please call me back when you have reviewed the attached litigation filing.',
      'qs': [
        {
          'num': 80,
          'c': 'What legal issue is Brenda Walsh handling?',
          'opts': ['A trademark infringement dispute regarding a corporate logo', 'A breach of contract claim by a commercial landlord', 'An employee discrimination lawsuit', 'A late tax filing penalty appeal'],
          'a': 'A',
          'exp': 'Luật sư xử lý tranh chấp xâm phạm thương hiệu logo ("trademark infringement claim ... unauthorized use of our client\'s geometric star logo") → Chọn (A).'
        },
        {
          'num': 81,
          'c': 'What does the speaker mean when she says: "The ball is in their court"?',
          'opts': ['The competitor must now decide how to respond', 'The athletic footwear lawsuit has concluded', 'The legal dispute will be settled in arbitration court', 'The client is responsible for funding the trial'],
          'a': 'A',
          'exp': 'Thành ngữ kinh điển: "The ball is in their court" (Quả bóng đang ở phần sân của họ) có nghĩa là công ty đối thủ Zenith Apparel bây giờ phải đưa ra quyết định phản hồi ("The competitor must now decide how to respond") → Chọn (A).'
        },
        {
          'num': 82,
          'c': 'What will the law firm do if the competitor fails to comply by Thursday?',
          'opts': ['Seek a preliminary federal court injunction', 'Accept a financial settlement out of court', 'Withdraw the trademark application', 'Dismiss the commercial lawsuit entirely'],
          'a': 'A',
          'exp': 'Nếu đối thủ không tuân thủ trước thứ Năm, văn phòng luật sẽ nộp đơn xin lệnh cấm khẩn cấp của tòa án liên bang ("file for an immediate preliminary federal injunction") → Chọn (A).'
        }
      ]
    },
    // Talk 5: Q83-85
    {
      'start': 83,
      'audio': 'p4_q83-85.m4a',
      'script': 'Questions 83 through 85 refer to the following financial market broadcast. '
          'Welcome to Midday Market Pulse on National Business Radio. In early morning trading, global equity markets experienced pronounced volatility following the Federal Reserve\'s surprise decision to increase the benchmark overnight lending rate by fifty basis points to curb persistent inflationary pressures. The tech-heavy composite index dropped two point four percent within the first hour of trading, driven by steep sell-offs in semiconductor and cloud computing equities. Conversely, institutional yields on sovereign ten-year bonds surged to their highest levels in over a decade. Analysts from Goldman Sachs predict that while corporate borrowing costs will rise considerably, financial institutions with substantial cash reserves stand to benefit from wider lending interest margins. Stay tuned for our sector breakdown following this commercial break.',
      'trans': 'Welcome to Midday Market Pulse on National Business Radio. In early morning trading, global equity markets experienced pronounced volatility following the Federal Reserve\'s surprise decision to increase the benchmark overnight lending rate by fifty basis points to curb persistent inflationary pressures. The tech-heavy composite index dropped two point four percent within the first hour of trading, driven by steep sell-offs in semiconductor and cloud computing equities. Conversely, institutional yields on sovereign ten-year bonds surged to their highest levels in over a decade. Analysts from Goldman Sachs predict that while corporate borrowing costs will rise considerably, financial institutions with substantial cash reserves stand to benefit from wider lending interest margins. Stay tuned for our sector breakdown following this commercial break.',
      'qs': [
        {
          'num': 83,
          'c': 'What government action triggered market volatility this morning?',
          'opts': ['A fifty basis point increase in the benchmark interest rate', 'The imposition of import tariffs on foreign microchips', 'An emergency bailout for commercial mortgage lenders', 'A cut in federal corporate income tax rates'],
          'a': 'A',
          'exp': 'Biến động thị trường do quyết định bất ngờ của Fed tăng 50 điểm cơ bản lãi suất cho vay ("Federal Reserve\'s surprise decision to increase the benchmark overnight lending rate by fifty basis points") → Chọn (A).'
        },
        {
          'num': 84,
          'c': 'Which industry sector experienced steep stock price declines?',
          'opts': ['Semiconductor and cloud computing companies', 'Commercial retail grocery chains', 'Sovereign bond underwriting firms', 'Precious metal mining companies'],
          'a': 'A',
          'exp': 'Ngành công nghệ bán dẫn và điện toán đám mây bị bán tháo mạnh ("steep sell-offs in semiconductor and cloud computing equities") → Chọn (A).'
        },
        {
          'num': 85,
          'c': 'What entity is projected to benefit from the policy change?',
          'opts': ['Financial institutions with significant cash reserves', 'Small startup businesses seeking bank loans', 'Real estate residential mortgage brokers', 'Commercial airlines purchasing aviation fuel'],
          'a': 'A',
          'exp': 'Các tổ chức tài chính dồi dào tiền mặt sẽ hưởng lợi từ biên lãi suất cho vay rộng hơn ("financial institutions with substantial cash reserves stand to benefit") → Chọn (A).'
        }
      ]
    },
    // Talk 6: Q86-88
    {
      'start': 86,
      'audio': 'p4_q86-88.m4a',
      'script': 'Questions 86 through 87 refer to the following plant announcement. '
          'Attention all assembly line personnel at the Fremont Electric Vehicle Manufacturing Complex. As part of our capital modernization initiative to integrate next-generation solid-state battery packs into our Model V sedans, Line Two will be suspended starting Friday at 6:00 P.M. through Monday morning. During this 48-hour downtime, certified industrial robotics technicians from Kuka Engineering will install twenty-four precision robotic welding arms and calibrate optical seam alignment sensors. Line Two technicians scheduled for weekend shifts will be reassigned to sub-assembly module preparation in Building D with standard overtime pay rates applying. Normal vehicle assembly operations will resume promptly at 6:00 A.M. on Tuesday.',
      'trans': 'Attention all assembly line personnel at the Fremont Electric Vehicle Manufacturing Complex. As part of our capital modernization initiative to integrate next-generation solid-state battery packs into our Model V sedans, Line Two will be suspended starting Friday at 6:00 P.M. through Monday morning. During this 48-hour downtime, certified industrial robotics technicians from Kuka Engineering will install twenty-four precision robotic welding arms and calibrate optical seam alignment sensors. Line Two technicians scheduled for weekend shifts will be reassigned to sub-assembly module preparation in Building D with standard overtime pay rates applying. Normal vehicle assembly operations will resume promptly at 6:00 A.M. on Tuesday.',
      'qs': [
        {
          'num': 86,
          'c': 'Why is assembly Line Two being temporarily suspended?',
          'opts': ['To install robotic welding arms and battery integration equipment', 'Due to a severe shortage of automotive microcontrollers', 'Following an unannounced occupational safety inspection', 'To repair a damaged electrical power generator'],
          'a': 'A',
          'exp': 'Dây chuyền 2 tạm ngưng để lắp đặt cánh tay robot hàn và thiết bị tích hợp pin thể rắn ("install twenty-four precision robotic welding arms and calibrate optical seam alignment sensors") → Chọn (A).'
        },
        {
          'num': 87,
          'c': 'What will happen to Line Two technicians scheduled for the weekend?',
          'opts': ['They will be reassigned to Building D with overtime pay', 'They will receive unpaid mandatory furloughs', 'They will attend mandatory virtual software seminars', 'They will test-drive completed vehicles at the track'],
          'a': 'A',
          'exp': 'Công nhân ca cuối tuần được điều động sang Tòa nhà D làm modul phụ trợ và nhận lương ngoài giờ ("reassigned to sub-assembly module preparation in Building D with standard overtime pay rates") → Chọn (A).'
        },
        {
          'num': 88,
          'c': 'When will regular production resume on Line Two?',
          'opts': ['At 6:00 A.M. on Tuesday', 'At 6:00 P.M. on Friday', 'On Sunday afternoon', 'Next month'],
          'a': 'A',
          'exp': 'Dây chuyền hoạt động trở lại vào 6:00 sáng Thứ Ba ("resume promptly at 6:00 A.M. on Tuesday") → Chọn (A).'
        }
      ]
    },
    // Talk 7: Q89-91
    {
      'start': 89,
      'audio': 'p4_q89-91.m4a',
      'script': 'Questions 89 through 91 refer to the following cybersecurity training seminar. '
          'Good afternoon, colleagues. I am Dr. Marcus Vance, Chief Information Security Officer at Vanguard Global Technologies. Today\'s mandatory training module focuses on defending our organization against sophisticated spear-phishing campaigns. Recent threat intelligence reveals that criminal syndicates are utilizing generative artificial intelligence to produce highly convincing fraudulent emails that mimic the communication style of corporate executive directors. These emails typically urge recipient employees to wire emergency funds or click on malicious links under the guise of confidential acquisitions. Remember our cardinal rule: IT will never request password verification via email, and any financial wire transfer exceeding ten thousand dollars requires two-factor verbal authorization. Please complete the simulated phishing quiz on your terminals before logging off.',
      'trans': 'Good afternoon, colleagues. I am Dr. Marcus Vance, Chief Information Security Officer at Vanguard Global Technologies. Today\'s mandatory training module focuses on defending our organization against sophisticated spear-phishing campaigns. Recent threat intelligence reveals that criminal syndicates are utilizing generative artificial intelligence to produce highly convincing fraudulent emails that mimic the communication style of corporate executive directors. These emails typically urge recipient employees to wire emergency funds or click on malicious links under the guise of confidential acquisitions. Remember our cardinal rule: IT will never request password verification via email, and any financial wire transfer exceeding ten thousand dollars requires two-factor verbal authorization. Please complete the simulated phishing quiz on your terminals before logging off.',
      'qs': [
        {
          'num': 89,
          'c': 'What primary threat does Dr. Vance discuss in the training seminar?',
          'opts': ['AI-generated spear-phishing fraudulent emails', 'Physical theft of corporate laptops from offices', 'Ransomware infecting backup storage hard drives', 'Distributed denial-of-service server crashes'],
          'a': 'A',
          'exp': 'Mối đe dọa an ninh mạng chính: email lừa đảo mạo danh giám đốc do AI tạo ra ("utilizing generative artificial intelligence to produce highly convincing fraudulent emails") → Chọn (A).'
        },
        {
          'num': 90,
          'c': 'What protocol is required for financial wire transfers exceeding \$10,000?',
          'opts': ['Two-factor verbal authorization', 'Approval by the municipal banking commissioner', 'A written notary certificate delivered in person', 'Submitting original receipts via postal mail'],
          'a': 'A',
          'exp': 'Quy tắc vàng: lệnh chuyển tiền trên \$10,000 yêu cầu xác thực bằng lời nói 2 lớp ("any financial wire transfer exceeding ten thousand dollars requires two-factor verbal authorization") → Chọn (A).'
        },
        {
          'num': 91,
          'c': 'What must attendees complete before logging off today?',
          'opts': ['A simulated phishing interactive quiz', 'A survey evaluating Dr. Vance\'s presentation style', 'A software update for their company smartphones', 'An encrypted password reset procedure'],
          'a': 'A',
          'exp': 'Học viên phải hoàn thành bài trắc nghiệm giả lập câu cá lừa đảo ("complete the simulated phishing quiz on your terminals before logging off") → Chọn (A).'
        }
      ]
    },
    // Talk 8: Q92-94
    {
      'start': 92,
      'audio': 'p4_q92-94.m4a',
      'script': 'Questions 92 through 94 refer to the following museum tour introduction. '
          'Welcome, architectural society patrons, to the Modern Pavilion of the Metropol Museum of Design. My name is Elena, and I will be guiding you through our special exhibition entitled Sustainable Horizons: Architectural Innovation in the Urban Age. This gallery showcases full-scale architectural models and blueprints from world-renowned firms that are pioneering zero-carbon skyscraper design. Over the next hour, we will examine how geothermal foundation pilings, cross-laminated timber, and kinetic solar shading facades can reduce commercial building energy consumption by up to sixty-five percent. Please note that while personal photography is permitted, flash photography and tripods are strictly prohibited to protect the delicate light-sensitive blueprint inks. Let\'s begin in Gallery Three with the scale model of the Copenhagen Bio-Tower.',
      'trans': 'Welcome, architectural society patrons, to the Modern Pavilion of the Metropol Museum of Design. My name is Elena, and I will be guiding you through our special exhibition entitled Sustainable Horizons: Architectural Innovation in the Urban Age. This gallery showcases full-scale architectural models and blueprints from world-renowned firms that are pioneering zero-carbon skyscraper design. Over the next hour, we will examine how geothermal foundation pilings, cross-laminated timber, and kinetic solar shading facades can reduce commercial building energy consumption by up to sixty-five percent. Please note that while personal photography is permitted, flash photography and tripods are strictly prohibited to protect the delicate light-sensitive blueprint inks. Let\'s begin in Gallery Three with the scale model of the Copenhagen Bio-Tower.',
      'qs': [
        {
          'num': 92,
          'c': 'What is the theme of the museum\'s special exhibition?',
          'opts': ['Sustainable and zero-carbon architectural design', 'Ancient Greek and Roman structural engineering', 'Industrial interior furniture from the nineteenth century', 'Digital photography techniques in urban landscapes'],
          'a': 'A',
          'exp': 'Chủ đề triển lãm là kiến trúc bền vững không phát thải carbon ("Sustainable Horizons ... pioneering zero-carbon skyscraper design") → Chọn (A).'
        },
        {
          'num': 93,
          'c': 'By how much can the featured architectural innovations reduce building energy usage?',
          'opts': ['Up to sixty-five percent', 'Up to thirty percent', 'By ninety percent', 'Exactly forty percent'],
          'a': 'A',
          'exp': 'Các cải tiến có thể giảm tới 65% năng lượng tiêu thụ ("reduce commercial building energy consumption by up to sixty-five percent") → Chọn (A).'
        },
        {
          'num': 94,
          'c': 'What equipment is strictly prohibited inside the gallery?',
          'opts': ['Flash photography and camera tripods', 'Mobile smartphones and handheld audio recorders', 'Bottled water and plastic umbrellas', 'High-heeled shoes and bulky backpacks'],
          'a': 'A',
          'exp': 'Quy định cấm chụp ảnh có đèn flash và chân máy ảnh tripod ("flash photography and tripods are strictly prohibited") → Chọn (A).'
        }
      ]
    },
    // Talk 9: Q95-97 (Inference quote)
    {
      'start': 95,
      'audio': 'p4_q95-97.m4a',
      'script': 'Questions 95 through 97 refer to the following voicemail message. '
          'Good afternoon, Mr. Kensington. This is Melissa from corporate hospitality at the Grand Hyatt Tokyo. I am calling regarding your executive reservation for the Global Biotechnology Summit commencing on Wednesday. When our housekeeping staff inspected your assigned Presidential Suite on the thirty-second floor this morning, they discovered a burst water pipe in the adjoining HVAC service duct, causing minor ceiling water damage. Don\'t unpack just yet. We have automatically upgraded your party to our two-story Imperial Penthouse Suite on the thirty-fifth floor at no additional charge. In addition, our executive private limousine will meet you at Narita Airport baggage claim upon your flight arrival tomorrow evening. Please contact our VIP guest relations desk if you require private conference room bookings during your stay.',
      'trans': 'Good afternoon, Mr. Kensington. This is Melissa from corporate hospitality at the Grand Hyatt Tokyo. I am calling regarding your executive reservation for the Global Biotechnology Summit commencing on Wednesday. When our housekeeping staff inspected your assigned Presidential Suite on the thirty-second floor this morning, they discovered a burst water pipe in the adjoining HVAC service duct, causing minor ceiling water damage. Don\'t unpack just yet. We have automatically upgraded your party to our two-story Imperial Penthouse Suite on the thirty-fifth floor at no additional charge. In addition, our executive private limousine will meet you at Narita Airport baggage claim upon your flight arrival tomorrow evening. Please contact our VIP guest relations desk if you require private conference room bookings during your stay.',
      'qs': [
        {
          'num': 95,
          'c': 'What problem occurred in Mr. Kensington\'s originally booked hotel suite?',
          'opts': ['A burst water pipe caused ceiling water damage', 'The electronic door lock malfunctioned repeatedly', 'The central air conditioning was completely offline', 'The suite was erroneously double-booked to another guest'],
          'a': 'A',
          'exp': 'Sự cố: vỡ đường ống nước ở hộp kỹ thuật gây thấm trần nhà ("discovered a burst water pipe ... causing minor ceiling water damage") → Chọn (A).'
        },
        {
          'num': 96,
          'c': 'Why does the caller say: "Don\'t unpack just yet"?',
          'opts': ['To indicate humorously that the guest has been relocated to a far superior suite', 'To warn the traveler that his luggage was lost by the airline', 'To cancel the guest\'s reservation due to hotel flooding', 'To advise him to check into a competing hotel facility'],
          'a': 'A',
          'exp': 'Câu nói ngụ ý: "Don\'t unpack just yet" (Đừng vội dỡ hành lý) nhằm tạo bất ngờ thú vị thông báo khách được nâng cấp miễn phí lên căn hộ Penthouse 2 tầng cao cấp hơn nhiều ("indicate that the guest has been relocated to a far superior suite") → Chọn (A).'
        },
        {
          'num': 97,
          'c': 'What complimentary transportation service is provided to Mr. Kensington?',
          'opts': ['Private executive limousine pickup at Narita Airport', 'High-speed bullet train passes for Tokyo transit', 'Complimentary helicopter transfer to the convention center', 'A pre-paid rental sports car at the hotel lobby'],
          'a': 'A',
          'exp': 'Dịch vụ miễn phí: xe limousine đón riêng tại sân bay Narita ("private limousine will meet you at Narita Airport baggage claim") → Chọn (A).'
        }
      ]
    },
    // Talk 10: Q98-100
    {
      'start': 98,
      'audio': 'p4_q98-100.m4a',
      'script': 'Questions 98 through 100 refer to the following human resources announcement. '
          'Attention all salaried staff members of Pinnacle Financial Group. As part of our annual corporate benefits restructuring, our open enrollment window for healthcare, dental, and retirement plans will commence this coming Monday, November 14, and conclude promptly at midnight on December 2. This year, we are proud to introduce a high-deductible healthcare plan paired with a triple-tax-advantaged Health Savings Account, featuring an employer dollar-for-dollar seed contribution of up to twelve hundred dollars annually. Furthermore, our 401(k) retirement matching contribution has been increased from four percent to six percent of gross salary for employees with more than three years of tenure. Information webinars detailing these plan changes will take place daily via Zoom. Failure to submit selections by the December 2 deadline will result in automatic default enrollment into your previous year\'s coverage tier.',
      'trans': 'Attention all salaried staff members of Pinnacle Financial Group. As part of our annual corporate benefits restructuring, our open enrollment window for healthcare, dental, and retirement plans will commence this coming Monday, November 14, and conclude promptly at midnight on December 2. This year, we are proud to introduce a high-deductible healthcare plan paired with a triple-tax-advantaged Health Savings Account, featuring an employer dollar-for-dollar seed contribution of up to twelve hundred dollars annually. Furthermore, our 401(k) retirement matching contribution has been increased from four percent to six percent of gross salary for employees with more than three years of tenure. Information webinars detailing these plan changes will take place daily via Zoom. Failure to submit selections by the December 2 deadline will result in automatic default enrollment into your previous year\'s coverage tier.',
      'qs': [
        {
          'num': 98,
          'c': 'What is the purpose of the announcement?',
          'opts': ['To outline annual open enrollment options for employee benefits', 'To inform employees about upcoming salary reductions', 'To announce the merger of two corporate financial subsidiaries', 'To schedule performance review appraisals for salaried managers'],
          'a': 'A',
          'exp': 'Mục đích: công bố kỳ đăng ký phúc lợi bảo hiểm y tế và quỹ hưu trí hàng năm ("annual corporate benefits restructuring ... open enrollment window") → Chọn (A).'
        },
        {
          'num': 99,
          'c': 'How has the company enhanced its 401(k) retirement matching program?',
          'opts': ['Increased the matching contribution rate to six percent for tenured staff', 'Doubled the annual cash bonus for all junior analysts', 'Offered company shares at a fifty percent discount', 'Eliminated the mandatory retirement age limit'],
          'a': 'A',
          'exp': 'Chính sách quỹ hưu trí 401(k) tăng mức đóng góp đối ứng của công ty từ 4% lên 6% cho nhân viên trên 3 năm thâm niên ("increased from four percent to six percent of gross salary for employees with more than three years of tenure") → Chọn (A).'
        },
        {
          'num': 100,
          'c': 'What happens if an employee fails to submit benefit choices by December 2?',
          'opts': ['Automatic default re-enrollment in their previous coverage plan', 'Immediate suspension of health insurance benefits', 'A standard administrative late penalty fee of \$500', 'Disqualification from receiving year-end financial bonuses'],
          'a': 'A',
          'exp': 'Nếu không nộp trước 2/12, hệ thống sẽ tự động đăng ký lại theo gói bảo hiểm năm trước ("automatic default enrollment into your previous year\'s coverage tier") → Chọn (A).'
        }
      ]
    },
  ];

  return talks.map<Map<String, dynamic>>((t) {
    return <String, dynamic>{
      'part': 4,
      'audio': t['audio'] as String,
      'transcript': t['trans'] as String,
      '_speech': t['script'] as String,
      'questions': (t['qs'] as List).map<Map<String, dynamic>>((q) {
        final qm = q as Map<String, dynamic>;
        return <String, dynamic>{
          'number': qm['num'],
          'content': qm['c'],
          'options': qm['opts'],
          'answer': qm['a'],
          'explanation': qm['exp'],
          'tags': ['listening', 'talks']
        };
      }).toList()
    };
  }).toList();
}
