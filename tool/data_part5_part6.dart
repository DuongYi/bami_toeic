// Module Part 5 (Câu 101-130) & Part 6 (Câu 131-146) - ETS Extreme Hard Test 01 (Target 990)

List<Map<String, dynamic>> buildPart5() {
  final qs = [
    // 101: Inversion with negative adverb
    {
      'num': 101,
      'content': 'Seldom ------- such unprecedented volatility in the foreign exchange markets within a single trading quarter.',
      'options': ['have financial analysts witnessed', 'financial analysts have witnessed', 'are financial analysts witnessing', 'witnessing financial analysts'],
      'answer': 'A',
      'explanation': 'Cấu trúc đảo ngữ bắt buộc với phó từ phủ định đứng đầu câu: "Seldom + Trợ động từ + Chủ ngữ + Động từ chính" → Chọn "have financial analysts witnessed".',
      'tags': ['reading', 'grammar', 'inversion']
    },
    // 102: Subjunctive mood
    {
      'num': 102,
      'content': 'It is imperative that the lead regulatory compliance auditor ------- all clinical trial anomalies to the ethics board without delay.',
      'options': ['report', 'reports', 'reported', 'reporting'],
      'answer': 'A',
      'explanation': 'Thức giả định (Subjunctive mood) sau cấu trúc mang tính cấp bách "It is imperative that + S + (should) bare infinitive" → động từ luôn ở dạng nguyên mẫu không "to" "report".',
      'tags': ['reading', 'grammar', 'subjunctive']
    },
    // 103: Confusing words: respective vs respectful
    {
      'num': 103,
      'content': 'Following the annual executive summit, department heads were instructed to draft strategic roadmaps for their ------- divisions.',
      'options': ['respective', 'respectful', 'respectable', 'respecting'],
      'answer': 'A',
      'explanation': 'Bẫy từ vựng cao cấp: "respective" = tương ứng của từng người/từng bộ phận; "respectful" = thể hiện sự tôn trọng; "respectable" = đáng kính. Cụm "their respective divisions" = các bộ phận tương ứng của họ → Chọn (A).',
      'tags': ['reading', 'vocabulary']
    },
    // 104: Perfect participle clause
    {
      'num': 104,
      'content': '------- the preliminary audit balance sheets thoroughly, the comptroller identified several unaccounted disbursements.',
      'options': ['Having evaluated', 'Evaluated', 'To evaluate', 'Being evaluated'],
      'answer': 'A',
      'explanation': 'Rút gọn mệnh đề đồng chủ ngữ ở dạng phân từ hoàn thành (Perfect participle): "Having evaluated..." diễn tả hành động thẩm định đã hoàn tất trước khi phát hiện ra các khoản chi không có chứng từ.',
      'tags': ['reading', 'grammar', 'participle']
    },
    // 105: Advanced preposition: Notwithstanding
    {
      'num': 105,
      'content': '------- persistent supply chain bottlenecks across the Pacific corridor, Apex Electronics fulfilled its overseas obligations on schedule.',
      'options': ['Notwithstanding', 'Although', 'Despite of', 'Whereas'],
      'answer': 'A',
      'explanation': 'Theo sau là cụm danh từ ("persistent supply chain bottlenecks...") mang nghĩa nhượng bộ → chọn giới từ "Notwithstanding" (= Despite / In spite of). "Although/Whereas" cần mệnh đề; "Despite of" sai ngữ pháp.',
      'tags': ['reading', 'preposition']
    },
    // 106: Confusing words: economic vs economical
    {
      'num': 106,
      'content': 'Upgrading our fleet to hybrid commercial vans proved to be an remarkably ------- decision, reducing operational fuel expenditures by thirty percent.',
      'options': ['economical', 'economic', 'economy', 'economize'],
      'answer': 'A',
      'explanation': 'Bẫy tính từ: "economical" = tiết kiệm chi phí; "economic" = thuộc về nền kinh tế vĩ mô. Quyết định giúp tiết kiệm chi phí nhiên liệu → chọn "economical" (A).',
      'tags': ['reading', 'vocabulary']
    },
    // 107: Passive causative / participle
    {
      'num': 107,
      'content': 'The chief legal officer demanded that the non-disclosure agreements be kept strictly ------- throughout the duration of the buyout negotiations.',
      'options': ['confidential', 'confidentially', 'confidence', 'confiding'],
      'answer': 'A',
      'explanation': 'Cấu trúc "keep + O + adj" (giữ cái gì ở trạng thái như thế nào). Sau phó từ chỉ mức độ "strictly" cần tính từ → chọn "confidential" (bảo mật).',
      'tags': ['reading', 'word-form']
    },
    // 108: Inversion with Under no circumstances
    {
      'num': 108,
      'content': 'Under no circumstances ------- proprietary client datasets to be transferred onto unencrypted portable hard drives.',
      'options': ['are', 'is', 'have', 'were'],
      'answer': 'A',
      'explanation': 'Đảo ngữ với cụm từ phủ định "Under no circumstances + are + datasets (danh từ số nhiều) + to be transferred..." (cấu trúc be to V thể hiện mệnh lệnh cấm đoán).',
      'tags': ['reading', 'grammar', 'inversion']
    },
    // 109: Advanced conjunction: Given that
    {
      'num': 109,
      'content': '------- the manufacturing consortium has exceeded its initial production quota, the board approved an additional incentive dividend.',
      'options': ['Given that', 'In spite of', 'Regardless', 'Except that'],
      'answer': 'A',
      'explanation': 'Liên từ chỉ lý do/căn cứ: "Given that + clause" = xét thấy rằng / căn cứ vào việc... Phù hợp với mệnh đề chỉ lý do vì liên doanh đã vượt chỉ tiêu sản xuất.',
      'tags': ['reading', 'conjunction']
    },
    // 110: Confusing words: considerable vs considerate
    {
      'num': 110,
      'content': 'The proposed commercial zoning revision has generated ------- debate among municipal developers and neighborhood residents.',
      'options': ['considerable', 'considerate', 'consideration', 'considerately'],
      'answer': 'A',
      'explanation': 'Bẫy từ vựng: "considerable" = đáng kể, to lớn; "considerate" = chu đáo, biết quan tâm người khác. Cuộc tranh luận to lớn/đáng kể → chọn "considerable" (A).',
      'tags': ['reading', 'vocabulary']
    },
    // 111: Subjunctive verb after mandate
    {
      'num': 111,
      'content': 'New environmental regulations mandate that every industrial chemical refinery ------- continuous smokestack monitoring telemetry.',
      'options': ['install', 'installs', 'installed', 'installing'],
      'answer': 'A',
      'explanation': 'Động từ chỉ yêu cầu/mệnh lệnh "mandate that + S + bare V" → động từ nguyên thể không "to" "install".',
      'tags': ['reading', 'grammar', 'subjunctive']
    },
    // 112: Advanced vocabulary: ostensibly
    {
      'num': 112,
      'content': 'The corporate restructuring was ------- implemented to reduce overhead expenses, although internal sources suggest it aimed to centralize executive decision-making.',
      'options': ['ostensibly', 'authentically', 'reluctantly', 'subordinately'],
      'answer': 'A',
      'explanation': 'Phó từ chỉ bề ngoài/danh nghĩa: "ostensibly" = bề ngoài là / mang danh nghĩa là (tương phản với "although internal sources suggest..." vế sau).',
      'tags': ['reading', 'vocabulary']
    },
    // 113: Advanced conjunction: In accordance with
    {
      'num': 113,
      'content': 'All hazardous industrial waste containers must be labeled and manifested ------- municipal environmental protection statutes.',
      'options': ['in accordance with', 'in spite of', 'contrary to', 'on behalf of'],
      'answer': 'A',
      'explanation': 'Cụm giới từ chỉ sự tuân thủ quy định pháp luật: "in accordance with" = theo đúng / phù hợp với các điều lệ bảo vệ môi trường.',
      'tags': ['reading', 'preposition']
    },
    // 114: Confusing words: comprehensive vs comprehensible
    {
      'num': 114,
      'content': 'Dr. Vance presented a remarkably ------- study analyzing cross-border pharmaceutical licensing agreements over the past two decades.',
      'options': ['comprehensive', 'comprehensible', 'comprehend', 'comprehension'],
      'answer': 'A',
      'explanation': 'Bẫy từ vựng: "comprehensive" = toàn diện, sâu rộng; "comprehensible" = có thể hiểu được. Công trình nghiên cứu toàn diện, sâu rộng → chọn "comprehensive" (A).',
      'tags': ['reading', 'vocabulary']
    },
    // 115: Inversion with Not only
    {
      'num': 115,
      'content': 'Not only ------- the executive team to renegotiate the vendor contract, but they also secured a ten percent volume rebate.',
      'options': ['did the committee manage', 'the committee managed', 'was the committee managing', 'managing the committee'],
      'answer': 'A',
      'explanation': 'Đảo ngữ với "Not only + Trợ động từ did + Chủ ngữ the committee + Động từ manage... but also...".',
      'tags': ['reading', 'grammar', 'inversion']
    },
    // 116: Advanced adverb: inadvertently
    {
      'num': 116,
      'content': 'An entry-level data processing clerk ------- transmitted unredacted customer transaction records to an external testing server.',
      'options': ['inadvertently', 'decisively', 'deliberately', 'punctually'],
      'answer': 'A',
      'explanation': 'Phó từ chỉ sự vô tình/sơ suất: "inadvertently" = sơ ý, vô ý, không cố ý. Thể hiện việc gửi nhầm dữ liệu chưa kiểm duyệt.',
      'tags': ['reading', 'vocabulary']
    },
    // 117: Compound preposition: Prior to
    {
      'num': 117,
      'content': '------- finalizing the commercial merger, both banking entities must obtain explicit antitrust clearance from the federal trade commission.',
      'options': ['Prior to', 'Apart from', 'In addition', 'Instead of'],
      'answer': 'A',
      'explanation': 'Cụm giới từ chỉ thời gian trước khi làm gì: "Prior to + V-ing/N" = Trước khi hoàn tất sáp nhập thương mại.',
      'tags': ['reading', 'preposition']
    },
    // 118: Subjunctive requirement
    {
      'num': 118,
      'content': 'The ethics committee insisted that every prospective board member ------- any potential conflicts of interest before taking office.',
      'options': ['disclose', 'discloses', 'disclosed', 'disclosing'],
      'answer': 'A',
      'explanation': 'Cấu trúc giả định "insisted that + S + (should) bare V" → động từ nguyên mẫu không chia "disclose".',
      'tags': ['reading', 'grammar', 'subjunctive']
    },
    // 119: Adjective form: appreciative vs appreciable
    {
      'num': 119,
      'content': 'Following the deployment of automated diagnostic sensors, the facility experienced an ------- reduction in unexpected equipment downtime.',
      'options': ['appreciable', 'appreciative', 'appreciate', 'appreciating'],
      'answer': 'A',
      'explanation': 'Bẫy từ vựng cao cấp: "appreciable" = có thể thấy rõ, đáng kể; "appreciative" = biết ơn, trân trọng. Mức giảm đáng kể, rõ rệt → chọn "appreciable" (A).',
      'tags': ['reading', 'vocabulary']
    },
    // 120: Conjunction: As though
    {
      'num': 120,
      'content': 'The chief architect presented the preliminary stadium blueprints ------- the municipal permits had already been guaranteed.',
      'options': ['as though', 'so that', 'in order that', 'even though'],
      'answer': 'A',
      'explanation': 'Liên từ chỉ sự giả định: "as though" = như thể là (với cấu trúc thì quá khứ hoàn thành "had already been guaranteed").',
      'tags': ['reading', 'conjunction']
    },
    // 121: Reduced relative clause
    {
      'num': 121,
      'content': 'Any commercial cargo ------- hazardous lithium-ion batteries must adhere strictly to international aviation transport containment protocols.',
      'options': ['containing', 'contained', 'contains', 'containment'],
      'answer': 'A',
      'explanation': 'Mệnh đề quan hệ rút gọn dạng chủ động: "Any commercial cargo (which contains) → containing hazardous lithium-ion batteries".',
      'tags': ['reading', 'grammar', 'participle']
    },
    // 122: Advanced vocabulary: rigorous
    {
      'num': 122,
      'content': 'Only candidates who demonstrate ------- adherence to ethical research protocols will be certified for clinical laboratory trials.',
      'options': ['rigorous', 'tentative', 'arbitrary', 'negligent'],
      'answer': 'A',
      'explanation': 'Tính từ chỉ sự nghiêm ngặt, khắt khe: "rigorous adherence" = sự tuân thủ nghiêm ngặt các quy chuẩn nghiên cứu đạo đức.',
      'tags': ['reading', 'vocabulary']
    },
    // 123: Advanced preposition: In light of
    {
      'num': 123,
      'content': '------- the unexpected surge in raw lithium procurement costs, the automobile manufacturer adjusted the retail base price of its electric sedans.',
      'options': ['In light of', 'Contrary to', 'As well as', 'In place of'],
      'answer': 'A',
      'explanation': 'Cụm giới từ chỉ lý do: "In light of + N" = Xét về / bởi vì / trước tình hình gia tăng giá nguyên liệu lithium.',
      'tags': ['reading', 'preposition']
    },
    // 124: Correlative conjunction: Not only... but
    {
      'num': 124,
      'content': 'The cloud security platform protects enterprise networks not only against unauthorized intrusion ------- against accidental data loss.',
      'options': ['but also', 'and so', 'as well', 'nor yet'],
      'answer': 'A',
      'explanation': 'Cặp liên từ tương quan bắt buộc: "not only A but also B" = không những A mà còn B.',
      'tags': ['reading', 'conjunction']
    },
    // 125: Advanced vocabulary: unprecedented
    {
      'num': 125,
      'content': 'The logistics firm achieved an ------- volume of international freight tonnage during the pre-holiday shipping season.',
      'options': ['unprecedented', 'unprepared', 'unproven', 'unpopular'],
      'answer': 'A',
      'explanation': 'Tính từ cao cấp trong kinh doanh: "unprecedented volume" = khối lượng chưa từng có tiền lệ / kỷ lục từ trước đến nay.',
      'tags': ['reading', 'vocabulary']
    },
    // 126: Conditional inversion: Should
    {
      'num': 126,
      'content': '------- any discrepancy arise during the quarterly inventory reconciliation, the lead auditor must be notified immediately.',
      'options': ['Should', 'Were', 'Had', 'Would'],
      'answer': 'A',
      'explanation': 'Đảo ngữ câu điều kiện loại 1: "Should + S + bare V" (= If any discrepancy arises...).',
      'tags': ['reading', 'grammar', 'inversion']
    },
    // 127: Confusing words: prospective vs perspective
    {
      'num': 127,
      'content': 'Human resources invited several ------- candidates for second-round panel interviews with the department director.',
      'options': ['prospective', 'perspective', 'perspicuous', 'perceptive'],
      'answer': 'A',
      'explanation': 'Bẫy từ vựng: "prospective candidates" = các ứng viên tiềm năng / có triển vọng trong tương lai; "perspective" = góc nhìn, quan điểm (danh từ).',
      'tags': ['reading', 'vocabulary']
    },
    // 128: Preposition: With the exception of
    {
      'num': 128,
      'content': '------- the executive boardroom on the thirty-fifth floor, all conference rooms in the tower are equipped with smart projection glass.',
      'options': ['With the exception of', 'In accordance to', 'In consequence of', 'On the occasion of'],
      'answer': 'A',
      'explanation': 'Cụm giới từ chỉ sự loại trừ: "With the exception of + N" = Ngoại trừ phòng họp ban giám đốc ở tầng 35.',
      'tags': ['reading', 'preposition']
    },
    // 129: Subjunctive recommendation
    {
      'num': 129,
      'content': 'The management consultancy strongly recommended that the manufacturing consortium ------- its automated supply chain infrastructure.',
      'options': ['upgrade', 'upgrades', 'upgraded', 'upgrading'],
      'answer': 'A',
      'explanation': 'Thức giả định sau động từ khuyến nghị "recommended that + S + bare V" → động từ nguyên mẫu "upgrade".',
      'tags': ['reading', 'grammar', 'subjunctive']
    },
    // 130: Advanced vocabulary: meticulously
    {
      'num': 130,
      'content': 'Before entering commercial clinical trials, all biomedical instrumentation must be ------- calibrated by certified technicians.',
      'options': ['meticulously', 'haphazardly', 'reluctantly', 'subordinately'],
      'answer': 'A',
      'explanation': 'Phó từ chỉ sự tỉ mỉ, cẩn trọng: "meticulously calibrated" = được hiệu chuẩn một cách cực kỳ tỉ mỉ, chuẩn xác.',
      'tags': ['reading', 'vocabulary']
    },
  ];

  return qs.map<Map<String, dynamic>>((q) {
    return <String, dynamic>{
      'part': 5,
      'questions': [
        {
          'number': q['num'],
          'content': q['content'],
          'options': q['options'],
          'answer': q['answer'],
          'explanation': q['explanation'],
          'tags': q['tags']
        }
      ]
    };
  }).toList();
}

List<Map<String, dynamic>> buildPart6() {
  final passages = [
    // Passage 1: Q131-134 (Data Security & GDPR Compliance Policy)
    {
      'part': 6,
      'text': 'POLICY DIRECTIVE: GLOBAL DATA PROTECTION AND ENCRYPTION PROTOCOLS\n'
          'Effective Date: January 1\n'
          'To: All Personnel and Contracted Associates\n\n'
          'In light of updated international data protection regulations, Vanguard Financial Group has established rigorous data handling mandates across all global business units. Effective immediately, all electronic communications transmitting customer personal identifiable information must utilize AES-256 bit encryption. [131] -------, unencrypted storage of client records on unauthorized portable storage drives is strictly prohibited.\n\n'
          'Department supervisors are directly [132] ------- for ensuring that all subordinate personnel complete the mandatory biometric security verification modules before the end of the current billing cycle. [133] -------. Failure to complete this required accreditation will result in the immediate revocation of internal enterprise system credentials.\n\n'
          'Any discovered security breach or accidental transmission must be reported [134] ------- to the chief information security officer within two hours of identification.',
      'qs': [
        {
          'num': 131,
          'c': 'Choose the best transition word to fill in blank [131].',
          'opts': ['Furthermore', 'Conversely', 'Nevertheless', 'Instead'],
          'a': 'A',
          'exp': 'Liên từ nối bổ sung thông tin tăng cường: "Furthermore" (Hơn nữa / Thêm vào đó, việc lưu trữ không mã hóa trên ổ đĩa di động bị nghiêm cấm).'
        },
        {
          'num': 132,
          'c': 'Choose the best adjective form to fill in blank [132].',
          'opts': ['accountable', 'accountably', 'accountability', 'accounting'],
          'a': 'A',
          'exp': 'Cấu trúc "be directly accountable for + V-ing/N" (chịu trách nhiệm trực tiếp cho việc...) → chọn tính từ "accountable".'
        },
        {
          'num': 133,
          'c': 'Choose the best sentence to fill in blank [133].',
          'opts': [
            'These interactive training modules are accessible via the compliance portal.',
            'The executive dining room will remain closed during the winter holidays.',
            'All international flight bookings must be processed by corporate travel.',
            'Commercial real estate leases require three months of advance notice.'
          ],
          'a': 'A',
          'exp': 'Câu trước nhắc đến việc nhân viên phải hoàn thành các mô-đun xác minh bảo mật. Câu (A) nối tiếp cung cấp đường dẫn truy cập mô-đun học tập một cách chặt chẽ.'
        },
        {
          'num': 134,
          'c': 'Choose the best adverb to fill in blank [134].',
          'opts': ['promptly', 'prompt', 'promptness', 'prompting'],
          'a': 'A',
          'exp': 'Bổ nghĩa cho động từ thể bị động "must be reported" cần một phó từ chỉ thời gian cấp bách → chọn "promptly" (kịp thời, ngay lập tức).'
        }
      ]
    },
    // Passage 2: Q135-138 (Investor Letter: Postponement of Initial Public Offering)
    {
      'part': 6,
      'text': 'VALKYRIE AEROSPACE TECHNOLOGIES\n'
          'Confidential Investor Communique\n'
          'Date: October 14\n\n'
          'Dear Shareholders,\n\n'
          'We are writing to provide a transparent update regarding our scheduled Initial Public Offering (IPO) on the New York Stock Exchange. Following an extensive evaluation of macroeconomic conditions and recent interest rate adjustments by central banks, our board of directors has decided to [135] ------- our public listing until the second quarter of next year.\n\n'
          'While our fundamental balance sheet and revenue growth remain exceptionally robust, current market volatility has depressed market valuations across the aerospace sector. [136] -------. By delaying the offering, we aim to protect long-term shareholder equity and ensure an optimal capital valuation upon market debut.\n\n'
          'During this interim period, we will focus aggressively on fulfilling our multi-year defense satellite contracts. Our proprietary ion-propulsion thrusters have passed rigorous thermal vacuum endurance testing [137] ------- our internal engineering roadmap. We remain deeply [138] ------- for your continued confidence and partnership.',
      'qs': [
        {
          'num': 135,
          'c': 'Choose the best verb to fill in blank [135].',
          'opts': ['postpone', 'accelerate', 'liquidate', 'terminate'],
          'a': 'A',
          'exp': 'Dựa vào ngữ cảnh câu và câu sau ("By delaying the offering"), ban giám đốc quyết định hoãn đợt IPO sang quý 2 năm sau → chọn "postpone" (trì hoãn).'
        },
        {
          'num': 136,
          'c': 'Choose the best sentence to fill in blank [136].',
          'opts': [
            'Proceeding under current conditions would result in suboptimal share pricing.',
            'Our corporate headquarters will relocate to Houston by the end of this month.',
            'Several junior software developers have resigned to join competing firms.',
            'All physical stock certificates must be surrendered to the city registrar.'
          ],
          'a': 'A',
          'exp': 'Câu trước nói về định giá ngành hàng không bị suy giảm do thị trường biến động. Câu (A) nối tiếp giải thích: việc tiếp tục IPO lúc này sẽ dẫn đến giá cổ phiếu thấp không như kỳ vọng.'
        },
        {
          'num': 137,
          'c': 'Choose the best prepositional phrase to fill in blank [137].',
          'opts': ['in accordance with', 'contrary to', 'on behalf of', 'in place of'],
          'a': 'A',
          'exp': 'Cụm giới từ chỉ sự phù hợp với lộ trình kỹ thuật: "in accordance with our internal engineering roadmap" (đúng theo lộ trình kỹ thuật nội bộ).'
        },
        {
          'num': 138,
          'c': 'Choose the best adjective form to fill in blank [138].',
          'opts': ['grateful', 'gratefully', 'gratitude', 'grating'],
          'a': 'A',
          'exp': 'Cấu trúc "remain deeply + adj" (vẫn luôn vô cùng biết ơn...) → chọn tính từ "grateful".'
        }
      ]
    },
    // Passage 3: Q139-142 (Service Level Agreement & Consequential Damages Clause)
    {
      'part': 6,
      'text': 'ENTERPRISE CLOUD INFRASTRUCTURE SLA\n'
          'Section 14: Limitation of Liability and Indemnification\n\n'
          'Except as expressly outlined in Section 8 regarding gross negligence, neither party shall be held liable under any circumstances for any indirect, incidental, or [139] ------- damages, including loss of profits, revenue, or business reputation.\n\n'
          'The cloud hosting provider guarantees an annual server uptime threshold of ninety-nine point nine percent. [140] ------- this guaranteed threshold be breached during any calendar billing month, the customer shall be entitled to receive service credits as stipulated in Exhibit B. [141] -------. Such credits shall serve as the customer\'s sole and exclusive remedy for service interruptions.\n\n'
          'All claims for service performance credits must be submitted in writing within thirty calendar days of the alleged service outage, accompanied by detailed server [142] ------- records.',
      'qs': [
        {
          'num': 139,
          'c': 'Choose the best adjective to fill in blank [139].',
          'opts': ['consequential', 'consequence', 'consequently', 'consequent'],
          'a': 'A',
          'exp': 'Thuật ngữ pháp lý kinh tế chuẩn mực: "consequential damages" = các thiệt hại gián tiếp phát sinh từ vi phạm hợp đồng.'
        },
        {
          'num': 140,
          'c': 'Choose the best conditional inversion word to fill in blank [140].',
          'opts': ['Should', 'Were', 'Had', 'Unless'],
          'a': 'A',
          'exp': 'Đảo ngữ câu điều kiện loại 1 với "Should this guaranteed threshold be breached..." (= If this guaranteed threshold is breached...).'
        },
        {
          'num': 141,
          'c': 'Choose the best sentence to fill in blank [141].',
          'opts': [
            'Service credits cannot be redeemed for physical currency under any circumstance.',
            'Our corporate legal division was established over twenty-five years ago.',
            'All annual employee parking permits must be validated at the front entrance.',
            'Software developers should update their laptop operating systems today.'
          ],
          'a': 'A',
          'exp': 'Câu trước nói về việc khách hàng được nhận tín dụng dịch vụ (service credits). Câu (A) bổ sung quy định pháp lý: tín dụng này không được quy đổi thành tiền mặt.'
        },
        {
          'num': 142,
          'c': 'Choose the best noun to fill in blank [142].',
          'opts': ['telemetry', 'telepathic', 'telephoned', 'teleconference'],
          'a': 'A',
          'exp': 'Dữ liệu đo đạc kỹ thuật máy chủ: "detailed server telemetry records" (hồ sơ đo đạc dữ liệu viễn trắc của máy chủ).'
        }
      ]
    },
    // Passage 4: Q143-146 (Board Announcement: Post-Merger Cultural Transformation)
    {
      'part': 6,
      'text': 'EXECUTIVE BOARD BULLETIN\n'
          'Subject: Fostering Synergy and Integration Following the Apex-Nexa Merger\n\n'
          'As we mark the completion of the formal corporate merger between Apex Solutions and Nexa Robotics, our overarching priority is aligning our organizational cultures to drive collaborative innovation. [143] ------- our individual histories of pioneering technological breakthroughs, our combined future demands a unified operational mindset.\n\n'
          'To facilitate seamless cross-functional collaboration, a joint transformation steering taskforce has been [144] -------. This committee comprises leaders from product engineering, human resources, and business analytics. [145] -------. Beginning next week, the taskforce will host open town hall forums across all regional campuses to address employee inquiries directly.\n\n'
          'We encourage every team member to participate actively and share constructive feedback as we [146] ------- on this transformative chapter in our corporate journey.',
      'qs': [
        {
          'num': 143,
          'c': 'Choose the best preposition to fill in blank [143].',
          'opts': ['Notwithstanding', 'Although', 'Despite of', 'Whereas'],
          'a': 'A',
          'exp': 'Theo sau là cụm danh từ "our individual histories of pioneering..." mang nghĩa nhượng bộ → chọn "Notwithstanding" (= Dẫu cho lịch sử riêng biệt của mỗi bên...).'
        },
        {
          'num': 144,
          'c': 'Choose the best verb form to fill in blank [144].',
          'opts': ['established', 'establishes', 'establishing', 'establishment'],
          'a': 'A',
          'exp': 'Cấu trúc bị động hiện tại hoàn thành: "has been + V3/ed" → chọn "established" (đã được thành lập).'
        },
        {
          'num': 145,
          'c': 'Choose the best sentence to fill in blank [145].',
          'opts': [
            'Their mandate is to streamline internal workflows and harmonize workplace policies.',
            'Our quarterly dividend payout was deposited into employee checking accounts.',
            'Conference room bookings can be reserved via the receptionist mobile application.',
            'The cafeteria will discontinue its specialty breakfast buffet next Tuesday.'
          ],
          'a': 'A',
          'exp': 'Câu trước giới thiệu ban đặc nhiệm chuyển đổi gồm các lãnh đạo chủ chốt. Câu (A) nối tiếp nêu nhiệm vụ của họ: tinh gọn quy trình làm việc nội bộ và hài hòa các chính sách công sở.'
        },
        {
          'num': 146,
          'c': 'Choose the best verb to fill in blank [146].',
          'opts': ['embark', 'embarks', 'embarked', 'embarking'],
          'a': 'A',
          'exp': 'Mệnh đề hiện tại đơn với chủ ngữ "we": "as we embark on this transformative chapter" (khi chúng ta dấn thân / bước vào chương chuyển mình mới này).'
        }
      ]
    },
  ];

  return passages.map<Map<String, dynamic>>((p) {
    return <String, dynamic>{
      'part': 6,
      'passage': p['text'] as String,
      'questions': (p['qs'] as List).map<Map<String, dynamic>>((q) {
        final qm = q as Map<String, dynamic>;
        return <String, dynamic>{
          'number': qm['num'],
          'content': qm['c'],
          'options': qm['opts'],
          'answer': qm['a'],
          'explanation': qm['exp'],
          'tags': ['reading', 'text-completion']
        };
      }).toList()
    };
  }).toList();
}
