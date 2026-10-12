// Module Part 7 (Câu 147-200) - ETS Extreme Hard Test 01 (Target 990)
// Bao gồm: 10 bài Đoạn đơn (Q147-175: 29 câu), 2 bài Đoạn đôi (Q176-185: 10 câu), 3 bài Đoạn ba (Q186-200: 15 câu)

List<Map<String, dynamic>> buildPart7() {
  return [
    ..._buildPart7Single(),
    ..._buildPart7Double(),
    ..._buildPart7Triple(),
  ];
}

// =============================================================================
// PHẦN 1: ĐOẠN ĐƠN (SINGLE PASSAGES) - CÂU 147 ĐẾN 175 (29 CÂU)
// =============================================================================

List<Map<String, dynamic>> _buildPart7Single() {
  final passages = [
    // Bài 1: Q147-148 (Shipping Invoice & Demurrage Notice)
    {
      'text': 'PACIFIC MERIDIAN FREIGHT CONGLOMERATE\n'
          'Bill of Lading & Commercial Shipping Manifest #PMF-88492\n'
          'Shipper: Yokohama Advanced Robotics Ltd. | Consignee: Detroit Assembly Works\n'
          'Vessel: MV Pacific Fortune (Voyage 408) | Port of Discharge: Port of Oakland\n\n'
          'Cargo Description:\n'
          '• 16 Forty-Foot High-Cube Containers: Precision Servo Motors and Industrial Gearing (Class 7 Hazardous Electronics)\n'
          '• Declared Cargo Valuation: \$3,450,000 USD\n'
          '• Port Discharge Timestamp: October 8, 04:30 PST\n\n'
          'Demurrage & Detention Terms:\n'
          'Standard free time for container retrieval is four calendar days following customs clearance. Containers remaining on port premises after October 12, 17:00 PST will incur mandatory port demurrage surcharges of \$350 per container per calendar day for the first three days, escalating to \$650 per container per day thereafter. All demurrage balances must be settled in full prior to release by terminal gates.',
      'qs': [
        {
          'num': 147,
          'c': 'What cargo is being transported on the MV Pacific Fortune?',
          'opts': ['Precision servo motors and industrial gearing', 'Organic agricultural produce', 'Automotive consumer battery packs', 'Pre-fabricated steel building beams'],
          'a': 'A',
          'exp': 'Bản kê hàng hóa ghi rõ: "Precision Servo Motors and Industrial Gearing" → Chọn (A).'
        },
        {
          'num': 148,
          'c': 'What penalty applies if containers are not retrieved before October 12?',
          'opts': ['Daily demurrage surcharges of at least \$350 per container', 'Immediate seizure of the electronics by customs agents', 'Permanent cancellation of the company\'s commercial import license', 'A mandatory forty percent tariff penalty on cargo valuation'],
          'a': 'A',
          'exp': 'Điều khoản lưu kho bến bãi: sau ngày 12/10 sẽ chịu phí phạt demurrage tối thiểu \$350/ngày/container cho 3 ngày đầu → Chọn (A).'
        }
      ]
    },
    // Bài 2: Q149-150 (Workplace Policy Amendment Email)
    {
      'text': 'MEMORANDUM\n'
          'To: All Regional Corporate Personnel\n'
          'From: Evelyn Vance, Chief People Officer\n'
          'Date: November 3\n'
          'Subject: Revised Hybrid Attendance Framework for Q1\n\n'
          'Following an extensive operational productivity assessment across our domestic campuses, the executive steering committee has revised our hybrid work policy, effective January 15.\n\n'
          'All full-time salaried employees previously categorized as fully remote must now maintain a minimum in-office presence of three anchor days per week (Tuesdays, Wednesdays, and Thursdays). Mondays and Fridays will remain discretionary remote work days, provided that core team sprint deadlines are consistently achieved. Department directors possess limited discretionary latitude to grant individual medical or caregiver exemptions, which must be formally audited and renewed every six months. We believe this collaborative framework balances organizational synergy with professional flexibility.',
      'qs': [
        {
          'num': 149,
          'c': 'What does the updated attendance framework require of previously remote employees?',
          'opts': ['Working in the office on Tuesdays, Wednesdays, and Thursdays', 'Relocating to the corporate headquarters campus in Chicago', 'Attending weekly virtual town halls on Monday mornings', 'Logging out of enterprise software systems before 5:00 P.M.'],
          'a': 'A',
          'exp': 'Quy định mới bắt buộc nhân viên từ xa trước đây phải có mặt tại văn phòng 3 ngày cố định (Thứ Ba, Thứ Tư, Thứ Năm) → Chọn (A).'
        },
        {
          'num': 150,
          'c': 'How often must individual remote work exemptions be reviewed?',
          'opts': ['Every six months', 'Once every quarter', 'On an annual basis', 'Every two weeks'],
          'a': 'A',
          'exp': 'Các trường hợp miễn trừ y tế/chăm sóc gia đình phải được kiểm toán và gia hạn 6 tháng một lần ("renewed every six months") → Chọn (A).'
        }
      ]
    },
    // Bài 3: Q151-152 (Executive Job Posting: Clinical Pharmacology Director)
    {
      'text': 'EXECUTIVE SEARCH: DIRECTOR OF CLINICAL PHARMACOLOGY\n'
          'Apex BioPharma Laboratories | Location: Cambridge, Massachusetts\n\n'
          'Apex BioPharma Laboratories is searching for an accomplished medical researcher to direct our clinical pharmacokinetics and toxicological discovery unit. The incumbent will oversee Phase One through Phase Three human trial protocols and interface directly with international regulatory agencies (FDA, EMA).\n\n'
          'Prerequisites & Selection Criteria:\n'
          '• M.D. or Ph.D. in Pharmacology, Bio-chemistry, or a cognate molecular biology field.\n'
          '• Minimum eight years of progressive leadership within enterprise biotechnology environments.\n'
          '• A distinguished record of first-author publications in peer-reviewed medical journals (minimum 10 publications in past five years).\n'
          '• Demonstrated success filing Investigational New Drug (IND) applications.\n\n'
          'Compensation spans \$210,000–\$250,000 base salary, complemented by performance-indexed equity grants and comprehensive executive benefits. Inquiries with curriculum vitae should be directed to executivecareers@apexbiopharma.com prior to December 1.',
      'qs': [
        {
          'num': 151,
          'c': 'What is NOT stated as a mandatory prerequisite for the director position?',
          'opts': ['Fluency in three or more European languages', 'An M.D. or Ph.D. in a relevant scientific discipline', 'At least eight years of biotechnology leadership experience', 'A publication track record in peer-reviewed medical journals'],
          'a': 'A',
          'exp': 'Yêu cầu tuyển dụng không hề nhắc tới việc phải thông thạo từ 3 ngôn ngữ châu Âu trở lên → Chọn (A).'
        },
        {
          'num': 152,
          'c': 'What deadline is specified for submitting application materials?',
          'opts': ['Prior to December 1', 'By October 15', 'January 15', 'Within thirty calendar days'],
          'a': 'A',
          'exp': 'Hạn chót nộp hồ sơ được nêu rõ là trước ngày 1 tháng 12 ("prior to December 1") → Chọn (A).'
        }
      ]
    },
    // Bài 4: Q153-155 (Non-Disclosure Agreement: Judicial Compulsion Clause)
    {
      'text': 'CONFIDENTIALITY AND NON-DISCLOSURE AGREEMENT\n'
          'Paragraph 6: Permitted Disclosures and Compelled Judicial Process\n\n'
          'Notwithstanding the strict non-disclosure obligations set forth in Section 3, the Receiving Party may disclose Proprietary Confidential Information solely to the extent that such disclosure is legally compelled by a valid subpoena, court order, or formal decree issued by a governmental regulatory agency possessing competent legal jurisdiction.\n\n'
          'Provided, however, that in the event of such compelled disclosure, the Receiving Party shall: (a) provide immediate written notice to the Disclosing Party no later than three business days prior to disclosure; (b) consult in good faith with the Disclosing Party to seek a protective court order or confidential treatment; and (c) disclose only that portion of Proprietary Information that is strictly required by the judicial mandate. Any proprietary trade secrets disclosed pursuant to this section shall continue to remain confidential for all other commercial purposes.',
      'qs': [
        {
          'num': 153,
          'c': 'Under what condition is the Receiving Party permitted to disclose confidential information?',
          'opts': ['When legally compelled by a court order or government subpoena', 'Upon receiving written permission from competing industry partners', 'After five calendar years have elapsed from contract signing', 'Whenever quarterly financial reports are submitted to investors'],
          'a': 'A',
          'exp': 'Ngoại lệ cho phép tiết lộ: khi bị cơ quan tòa án hoặc cơ quan chính phủ có thẩm quyền bắt buộc bằng trát hầu tòa hoặc lệnh tòa ("legally compelled by a valid subpoena, court order...") → Chọn (A).'
        },
        {
          'num': 154,
          'c': 'What notice requirement must be met before compelled disclosure occurs?',
          'opts': ['Providing written notification at least three business days beforehand', 'Publishing a notice in the municipal legal newspaper', 'Notifying all company shareholders by certified postal courier', 'Securing approval from an independent arbitration panel'],
          'a': 'A',
          'exp': 'Nghĩa vụ thông báo: gửi thông báo bằng văn bản trước ít nhất 3 ngày làm việc ("written notice ... no later than three business days prior to disclosure") → Chọn (A).'
        },
        {
          'num': 155,
          'c': 'What amount of proprietary information may be shared during compelled process?',
          'opts': ['Only the precise portion strictly required by judicial decree', 'The entire corporate engineering database', 'All documentation generated during the previous fiscal year', 'Whatever materials the legal counsel deems publicly interesting'],
          'a': 'A',
          'exp': 'Phần tài liệu được tiết lộ: chỉ đúng phần mà trát lệnh tư pháp yêu cầu ("only that portion of Proprietary Information that is strictly required") → Chọn (A).'
        }
      ]
    },
    // Bài 5: Q156-158 (Annual Utility Report: Offshore Wind Farm Expansion)
    {
      'text': 'NORTH SEA RENEWABLES CONGLOMERATE\n'
          'Annual Sustainable Energy Infrastructure Report\n\n'
          'During the preceding fiscal year, North Sea Renewables achieved commercial grid connection for Phase Two of the Dogger Bank Offshore Wind Array, situated eighty miles off the northeastern Yorkshire coastline. The installation of forty-eight high-capacity 14-megawatt Haliade-X turbines added 672 megawatts of zero-carbon generation capacity to the national electric grid, powering approximately 620,000 homes.\n\n'
          'Despite severe winter gale disruptions that caused twenty-four days of subsea cabling downtime, capital expenditures were contained within two percent of our approved four point two billion pound budget. Our innovative acoustic bubble curtain technology reduced underwater pile-driving acoustic shockwaves by ninety percent, preserving marine mammal habitats in full compliance with North Sea conservation treaties. Phase Three installation of sixty additional deep-water floating turbines will commence in April.',
      'qs': [
        {
          'num': 156,
          'c': 'Where is the Dogger Bank Offshore Wind Array situated?',
          'opts': ['Eighty miles off the northeastern Yorkshire coastline', 'Twelve miles from downtown London', 'In a freshwater highland lake reservoir', 'Along the coastal harbor of Rotterdam'],
          'a': 'A',
          'exp': 'Vị trí trang trại gió ngoài khơi: 80 dặm ngoài khơi bờ biển đông bắc Yorkshire ("eighty miles off the northeastern Yorkshire coastline") → Chọn (A).'
        },
        {
          'num': 157,
          'c': 'What environmental mitigation technology was utilized during construction?',
          'opts': ['Acoustic bubble curtains to dampen underwater noise shockwaves', 'Solar-powered dredging barges to collect coastal sediment', 'Artificial coral reef concrete breakwaters', 'Satellite-guided radar beacons to deter migratory birds'],
          'a': 'A',
          'exp': 'Công nghệ bảo vệ môi trường: rèm bọt khí âm thanh giúp giảm 90% sóng âm khi đóng cọc đáy biển để bảo vệ sinh vật biển ("acoustic bubble curtain technology reduced underwater pile-driving acoustic shockwaves") → Chọn (A).'
        },
        {
          'num': 158,
          'c': 'When will Phase Three installation begin?',
          'opts': ['In April', 'Next winter', 'In twenty-four days', 'After two years'],
          'a': 'A',
          'exp': 'Giai đoạn 3 sẽ bắt đầu vào tháng Tư ("Phase Three installation ... will commence in April") → Chọn (A).'
        }
      ]
    },
    // Bài 6: Q159-161 (VIP Guest Service Feedback & Hotel Resolution Letter)
    {
      'text': 'THE KENSINGTON ROYALE HOTEL & RESIDENCES\n'
          'Office of the General Manager | Date: October 20\n'
          'To: Mr. Arthur Pendelton, Chief Investment Officer, Pendelton Capital\n\n'
          'Dear Mr. Pendelton,\n\n'
          'Thank you for contacting my office directly regarding your stay in the Sovereign Suite from October 14 through October 18. I was profoundly dismayed to learn that your experience fell far short of our royal service standards. Specifically, the intermittent failure of the smart climate control system and the unacceptable three-hour delay in laundry turnaround were completely inexcusable.\n\n'
          'Our chief engineering officer determined that a faulty digital motherboard in the suite\'s thermal regulation sub-station caused the persistent temperature fluctuations. The unit was replaced yesterday. Furthermore, our housekeeping leadership has instituted double-check dispatch manifests to eliminate laundry scheduling bottlenecks.\n\n'
          'As a tangible gesture of our sincere remorse and in recognition of your Diamond Loyalty status, I have credited 150,000 reward points to your loyalty account and credited back the entirety of your four-night lodging charges (\$6,800 USD). We hope to welcome you back on your next London visit.',
      'qs': [
        {
          'num': 159,
          'c': 'What issues prompted Mr. Pendelton\'s dissatisfaction?',
          'opts': ['Erratic temperature controls and delayed laundry service', 'Unsanitary bathroom linens and noisy street traffic', 'Unpalatable room service dining and missing baggage', 'An incorrect room billing rate and rude desk staff'],
          'a': 'A',
          'exp': 'Khách hàng bức xúc vì lỗi điều hòa nhiệt độ phòng chập chờn và giặt ủi chậm trễ 3 tiếng ("intermittent failure of the smart climate control system and the unacceptable three-hour delay in laundry turnaround") → Chọn (A).'
        },
        {
          'num': 160,
          'c': 'What caused the climate control malfunction in the Sovereign Suite?',
          'opts': ['A defective digital motherboard in the thermal regulation unit', 'A citywide municipal electrical power blackout', 'An open window left unlatched by housekeeping', 'A severed water line beneath the marble flooring'],
          'a': 'A',
          'exp': 'Nguyên nhân kỹ thuật: bo mạch điều khiển kỹ thuật số bị lỗi ("faulty digital motherboard in the suite\'s thermal regulation sub-station") → Chọn (A).'
        },
        {
          'num': 161,
          'c': 'How did the hotel compensate Mr. Pendelton for the inconvenience?',
          'opts': ['Refunded his \$6,800 room charges and awarded 150,000 points', 'Offered a complimentary limousine ride to Heathrow Airport', 'Upgraded his reservation to the Imperial Penthouse', 'Presented a lifetime fifty percent dining voucher'],
          'a': 'A',
          'exp': 'Bồi thường: hoàn trả toàn bộ \$6,800 tiền phòng 4 đêm và cộng 150,000 điểm tích lũy ("credited 150,000 reward points ... and credited back the entirety of your four-night lodging charges (\$6,800 USD)") → Chọn (A).'
        }
      ]
    },
    // Bài 7: Q162-164 (Trade Expo Exhibition Manual & Booth Rules)
    {
      'text': 'FRANKFURT INTERNATIONAL AUTOMOTIVE TECH EXPO (FIATE)\n'
          'Exhibitor Manual: Structural Rigging and Heavy Equipment Regulations\n\n'
          'All exhibitors constructing double-decker pavilions or suspending heavy audiovisual equipment from the hall ceiling rafters must adhere strictly to Messe Frankfurt Safety Directives.\n\n'
          'Key Regulations:\n'
          '1. Rigging Submissions: Detailed structural stress blueprints certified by a licensed professional civil engineer must be uploaded to the portal by August 1. Late submissions will incur a non-negotiable 500 Euro penalty fee.\n'
          '2. Height Restrictions: Single-tier exhibits are limited to a maximum height of 4.5 meters. Multi-tier pavilions may reach 6.0 meters, provided they maintain an automatic emergency fire sprinkler system connected to the municipal water riser.\n'
          '3. Heavy Vehicles: Fully electric vehicles displayed inside exhibition halls must have their battery charge depleted below twenty-five percent state of charge (SoC) for fire safety. Battery charging inside exhibit halls is strictly prohibited after 18:00.',
      'qs': [
        {
          'num': 162,
          'c': 'What document must exhibitors submit by August 1?',
          'opts': ['Structural stress blueprints certified by a licensed civil engineer', 'Proof of commercial liability insurance from an EU underwriter', 'A list of registered booth staff wearing formal uniform', 'Catering menus for evening reception guests'],
          'a': 'A',
          'exp': 'Tài liệu phải nộp trước 1/8: bản vẽ kết cấu chịu lực được kỹ sư xây dựng có chứng chỉ phê duyệt ("structural stress blueprints certified by a licensed professional civil engineer") → Chọn (A).'
        },
        {
          'num': 163,
          'c': 'What is the maximum permissible height for single-tier exhibit booths?',
          'opts': ['4.5 meters', '6.0 meters', '2.5 meters', '8.0 meters'],
          'a': 'A',
          'exp': 'Chiều cao tối đa cho gian hàng 1 tầng: 4.5 mét ("Single-tier exhibits are limited to a maximum height of 4.5 meters") → Chọn (A).'
        },
        {
          'num': 164,
          'c': 'What fire safety regulation applies to electric vehicles displayed in halls?',
          'opts': ['Battery charge must remain below twenty-five percent', 'Vehicles must have all tires removed during the expo', 'Charging cords must remain plugged in twenty-four hours a day', 'Vehicles must be parked within five meters of emergency exits'],
          'a': 'A',
          'exp': 'Quy tắc an toàn chống cháy cho xe điện: pin phải duy trì dưới 25% dung lượng sạc ("battery charge depleted below twenty-five percent state of charge") → Chọn (A).'
        }
      ]
    },
    // Bài 8: Q165-167 (Financial Article: Protectionist Tariffs & Supply Chain Shocks)
    {
      'text': 'FINANCIAL JOURNAL OF GLOBAL COMMERCE\n'
          'Article: The Unintended Ripple Effects of Strategic Import Tariffs\n'
          'By Senior Trade Economics Correspondent Julian Vance\n\n'
          'While the implementation of a 25% blanket import tariff on foreign raw steel was ostensibly engineered to bolster domestic blast furnace foundries, downstream manufacturing industries are bearing the brunt of acute price shocks. Domestic commercial appliance and automotive fabricators have experienced a 38% surge in cold-rolled coil procurement costs over the preceding six months.\n\n'
          'Consequently, operating margins for mid-market industrial machinery manufacturers contracted from 14.2% to a historic low of 6.8% in the third quarter. Unable to absorb these margin compressions indefinitely, major industrial exporters like Caterpillar and John Deere have instituted surcharge clauses on finished tractors, passing costs directly to agricultural buyers. Trade economists predict that unless tariff exemptions are granted for specialty automotive alloy grades by year-end, domestic manufacturers will relocate sub-assembly lines to Mexico or Canada.',
      'qs': [
        {
          'num': 165,
          'c': 'What was the stated objective of the 25% import tariff on raw steel?',
          'opts': ['To bolster domestic blast furnace foundries', 'To generate federal revenue to fund highway construction', 'To encourage automotive companies to switch to aluminum', 'To reduce consumer spending on imported household appliances'],
          'a': 'A',
          'exp': 'Mục tiêu danh nghĩa của thuế nhập khẩu 25% là thúc đẩy các xưởng luyện thép lò cao trong nước ("ostensibly engineered to bolster domestic blast furnace foundries") → Chọn (A).'
        },
        {
          'num': 166,
          'c': 'What has happened to operating margins for mid-market machinery manufacturers?',
          'opts': ['Contracted from 14.2% down to 6.8%', 'Expanded by thirty-eight percent', 'Remained completely unchanged throughout the quarter', 'Rose to an all-time record high of twenty-five percent'],
          'a': 'A',
          'exp': 'Biên lợi nhuận hoạt động bị teo tóp từ 14.2% xuống mức thấp kỷ lục 6.8% ("operating margins ... contracted from 14.2% to a historic low of 6.8%") → Chọn (A).'
        },
        {
          'num': 167,
          'c': 'What action might manufacturers take if specialty tariff exemptions are not granted?',
          'opts': ['Relocate sub-assembly operations to Mexico or Canada', 'Permanently discontinue finished tractor manufacturing', 'File an antitrust lawsuit against domestic foundries', 'Cease all retail agricultural sales worldwide'],
          'a': 'A',
          'exp': 'Nếu không được miễn trừ thuế, các nhà sản xuất có thể chuyển dây chuyền lắp ráp phụ sang Mexico hoặc Canada ("relocate sub-assembly lines to Mexico or Canada") → Chọn (A).'
        }
      ]
    },
    // Bài 9: Q168-171 (Internal Memo: 360-Degree Performance Review & Promotion Criteria)
    {
      'text': 'GLOBAL CONSULTING GROUP\n'
          'Internal Executive Memo: 360-Degree Leadership Performance Evaluation\n'
          'From: Corporate Talent Committee | Date: November 12\n\n'
          'Beginning next month, Global Consulting Group will transition from traditional annual supervisor reviews to a comprehensive 360-degree appraisal framework for all Senior Associates and Engagement Managers. Under this framework, performance ratings will be weighted across four distinct perspectives: Supervisor Assessment (40%), Peer Review (25%), Subordinate Team Feedback (20%), and Client Satisfaction NPS (15%).\n\n'
          'Promotion to Partner Eligibility:\n'
          'To be shortlisted for Junior Partner candidacy, candidates must maintain an aggregate composite score of at least 4.6 out of 5.0 over three consecutive evaluation cycles. Furthermore, candidates must have originated at least \$2.5 million in new client billings and demonstrated verified sponsorship of at least two junior consultants from underrepresented backgrounds.\n\n'
          'Confidential Evaluation Windows:\n'
          'Peer and subordinate evaluations must be submitted via the anonymized portal between December 1 and December 15. The system utilizes automated sentiment masking to protect reviewer anonymity. Personal coaching briefings with managing partners will be scheduled throughout January.',
      'qs': [
        {
          'num': 168,
          'c': 'What evaluation perspective carries the highest weight in the new framework?',
          'opts': ['Supervisor Assessment (40%)', 'Peer Review (25%)', 'Subordinate Team Feedback (20%)', 'Client Satisfaction NPS (15%)'],
          'a': 'A',
          'exp': 'Trọng số cao nhất thuộc về Đánh giá của cấp trên trực tiếp (40%) → Chọn (A).'
        },
        {
          'num': 169,
          'c': 'What minimum score is required over three cycles to qualify for Partner consideration?',
          'opts': ['4.6 out of 5.0', '4.0 out of 5.0', '3.5 out of 5.0', '4.9 out of 5.0'],
          'a': 'A',
          'exp': 'Điểm tối thiểu yêu cầu qua 3 kỳ đánh giá là 4.6 trên 5.0 ("aggregate composite score of at least 4.6 out of 5.0") → Chọn (A).'
        },
        {
          'num': 170,
          'c': 'How much new client business must prospective partners have generated?',
          'opts': ['At least \$2.5 million', 'Exactly \$1.0 million', 'Over \$10 million', '\$500,000'],
          'a': 'A',
          'exp': 'Chỉ tiêu doanh số đem về: ít nhất 2.5 triệu đô la ("originated at least \$2.5 million in new client billings") → Chọn (A).'
        },
        {
          'num': 171,
          'c': 'How is reviewer anonymity protected on the evaluation portal?',
          'opts': ['Automated sentiment masking technology is applied', 'Reviews are hand-delivered in sealed envelopes', 'Only executive managing partners can read reviews', 'Evaluators use pseudonyms assigned by human resources'],
          'a': 'A',
          'exp': 'Công nghệ che giấu ẩn danh người đánh giá: hệ thống áp dụng công nghệ tự động làm mờ sắc thái biểu cảm ("automated sentiment masking to protect reviewer anonymity") → Chọn (A).'
        }
      ]
    },
    // Bài 10: Q172-175 (BSL-3 Cleanroom Protocol & Decontamination Manual)
    {
      'text': 'BIORISK MANAGEMENT INSTITUTE\n'
          'Biosafety Level 3 (BSL-3) High-Containment Cleanroom Standard Operating Procedure\n\n'
          'Section 8: Negative Pressure Airflow Interlocks and Emergency Decontamination\n\n'
          'Personnel entering BSL-3 biocontainment corridors must pass through a two-stage pneumatic airlock. Chamber One maintains an ambient pressure differential of -25 Pascals relative to outer hallways, while Chamber Two maintains -50 Pascals relative to active culture containment suites. At no point should both airlock doors be opened concurrently; an automated magnetic interlock prohibits opening the secondary door until the primary door has completed a twelve-second positive sealing cycle.\n\n'
          'Emergency Spill Protocols:\n'
          'In the event of an aerosolized liquid culture spill exceeding 50 milliliters:\n'
          '1. Actuate the wall-mounted red pull-switch immediately to trigger localized HEPA filtration isolation and initiate the automated vaporized hydrogen peroxide (VHP) fogging cycle.\n'
          '2. Evacuate through Emergency Exit West within ninety seconds. Do not attempt manual swab collection.\n'
          '3. Report directly to Decontamination Station C for a mandatory fourteen-minute chemical disinfectant shower before changing into sterile hospital scrubs.',
      'qs': [
        {
          'num': 172,
          'c': 'What safety mechanism prevents both airlock doors from opening simultaneously?',
          'opts': ['An automated magnetic interlock system', 'A manual padlock combination code', 'A biometric fingerprint retinal scanner', 'A physical wooden barricade beam'],
          'a': 'A',
          'exp': 'Cơ chế an toàn ngăn mở 2 cửa cùng lúc: hệ thống khóa liên động từ tính tự động ("automated magnetic interlock prohibits opening the secondary door") → Chọn (A).'
        },
        {
          'num': 173,
          'c': 'How long is the sealing cycle between airlock chambers?',
          'opts': ['Twelve seconds', 'Fifty seconds', 'Two minutes', 'Ninety seconds'],
          'a': 'A',
          'exp': 'Chu kỳ khóa kín của cửa là 12 giây ("twelve-second positive sealing cycle") → Chọn (A).'
        },
        {
          'num': 174,
          'c': 'What volume of spilled culture requires triggering emergency evacuation?',
          'opts': ['Exceeding 50 milliliters', 'Over 500 liters', 'More than 1 gallon', 'Any droplet whatsoever'],
          'a': 'A',
          'exp': 'Thể tích tràn chất lỏng kích hoạt báo động: vượt quá 50 mililit ("culture spill exceeding 50 milliliters") → Chọn (A).'
        },
        {
          'num': 175,
          'c': 'What must personnel do immediately after evacuating to Decontamination Station C?',
          'opts': ['Take a fourteen-minute chemical disinfectant shower', 'Sign an incident accident indemnity release form', 'Drive themselves to the nearest municipal hospital', 'Call the federal environmental protection hotline'],
          'a': 'A',
          'exp': 'Nghĩa vụ ngay sau khi sơ tán tới Trạm C: tắm khử khuẩn bằng hóa chất trong 14 phút ("mandatory fourteen-minute chemical disinfectant shower") → Chọn (A).'
        }
      ]
    },
  ];

  return passages.map<Map<String, dynamic>>((p) {
    return <String, dynamic>{
      'part': 7,
      'passage': p['text'] as String,
      'questions': (p['qs'] as List).map<Map<String, dynamic>>((q) {
        final qm = q as Map<String, dynamic>;
        return <String, dynamic>{
          'number': qm['num'],
          'content': qm['c'],
          'options': qm['opts'],
          'answer': qm['a'],
          'explanation': qm['exp'],
          'tags': ['reading', 'detail']
        };
      }).toList()
    };
  }).toList();
}

// =============================================================================
// PHẦN 2: ĐOẠN ĐÔI (DOUBLE PASSAGES) - CÂU 176 ĐẾN 185 (10 CÂU)
// =============================================================================

List<Map<String, dynamic>> _buildPart7Double() {
  final sets = [
    // Double 1: Q176-180 (HVAC RFP & Contractor Tender Proposal)
    {
      'part': 7,
      'passage': 'DOCUMENT 1: REQUEST FOR PROPOSALS (RFP)\n'
          'Crownfield Real Estate Management | Date: August 5\n'
          'Project: Complete Central HVAC Replacement at Lexington Tower\n\n'
          'Crownfield Management invites competitive bids from certified commercial mechanical contractors to replace the legacy chiller and ducted air ventilation system at Lexington Tower (34 floors, 420,000 square feet). Proposals must include:\n'
          '• Decommissioning and crane removal of two 450-ton roof-mounted centrifugal chillers.\n'
          '• Installation of modern variable refrigerant flow (VRF) units achieving at least 30% reduction in annual electricity consumption.\n'
          '• Smart building integration with BACnet automation protocols.\n'
          '• Work must occur strictly over weekend windows (Friday 19:00 to Monday 05:00) to avoid interrupting corporate tenants.\n'
          '• Submissions due by August 25. Projected budget cap: \$1,800,000 USD.\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 2: BID PROPOSAL\n'
          'Apex Mechanical Contractors | Date: August 22\n'
          'To: Selection Committee, Crownfield Real Estate Management\n\n'
          'We are delighted to submit our tender for the Lexington Tower HVAC Modernization project. Apex Mechanical brings over thirty years of high-rise commercial retrofit expertise in downtown Manhattan.\n\n'
          'Scope & Financial Terms:\n'
          '• Equipment: Daikin Ultra-Efficiency VRF Modular Chiller System (guaranteed 34% energy savings, exceeding your 30% target).\n'
          '• Automation: Native BACnet-compatible digital thermostats and remote mobile diagnostics.\n'
          '• Crane Logistics: Heavy crane rigging permits pre-approved with the municipal transit authority for three consecutive weekends in October.\n'
          '• Total Fixed-Cost Bid: \$1,685,000 USD (inclusive of all equipment, labor, permits, and a five-year comprehensive parts warranty).\n'
          '• Note on Timeline: Because our crane permits are scheduled for October 8–24, contract finalization must occur prior to September 10.',
      'qs': [
        {
          'num': 176,
          'c': 'What energy efficiency requirement did Crownfield specify in the RFP?',
          'opts': ['At least a thirty percent reduction in annual electricity usage', 'Complete conversion to rooftop solar power', 'A zero-emission geothermal ground loop system', 'A fifty percent decrease in municipal water consumption'],
          'a': 'A',
          'exp': 'Yêu cầu trong RFP: giảm ít nhất 30% mức tiêu thụ điện hàng năm ("at least 30% reduction in annual electricity consumption") → Chọn (A).'
        },
        {
          'num': 177,
          'c': 'Why must installation work occur only during weekend windows?',
          'opts': ['To avoid disrupting commercial tenants during business hours', 'Because crane permits are only valid on Sundays', 'To comply with municipal noise ordinance statutes', 'Because building elevators are turned off on weekdays'],
          'a': 'A',
          'exp': 'Lý do chỉ thi công cuối tuần: tránh làm gián đoạn các công ty thuê văn phòng ("avoid interrupting corporate tenants") → Chọn (A).'
        },
        {
          'num': 178,
          'c': 'How does Apex Mechanical\'s bid compare to Crownfield\'s budget cap?',
          'opts': ['It is \$115,000 below the maximum budget cap', 'It exceeds the budget by twenty percent', 'It matches the exact budget cap of \$1,800,000', 'It requires an additional \$300,000 in contingency reserves'],
          'a': 'A',
          'exp': 'Câu hỏi suy luận chéo: Ngân sách tối đa của chủ nhà là \$1,800,000; giá thầu trọn gói của Apex là \$1,685,000 → Thấp hơn \$115,000 (\$1,800,000 - \$1,685,000) → Chọn (A).'
        },
        {
          'num': 179,
          'c': 'What warranty coverage does Apex Mechanical include in its fixed-cost price?',
          'opts': ['A five-year comprehensive parts warranty', 'Ten years of free filter replacement labor', 'A lifetime guarantee against roof leaks', 'One year of emergency electrical service'],
          'a': 'A',
          'exp': 'Bảo hành: bảo hành toàn diện phụ tùng trong 5 năm ("five-year comprehensive parts warranty") → Chọn (A).'
        },
        {
          'num': 180,
          'c': 'By what date must Crownfield finalize the contract to secure Apex\'s schedule?',
          'opts': ['Prior to September 10', 'By August 5', 'On August 25', 'By October 24'],
          'a': 'A',
          'exp': 'Thời hạn chốt hợp đồng để kịp giấy phép cẩu hàng: trước ngày 10 tháng 9 ("must occur prior to September 10") → Chọn (A).'
        }
      ]
    },
    // Double 2: Q181-185 (Symposium Schedule & Speaker Reschedule Email)
    {
      'part': 7,
      'passage': 'DOCUMENT 1: SYMPOSIUM SCHEDULE\n'
          'International Macroeconomic Forum | Geneva Convention Palace\n'
          'Date: Thursday, November 18 | Room: Auditorium Alpha (Level 2)\n\n'
          '• 09:00 – 10:30: Opening Remarks & Global Trade Outlook (Dr. Henrik Lindqvist)\n'
          '• 10:45 – 12:15: Sovereign Debt Restructuring in Emerging Markets (Prof. Claudia Rossi)\n'
          '• 12:15 – 13:45: Executive Luncheon Banquet (Lake View Dining Hall)\n'
          '• 14:00 – 15:30: Central Bank Digital Currencies and Cross-Border Settlements (Dr. Aris Thorne)\n'
          '• 15:45 – 17:15: Panel Discussion: Supply Chain Geopolitics (Chaired by Dr. Thorne)\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 2: URGENT EMAIL\n'
          'From: Prof. Claudia Rossi <c.rossi@bocconi.it>\n'
          'To: Program Coordinator <organizers@macroforum.org>\n'
          'Date: Wednesday, November 17, 18:40 CET\n'
          'Subject: Urgent Travel Disruption - Schedule Adjustment Request\n\n'
          'Dear Forum Coordinators,\n\n'
          'I am writing with deep regret to inform you that my connecting flight from Milan Malpensa to Geneva was abruptly cancelled due to an air traffic controller wildcat strike in Northern Italy. I have rebooked onto an express train departing Milan tomorrow morning at 08:30, which is scheduled to arrive at Geneva Central Station at 12:45 CET.\n\n'
          'Consequently, I will be unable to deliver my morning presentation at 10:45. Would it be feasible to swap presentation slots with Dr. Aris Thorne? If Dr. Thorne can deliver his lecture on Central Bank Digital Currencies during the 10:45 morning window, I could take his 14:00 afternoon slot immediately following the luncheon banquet. I have spoken to Dr. Thorne briefly by phone, and he indicated he is agreeable to this exchange if audio-visual setups allow.',
      'qs': [
        {
          'num': 181,
          'c': 'What topic was Professor Rossi originally scheduled to address?',
          'opts': ['Sovereign Debt Restructuring in Emerging Markets', 'Central Bank Digital Currencies', 'Supply Chain Geopolitics', 'Global Trade Outlook in Northern Europe'],
          'a': 'A',
          'exp': 'Theo lịch trình Doc 1, bài giảng của Giáo sư Rossi lúc 10:45 là về tái cơ cấu nợ công ở các thị trường mới nổi ("Sovereign Debt Restructuring in Emerging Markets") → Chọn (A).'
        },
        {
          'num': 182,
          'c': 'Why is Professor Rossi unable to arrive in Geneva before noon?',
          'opts': ['Her flight was cancelled due to an air traffic controller strike', 'She contracted a sudden illness requiring hospital treatment', 'Her train derailed outside Milan', 'She lost her passport at Malpensa Airport'],
          'a': 'A',
          'exp': 'Nguyên nhân: chuyến bay bị hủy đột ngột do cuộc đình công của kiểm soát viên không lưu ở Bắc Ý ("air traffic controller wildcat strike") → Chọn (A).'
        },
        {
          'num': 183,
          'c': 'What adjustment does Professor Rossi propose?',
          'opts': ['Swapping presentation slots with Dr. Aris Thorne', 'Presenting her lecture remotely via Zoom video conference', 'Moving her talk to Friday morning', 'Canceling the afternoon panel discussion entirely'],
          'a': 'A',
          'exp': 'Đề xuất đổi ca: đổi khung giờ thuyết trình với Dr. Aris Thorne ("swap presentation slots with Dr. Aris Thorne") → Chọn (A).'
        },
        {
          'num': 184,
          'c': 'If the proposal is accepted, what lecture will attendees hear at 10:45 A.M.?',
          'opts': ['Central Bank Digital Currencies and Cross-Border Settlements', 'Global Trade Outlook and Supply Chain Tariffs', 'Sovereign Debt Restructuring', 'Executive Luncheon Banquet Speeches'],
          'a': 'A',
          'exp': 'Suy luận chéo: Nếu hoán đổi thành công, Dr. Aris Thorne sẽ thuyết trình lúc 10:45 về chuyên đề của ông: "Central Bank Digital Currencies and Cross-Border Settlements" → Chọn (A).'
        },
        {
          'num': 185,
          'c': 'When does Professor Rossi\'s train arrive in Geneva?',
          'opts': ['At 12:45 CET', 'At 08:30 CET', 'At 10:45 CET', 'At 14:00 CET'],
          'a': 'A',
          'exp': 'Tàu của Giáo sư Rossi đến Geneva lúc 12:45 CET ("scheduled to arrive at Geneva Central Station at 12:45 CET") → Chọn (A).'
        }
      ]
    },
  ];

  return sets.map<Map<String, dynamic>>((s) {
    return <String, dynamic>{
      'part': 7,
      'passage': s['passage'] as String,
      'questions': (s['qs'] as List).map<Map<String, dynamic>>((q) {
        final qm = q as Map<String, dynamic>;
        return <String, dynamic>{
          'number': qm['num'],
          'content': qm['c'],
          'options': qm['opts'],
          'answer': qm['a'],
          'explanation': qm['exp'],
          'tags': ['reading', 'double-passage']
        };
      }).toList()
    };
  }).toList();
}

// =============================================================================
// PHẦN 3: ĐOẠN BA (TRIPLE PASSAGES) - CÂU 186 ĐẾN 200 (15 CÂU)
// =============================================================================

List<Map<String, dynamic>> _buildPart7Triple() {
  final sets = [
    // Triple 1: Q186-190 (Corporate EV Policy + Expense Report + Audit Rejection Email)
    {
      'part': 7,
      'passage': 'DOCUMENT 1: CORPORATE POLICY DIRECTIVE\n'
          'Vanguard Logistics Group | Policy 24-B: Fleet & Personal Electric Vehicle (EV) Subsidy\n'
          'Effective Date: March 1\n\n'
          'To incentivize green commuting, Vanguard reimburses field sales representatives who utilize personal electric vehicles for business client visitations:\n'
          '1. Mileage Allowance: Reimbursed at \$0.62 per mile for documented client travel exceeding 25 miles from the employee\'s assigned regional office.\n'
          '2. Charging Reimbursement: DC Fast Charging expenses incurred during active client travel are 100% reimbursable up to a monthly cap of \$180. Overnight home-charging utility bills are strictly non-reimbursable.\n'
          '3. Documentation Mandate: All expense reports must include GPS-stamped route logs and original digital receipts from certified charging networks (ChargePoint, EVgo, Electrify America). Claims must be submitted within 14 calendar days of month-end.\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 2: EXPENSE CLAIM SUMMARY\n'
          'Employee: Marcus Bennett | Department: Enterprise Field Sales (Cleveland Branch)\n'
          'Billing Period: October | Submission Date: November 6\n\n'
          '• Item 1 (Oct 4): Client visit to Akron Industrial Park (64 miles round-trip) -> Mileage claim: \$39.68\n'
          '• Item 2 (Oct 11): Client conference in Columbus (240 miles round-trip) -> Mileage claim: \$148.80\n'
          '• Item 3 (Oct 11): Electrify America Fast-Charge receipt (Columbus) -> \$34.50\n'
          '• Item 4 (Oct 22): Monthly residential home electricity utility statement -> \$115.00\n'
          '• Item 5 (Oct 28): Routine car wash and interior vacuuming -> \$25.00\n'
          'Total Claimed Reimbursement: \$362.98\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 3: INTERNAL AUDIT NOTIFICATION\n'
          'From: Internal Expense Audit Division <audit@vanguardlogistics.com>\n'
          'To: Marcus Bennett <mbennett@vanguardlogistics.com>\n'
          'Date: November 9\n'
          'Subject: Adjustment to October Travel Expense Claim #EXP-7721\n\n'
          'Dear Mr. Bennett,\n\n'
          'We have completed our compliance review of your October travel expense report. While Items 1, 2, and 3 fully comply with Policy 24-B guidelines and have been approved for disbursement, we must inform you that two items on your claim have been disallowed.\n\n'
          'Specifically, under Section 2 of Policy 24-B, residential utility bills for home vehicle charging are strictly ineligible for corporate reimbursement. Furthermore, routine cosmetic maintenance such as car washes is not covered under our travel allowance. Consequently, your approved reimbursement amount has been revised down from \$362.98 to \$222.98. The approved sum will be deposited in your bank account on November 15.',
      'qs': [
        {
          'num': 186,
          'c': 'What requirement must employees meet to receive mileage reimbursement under Policy 24-B?',
          'opts': ['Travel must exceed 25 miles from their regional office', 'Vehicles must be less than two years old', 'Travel must occur during weekend hours', 'Drivers must carry commercial cargo insurance'],
          'a': 'A',
          'exp': 'Quy định trong Doc 1 nêu rõ: chỉ hoàn tiền số dặm khi chuyến đi vượt quá 25 dặm từ văn phòng chi nhánh ("exceeding 25 miles from the employee\'s assigned regional office") → Chọn (A).'
        },
        {
          'num': 187,
          'c': 'Why was Marcus Bennett\'s home electricity bill (Item 4) disallowed?',
          'opts': ['Policy 24-B expressly prohibits reimbursing residential home charging', 'The submission was filed after the 14-day deadline', 'Marcus failed to attach a photo of his electric meter', 'His monthly utility bill exceeded the \$180 maximum cap'],
          'a': 'A',
          'exp': 'Khoản tiền điện sạc tại nhà (\$115) bị từ chối vì chính sách quy định rõ: "Overnight home-charging utility bills are strictly non-reimbursable" → Chọn (A).'
        },
        {
          'num': 188,
          'c': 'What total amount was Marcus originally seeking to claim?',
          'opts': ['\$362.98', '\$222.98', '\$180.00', '\$148.80'],
          'a': 'A',
          'exp': 'Số tiền ban đầu Marcus yêu cầu hoàn là \$362.98 trong Doc 2 ("Total Claimed Reimbursement: \$362.98") → Chọn (A).'
        },
        {
          'num': 189,
          'c': 'What was the total dollar value of the two disallowed items combined?',
          'opts': ['\$140.00', '\$115.00', '\$25.00', '\$34.50'],
          'a': 'A',
          'exp': 'Suy luận chéo: Hai mục bị loại là tiền điện nhà (Item 4: \$115.00) và rửa xe (Item 5: \$25.00). Tổng số tiền bị loại là \$115.00 + \$25.00 = \$140.00 (khớp với mức giảm từ \$362.98 xuống \$222.98) → Chọn (A).'
        },
        {
          'num': 190,
          'c': 'When will Marcus receive his approved reimbursement deposit?',
          'opts': ['On November 15', 'On November 6', 'On October 31', 'On December 1'],
          'a': 'A',
          'exp': 'Trong email Doc 3 nêu rõ: số tiền đã duyệt sẽ được chuyển vào tài khoản vào ngày 15 tháng 11 ("deposited in your bank account on November 15") → Chọn (A).'
        }
      ]
    },
    // Triple 2: Q191-195 (Press Release + Harsh Food Review + Executive Chef Rebuttal)
    {
      'part': 7,
      'passage': 'DOCUMENT 1: PRESS RELEASE\n'
          'HARBOR VIEW HOSPITALITY GROUP\n'
          'For Immediate Release: September 1\n'
          'Subject: Grand Opening of L’Etoile Maritime at Pier 21\n\n'
          'Harbor View Hospitality is proud to announce the grand opening of L’Etoile Maritime, a premier seafood culinary destination situated at the newly redeveloped historic Pier 21 waterfront pavilion in Boston. Led by Michelin-starred Executive Chef Jean-Luc Moreau, L’Etoile Maritime showcases sustainable wild-caught North Atlantic seafood paired with organic biodynamic wines.\n\n'
          'Signature Offerings:\n'
          '• Wood-Fired Maine Diver Scallops with saffron-infused parsnip puree.\n'
          '• Poached Nova Scotia Lobster Tail served over handmade squid-ink tagliatelle.\n'
          '• Panoramic 270-degree floor-to-ceiling glass dining room overlooking Boston Harbor.\n'
          'Reservations are open exclusively via OpenTable starting September 15. Private banquet bookings available for corporate galas up to 120 guests.\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 2: RESTAURANT REVIEW\n'
          'THE METROPOLITAN DINING CHRONICLE\n'
          'Headline: Splendid Views Overshadowed by Inconsistent Execution at L\'Etoile Maritime\n'
          'By Senior Food Critic Sebastian Drake | Published: October 10\n'
          'Rating: ★★☆☆☆ (2 out of 5 Stars)\n\n'
          'There is no denying that the breathtaking harbor sunset at L’Etoile Maritime provides one of the most stunning dining backdrops in New England. Regrettably, the culinary execution on my visit last Friday did not justify the eye-watering \$240-per-person tasting menu.\n\n'
          'While the poached lobster tail was masterfully tender and sweet, the wood-fired Maine diver scallops arrived at our table lukewarm and noticeably over-salted. Even more frustrating was the glacial dining room service: a forty-five minute lag transpired between our appetizer course and entrees, leaving our party waiting with empty water glasses. For a restaurant with Michelin pedigree, such operational lapses are inexcusable.\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 3: CHEF\'S LETTER TO THE EDITOR\n'
          'To: The Editorial Board, The Metropolitan Dining Chronicle\n'
          'From: Executive Chef Jean-Luc Moreau, L\'Etoile Maritime\n'
          'Published: October 14\n\n'
          'Dear Mr. Drake and Editors,\n\n'
          'I read Sebastian Drake\'s review with genuine humility and professional concern. I take personal responsibility for the shortcomings highlighted during his visit on October 6.\n\n'
          'Following his critique, we investigated our kitchen operations and identified a technical fault in our secondary wood-fired hearth ventilation hood, which caused uneven thermal circulation and delayed scallop preparation times. The ventilation system has been thoroughly re-engineered. Furthermore, our general manager has hired four additional floor sommeliers and food runners to guarantee seamless table service turnaround.\n\n'
          'To demonstrate our unwavering commitment to culinary perfection, we invite Mr. Drake and his editorial colleagues to return as our personal guests to experience our newly launched autumn tasting menu.',
      'qs': [
        {
          'num': 191,
          'c': 'Where is L’Etoile Maritime located?',
          'opts': ['At Pier 21 waterfront pavilion in Boston', 'In downtown Manhattan near Fifth Avenue', 'On the historic docks of Portland, Maine', 'Inside a luxury hotel in Nova Scotia'],
          'a': 'A',
          'exp': 'Thông cáo báo chí Doc 1 nêu rõ nhà hàng tọa lạc tại Pier 21 ở Boston ("Pier 21 waterfront pavilion in Boston") → Chọn (A).'
        },
        {
          'num': 192,
          'c': 'Which dish did food critic Sebastian Drake praise during his visit?',
          'opts': ['The poached Nova Scotia lobster tail', 'The wood-fired Maine diver scallops', 'The saffron-infused parsnip soup', 'The house artisan sourdough bread'],
          'a': 'A',
          'exp': 'Nhà phê bình khen ngợi món tôm hùm luộc rất mềm và ngọt ("poached lobster tail was masterfully tender and sweet") → Chọn (A).'
        },
        {
          'num': 193,
          'c': 'What specific service failure did Mr. Drake criticize in his review?',
          'opts': ['A forty-five minute delay between appetizers and entrees', 'The sommelier recommended an overpriced wine bottle', 'The hostess cancelled his reservation without notice', 'The kitchen refused to accommodate dietary allergies'],
          'a': 'A',
          'exp': 'Lỗi phục vụ bị phê bình: khoảng trống chờ đợi tới 45 phút giữa món khai vị và món chính ("forty-five minute lag transpired between our appetizer course and entrees") → Chọn (A).'
        },
        {
          'num': 194,
          'c': 'What mechanical problem caused the uneven cooking of the scallops?',
          'opts': ['A fault in the wood-fired hearth ventilation hood', 'A broken electrical convection oven heating element', 'An unexpected municipal gas supply shutdown', 'A damaged digital refrigerator thermostat'],
          'a': 'A',
          'exp': 'Bếp trưởng Jean-Luc Moreau giải thích lỗi do chụp hút thông gió của bếp củi gây luân chuyển nhiệt không đều ("technical fault in our secondary wood-fired hearth ventilation hood") → Chọn (A).'
        },
        {
          'num': 195,
          'c': 'What staff adjustments did management implement in response to the critique?',
          'opts': ['Hired four additional sommeliers and food runners', 'Replaced the entire line cooking brigade', 'Appointed a new general manager from Paris', 'Transferred the executive chef to another restaurant'],
          'a': 'A',
          'exp': 'Biện pháp khắc phục: tuyển thêm 4 nhân viên phụ trách rượu và chạy bàn ("hired four additional floor sommeliers and food runners") → Chọn (A).'
        }
      ]
    },
    // Triple 3: Q196-200 (Equipment Order Specs + Factory Inspection Cert + Malfunction Notice)
    {
      'part': 7,
      'passage': 'DOCUMENT 1: PURCHASE SPECIFICATION CONTRACT\n'
          'Client: BioCare Pharmaceuticals (North Carolina)\n'
          'Vendor: Krones Automated Packaging Systems (Stuttgart, Germany)\n'
          'Order Date: May 12 | Contract Reference: PO-99382-K\n\n'
          'Equipment Ordered:\n'
          '• Model: Krones OptiSeal 4000 Ultra-Speed Pharmaceutical Blister Packaging Line\n'
          '• Required Operating Speed: 400 sealed blister packs per minute with sub-millimeter thermal sealing tolerance.\n'
          '• Inspection Criteria: Integrated high-resolution machine vision cameras to detect micro-cracks in foil backing.\n'
          '• Delivery & Factory Acceptance: Certified factory inspection report must be furnished before air freight dispatch.\n'
          '• Warranty: 24-month comprehensive replacement warranty with 48-hour on-site technician dispatch guarantee for tier-one malfunctions.\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 2: FACTORY ACCEPTANCE TEST (FAT) CERTIFICATE\n'
          'Krones Quality Assurance Division | Date: August 18\n'
          'Equipment Serial Number: KS-4000-8819\n\n'
          'Test Results:\n'
          '• Motor Drive RPM Stability: PASS (Tested at 420 packs/minute for 8 continuous hours)\n'
          '• Thermal Foil Sealing Integrity: PASS (Hermetic seal maintained at 185°C ± 0.5°C)\n'
          '• Machine Vision Optical Reject Gate: PASS (100% detection of simulated 0.2mm foil fractures)\n'
          '• Emergency Stop Deceleration: PASS (Complete inertia shutdown within 1.2 seconds)\n\n'
          'Inspector Certification:\n'
          'Certified by Lead Quality Engineer Klaus Weber. Equipment cleared for crating and international air cargo freight via Frankfurt Airport.\n\n'
          '────────────────────────────────────────────────────────\n\n'
          'DOCUMENT 3: URGENT TECHNICAL MALFUNCTION NOTICE\n'
          'From: Dr. Rachel Adams, VP of Manufacturing, BioCare Pharmaceuticals\n'
          'To: Krones Customer Support Engineering <support@krones-systems.de>\n'
          'Date: September 22\n'
          'Subject: Urgent Warranty Service Dispatch Request - Serial #KS-4000-8819\n\n'
          'Dear Krones Technical Team,\n\n'
          'The OptiSeal 4000 system arrived at our Raleigh facility on September 10 and was commissioned by your local installation contractors last week. However, during our initial commercial trial run yesterday, the machine vision optical reject arm repeatedly malfunctioned.\n\n'
          'Specifically, whenever line throughput exceeded 300 packs per minute, the optical sensors generated false positive defect flags, causing the pneumatic reject gate to divert over eighteen percent of completely flawless blister packs into the scrap bin. This has halted our scheduled production of cardiovascular medication.\n\n'
          'Under Section 5 of our contract (PO-99382-K), this qualifies as a critical tier-one defect. We formally request the immediate dispatch of a senior robotics optical specialist to our facility within the contractual 48-hour window.',
      'qs': [
        {
          'num': 196,
          'c': 'What production speed was specified in the original purchase contract?',
          'opts': ['400 sealed blister packs per minute', '185 packs per minute', '420 packs per minute', '300 packs per minute'],
          'a': 'A',
          'exp': 'Hợp đồng mua bán Doc 1 quy định tốc độ vận hành tiêu chuẩn: 400 vỉ thuốc đóng kín mỗi phút ("Required Operating Speed: 400 sealed blister packs per minute") → Chọn (A).'
        },
        {
          'num': 197,
          'c': 'What does the Factory Acceptance Test (Doc 2) indicate about the machinery in Germany?',
          'opts': ['It successfully passed all quality and speed performance tests', 'It failed the emergency stop deceleration safety test', 'It required a replacement motor drive before crating', 'The machine vision camera had to be recalibrated twice'],
          'a': 'A',
          'exp': 'Biên bản kiểm tra xuất xưởng FAT Doc 2 cho thấy máy vượt qua tất cả các bài kiểm tra chất lượng ("PASS on all tests") → Chọn (A).'
        },
        {
          'num': 198,
          'c': 'What problem occurred during the commercial trial run in North Carolina?',
          'opts': ['Flawless packs were mistakenly flagged as defective and discarded', 'The thermal heating element overheated and melted the foil', 'The motor drive completely jammed and stopped rotating', 'The blister packs were missing expiration date stampings'],
          'a': 'A',
          'exp': 'Sự cố thực tế Doc 3: cảm biến báo lỗi sai khiến 18% sản phẩm hoàn hảo bị gạt bỏ nhầm vào thùng rác ("generated false positive defect flags, causing the pneumatic reject gate to divert over eighteen percent of completely flawless blister packs") → Chọn (A).'
        },
        {
          'num': 199,
          'c': 'How soon is Krones contractually obligated to dispatch an on-site technician?',
          'opts': ['Within forty-eight hours', 'Within two business weeks', 'In twenty-four months', 'Within twelve calendar days'],
          'a': 'A',
          'exp': 'Nghĩa vụ bảo hành hợp đồng: cử kỹ thuật viên đến tận nơi trong vòng 48 giờ đối với sự cố cấp 1 ("48-hour on-site technician dispatch guarantee for tier-one malfunctions") → Chọn (A).'
        },
        {
          'num': 200,
          'c': 'At what operating threshold did the optical sensor malfunction begin appearing?',
          'opts': ['Whenever throughput exceeded 300 packs per minute', 'Only when operating at maximum speed of 420 packs per minute', 'Immediately upon turning on the power switch', 'After eight continuous hours of running'],
          'a': 'A',
          'exp': 'Lỗi xuất hiện khi tốc độ vượt quá 300 vỉ/phút ("whenever line throughput exceeded 300 packs per minute") → Chọn (A).'
        }
      ]
    },
  ];

  return sets.map<Map<String, dynamic>>((s) {
    return <String, dynamic>{
      'part': 7,
      'passage': s['passage'] as String,
      'questions': (s['qs'] as List).map<Map<String, dynamic>>((q) {
        final qm = q as Map<String, dynamic>;
        return <String, dynamic>{
          'number': qm['num'],
          'content': qm['c'],
          'options': qm['opts'],
          'answer': qm['a'],
          'explanation': qm['exp'],
          'tags': ['reading', 'triple-passage']
        };
      }).toList()
    };
  }).toList();
}
