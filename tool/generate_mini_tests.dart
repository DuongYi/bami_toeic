import 'dart:convert';
import 'dart:io';

// Script tự động tạo 5 bộ đề Mini Test 25 câu đủ 7 Part (Part 1 -> Part 7),
// kèm tạo file ảnh SVG -> PNG (Part 1) và audio TTS (Part 1 - 4) bằng macOS 'say'.

class MiniTestData {
  final String id;
  final String title;
  final String description;
  final List<Map<String, dynamic>> groups;

  MiniTestData({
    required this.id,
    required this.title,
    required this.description,
    required this.groups,
  });
}

void main() async {
  stdout.writeln('🚀 Bắt đầu tạo 5 bộ đề Mini Test (25 câu, đủ Part 1 - 7)...');

  final tests = [
    _buildMiniTest01(),
    _buildMiniTest02(),
    _buildMiniTest03(),
    _buildMiniTest04(),
    _buildMiniTest05(),
  ];

  for (final t in tests) {
    final dir = Directory('content/tests/${t.id}');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    // 1. Ghi test.json
    final testJson = {
      'title': t.title,
      'source': 'Bami TOEIC - Mini Test 25Q',
      'description': t.description,
      'is_free': true,
      'groups': t.groups,
    };
    final jsonFile = File('${dir.path}/test.json');
    jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(testJson));
    stdout.writeln('  ✓ Đã ghi: ${jsonFile.path}');

    // 2. Tạo hình ảnh Part 1 và audio Part 1 - 4
    for (final g in t.groups) {
      final image = g['image'] as String?;
      final audio = g['audio'] as String?;
      final svgContent = g['_svg'] as String?;
      final voiceScript = g['_speech'] as String?;

      // Tạo file ảnh PNG từ SVG
      if (image != null && svgContent != null) {
        final svgFile = File('${dir.path}/$image.svg');
        svgFile.writeAsStringSync(svgContent);
        final res = Process.runSync('qlmanage', ['-t', '-s', '800', '-o', dir.path, svgFile.path]);
        if (res.exitCode == 0) {
          final generatedPng = File('${dir.path}/$image.svg.png');
          if (generatedPng.existsSync()) {
            final targetPng = File('${dir.path}/$image');
            if (targetPng.existsSync()) targetPng.deleteSync();
            generatedPng.renameSync(targetPng.path);
            svgFile.deleteSync();
          }
        }
      }

      // Tạo file âm thanh .m4a bằng macOS say
      if (audio != null && voiceScript != null) {
        final audioFile = File('${dir.path}/$audio');
        Process.runSync('say', ['-v', 'Samantha', voiceScript, '-o', audioFile.path]);
      }
    }
  }

  // 3. Tạo file master SQL cho Supabase SQL Editor
  _generateSqlSeed(tests);

  stdout.writeln('🎉 Hoàn tất tạo 5 bộ đề Mini Test 25 câu!');
}

void _generateSqlSeed(List<MiniTestData> tests) {
  final buffer = StringBuffer();
  buffer.writeln('-- =================================================================');
  buffer.writeln('-- BAMI TOEIC: 5 BỘ ĐỀ MINI TEST 25 CÂU ĐỦ 7 PART (SEED DATA)');
  buffer.writeln('-- Dành cho Supabase Dashboard -> SQL Editor -> Run');
  buffer.writeln('-- =================================================================');
  buffer.writeln();
  buffer.writeln('BEGIN;');
  buffer.writeln();
  buffer.writeln('-- Xóa dữ liệu cũ của các đề Mini Test 25Q nếu có');
  buffer.writeln("DELETE FROM public.tests WHERE title LIKE 'Mini Test 25Q - Đề %';");
  buffer.writeln();

  for (final t in tests) {
    buffer.writeln('-- -------------------------------------------------------------');
    buffer.writeln('-- BỘ ĐỀ: ${t.title}');
    buffer.writeln('-- -------------------------------------------------------------');
    buffer.writeln('DO \$\$');
    buffer.writeln('DECLARE');
    buffer.writeln('  v_test_id uuid;');
    buffer.writeln('  v_group_id uuid;');
    buffer.writeln('BEGIN');
    buffer.writeln('  INSERT INTO public.tests (title, source, description, is_free)');
    buffer.writeln('  VALUES (');
    buffer.writeln("    '${_escape(t.title)}',");
    buffer.writeln("    'Bami TOEIC - Mini Test 25Q',");
    buffer.writeln("    '${_escape(t.description)}',");
    buffer.writeln('    true');
    buffer.writeln('  )');
    buffer.writeln('  RETURNING id INTO v_test_id;');
    buffer.writeln();

    int orderNo = 1;
    for (final g in t.groups) {
      final part = g['part'] as int;
      final passage = g['passage'] as String?;
      final transcript = g['transcript'] as String?;
      final audio = g['audio'] as String?;
      final image = g['image'] as String?;
      final questions = g['questions'] as List<dynamic>;

      buffer.writeln('  -- Group #$orderNo (Part $part)');
      buffer.writeln('  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)');
      buffer.writeln('  VALUES (');
      buffer.writeln('    v_test_id,');
      buffer.writeln('    $part,');
      buffer.writeln('    $orderNo,');
      buffer.writeln(passage != null ? "    '${_escape(passage)}'," : '    NULL,');
      buffer.writeln(transcript != null ? "    '${_escape(transcript)}'," : '    NULL,');
      buffer.writeln(audio != null ? "    'tests/${t.id}/$audio'," : '    NULL,');
      buffer.writeln(image != null ? "    'tests/${t.id}/$image'" : '    NULL');
      buffer.writeln('  )');
      buffer.writeln('  RETURNING id INTO v_group_id;');
      buffer.writeln();

      for (final q in questions) {
        final number = q['number'] as int;
        final content = (q['content'] as String?) ?? 'Choose the best option for question $number.';
        final options = jsonEncode(q['options'] ?? ['(A)', '(B)', '(C)', '(D)']);
        final answer = q['answer'] as String;
        final explanation = q['explanation'] as String?;
        final tags = q['tags'] as List<dynamic>?;

        buffer.writeln('  -- Question $number');
        buffer.writeln('  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)');
        buffer.writeln('  VALUES (');
        buffer.writeln('    v_test_id,');
        buffer.writeln('    v_group_id,');
        buffer.writeln('    $part,');
        buffer.writeln('    $number,');
        buffer.writeln("    '${_escape(content)}',");
        buffer.writeln("    '${_escape(options)}'::jsonb,");
        buffer.writeln("    '${_escape(answer)}',");
        buffer.writeln(explanation != null ? "    '${_escape(explanation)}'," : '    NULL,');
        buffer.writeln('    ${_arrayToSql(tags)}');
        buffer.writeln('  );');
      }
      buffer.writeln();
      orderNo++;
    }

    buffer.writeln('END \$\$;');
    buffer.writeln();
  }

  buffer.writeln('COMMIT;');
  buffer.writeln();
  buffer.writeln('-- Báo cáo tổng số câu hỏi theo từng đề:');
  buffer.writeln("SELECT t.title, COUNT(q.id) AS total_questions");
  buffer.writeln("FROM public.tests t");
  buffer.writeln("LEFT JOIN public.questions q ON q.test_id = t.id");
  buffer.writeln("WHERE t.title LIKE 'Mini Test 25Q - Đề %'");
  buffer.writeln("GROUP BY t.id, t.title");
  buffer.writeln("ORDER BY t.title;");

  File('supabase/seed_mini_tests.sql').writeAsStringSync(buffer.toString());
  stdout.writeln('  ✓ Đã sinh master SQL: supabase/seed_mini_tests.sql');
}

String _escape(String text) => text.replaceAll("'", "''");

String _arrayToSql(List<dynamic>? list) {
  if (list == null || list.isEmpty) return 'ARRAY[]::text[]';
  final items = list.map((e) => "'${_escape(e.toString())}'").join(', ');
  return 'ARRAY[$items]::text[]';
}

// =============================================================================
// NỘI DUNG CHI TIẾT 5 BỘ ĐỀ MINI TEST
// =============================================================================

MiniTestData _buildMiniTest01() {
  return MiniTestData(
    id: 'mini_test01',
    title: 'Mini Test 25Q - Đề 01',
    description: 'Đề thi 25 câu rút gọn chuẩn format TOEIC, bao quát cả 7 phần: Nghe hiểu tranh ảnh, Hỏi đáp, Hội thoại, Độc thoại & Đọc hiểu ngữ pháp, đoạn văn.',
    groups: [
      // Part 1 - Q1
      {
        'part': 1,
        'image': 'p1_q1.png',
        'audio': 'p1_q1.m4a',
        'transcript': '(A) A woman is organizing files in a cabinet. (B) A laptop has been left open on a wooden desk. (C) Some armchairs are arranged around a rug. (D) A coffee cup is being cleaned in the sink.',
        '_speech': 'Number 1. Look at the picture marked number 1 in your test book. (A) A woman is organizing files in a cabinet. (B) A laptop has been left open on a wooden desk. (C) Some armchairs are arranged around a rug. (D) A coffee cup is being cleaned in the sink.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#EAEFF5"/>
  <rect y="380" width="800" height="220" fill="#B5835A"/>
  <rect x="240" y="220" width="320" height="200" rx="12" fill="#1E293B"/>
  <rect x="255" y="235" width="290" height="170" rx="6" fill="#60A5FA"/>
  <polygon points="200,420 600,420 560,440 240,440" fill="#0F172A"/>
  <rect x="620" y="320" width="60" height="80" rx="8" fill="#F8FAFC"/>
  <circle cx="140" cy="340" r="35" fill="#10B981"/>
  <rect x="125" y="355" width="30" height="50" fill="#D97706"/>
</svg>''',
        'questions': [
          {
            'number': 1,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'A woman is organizing files in a cabinet.',
              'A laptop has been left open on a wooden desk.',
              'Some armchairs are arranged around a rug.',
              'A coffee cup is being cleaned in the sink.'
            ],
            'answer': 'B',
            'explanation': 'Trong bức tranh miêu tả một chiếc máy tính xách tay đang mở trên bàn gỗ cùng một tách cà phê và chậu cây nhỏ → Chọn (B).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 1 - Q2
      {
        'part': 1,
        'image': 'p1_q2.png',
        'audio': 'p1_q2.m4a',
        'transcript': '(A) Several bicycles are parked in front of a wooden fence. (B) A cyclist is pedaling down a busy avenue. (C) Vehicles are waiting at a traffic intersection. (D) A wooden barrier is being constructed by carpenters.',
        '_speech': 'Number 2. Look at the picture marked number 2 in your test book. (A) Several bicycles are parked in front of a wooden fence. (B) A cyclist is pedaling down a busy avenue. (C) Vehicles are waiting at a traffic intersection. (D) A wooden barrier is being constructed by carpenters.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#DBEAFE"/>
  <circle cx="680" cy="120" r="45" fill="#FBBF24"/>
  <rect y="420" width="800" height="180" fill="#9CA3AF"/>
  <rect y="220" width="800" height="20" fill="#854D0E"/>
  <rect y="300" width="800" height="20" fill="#854D0E"/>
  <rect x="150" y="180" width="20" height="240" fill="#713F12"/>
  <rect x="380" y="180" width="20" height="240" fill="#713F12"/>
  <rect x="620" y="180" width="20" height="240" fill="#713F12"/>
  <circle cx="200" cy="460" r="45" stroke="#1E293B" stroke-width="12" fill="none"/>
  <circle cx="330" cy="460" r="45" stroke="#1E293B" stroke-width="12" fill="none"/>
  <circle cx="480" cy="460" r="45" stroke="#1E293B" stroke-width="12" fill="none"/>
  <circle cx="610" cy="460" r="45" stroke="#1E293B" stroke-width="12" fill="none"/>
</svg>''',
        'questions': [
          {
            'number': 2,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'Several bicycles are parked in front of a wooden fence.',
              'A cyclist is pedaling down a busy avenue.',
              'Vehicles are waiting at a traffic intersection.',
              'A wooden barrier is being constructed by carpenters.'
            ],
            'answer': 'A',
            'explanation': 'Những chiếc xe đạp được xếp thành hàng phía trước hàng rào gỗ → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 2 - Q7
      {
        'part': 2,
        'audio': 'p2_q7.m4a',
        'transcript': 'M: Where is the annual shareholder meeting taking place this year?\nW: (A) In the third-floor auditorium. (B) Yes, every twelve months. (C) Mr. Davis delivered a great talk.',
        '_speech': 'Number 7. Where is the annual shareholder meeting taking place this year? (A) In the third-floor auditorium. (B) Yes, every twelve months. (C) Mr. Davis delivered a great talk.',
        'questions': [
          {
            'number': 7,
            'content': 'Where is the annual shareholder meeting taking place this year?',
            'options': [
              'In the third-floor auditorium.',
              'Yes, every twelve months.',
              'Mr. Davis delivered a great talk.'
            ],
            'answer': 'A',
            'explanation': 'Câu hỏi bắt đầu bằng "Where" hỏi địa điểm → phương án chỉ nơi chốn (A) "In the third-floor auditorium" là đáp án chính xác.',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q8
      {
        'part': 2,
        'audio': 'p2_q8.m4a',
        'transcript': 'W: When will the updated project schedule be distributed to the team?\nM: (A) Across the street from the clinic. (B) Later this afternoon by email. (C) Thirty team members in total.',
        '_speech': 'Number 8. When will the updated project schedule be distributed to the team? (A) Across the street from the clinic. (B) Later this afternoon by email. (C) Thirty team members in total.',
        'questions': [
          {
            'number': 8,
            'content': 'When will the updated project schedule be distributed to the team?',
            'options': [
              'Across the street from the clinic.',
              'Later this afternoon by email.',
              'Thirty team members in total.'
            ],
            'answer': 'B',
            'explanation': 'Câu hỏi bắt đầu bằng "When" hỏi thời gian hoàn thành → chọn (B) "Later this afternoon by email".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q9
      {
        'part': 2,
        'audio': 'p2_q9.m4a',
        'transcript': 'M: Would you like me to book your train tickets for the regional conference?\nW: (A) Thanks, but I have already arranged them. (B) The express train was delayed. (C) Yes, at station platform three.',
        '_speech': 'Number 9. Would you like me to book your train tickets for the regional conference? (A) Thanks, but I have already arranged them. (B) The express train was delayed. (C) Yes, at station platform three.',
        'questions': [
          {
            'number': 9,
            'content': 'Would you like me to book your train tickets for the regional conference?',
            'options': [
              'Thanks, but I have already arranged them.',
              'The express train was delayed.',
              'Yes, at station platform three.'
            ],
            'answer': 'A',
            'explanation': 'Lời đề nghị giúp đỡ "Would you like me to..." → phản hồi lịch sự từ chối khéo (A) "Cảm ơn, nhưng tôi đã tự thu xếp rồi".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 3 - Q32-34
      {
        'part': 3,
        'audio': 'p3_q32-34.m4a',
        'transcript': 'W: Good morning, Robert. Has the logistics company delivered our shipment of promotional brochures yet? The marketing expo starts tomorrow morning.\nM: I checked with the front desk ten minutes ago, Brenda, and the delivery driver said the truck was caught in severe highway traffic. They expect to arrive by 2:00 P.M.\nW: That gives us very little time to assemble the welcome packets before our booth opens.\nM: Don\'t worry. I will ask two interns from human resources to help us organize and fold the materials as soon as the boxes arrive.',
        '_speech': 'Questions 32 through 34 refer to the following conversation. Good morning, Robert. Has the logistics company delivered our shipment of promotional brochures yet? The marketing expo starts tomorrow morning. I checked with the front desk ten minutes ago, Brenda, and the delivery driver said the truck was caught in severe highway traffic. They expect to arrive by 2:00 P.M. That gives us very little time to assemble the welcome packets before our booth opens. Don\'t worry. I will ask two interns from human resources to help us organize and fold the materials as soon as the boxes arrive.',
        'questions': [
          {
            'number': 32,
            'content': 'What problem are the speakers discussing?',
            'options': [
              'A shipment of promotional brochures is delayed.',
              'An exhibition booth reservation was cancelled.',
              'A presentation room is too small for attendees.',
              'The budget for marketing materials was cut.'
            ],
            'answer': 'A',
            'explanation': 'Người phụ nữ hỏi về tài liệu quảng cáo và người nam giải thích xe tải giao hàng bị kẹt xe trên cao tốc đến 2h chiều mới tới → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 33,
            'content': 'When does the marketing expo begin?',
            'options': [
              'This afternoon at 2:00 P.M.',
              'Tomorrow morning',
              'Next Monday',
              'At the end of this month'
            ],
            'answer': 'B',
            'explanation': 'Người phụ nữ nói: "The marketing expo starts tomorrow morning" → Chọn (B).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 34,
            'content': 'How does the man propose to solve the schedule problem?',
            'options': [
              'By printing new brochures in the office',
              'By rescheduling the client presentation',
              'By recruiting interns to help assemble packets',
              'By contacting a different shipping vendor'
            ],
            'answer': 'C',
            'explanation': 'Người nam nói: "I will ask two interns from human resources to help us organize and fold the materials..." → Chọn (C).',
            'tags': ['listening', 'conversation']
          }
        ]
      },
      // Part 4 - Q71-73
      {
        'part': 4,
        'audio': 'p4_q71-73.m4a',
        'transcript': 'Attention all transit passengers traveling on the Silverline Express to Riverside Station. We regret to inform you that track maintenance between Oakfield and Pinecrest will temporarily suspend through-train service this weekend, starting Saturday at 6:00 A.M. Complimentary shuttle buses will operate outside Oakfield Station every ten minutes to transport passengers directly to Pinecrest. Standard train service will resume regular operations on Monday morning at 5:00 A.M. For real-time updates and alternative route suggestions, please visit our official website at www.metrorail.org or speak with a station agent.',
        '_speech': 'Questions 71 through 73 refer to the following announcement. Attention all transit passengers traveling on the Silverline Express to Riverside Station. We regret to inform you that track maintenance between Oakfield and Pinecrest will temporarily suspend through-train service this weekend, starting Saturday at 6:00 A.M. Complimentary shuttle buses will operate outside Oakfield Station every ten minutes to transport passengers directly to Pinecrest. Standard train service will resume regular operations on Monday morning at 5:00 A.M. For real-time updates and alternative route suggestions, please visit our official website at www.metrorail.org or speak with a station agent.',
        'questions': [
          {
            'number': 71,
            'content': 'Where is this announcement most likely being broadcast?',
            'options': [
              'Inside an airport departure lounge',
              'At a passenger train station',
              'At an automotive repair center',
              'Inside a regional ferry terminal'
            ],
            'answer': 'B',
            'explanation': 'Thông báo nhắc tới "transit passengers", "Silverline Express", "track maintenance", "train service" → phát tại ga tàu hỏa (B).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 72,
            'content': 'What will occur this weekend?',
            'options': [
              'Train ticket fares will increase by five percent.',
              'Train service between two stations will be temporarily suspended.',
              'A new express route to Riverside will open.',
              'Station parking lots will be closed for repaving.'
            ],
            'answer': 'B',
            'explanation': 'Thông báo nói: "track maintenance between Oakfield and Pinecrest will temporarily suspend through-train service this weekend" → Chọn (B).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 73,
            'content': 'What alternative transportation is provided for passengers?',
            'options': [
              'Free shuttle buses every ten minutes',
              'Discounted taxi vouchers',
              'Bicycle rental stations',
              'Ferry transit vouchers'
            ],
            'answer': 'A',
            'explanation': 'Thông báo nêu: "Complimentary shuttle buses will operate outside Oakfield Station every ten minutes..." → Chọn (A).',
            'tags': ['listening', 'talks']
          }
        ]
      },
      // Part 5 - Q101-105
      {
        'part': 5,
        'questions': [
          {
            'number': 101,
            'content': 'All invoice receipts must be forwarded ------- to the accounts payable division to ensure prompt processing.',
            'options': ['promptly', 'prompt', 'promptness', 'prompted'],
            'answer': 'A',
            'explanation': 'Bổ nghĩa cho động từ thể bị động "must be forwarded" cần một trạng từ chỉ cách thức → chọn "promptly" (kịp thời, ngay lập tức).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 102,
            'content': 'Ms. Kowalski demonstrated remarkable ------- when resolving the overseas client\'s shipping dispute.',
            'options': ['professionalism', 'professionally', 'professional', 'profess'],
            'answer': 'A',
            'explanation': 'Sau tính từ "remarkable" cần một danh từ làm tân ngữ cho động từ "demonstrated" → chọn danh từ "professionalism" (tác phong chuyên nghiệp).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 103,
            'content': 'Dr. Chen scheduled a virtual briefing to introduce ------- research proposal to the executive board.',
            'options': ['his', 'him', 'himself', 'he'],
            'answer': 'A',
            'explanation': 'Đứng trước cụm danh từ "research proposal" cần một tính từ sở hữu bổ nghĩa → chọn "his" (của ông ấy).',
            'tags': ['reading', 'pronoun']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 104,
            'content': 'The company offered all staff members flexible hours ------- commuter traffic could be minimized during rush hour.',
            'options': ['so that', 'because of', 'in order to', 'as if'],
            'answer': 'A',
            'explanation': 'Theo sau chỗ trống là mệnh đề có chủ ngữ và trợ động từ ("commuter traffic could be minimized...") biểu thị mục đích → chọn liên từ "so that" (để mà).',
            'tags': ['reading', 'conjunction']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 105,
            'content': 'Protective eyeglasses and earplugs are mandatory at all times ------- the manufacturing plant floor.',
            'options': ['throughout', 'between', 'against', 'onto'],
            'answer': 'A',
            'explanation': 'Giới từ "throughout" đi kèm địa điểm mang nghĩa "trên toàn bộ khuôn viên / khắp mặt sàn nhà máy sản xuất".',
            'tags': ['reading', 'preposition']
          }
        ]
      },
      // Part 6 - Q131-134
      {
        'part': 6,
        'passage': 'MEMORANDUM\nTo: All Headquarters Personnel\nFrom: Facilities & Operations Committee\nDate: October 14\nSubject: Scheduled Corporate Office Relocation\n\nAs previously communicated, our headquarters will transition to the modern Diamond Tower complex over the upcoming weekend. The relocation procedures will begin on Friday at 5:00 P.M. and continue [131] ------- Sunday evening.\n\nAll team members are requested to pack their personal desktop items and sensitive documents into the provided blue plastic crates before departing on Friday afternoon. [132] -------. Cardboard boxes and color-coded destination labels will be distributed by the facilities team starting tomorrow at 9:00 A.M.\n\nPlease note that our new facility features an automated optical card reader system. You will receive your new permanent access badge [133] ------- upon checking in with the security desk on Monday morning. We sincerely appreciate your patience and [134] ------- as we finalize this exciting corporate transition.',
        'questions': [
          {
            'number': 131,
            'content': 'Choose the best preposition to fill in blank [131].',
            'options': ['through', 'across', 'between', 'among'],
            'answer': 'A',
            'explanation': 'Cụm diễn tả hành động liên tục đến hết một mốc thời gian: "continue through Sunday evening" (tiếp diễn liên tục xuyên suốt đến hết tối Chủ Nhật).',
            'tags': ['reading', 'preposition']
          },
          {
            'number': 132,
            'content': 'Choose the best sentence to fill in blank [132].',
            'options': [
              'Please ensure all storage crates are securely locked and clearly labeled.',
              'The cafeteria will launch a new seasonal lunch menu next month.',
              'Annual health insurance renewal documents must be signed by noon.',
              'Parking tickets can be validated at the front information counter.'
            ],
            'answer': 'A',
            'explanation': 'Câu trước nói về việc đóng gói đồ đạc vào thùng nhựa được cung cấp. Câu (A) nối tiếp dặn dò khóa và dán nhãn thùng chứa đồ một cách logic.',
            'tags': ['reading', 'context']
          },
          {
            'number': 133,
            'content': 'Choose the best adverb to fill in blank [133].',
            'options': ['promptly', 'prompt', 'promptness', 'prompting'],
            'answer': 'A',
            'explanation': 'Bổ nghĩa cho cụm động từ "will receive your new permanent access badge" cần trạng từ → chọn "promptly" (ngay lập tức khi điểm danh sáng thứ Hai).',
            'tags': ['reading', 'word-form']
          },
          {
            'number': 134,
            'content': 'Choose the best word form to fill in blank [134].',
            'options': ['cooperation', 'cooperate', 'cooperative', 'cooperatively'],
            'answer': 'A',
            'explanation': 'Sau tính từ sở hữu "your" và đi liền sau danh từ "patience and..." cần một danh từ đồng vị → chọn "cooperation" (sự hợp tác).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      // Part 7 - Group 1 (Passage 1: Q147-148)
      {
        'part': 7,
        'passage': 'OFFICEPRO EQUIPMENT DIRECT\nOrder Confirmation & Delivery Schedule\nOrder Number: OP-92481\nRecipient: Ms. Laura Chen, Operations Director, Apex Studio\nOrder Date: October 12\n\nItems Purchased:\n• 12 Ergonomic Mesh Executive Chairs (Model EC-200): \$2,400.00\n• 6 Motorized Adjustable Standing Desks (Model SD-50): \$1,800.00\nSubtotal: \$4,200.00\nCorporate Volume Discount (10% on orders above \$3,000): -\$420.00\nFreight Delivery: Complimentary\nTotal Paid: \$3,780.00\n\nDelivery Instructions:\nYour items will be transported by Apex Freight and are slated to arrive at your facility on Thursday, October 16, between 9:00 A.M. and 1:00 P.M. An authorized company representative must be present to inspect items and sign the cargo bill of lading.\n\nNeed to modify your delivery window?\nPlease email our dispatch unit at logistics@officepro.com at least 24 hours prior to the scheduled delivery date to reschedule without incurring an administrative restocking penalty.',
        'questions': [
          {
            'number': 147,
            'content': 'Why did Ms. Chen\'s order qualify for a 10% discount?',
            'options': [
              'Because she placed an order exceeding \$3,000 in total value',
              'Because she paid the entire balance using a corporate charge card',
              'Because she agreed to accept an afternoon delivery slot',
              'Because she enrolled in an annual equipment maintenance plan'
            ],
            'answer': 'A',
            'explanation': 'Dòng chiết khấu nêu rõ: "Corporate Volume Discount (10% on orders above \$3,000)" → Đơn hàng vượt \$3,000 nên được giảm giá 10% (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 148,
            'content': 'What must Ms. Chen do to reschedule delivery without incurring a penalty fee?',
            'options': [
              'Email customer support at least 24 hours before the delivery date',
              'Visit the regional distribution warehouse in person',
              'Return half of the ordered standing desks',
              'Pay an expedited shipping surcharge upon driver arrival'
            ],
            'answer': 'A',
            'explanation': 'Đoạn cuối: "Please email our dispatch unit at logistics@officepro.com at least 24 hours prior to the scheduled delivery date..." → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      },
      // Part 7 - Group 2 (Passage 2: Q152-154)
      {
        'part': 7,
        'passage': 'E-MAIL 1\nFrom: Martin Vance <mvance@vancestrat.com>\nTo: Clara Higgins <chiggins@brightonhotel.com>\nDate: November 4\nSubject: Annual Leadership Retreat Reservation\n\nDear Ms. Higgins,\nOn behalf of Vance Strategy Group, I would like to reserve the Horizon Conference Room at the Brighton Hotel for our upcoming Executive Leadership Retreat on December 15. We anticipate 35 attendees and will require an audiovisual setup with dual projection screens and wireless lapel microphones. Additionally, we would like a hot buffet luncheon served at 12:30 P.M. Could you please send me a cost estimate and confirm availability?\n\nSincerely,\nMartin Vance, Senior Partner\n\n────────────────────────────────────────────────────────\n\nE-MAIL 2\nFrom: Clara Higgins <chiggins@brightonhotel.com>\nTo: Martin Vance <mvance@vancestrat.com>\nDate: November 5\nSubject: RE: Annual Leadership Retreat Reservation\n\nDear Mr. Vance,\nThank you for choosing the Brighton Hotel! I am happy to confirm that the Horizon Conference Room is available on December 15. We have reserved the room from 8:00 A.M. to 5:00 P.M. Our standard audiovisual conference package includes the dual projection screens and wireless microphones you requested.\n\nHowever, our culinary team will be hosting a large holiday banquet in the main ballroom that afternoon. Therefore, luncheon service in the Horizon Suite will need to be served thirty minutes earlier, at 12:00 P.M. Please review the attached banquet contract and return a signed copy along with a 20% deposit by November 20 to secure the booking.\n\nWarm regards,\nClara Higgins, Events Manager',
        'questions': [
          {
            'number': 152,
            'content': 'What is the purpose of Mr. Vance\'s email?',
            'options': [
              'To reserve meeting space and catering for a company retreat',
              'To file a formal complaint regarding faulty audiovisual equipment',
              'To apply for a vacant event coordinator position',
              'To cancel an existing conference room reservation'
            ],
            'answer': 'A',
            'explanation': 'Mr. Vance viết thư để đặt phòng Horizon và dịch vụ ăn uống tiệc trưa cho 35 người tham gia kỳ nghỉ dưỡng ban lãnh đạo → Chọn (A).',
            'tags': ['reading', 'main-idea']
          },
          {
            'number': 153,
            'content': 'What adjustment does Ms. Higgins propose regarding lunch?',
            'options': [
              'Serving the luncheon thirty minutes earlier at 12:00 P.M.',
              'Moving the dining area to an outdoor terrace',
              'Replacing the hot buffet with cold sandwich platters',
              'Postponing lunch service until 1:30 P.M.'
            ],
            'answer': 'A',
            'explanation': 'Ms. Higgins giải thích khách sạn có tiệc lớn ở đại sảnh nên: "luncheon service in the Horizon Suite will need to be served thirty minutes earlier, at 12:00 P.M." → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 154,
            'content': 'What must Mr. Vance do by November 20?',
            'options': [
              'Submit a signed contract and a 20% deposit',
              'Confirm the dietary restrictions of all 35 attendees',
              'Pay the full rental balance in advance',
              'Inspect the Horizon Conference Room in person'
            ],
            'answer': 'A',
            'explanation': 'Đoạn cuối e-mail 2: "Please review the attached banquet contract and return a signed copy along with a 20% deposit by November 20..." → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      }
    ],
  );
}

MiniTestData _buildMiniTest02() {
  return MiniTestData(
    id: 'mini_test02',
    title: 'Mini Test 25Q - Đề 02',
    description: 'Chủ đề Tuyển dụng, Đào tạo nhân sự & Phát triển nghề nghiệp: 25 câu đủ 7 phần kiểm tra năng lực phản xạ nghe và đọc hiểu TOEIC.',
    groups: [
      // Part 1 - Q1
      {
        'part': 1,
        'image': 'p1_q1.png',
        'audio': 'p1_q1.m4a',
        'transcript': '(A) A speaker is standing near a whiteboard. (B) Some chairs are stacked against the back wall. (C) Documents are being passed around the boardroom. (D) A technician is replacing a ceiling projector bulb.',
        '_speech': 'Number 1. Look at the picture marked number 1 in your test book. (A) A speaker is standing near a whiteboard. (B) Some chairs are stacked against the back wall. (C) Documents are being passed around the boardroom. (D) A technician is replacing a ceiling projector bulb.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#F1F5F9"/>
  <rect y="420" width="800" height="180" fill="#CBD5E1"/>
  <rect x="120" y="100" width="340" height="220" rx="8" fill="#FFFFFF" stroke="#94A3B8" stroke-width="8"/>
  <line x1="160" y1="160" x2="380" y2="160" stroke="#0284C7" stroke-width="12" stroke-linecap="round"/>
  <line x1="160" y1="210" x2="320" y2="210" stroke="#0284C7" stroke-width="12" stroke-linecap="round"/>
  <circle cx="580" cy="220" r="45" fill="#3B82F6"/>
  <rect x="540" y="270" width="80" height="170" rx="16" fill="#1E40AF"/>
  <line x1="560" y1="440" x2="560" y2="560" stroke="#1E3A8A" stroke-width="20" stroke-linecap="round"/>
  <line x1="600" y1="440" x2="600" y2="560" stroke="#1E3A8A" stroke-width="20" stroke-linecap="round"/>
</svg>''',
        'questions': [
          {
            'number': 1,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'A speaker is standing near a whiteboard.',
              'Some chairs are stacked against the back wall.',
              'Documents are being passed around the boardroom.',
              'A technician is replacing a ceiling projector bulb.'
            ],
            'answer': 'A',
            'explanation': 'Bức tranh miêu tả một người đang đứng thuyết trình cạnh bảng trắng trong phòng hội thảo → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 1 - Q2
      {
        'part': 1,
        'image': 'p1_q2.png',
        'audio': 'p1_q2.m4a',
        'transcript': '(A) Shelves in a library are stocked with reference books. (B) A customer is paying at a retail checkout counter. (C) Boxes are being unloaded from a cargo van. (D) A ladder is leaning against a brick wall.',
        '_speech': 'Number 2. Look at the picture marked number 2 in your test book. (A) Shelves in a library are stocked with reference books. (B) A customer is paying at a retail checkout counter. (C) Boxes are being unloaded from a cargo van. (D) A ladder is leaning against a brick wall.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#FEF3C7"/>
  <rect x="100" y="80" width="600" height="440" rx="12" fill="#78350F"/>
  <rect x="140" y="110" width="520" height="110" fill="#451A03"/>
  <rect x="140" y="240" width="520" height="110" fill="#451A03"/>
  <rect x="140" y="370" width="520" height="110" fill="#451A03"/>
  <rect x="160" y="130" width="40" height="90" fill="#DC2626"/>
  <rect x="210" y="130" width="35" height="90" fill="#2563EB"/>
  <rect x="255" y="130" width="50" height="90" fill="#16A34A"/>
  <rect x="315" y="130" width="45" height="90" fill="#D97706"/>
  <rect x="160" y="260" width="55" height="90" fill="#9333EA"/>
  <rect x="225" y="260" width="40" height="90" fill="#0D9488"/>
  <rect x="275" y="260" width="60" height="90" fill="#E11D48"/>
</svg>''',
        'questions': [
          {
            'number': 2,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'Shelves in a library are stocked with reference books.',
              'A customer is paying at a retail checkout counter.',
              'Boxes are being unloaded from a cargo van.',
              'A ladder is leaning against a brick wall.'
            ],
            'answer': 'A',
            'explanation': 'Các kệ sách được sắp xếp ngay ngắn đầy các cuốn sách → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 2 - Q7
      {
        'part': 2,
        'audio': 'p2_q7.m4a',
        'transcript': 'W: Who will be conducting the orientation for our incoming software engineers?\nM: (A) David from the talent acquisition team. (B) In the fourth-floor seminar room. (C) It starts tomorrow at nine.',
        '_speech': 'Number 7. Who will be conducting the orientation for our incoming software engineers? (A) David from the talent acquisition team. (B) In the fourth-floor seminar room. (C) It starts tomorrow at nine.',
        'questions': [
          {
            'number': 7,
            'content': 'Who will be conducting the orientation for our incoming software engineers?',
            'options': [
              'David from the talent acquisition team.',
              'In the fourth-floor seminar room.',
              'It starts tomorrow at nine.'
            ],
            'answer': 'A',
            'explanation': 'Hỏi "Who" về người phụ trách → Chọn (A) "David from the talent acquisition team".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q8
      {
        'part': 2,
        'audio': 'p2_q8.m4a',
        'transcript': 'M: Did you send the revised job description to the hiring manager?\nW: (A) Yes, I emailed it first thing this morning. (B) He was hired as a systems analyst. (C) About thirty applicants applied.',
        '_speech': 'Number 8. Did you send the revised job description to the hiring manager? (A) Yes, I emailed it first thing this morning. (B) He was hired as a systems analyst. (C) About thirty applicants applied.',
        'questions': [
          {
            'number': 8,
            'content': 'Did you send the revised job description to the hiring manager?',
            'options': [
              'Yes, I emailed it first thing this morning.',
              'He was hired as a systems analyst.',
              'About thirty applicants applied.'
            ],
            'answer': 'A',
            'explanation': 'Câu hỏi Yes/No trong quá khứ → xác nhận đã gửi qua email vào đầu giờ sáng nay (A).',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q9
      {
        'part': 2,
        'audio': 'p2_q9.m4a',
        'transcript': 'W: Shouldn\'t we order more copies of the employee benefits booklet?\nM: (A) We still have three unopened boxes in storage. (B) The human resources office is on level two. (C) Yes, she received the benefit.',
        '_speech': 'Number 9. Shouldn\'t we order more copies of the employee benefits booklet? (A) We still have three unopened boxes in storage. (B) The human resources office is on level two. (C) Yes, she received the benefit.',
        'questions': [
          {
            'number': 9,
            'content': 'Shouldn\'t we order more copies of the employee benefits booklet?',
            'options': [
              'We still have three unopened boxes in storage.',
              'The human resources office is on level two.',
              'Yes, she received the benefit.'
            ],
            'answer': 'A',
            'explanation': 'Câu hỏi phủ định gợi ý đặt thêm tài liệu → trả lời gián tiếp là trong kho vẫn còn 3 thùng chưa mở (A).',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 3 - Q32-34
      {
        'part': 3,
        'audio': 'p3_q32-34.m4a',
        'transcript': 'M: Rebecca, have you finalized the interview schedule for the senior graphic designer candidates?\nW: Almost, Kevin. We have three interviews lined up for Thursday, but one candidate, Alex Mercer, called to ask if we could reschedule his meeting to Friday morning due to a family emergency.\nM: That shouldn\'t be an issue. Room 302 is reserved for our creative team all day Friday. Let\'s confirm the new time with him.\nW: Great. I\'ll send him a confirmation email right away and notify the panel interviewers.',
        '_speech': 'Questions 32 through 34 refer to the following conversation. Rebecca, have you finalized the interview schedule for the senior graphic designer candidates? Almost, Kevin. We have three interviews lined up for Thursday, but one candidate, Alex Mercer, called to ask if we could reschedule his meeting to Friday morning due to a family emergency. That shouldn\'t be an issue. Room 302 is reserved for our creative team all day Friday. Let\'s confirm the new time with him. Great. I\'ll send him a confirmation email right away and notify the panel interviewers.',
        'questions': [
          {
            'number': 32,
            'content': 'What position are the speakers interviewing candidates for?',
            'options': [
              'Senior graphic designer',
              'Software quality tester',
              'Human resources director',
              'Financial risk analyst'
            ],
            'answer': 'A',
            'explanation': 'Người nam hỏi: "have you finalized the interview schedule for the senior graphic designer candidates?" → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 33,
            'content': 'Why did Alex Mercer request a schedule change?',
            'options': [
              'Because of a family emergency',
              'Because his train was cancelled',
              'Because he accepted another job offer',
              'Because he lost his portfolio files'
            ],
            'answer': 'A',
            'explanation': 'Người phụ nữ nói: "...ask if we could reschedule his meeting to Friday morning due to a family emergency" → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 34,
            'content': 'What will Rebecca do next?',
            'options': [
              'Send a confirmation email to the applicant',
              'Reserve conference room 302',
              'Print copies of the applicant\'s resume',
              'Interview another prospective designer'
            ],
            'answer': 'A',
            'explanation': 'Rebecca nói: "I\'ll send him a confirmation email right away..." → Chọn (A).',
            'tags': ['listening', 'conversation']
          }
        ]
      },
      // Part 4 - Q71-73
      {
        'part': 4,
        'audio': 'p4_q71-73.m4a',
        'transcript': 'Good morning, everyone, and welcome to Crestview Technologies. My name is Brian Foster from the employee development department, and I will be leading your orientation session today. Over the next three days, you will receive in-depth training on our internal software platforms, workplace safety standards, and corporate compliance policies. Before we begin our first module on cyber security protocols, please take a moment to log in to the tablets placed on your desks and complete the electronic emergency contact form. If you encounter any technical difficulty logging in, please raise your hand and a facilitator will assist you.',
        '_speech': 'Questions 71 through 73 refer to the following talk. Good morning, everyone, and welcome to Crestview Technologies. My name is Brian Foster from the employee development department, and I will be leading your orientation session today. Over the next three days, you will receive in-depth training on our internal software platforms, workplace safety standards, and corporate compliance policies. Before we begin our first module on cyber security protocols, please take a moment to log in to the tablets placed on your desks and complete the electronic emergency contact form. If you encounter any technical difficulty logging in, please raise your hand and a facilitator will assist you.',
        'questions': [
          {
            'number': 71,
            'content': 'Who most likely are the listeners?',
            'options': [
              'Newly hired company employees',
              'Visiting international tourists',
              'College students touring a computer laboratory',
              'Customers testing new tablet devices'
            ],
            'answer': 'A',
            'explanation': 'Người nói chào mừng nhân viên mới ("welcome to Crestview Technologies... leading your orientation session today") → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 72,
            'content': 'How long will the training program last?',
            'options': [
              'Three days',
              'One week',
              'Two hours',
              'Four months'
            ],
            'answer': 'A',
            'explanation': 'Người nói nêu rõ: "Over the next three days, you will receive in-depth training..." → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 73,
            'content': 'What are listeners instructed to do before the first module?',
            'options': [
              'Complete an electronic emergency contact form on their tablets',
              'Introduce themselves to the executive vice president',
              'Submit original college diploma certificates',
              'Take a written English comprehension examination'
            ],
            'answer': 'A',
            'explanation': 'Người nói dặn: "...please take a moment to log in to the tablets placed on your desks and complete the electronic emergency contact form" → Chọn (A).',
            'tags': ['listening', 'talks']
          }
        ]
      },
      // Part 5 - Q101-105
      {
        'part': 5,
        'questions': [
          {
            'number': 101,
            'content': 'All job applicants must fill out the employment history form ------- prior to entering the interview room.',
            'options': ['completely', 'complete', 'completing', 'completion'],
            'answer': 'A',
            'explanation': 'Bổ nghĩa cho cụm động từ vị ngữ "fill out the employment history form" cần một phó từ (adverb) chỉ thể cách → chọn "completely" (một cách đầy đủ, hoàn chỉnh).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 102,
            'content': 'The human resources committee expressed great ------- with the high caliber of candidate applications.',
            'options': ['satisfaction', 'satisfactory', 'satisfy', 'satisfying'],
            'answer': 'A',
            'explanation': 'Sau tính từ "great" cần danh từ làm tân ngữ trực tiếp cho động từ "expressed" → chọn "satisfaction" (sự hài lòng).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 103,
            'content': 'Ms. Sterling commended the summer interns for ------- outstanding contribution to the database migration.',
            'options': ['their', 'they', 'them', 'theirs'],
            'answer': 'A',
            'explanation': 'Đứng trước cụm danh từ "outstanding contribution" cần tính từ sở hữu số nhiều tương ứng với "summer interns" → chọn "their" (của họ).',
            'tags': ['reading', 'pronoun']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 104,
            'content': 'Applicants will not be invited for an executive interview ------- their background check passes scrutiny.',
            'options': ['unless', 'despite', 'because of', 'without'],
            'answer': 'A',
            'explanation': 'Theo sau là một mệnh đề hoàn chỉnh mang nghĩa điều kiện phủ định ("trừ phi việc xác minh lý lịch được thông qua") → chọn liên từ "unless" (= if not).',
            'tags': ['reading', 'conjunction']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 105,
            'content': 'The newly adopted corporate dress policy will remain in effect ------- the upcoming fiscal year.',
            'options': ['throughout', 'between', 'against', 'onto'],
            'answer': 'A',
            'explanation': 'Giới từ "throughout" đi với khoảng thời gian mang nghĩa "xuyên suốt / trong toàn bộ năm tài chính sắp tới".',
            'tags': ['reading', 'preposition']
          }
        ]
      },
      // Part 6 - Q131-134
      {
        'part': 6,
        'passage': 'MEMORANDUM\nTo: All Department Directors\nFrom: Eleanor Vance, Human Resources Vice President\nDate: September 8\nSubject: Promotion Announcement\n\nWe take tremendous pride in announcing the promotion of Daniel Thorne to the position of Senior Talent Acquisition Director, effective October 1. Over the last four years, Mr. Thorne has demonstrated outstanding leadership and strategic vision in modernizing our global hiring workflows. [131] ------- his tenure, our average onboarding time decreased by thirty-five percent.\n\nIn his expanded capacity, Mr. Thorne will spearhead executive recruitment initiatives and coordinate university internship partnerships. He will be directly [132] ------- for aligning our staffing roadmap with international branch targets. [133] -------. We are confident that his analytical acumen will continue to strengthen our workforce.\n\nPlease join us in the fifth-floor reception lounge this Friday at 4:30 P.M. to celebrate his promotion. Complimentary beverages and light hors d\'oeuvres will be [134] ------- by the corporate hospitality team.',
        'questions': [
          {
            'number': 131,
            'content': 'Choose the best preposition to fill in blank [131].',
            'options': ['During', 'Above', 'Between', 'Against'],
            'answer': 'A',
            'explanation': 'Cụm từ chỉ khoảng thời gian nhiệm kỳ: "During his tenure" = Trong suốt nhiệm kỳ của ông ấy.',
            'tags': ['reading', 'preposition']
          },
          {
            'number': 132,
            'content': 'Choose the best word to fill in blank [132].',
            'options': ['responsible', 'responsibly', 'responsibility', 'responsive'],
            'answer': 'A',
            'explanation': 'Cấu trúc cố định "be directly responsible for + V-ing/N" (chịu trách nhiệm trực tiếp cho...) → chọn tính từ "responsible".',
            'tags': ['reading', 'word-form']
          },
          {
            'number': 133,
            'content': 'Choose the best sentence to fill in blank [133].',
            'options': [
              'He will also mentor incoming recruiters across our European regional offices.',
              'The company budget for international travel was drastically reduced.',
              'All employees must renew their parking garage passes before Friday.',
              'The flight to Frankfurt was delayed due to winter storms.'
            ],
            'answer': 'A',
            'explanation': 'Câu trước nói về trách nhiệm mới của Daniel Thorne. Câu (A) bổ sung thêm trách nhiệm phù hợp ("Anh ấy cũng sẽ hướng dẫn các chuyên viên tuyển dụng mới...").',
            'tags': ['reading', 'context']
          },
          {
            'number': 134,
            'content': 'Choose the best verb form to fill in blank [134].',
            'options': ['provided', 'provides', 'providing', 'provision'],
            'answer': 'A',
            'explanation': 'Cấu trúc bị động tương lai: "will be + V3/ed" → chọn "provided" (sẽ được cung cấp bởi đội ngũ lễ tân).',
            'tags': ['reading', 'grammar']
          }
        ]
      },
      // Part 7 - Group 1 (Passage 1: Q147-148)
      {
        'part': 7,
        'passage': 'SUMMIT ENTERPRISE SOLUTIONS\nCareer Opportunity: Senior Cloud Systems Architect\nLocation: Austin, Texas (Hybrid: 3 days in office, 2 days remote)\n\nPosition Overview:\nSummit Enterprise Solutions is seeking a driven Senior Cloud Systems Architect to design, optimize, and maintain our high-throughput distributed infrastructure. The successful applicant will lead cross-functional engineering teams and implement scalable microservices solutions.\n\nMinimum Qualifications:\n• Bachelor\'s degree in Computer Science, Software Engineering, or equivalent practical experience.\n• At least 6 years of hands-on experience managing AWS or Google Cloud enterprise deployments.\n• Demonstrated proficiency in infrastructure automation tools (Terraform, Ansible, Kubernetes).\n\nCompensation & Benefits:\nWe offer an industry-competitive base salary (\$135,000–\$155,000), 100% employer-covered health and dental insurance, and a \$3,000 annual professional training allowance. Qualified applicants should email a cover letter, resume, and public code repository link to careers@summitenterprise.com no later than November 15.',
        'questions': [
          {
            'number': 147,
            'content': 'What is the primary purpose of the notice?',
            'options': [
              'To announce an open employment position',
              'To promote an upcoming cloud computing seminar',
              'To inform customers about scheduled server maintenance',
              'To request bids from external software contractors'
            ],
            'answer': 'A',
            'explanation': 'Tiêu đề "Career Opportunity: Senior Cloud Systems Architect" và nội dung miêu tả công việc, yêu cầu tuyển dụng cho thấy mục đích chính là đăng tin tuyển dụng (A).',
            'tags': ['reading', 'main-idea']
          },
          {
            'number': 148,
            'content': 'What is NOT stated as a required qualification for the role?',
            'options': [
              'A Master\'s degree in Business Administration',
              'A Bachelor\'s degree in Computer Science or related field',
              'At least 6 years managing enterprise cloud deployments',
              'Experience using infrastructure automation tools'
            ],
            'answer': 'A',
            'explanation': 'Yêu cầu chỉ ghi "Bachelor\'s degree in Computer Science...", không hề yêu cầu bằng thạc sĩ kinh doanh (MBA) → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      },
      // Part 7 - Group 2 (Passage 2: Q152-154)
      {
        'part': 7,
        'passage': 'MEMORANDUM 1\nTo: All Engineering Staff\nFrom: Derek Ward, VP of Product Engineering\nDate: August 10\nSubject: Professional Certification Reimbursement Program\n\nTo foster continuous technical innovation, Summit Enterprise will now sponsor employees pursuing industry-recognized certifications (e.g., AWS Certified Solutions Architect, CISSP, PMP). The company will reimburse 100% of exam registration fees and study materials up to \$1,500 per calendar year.\n\nTo be eligible, employees must have completed at least six months of continuous service and receive written approval from their department head prior to purchasing courses or exam vouchers. Invoices and passing certificates must be submitted to HR within 30 days of exam completion.\n\n────────────────────────────────────────────────────────\n\nMEMORANDUM 2\nTo: Derek Ward, VP of Product Engineering\nFrom: Priya Patel, Senior Systems Analyst\nDate: August 12\nSubject: Certification Approval Request\n\nDear Mr. Ward,\nI am writing to formally request sponsorship under our new Professional Certification Reimbursement Program. I have been with Summit Enterprise for over two years in the cloud infrastructure unit. I intend to sit for the AWS Certified DevOps Engineer exam scheduled on October 20. The preparation course and official exam voucher cost \$650 in total. My supervisor, Sandra Bullock, has already reviewed my application and endorsed my participation. Please let me know if you require any additional documentation.\n\nBest regards,\nPriya Patel',
        'questions': [
          {
            'number': 152,
            'content': 'What benefit does the new company policy introduce?',
            'options': [
              'Financial reimbursement for approved professional certification expenses',
              'Additional paid vacation days for employees completing training',
              'Complimentary laptop computers for home office use',
              'Free membership to a local athletic health club'
            ],
            'answer': 'A',
            'explanation': 'Chính sách công ty tài trợ 100% lệ phí thi và tài liệu ôn tập chứng chỉ chuyên môn lên tới \$1,500/năm → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 153,
            'content': 'Why is Priya Patel eligible for the program?',
            'options': [
              'She has worked at the company for more than six months',
              'She is the head of the human resources division',
              'She scored the highest mark on a corporate quiz',
              'She already passed the DevOps exam in August'
            ],
            'answer': 'A',
            'explanation': 'Điều kiện chính sách là làm việc ít nhất 6 tháng; Priya Patel cho biết cô đã làm việc tại công ty hơn hai năm ("over two years") → Chọn (A).',
            'tags': ['reading', 'inference']
          },
          {
            'number': 154,
            'content': 'How much funding is Priya requesting for her certification?',
            'options': [
              '\$650',
              '\$1,500',
              '\$3,000',
              '\$250'
            ],
            'answer': 'A',
            'explanation': 'Priya nêu rõ: "The preparation course and official exam voucher cost \$650 in total" → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      }
    ],
  );
}

MiniTestData _buildMiniTest03() {
  return MiniTestData(
    id: 'mini_test03',
    title: 'Mini Test 25Q - Đề 03',
    description: 'Chủ đề Tiếp thị, Dịch vụ khách hàng, Bán lẻ & Quản lý bảo trì: Đề thi mini 25 câu chất lượng cao rèn luyện cả kỹ năng Listening và Reading.',
    groups: [
      // Part 1 - Q1
      {
        'part': 1,
        'image': 'p1_q1.png',
        'audio': 'p1_q1.m4a',
        'transcript': '(A) A cashier is scanning merchandise at a register. (B) Clothing racks have been pushed against the glass door. (C) Customers are dining at an outdoor bistro table. (D) Mannequins are displayed in a storefront showcase.',
        '_speech': 'Number 1. Look at the picture marked number 1 in your test book. (A) A cashier is scanning merchandise at a register. (B) Clothing racks have been pushed against the glass door. (C) Customers are dining at an outdoor bistro table. (D) Mannequins are displayed in a storefront showcase.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#FDF2F8"/>
  <rect y="380" width="800" height="220" fill="#FCE7F3"/>
  <rect x="180" y="240" width="440" height="200" rx="16" fill="#DB2777"/>
  <rect x="240" y="160" width="120" height="90" rx="8" fill="#1E293B"/>
  <rect x="250" y="170" width="100" height="70" rx="4" fill="#67E8F9"/>
  <circle cx="540" cy="180" r="35" fill="#F472B6"/>
  <rect x="510" y="225" width="60" height="160" rx="12" fill="#BE185D"/>
  <rect x="380" y="260" width="60" height="70" fill="#F3F4F6"/>
</svg>''',
        'questions': [
          {
            'number': 1,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'A cashier is scanning merchandise at a register.',
              'Clothing racks have been pushed against the glass door.',
              'Customers are dining at an outdoor bistro table.',
              'Mannequins are displayed in a storefront showcase.'
            ],
            'answer': 'A',
            'explanation': 'Tranh vẽ cảnh thu ngân đang đứng tại quầy thanh toán với máy quét và hàng hóa → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 1 - Q2
      {
        'part': 1,
        'image': 'p1_q2.png',
        'audio': 'p1_q2.m4a',
        'transcript': '(A) Outdoor dining tables are shaded by large umbrellas. (B) Waitstaff are polishing wine glasses at the counter. (C) Street performers are gathering an audience. (D) Pedestrians are sheltering under a bus canopy.',
        '_speech': 'Number 2. Look at the picture marked number 2 in your test book. (A) Outdoor dining tables are shaded by large umbrellas. (B) Waitstaff are polishing wine glasses at the counter. (C) Street performers are gathering an audience. (D) Pedestrians are sheltering under a bus canopy.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#ECFDF5"/>
  <circle cx="700" cy="100" r="50" fill="#FBBF24"/>
  <rect y="420" width="800" height="180" fill="#D1D5DB"/>
  <polygon points="150,220 350,220 250,140" fill="#059669"/>
  <rect x="245" y="220" width="10" height="220" fill="#065F46"/>
  <rect x="180" y="380" width="140" height="50" rx="8" fill="#92400E"/>
  <polygon points="450,220 650,220 550,140" fill="#059669"/>
  <rect x="545" y="220" width="10" height="220" fill="#065F46"/>
  <rect x="480" y="380" width="140" height="50" rx="8" fill="#92400E"/>
</svg>''',
        'questions': [
          {
            'number': 2,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'Outdoor dining tables are shaded by large umbrellas.',
              'Waitstaff are polishing wine glasses at the counter.',
              'Street performers are gathering an audience.',
              'Pedestrians are sheltering under a bus canopy.'
            ],
            'answer': 'A',
            'explanation': 'Những chiếc bàn ăn ngoài trời được che bóng mát bởi những cây dù lớn → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 2 - Q7
      {
        'part': 2,
        'audio': 'p2_q7.m4a',
        'transcript': 'M: When does our promotional campaign for the autumn apparel line launch?\nW: (A) Early next month on social media. (B) Yes, autumn is my favorite season. (C) A twenty percent discount coupon.',
        '_speech': 'Number 7. When does our promotional campaign for the autumn apparel line launch? (A) Early next month on social media. (B) Yes, autumn is my favorite season. (C) A twenty percent discount coupon.',
        'questions': [
          {
            'number': 7,
            'content': 'When does our promotional campaign for the autumn apparel line launch?',
            'options': [
              'Early next month on social media.',
              'Yes, autumn is my favorite season.',
              'A twenty percent discount coupon.'
            ],
            'answer': 'A',
            'explanation': 'Hỏi "When" về thời điểm ra mắt chiến dịch tiếp thị → Chọn (A) "Early next month on social media".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q8
      {
        'part': 2,
        'audio': 'p2_q8.m4a',
        'transcript': 'W: Where can shoppers redeem their reward loyalty points?\nM: (A) At any checkout counter or online. (B) It earned five stars in reviews. (C) About forty reward points.',
        '_speech': 'Number 8. Where can shoppers redeem their reward loyalty points? (A) At any checkout counter or online. (B) It earned five stars in reviews. (C) About forty reward points.',
        'questions': [
          {
            'number': 8,
            'content': 'Where can shoppers redeem their reward loyalty points?',
            'options': [
              'At any checkout counter or online.',
              'It earned five stars in reviews.',
              'About forty reward points.'
            ],
            'answer': 'A',
            'explanation': 'Hỏi "Where" về địa điểm đổi điểm tích lũy → Chọn (A) "Tại bất kỳ quầy thu ngân nào hoặc trực tuyến".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q9
      {
        'part': 2,
        'audio': 'p2_q9.m4a',
        'transcript': 'M: Could you please review the draft of the press release before five o\'clock?\nW: (A) Certainly, I will read it right after lunch. (B) The printing press broke down. (C) Yes, exactly five copies.',
        '_speech': 'Number 9. Could you please review the draft of the press release before five o\'clock? (A) Certainly, I will read it right after lunch. (B) The printing press broke down. (C) Yes, exactly five copies.',
        'questions': [
          {
            'number': 9,
            'content': 'Could you please review the draft of the press release before five o\'clock?',
            'options': [
              'Certainly, I will read it right after lunch.',
              'The printing press broke down.',
              'Yes, exactly five copies.'
            ],
            'answer': 'A',
            'explanation': 'Lời đề nghị xem xét thông cáo báo chí "Could you please review..." → đồng ý sẵn lòng "Chắc chắn rồi, tôi sẽ đọc ngay sau bữa trưa" (A).',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 3 - Q32-34
      {
        'part': 3,
        'audio': 'p3_q32-34.m4a',
        'transcript': 'W: Hello, Mark. I was reviewing our customer satisfaction ratings for the third quarter, and while our delivery speed received glowing reviews, our online returns process scored below average.\nM: I noticed that as well, Hannah. Several customers left comments stating that printing physical return labels and finding drop-off lockers was cumbersome.\nW: Perhaps we should partner with a courier that provides QR-code drop-offs where customers don\'t need to print labels at home.\nM: That\'s a fantastic idea. I will contact Swift Logistics this afternoon to check their integration pricing.',
        '_speech': 'Questions 32 through 34 refer to the following conversation. Hello, Mark. I was reviewing our customer satisfaction ratings for the third quarter, and while our delivery speed received glowing reviews, our online returns process scored below average. I noticed that as well, Hannah. Several customers left comments stating that printing physical return labels and finding drop-off lockers was cumbersome. Perhaps we should partner with a courier that provides QR-code drop-offs where customers don\'t need to print labels at home. That\'s a fantastic idea. I will contact Swift Logistics this afternoon to check their integration pricing.',
        'questions': [
          {
            'number': 32,
            'content': 'What aspect of the company\'s service received low ratings?',
            'options': [
              'The online returns process',
              'The product packaging quality',
              'The speed of domestic delivery',
              'The accuracy of inventory counts'
            ],
            'answer': 'A',
            'explanation': 'Người phụ nữ nhận xét: "...our online returns process scored below average" → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 33,
            'content': 'What problem did customers mention in their reviews?',
            'options': [
              'Printing return labels was inconvenient',
              'Replacement items arrived damaged',
              'Customer service phone lines were busy',
              'The return window of 14 days was too short'
            ],
            'answer': 'A',
            'explanation': 'Người nam cho biết khách hàng phản ánh việc in nhãn đổi trả và tìm tủ nhận hàng phiền phức ("printing physical return labels ... was cumbersome") → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 34,
            'content': 'What will Mark do this afternoon?',
            'options': [
              'Contact a logistics courier about QR-code drop-offs',
              'Redesign the company\'s mobile shopping application',
              'Issue refunds to unsatisfied shoppers',
              'Survey retail store managers'
            ],
            'answer': 'A',
            'explanation': 'Mark nói: "I will contact Swift Logistics this afternoon to check their integration pricing" → Chọn (A).',
            'tags': ['listening', 'conversation']
          }
        ]
      },
      // Part 4 - Q71-73
      {
        'part': 4,
        'audio': 'p4_q71-73.m4a',
        'transcript': 'Attention Greenfield Mall shoppers. Thank you for visiting us this weekend. To celebrate the grand opening of our newly renovated East Wing, select fashion boutiques and tech stores are offering storewide discounts of up to thirty percent today only. Also, be sure to stop by the central atrium where our complimentary artisan coffee bar will be serving hot espresso drinks until 4:00 P.M. If you spend over fifty dollars at any participating store today, present your receipt at the customer service booth near Entrance B to receive a free canvas shopping tote.',
        '_speech': 'Questions 71 through 73 refer to the following announcement. Attention Greenfield Mall shoppers. Thank you for visiting us this weekend. To celebrate the grand opening of our newly renovated East Wing, select fashion boutiques and tech stores are offering storewide discounts of up to thirty percent today only. Also, be sure to stop by the central atrium where our complimentary artisan coffee bar will be serving hot espresso drinks until 4:00 P.M. If you spend over fifty dollars at any participating store today, present your receipt at the customer service booth near Entrance B to receive a free canvas shopping tote.',
        'questions': [
          {
            'number': 71,
            'content': 'What is being celebrated at Greenfield Mall?',
            'options': [
              'The grand opening of a renovated wing',
              'The mall\'s twentieth anniversary',
              'A national public holiday festival',
              'A regional student fashion competition'
            ],
            'answer': 'A',
            'explanation': 'Thông báo nêu: "To celebrate the grand opening of our newly renovated East Wing..." → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 72,
            'content': 'What is available in the central atrium until 4:00 P.M.?',
            'options': [
              'Complimentary artisan coffee drinks',
              'Live acoustic musical performances',
              'Automotive test drive bookings',
              'Free smartphone repair assessments'
            ],
            'answer': 'A',
            'explanation': 'Thông báo: "...complimentary artisan coffee bar will be serving hot espresso drinks until 4:00 P.M." → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 73,
            'content': 'How can shoppers qualify for a free canvas tote bag?',
            'options': [
              'By spending over fifty dollars at participating stores',
              'By signing up for an email newsletter',
              'By filling out a customer satisfaction survey',
              'By applying for a department store credit card'
            ],
            'answer': 'A',
            'explanation': 'Thông báo: "If you spend over fifty dollars at any participating store today, present your receipt ... to receive a free canvas shopping tote" → Chọn (A).',
            'tags': ['listening', 'talks']
          }
        ]
      },
      // Part 5 - Q101-105
      {
        'part': 5,
        'questions': [
          {
            'number': 101,
            'content': 'Participants found the interactive workshop on digital marketing analytics extremely -------.',
            'options': ['informative', 'inform', 'informatively', 'information'],
            'answer': 'A',
            'explanation': 'Cấu trúc "find + O + adj" (nhận thấy cái gì như thế nào) → sau phó từ chỉ mức độ "extremely" cần tính từ "informative" (bổ ích, hữu ích).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 102,
            'content': 'Hotel guests dining at the seaside restaurant are entitled to a complimentary breakfast ------- every morning.',
            'options': ['buffet', 'permit', 'contract', 'voucher'],
            'answer': 'A',
            'explanation': 'Cụm danh từ cố định trong ngành khách sạn "breakfast buffet" (bữa ăn sáng tự chọn).',
            'tags': ['reading', 'vocabulary']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 103,
            'content': 'Delegates attending the summit are requested to register ------- on the official event portal.',
            'options': ['themselves', 'they', 'them', 'theirs'],
            'answer': 'A',
            'explanation': 'Hành động đăng ký tác động lên chính chủ ngữ "Delegates" → dùng đại từ phản thân "themselves" (tự đăng ký).',
            'tags': ['reading', 'pronoun']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 104,
            'content': 'The technical seminar was rescheduled ------- the keynote speaker missed his connecting flight.',
            'options': ['because', 'due to', 'in spite of', 'as though'],
            'answer': 'A',
            'explanation': 'Theo sau là một mệnh đề hoàn chỉnh có chủ ngữ và động từ ("the keynote speaker missed his connecting flight") chỉ nguyên nhân → chọn liên từ "because".',
            'tags': ['reading', 'conjunction']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 105,
            'content': 'Customer parking spaces are situated directly ------- the primary supermarket entrance.',
            'options': ['behind', 'into', 'onto', 'during'],
            'answer': 'A',
            'explanation': 'Vị trí không gian của bãi đỗ xe so với cổng vào siêu thị → chọn giới từ nơi chốn "behind" (phía sau).',
            'tags': ['reading', 'preposition']
          }
        ]
      },
      // Part 6 - Q131-134
      {
        'part': 6,
        'passage': 'NOTICE TO ALL SYSTEM USERS\nFrom: IT Infrastructure & Operations\nDate: September 5\nSubject: Scheduled CRM System Maintenance\n\nPlease be advised that our central Customer Relationship Management (CRM) platform will undergo routine system maintenance this Saturday, September 9, beginning at 11:00 P.M. and concluding at 4:00 A.M. on Sunday morning.\n\nDuring this five-hour maintenance window, the database will be temporarily [131] ------- to all personnel. This maintenance is essential to deploy critical security patches and enhance server performance. [132] -------. We advise all sales and support representatives to finalize and save all active transaction records before logging off on Friday afternoon.\n\nIf you require urgent client contact records during the maintenance outage, please export the necessary files [133] ------- Saturday noon. Regular database operations will resume [134] ------- at 4:30 A.M. on Sunday.',
        'questions': [
          {
            'number': 131,
            'content': 'Choose the best word to fill in blank [131].',
            'options': ['inaccessible', 'accessible', 'accessibility', 'accessing'],
            'answer': 'A',
            'explanation': 'Trong thời gian hệ thống bảo trì máy chủ, cơ sở dữ liệu sẽ tạm thời "không thể truy cập được" → chọn tính từ phủ định "inaccessible".',
            'tags': ['reading', 'vocabulary']
          },
          {
            'number': 132,
            'content': 'Choose the best sentence to fill in blank [132].',
            'options': [
              'These enhancements will ensure faster query times and improved data safety.',
              'The marketing campaign proposal was rejected by our overseas partner.',
              'All international travel receipts must be turned in by Thursday.',
              'The executive dining lounge will be closed during the holidays.'
            ],
            'answer': 'A',
            'explanation': 'Câu trước nói về mục đích nâng cấp bảo mật và hiệu năng. Câu (A) tiếp nối mạch logic: "Những nâng cấp này sẽ đảm bảo thời gian truy vấn nhanh hơn và dữ liệu an toàn hơn".',
            'tags': ['reading', 'context']
          },
          {
            'number': 133,
            'content': 'Choose the best preposition to fill in blank [133].',
            'options': ['before', 'among', 'between', 'toward'],
            'answer': 'A',
            'explanation': 'Chỉ mốc thời gian phải hoàn tất trước khi sự kiện xảy ra: "before Saturday noon" (trước trưa Thứ Bảy).',
            'tags': ['reading', 'preposition']
          },
          {
            'number': 134,
            'content': 'Choose the best adverb to fill in blank [134].',
            'options': ['promptly', 'prompt', 'promptness', 'prompted'],
            'answer': 'A',
            'explanation': 'Bổ nghĩa cho động từ "will resume" tại mốc thời gian cụ thể cần phó từ (adverb) → chọn "promptly" (đúng giờ, kịp thời).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      // Part 7 - Group 1 (Passage 1: Q147-148)
      {
        'part': 7,
        'passage': 'APEX AUTOMOTIVE REPAIR\nCustomer Feedback & Service Evaluation\nDate of Service: August 18\nCustomer: David Miller\nVehicle: 2021 Silverton Sedan\n\nService Evaluation:\n• Punctuality: Excellent (5/5)\n• Work Quality: Excellent (5/5)\n• Facility Comfort: Average (3/5)\n• Pricing Transparency: Excellent (5/5)\n\nCustomer Remarks:\n"I brought my sedan in for the scheduled 30,000-mile inspection and front brake pad replacement. Technician Carlos did a wonderful job walking me through the rotor measurements and finished the job thirty minutes ahead of schedule. My only minor suggestion pertains to the customer lounge: seating was limited, and the guest Wi-Fi was quite spotty. Aside from that, the mechanical work was top-notch, and I will certainly return for future oil changes."\n\nManager Response:\nDate: August 20\nFrom: Brenda Larson, Service Manager\n\nDear Mr. Miller,\nThank you for sharing your experience. We are delighted that Carlos provided prompt, transparent service for your brake inspection. Regarding our waiting area, we are scheduled to expand the customer lounge next month with extra workstations and high-speed fiber internet. To show our appreciation for your loyalty, please present coupon code APEX-15OFF during your next visit to receive 15% off any standard maintenance service.',
        'questions': [
          {
            'number': 147,
            'content': 'Why did Mr. Miller bring his vehicle to Apex Automotive?',
            'options': [
              'For a scheduled inspection and brake pad replacement',
              'To repair severe collision body damage',
              'To test-drive a newly arrived Silverton sedan',
              'To install high-performance audio speakers'
            ],
            'answer': 'A',
            'explanation': 'Khách hàng viết: "I brought my sedan in for the scheduled 30,000-mile inspection and front brake pad replacement" → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 148,
            'content': 'What will Apex Automotive do next month?',
            'options': [
              'Expand the waiting lounge and install faster internet',
              'Relocate the auto repair shop to a new facility',
              'Discontinue the promotional discount coupon program',
              'Hire additional mechanical technicians'
            ],
            'answer': 'A',
            'explanation': 'Người quản lý phản hồi: "...we are scheduled to expand the customer lounge next month with extra workstations and high-speed fiber internet" → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      },
      // Part 7 - Group 2 (Passage 2: Q152-154)
      {
        'part': 7,
        'passage': 'ANNOUNCEMENT\nGREENVALE BOTANICAL GARDENS\nAnnual Plant Sale & Horticultural Exhibition\nDates: May 20–22 | Hours: 9:00 A.M. – 6:00 P.M. Daily\n\nGreenvale Botanical Gardens is thrilled to host our 15th Annual Plant Sale! Browse thousands of rare perennial flowers, indigenous shrubs, and organic vegetable seedlings cultivated by our master gardeners.\n\nEvent Highlights:\n• Free 30-minute gardening workshops held daily at 11:00 A.M. and 2:00 P.M. in the glass conservatory.\n• Members-Only Early Access: Garden members enjoy exclusive admission on Friday, May 20 from 8:00 A.M. to 10:00 A.M., plus an extra 15% discount on all plant purchases.\n• Soil testing station: Bring a cup of backyard soil for immediate mineral analysis (\$5 per sample; free for members).\n\nAdmission is \$12 for adults, \$6 for students, and free for children under six and current garden members. Parking is free in the North Lot.\n\n────────────────────────────────────────────────────────\n\nREVIEW POSTING\nUser: Sarah Jenkins | Date: May 23\nRating: ★★★★★\n\n"I attended the Greenvale Plant Sale on Saturday morning with my family. The variety of heirloom tomato seedlings was astonishing, and the staff at the soil testing booth gave us practical tips on improving our garden soil. Even though the North Lot was full by 10:30 A.M., parking attendants directed us smoothly to the overflow lot at the adjacent middle school. We also attended the 2:00 P.M. indoor gardening talk, which was incredibly insightful. We definitely plan to purchase a family membership before next year\'s sale!"',
        'questions': [
          {
            'number': 152,
            'content': 'What benefit do garden members receive on Friday, May 20?',
            'options': [
              'Exclusive early admission and a 15% plant discount',
              'Free admission for up to ten non-member guests',
              'A complimentary pair of professional gardening shears',
              'Reserved parking stalls in the overflow lot'
            ],
            'answer': 'A',
            'explanation': 'Thông báo nêu: "Garden members enjoy exclusive admission on Friday, May 20 from 8:00 A.M. to 10:00 A.M., plus an extra 15% discount on all plant purchases" → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 153,
            'content': 'Where did Sarah Jenkins park her car during her visit?',
            'options': [
              'At an overflow parking lot at a nearby school',
              'In the garden\'s primary North Lot',
              'On an adjacent residential neighborhood street',
              'In an underground parking facility'
            ],
            'answer': 'A',
            'explanation': 'Sarah viết: "...the North Lot was full by 10:30 A.M., parking attendants directed us smoothly to the overflow lot at the adjacent middle school" → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 154,
            'content': 'What does Sarah Jenkins indicate she will do before next year?',
            'options': [
              'Buy a garden family membership',
              'Volunteer as a parking attendant',
              'Donate plant seeds to the conservatory',
              'Host a gardening workshop in her backyard'
            ],
            'answer': 'A',
            'explanation': 'Câu cuối bài review: "We definitely plan to purchase a family membership before next year\'s sale!" → Chọn (A).',
            'tags': ['reading', 'inference']
          }
        ]
      }
    ],
  );
}

MiniTestData _buildMiniTest04() {
  return MiniTestData(
    id: 'mini_test04',
    title: 'Mini Test 25Q - Đề 04',
    description: 'Chủ đề Tài chính, Ngân sách, Mua sắm trang thiết bị & Hợp đồng dịch vụ: 25 câu đủ 7 phần kiểm tra ngữ pháp, phản xạ nghe và đọc hiểu chuyên sâu.',
    groups: [
      // Part 1 - Q1
      {
        'part': 1,
        'image': 'p1_q1.png',
        'audio': 'p1_q1.m4a',
        'transcript': '(A) An accountant is reviewing spreadsheets on multiple monitors. (B) File cabinets are being loaded into an elevator. (C) An office desk is being disassembled by movers. (D) A banker is counting cash at a teller window.',
        '_speech': 'Number 1. Look at the picture marked number 1 in your test book. (A) An accountant is reviewing spreadsheets on multiple monitors. (B) File cabinets are being loaded into an elevator. (C) An office desk is being disassembled by movers. (D) A banker is counting cash at a teller window.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#F8FAFC"/>
  <rect y="400" width="800" height="200" fill="#E2E8F0"/>
  <rect x="140" y="220" width="240" height="160" rx="8" fill="#1E293B"/>
  <rect x="150" y="230" width="220" height="140" rx="4" fill="#38BDF8"/>
  <rect x="420" y="220" width="240" height="160" rx="8" fill="#1E293B"/>
  <rect x="430" y="230" width="220" height="140" rx="4" fill="#34D399"/>
  <rect x="240" y="380" width="40" height="40" fill="#0F172A"/>
  <rect x="520" y="380" width="40" height="40" fill="#0F172A"/>
  <circle cx="400" cy="460" r="40" fill="#64748B"/>
</svg>''',
        'questions': [
          {
            'number': 1,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'An accountant is reviewing spreadsheets on multiple monitors.',
              'File cabinets are being loaded into an elevator.',
              'An office desk is being disassembled by movers.',
              'A banker is counting cash at a teller window.'
            ],
            'answer': 'A',
            'explanation': 'Bàn làm việc với nhiều màn hình hiển thị bảng tính tài chính → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 1 - Q2
      {
        'part': 1,
        'image': 'p1_q2.png',
        'audio': 'p1_q2.m4a',
        'transcript': '(A) Guests are seated in rows facing a conference podium. (B) Banquet tables are being folded and stored away. (C) Microphones are being installed on the ceiling. (D) Waiters are clearing dinner plates from tables.',
        '_speech': 'Number 2. Look at the picture marked number 2 in your test book. (A) Guests are seated in rows facing a conference podium. (B) Banquet tables are being folded and stored away. (C) Microphones are being installed on the ceiling. (D) Waiters are clearing dinner plates from tables.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#EFF6FF"/>
  <rect y="420" width="800" height="180" fill="#DBEAFE"/>
  <rect x="340" y="240" width="120" height="180" fill="#475569"/>
  <circle cx="360" cy="480" r="30" fill="#1E40AF"/>
  <circle cx="440" cy="480" r="30" fill="#1E40AF"/>
  <circle cx="280" cy="480" r="30" fill="#1E40AF"/>
  <circle cx="520" cy="480" r="30" fill="#1E40AF"/>
  <circle cx="320" cy="540" r="30" fill="#1E3A8A"/>
  <circle cx="480" cy="540" r="30" fill="#1E3A8A"/>
</svg>''',
        'questions': [
          {
            'number': 2,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'Guests are seated in rows facing a conference podium.',
              'Banquet tables are being folded and stored away.',
              'Microphones are being installed on the ceiling.',
              'Waiters are clearing dinner plates from tables.'
            ],
            'answer': 'A',
            'explanation': 'Người tham dự ngồi theo hàng hướng về bục phát biểu của phòng hội nghị → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 2 - Q7
      {
        'part': 2,
        'audio': 'p2_q7.m4a',
        'transcript': 'W: Where should I submit my travel reimbursement form?\nM: (A) Directly to the accounting department on the second floor. (B) Yes, the flight was fully reimbursed. (C) Within thirty calendar days.',
        '_speech': 'Number 7. Where should I submit my travel reimbursement form? (A) Directly to the accounting department on the second floor. (B) Yes, the flight was fully reimbursed. (C) Within thirty calendar days.',
        'questions': [
          {
            'number': 7,
            'content': 'Where should I submit my travel reimbursement form?',
            'options': [
              'Directly to the accounting department on the second floor.',
              'Yes, the flight was fully reimbursed.',
              'Within thirty calendar days.'
            ],
            'answer': 'A',
            'explanation': 'Hỏi "Where" về nơi nộp đơn hoàn tiền công tác → Chọn (A) "Trực tiếp cho phòng kế toán tại tầng 2".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q8
      {
        'part': 2,
        'audio': 'p2_q8.m4a',
        'transcript': 'M: Has the finance director approved our revised quarterly budget yet?\nW: (A) She is still reviewing the travel line items. (B) In the corporate conference room. (C) About fifteen percent higher.',
        '_speech': 'Number 8. Has the finance director approved our revised quarterly budget yet? (A) She is still reviewing the travel line items. (B) In the corporate conference room. (C) About fifteen percent higher.',
        'questions': [
          {
            'number': 8,
            'content': 'Has the finance director approved our revised quarterly budget yet?',
            'options': [
              'She is still reviewing the travel line items.',
              'In the corporate conference room.',
              'About fifteen percent higher.'
            ],
            'answer': 'A',
            'explanation': 'Câu hỏi trạng thái phê duyệt ngân sách → trả lời tình trạng bà ấy vẫn đang xem xét các mục công tác phí (A).',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q9
      {
        'part': 2,
        'audio': 'p2_q9.m4a',
        'transcript': 'W: Would you prefer paying with a company credit card or via wire transfer?\nM: (A) A wire transfer will be much easier for our audit records. (B) The card expired last month. (C) Yes, twenty percent off.',
        '_speech': 'Number 9. Would you prefer paying with a company credit card or via wire transfer? (A) A wire transfer will be much easier for our audit records. (B) The card expired last month. (C) Yes, twenty percent off.',
        'questions': [
          {
            'number': 9,
            'content': 'Would you prefer paying with a company credit card or via wire transfer?',
            'options': [
              'A wire transfer will be much easier for our audit records.',
              'The card expired last month.',
              'Yes, twenty percent off.'
            ],
            'answer': 'A',
            'explanation': 'Câu hỏi lựa chọn (Credit card hay Wire transfer) → chọn hình thức chuyển khoản (A) "A wire transfer will be much easier...".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 3 - Q32-34
      {
        'part': 3,
        'audio': 'p3_q32-34.m4a',
        'transcript': 'W: Good afternoon, Jason. Have you received the updated catering invoice from Grand Oak Convention Center for our awards banquet?\nM: Yes, Lisa, but I noticed they charged us for two hundred dinner plates when our confirmed attendee count was only one hundred and seventy.\nW: Oh, that\'s a difference of over one thousand dollars. Did you call their banquet manager to verify the count?\nM: I called her office twenty minutes ago, and she apologized for the administrative error. She promised to send an amended invoice with the correct amount before 4:00 P.M.',
        '_speech': 'Questions 32 through 34 refer to the following conversation. Good afternoon, Jason. Have you received the updated catering invoice from Grand Oak Convention Center for our awards banquet? Yes, Lisa, but I noticed they charged us for two hundred dinner plates when our confirmed attendee count was only one hundred and seventy. Oh, that\'s a difference of over one thousand dollars. Did you call their banquet manager to verify the count? I called her office twenty minutes ago, and she apologized for the administrative error. She promised to send an amended invoice with the correct amount before 4:00 P.M.',
        'questions': [
          {
            'number': 32,
            'content': 'What discrepancy did Jason discover on the banquet invoice?',
            'options': [
              'The company was charged for thirty extra dinner plates',
              'The event hall rental fee was doubled',
              'The date of the awards banquet was incorrect',
              'A mandatory gratuity fee was omitted'
            ],
            'answer': 'A',
            'explanation': 'Jason phát hiện hóa đơn tính tiền 200 suất trong khi chỉ có 170 khách (chênh lệch 30 suất) → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 33,
            'content': 'How much is the cost discrepancy approximately?',
            'options': [
              'Over one thousand dollars',
              'Five hundred dollars',
              'Two hundred dollars',
              'Three thousand dollars'
            ],
            'answer': 'A',
            'explanation': 'Lisa nói: "Oh, that\'s a difference of over one thousand dollars" → Chọn (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 34,
            'content': 'What did the banquet manager promise to do before 4:00 P.M.?',
            'options': [
              'Send an amended invoice with the correct figure',
              'Cancel the banquet reservation',
              'Provide free floral centerpieces for all tables',
              'Visit the company headquarters in person'
            ],
            'answer': 'A',
            'explanation': 'Jason cho biết quản lý hứa gửi hóa đơn sửa đổi trước 4 giờ chiều ("She promised to send an amended invoice with the correct amount before 4:00 P.M.") → Chọn (A).',
            'tags': ['listening', 'conversation']
          }
        ]
      },
      // Part 4 - Q71-73
      {
        'part': 4,
        'audio': 'p4_q71-73.m4a',
        'transcript': 'Good morning, department supervisors. This is Gregory Simmons from corporate finance with an important announcement regarding our year-end budgeting deadlines. All department heads must submit their finalized budget proposals for the upcoming fiscal year no later than Friday, November 18 at 5:00 P.M. Please remember to use the updated spreadsheet template available in the corporate intranet portal, as legacy formats will not be accepted by our automated accounting system. In addition, the executive board will host an open financial briefing on Wednesday morning to answer questions regarding capital expenditure limits. Attendance is strongly recommended.',
        '_speech': 'Questions 71 through 73 refer to the following talk. Good morning, department supervisors. This is Gregory Simmons from corporate finance with an important announcement regarding our year-end budgeting deadlines. All department heads must submit their finalized budget proposals for the upcoming fiscal year no later than Friday, November 18 at 5:00 P.M. Please remember to use the updated spreadsheet template available in the corporate intranet portal, as legacy formats will not be accepted by our automated accounting system. In addition, the executive board will host an open financial briefing on Wednesday morning to answer questions regarding capital expenditure limits. Attendance is strongly recommended.',
        'questions': [
          {
            'number': 71,
            'content': 'What is the speaker mainly announcing?',
            'options': [
              'Deadlines for year-end budget proposals',
              'A reduction in travel reimbursement rates',
              'A transition to a new corporate banking partner',
              'The election of a new board of directors'
            ],
            'answer': 'A',
            'explanation': 'Người nói thông báo về thời hạn nộp đề xuất ngân sách cuối năm ("important announcement regarding our year-end budgeting deadlines") → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 72,
            'content': 'What must supervisors use when preparing their submissions?',
            'options': [
              'The updated spreadsheet template on the intranet',
              'A printed physical ledger from accounting',
              'A proprietary mobile banking application',
              'An external audit evaluation software'
            ],
            'answer': 'A',
            'explanation': 'Người nói nhắc: "Please remember to use the updated spreadsheet template available in the corporate intranet portal..." → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 73,
            'content': 'What event is scheduled for Wednesday morning?',
            'options': [
              'An open financial briefing with the executive board',
              'An annual shareholder voting session',
              'A software training workshop on accounting tools',
              'A retirement luncheon for senior accountants'
            ],
            'answer': 'A',
            'explanation': 'Người nói nêu: "...the executive board will host an open financial briefing on Wednesday morning..." → Chọn (A).',
            'tags': ['listening', 'talks']
          }
        ]
      },
      // Part 5 - Q101-105
      {
        'part': 5,
        'questions': [
          {
            'number': 101,
            'content': 'All travel expense reports must be submitted for managerial ------- by the final business day of the month.',
            'options': ['approval', 'approve', 'approving', 'approved'],
            'answer': 'A',
            'explanation': 'Sau tính từ "managerial" cần một danh từ để tạo thành cụm danh từ "managerial approval" (sự phê duyệt của cấp quản lý).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 102,
            'content': 'The auditing committee emphasized that all client financial records must remain strictly -------.',
            'options': ['confidential', 'confidentially', 'confidence', 'confident'],
            'answer': 'A',
            'explanation': 'Động từ nối "remain" đi với tính từ chỉ tính chất. Sau phó từ bổ nghĩa "strictly" cần tính từ mang nghĩa bảo mật → chọn "confidential" (bảo mật, bí mật).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 103,
            'content': 'The chief financial officer reviewed the balance sheet figures ------- before distributing them to investors.',
            'options': ['himself', 'he', 'his', 'him'],
            'answer': 'A',
            'explanation': 'Câu đã đầy đủ chủ ngữ, vị ngữ và tân ngữ. Đại từ phản thân "himself" đứng cuối mệnh đề để nhấn mạnh chính ông CFO làm hành động kiểm tra.',
            'tags': ['reading', 'pronoun']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 104,
            'content': 'Employees will be reimbursed for allowable travel expenses ------- they submit original itemized receipts.',
            'options': ['provided that', 'as well as', 'in case of', 'regardless of'],
            'answer': 'A',
            'explanation': 'Liên từ điều kiện "Provided that" mang nghĩa "với điều kiện là / miễn là" đi kèm một mệnh đề hoàn chỉnh.',
            'tags': ['reading', 'conjunction']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 105,
            'content': 'Reimbursement checks will be deposited into employees\' bank accounts ------- ten business days.',
            'options': ['within', 'among', 'toward', 'along'],
            'answer': 'A',
            'explanation': 'Giới từ "within" + khoảng thời gian mang nghĩa "trong vòng / không quá mười ngày làm việc".',
            'tags': ['reading', 'preposition']
          }
        ]
      },
      // Part 6 - Q131-134
      {
        'part': 6,
        'passage': 'MEMORANDUM\nTo: All Department Supervisors\nFrom: Gregory Simmons, Chief Financial Officer\nDate: November 3\nSubject: Updated Corporate Travel Guidelines\n\nEffective December 1, all staff members traveling on corporate business must adhere strictly to our revised travel reimbursement guidelines. Under this updated protocol, all flight and hotel arrangements must be booked [131] ------- our designated corporate travel management portal to secure negotiated corporate rates.\n\nEmployees will no longer receive reimbursement for personal incidental charges, such as hotel minibar purchases or dry-cleaning services. [132] -------. Itemized expense claims, accompanied by scanned copies of official receipts, must be submitted within 14 calendar days of returning from travel.\n\nFailure to provide documented receipts on time will lead to reimbursement [133] -------. Should you have questions regarding allowable per-diem meals, please check the intranet directory or [134] ------- the finance department directly.',
        'questions': [
          {
            'number': 131,
            'content': 'Choose the best preposition to fill in blank [131].',
            'options': ['through', 'across', 'between', 'toward'],
            'answer': 'A',
            'explanation': 'Giới từ "through" mang nghĩa "thông qua cổng quản lý công tác được chỉ định" ("through our designated corporate travel management portal").',
            'tags': ['reading', 'preposition']
          },
          {
            'number': 132,
            'content': 'Choose the best sentence to fill in blank [132].',
            'options': [
              'Such personal charges must be settled directly by the individual traveler.',
              'Our annual product demonstration was well attended by international guests.',
              'The customer service hotline operates twenty-four hours a day.',
              'Parking permits will be issued at the security booth tomorrow.'
            ],
            'answer': 'A',
            'explanation': 'Câu trước nói về việc công ty không hoàn tiền cho chi phí cá nhân (mini-bar, giặt ủi). Câu (A) nối tiếp logic: "Các chi phí cá nhân như vậy phải do chính người đi công tác thanh toán".',
            'tags': ['reading', 'context']
          },
          {
            'number': 133,
            'content': 'Choose the best noun form to fill in blank [133].',
            'options': ['delays', 'delayed', 'deliberate', 'delaying'],
            'answer': 'A',
            'explanation': 'Sau danh từ "reimbursement" cần danh từ để tạo thành cụm danh từ ghép "reimbursement delays" (sự chậm trễ trong hoàn trả chi phí).',
            'tags': ['reading', 'word-form']
          },
          {
            'number': 134,
            'content': 'Choose the best verb form to fill in blank [134].',
            'options': ['contact', 'contacting', 'contacted', 'contactable'],
            'answer': 'A',
            'explanation': 'Cấu trúc song hành với động từ nguyên mẫu đứng trước liên từ "or": "please check ... or contact ... directly".',
            'tags': ['reading', 'grammar']
          }
        ]
      },
      // Part 7 - Group 1 (Passage 1: Q147-148)
      {
        'part': 7,
        'passage': 'GRAND OAK CONVENTION CENTER\nEvent Catering Agreement & Banquet Confirmation\nClient: Pinnacle Financial Group | Event: Annual Corporate Honors Banquet\nEvent Date: December 12 | Client Contact: Ms. Rachel Adams, Events Director\n\nEvent Specifications:\n• Venue: Grand Ballroom (Third Floor)\n• Confirmed Guests: 180 attendees\n• Service Package: Executive Three-Course Plated Banquet\n• Staff Setup: 4:30 P.M. | Guest Arrival: 6:00 P.M. | Meal Service: 7:00 P.M.\n\nFinancial Terms & Payment Schedule:\n• Total Contract Value: \$14,400 (includes catering, audio-visual suite, and service gratuity)\n• Initial Deposit: \$4,000 (received October 5)\n• Remaining Balance Due: \$10,400 payable on or before November 28\n\nCancellation Policy:\nCancellations received at least 30 calendar days prior to December 12 will receive a full deposit refund, less a standard \$250 administrative fee. Cancellations made within 30 days are non-refundable. Final meal selections and dietary requirements (vegetarian, kosher, gluten-free) must be submitted in writing to catering coordinator Mark Evans by December 1.',
        'questions': [
          {
            'number': 147,
            'content': 'What type of event is being held at the Grand Oak Convention Center?',
            'options': [
              'An annual corporate honors banquet',
              'A computer hardware manufacturing expo',
              'A public shareholder election meeting',
              'A software engineering certification class'
            ],
            'answer': 'A',
            'explanation': 'Mục tiêu đề hợp đồng: "Event: Annual Corporate Honors Banquet" (tiệc vinh danh doanh nghiệp hàng năm) → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 148,
            'content': 'When must the remaining balance of \$10,400 be settled?',
            'options': [
              'On or before November 28',
              'On October 5',
              'By December 1',
              'On December 12'
            ],
            'answer': 'A',
            'explanation': 'Trong mục Financial Terms: "Remaining Balance Due: \$10,400 payable on or before November 28" → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      },
      // Part 7 - Group 2 (Passage 2: Q152-154)
      {
        'part': 7,
        'passage': 'MEMORANDUM 1\nTo: Senior Management Team\nFrom: Teresa Alvarez, Chief Procurement Officer\nDate: October 15\nSubject: Office Printer Fleet Replacement Bids\n\nOur current leasing contract for multi-function office copiers with Lexmark Office Solutions expires on December 31. Over the past three months, the procurement committee solicited bids from three commercial vendors to replace our fleet of 24 copiers across three regional branches.\n\nAfter evaluating print quality, monthly maintenance turnaround, and volume pricing, the committee recommends partnering with Apex Imaging Services. Apex offers high-speed laser printers with integrated cloud scanning at a monthly lease rate of \$3,800, which is 12% lower than our current contract. In addition, Apex guarantees a four-hour on-site maintenance response time.\n\n────────────────────────────────────────────────────────\n\nMEMORANDUM 2\nTo: Teresa Alvarez, Chief Procurement Officer\nFrom: Marcus Sterling, Chief Executive Officer\nDate: October 17\nSubject: RE: Office Printer Fleet Replacement Bids\n\nDear Teresa,\nThank you for the thorough comparative analysis. Given the cost savings and the four-hour service response guarantee, I fully approve the committee\'s recommendation to award the leasing contract to Apex Imaging Services.\n\nPlease proceed with drafting the formal five-year agreement with their legal team. Prior to signing, ensure that the contract includes complimentary installation and staff training during the first week of January so our daily workflow remains uninterrupted.\n\nBest regards,\nMarcus Sterling',
        'questions': [
          {
            'number': 152,
            'content': 'Why did the procurement committee recommend Apex Imaging Services?',
            'options': [
              'Lower monthly lease pricing and a rapid maintenance guarantee',
              'They are the only vendor offering color photocopy machines',
              'Their corporate headquarters is located next to Apex Studio',
              'They agreed to buy back old office furniture'
            ],
            'answer': 'A',
            'explanation': 'Ủy ban đề xuất Apex vì chi phí thuê hàng tháng thấp hơn 12% và cam kết phản hồi kỹ thuật trong vòng 4 tiếng ("monthly lease rate ... 12% lower ... guarantees a four-hour on-site maintenance response time") → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 153,
            'content': 'What condition does Mr. Sterling require before signing the agreement?',
            'options': [
              'Complimentary installation and staff training in early January',
              'A further five percent discount on paper supplies',
              'Replacement of all office desktop computers',
              'An option to terminate the lease within six months'
            ],
            'answer': 'A',
            'explanation': 'CEO Marcus Sterling yêu cầu: "ensure that the contract includes complimentary installation and staff training during the first week of January" → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 154,
            'content': 'What is the duration of the proposed contract?',
            'options': [
              'Five years',
              'Three months',
              'One year',
              'Twelve months'
            ],
            'answer': 'A',
            'explanation': 'CEO chỉ đạo: "Please proceed with drafting the formal five-year agreement..." → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      }
    ],
  );
}

MiniTestData _buildMiniTest05() {
  return MiniTestData(
    id: 'mini_test05',
    title: 'Mini Test 25Q - Đề 05',
    description: 'Chủ đề Kho vận, Chuỗi cung ứng, Vận tải biển & Quản lý cơ sở vật chất: Đề thi mini 25 câu chất lượng cao hoàn thiện toàn bộ các phần TOEIC.',
    groups: [
      // Part 1 - Q1
      {
        'part': 1,
        'image': 'p1_q1.png',
        'audio': 'p1_q1.m4a',
        'transcript': '(A) A warehouse worker is operating a forklift truck. (B) Boxes are stacked neatly on wooden shipping pallets. (C) An overhead industrial crane is lowering a shipping container. (D) Workers are painting safety lines on the warehouse floor.',
        '_speech': 'Number 1. Look at the picture marked number 1 in your test book. (A) A warehouse worker is operating a forklift truck. (B) Boxes are stacked neatly on wooden shipping pallets. (C) An overhead industrial crane is lowering a shipping container. (D) Workers are painting safety lines on the warehouse floor.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#F3F4F6"/>
  <rect y="440" width="800" height="160" fill="#9CA3AF"/>
  <rect x="200" y="420" width="400" height="30" fill="#B45309"/>
  <rect x="220" y="300" width="110" height="120" fill="#D97706" stroke="#78350F" stroke-width="4"/>
  <rect x="345" y="300" width="110" height="120" fill="#D97706" stroke="#78350F" stroke-width="4"/>
  <rect x="470" y="300" width="110" height="120" fill="#D97706" stroke="#78350F" stroke-width="4"/>
  <rect x="280" y="180" width="110" height="120" fill="#D97706" stroke="#78350F" stroke-width="4"/>
  <rect x="410" y="180" width="110" height="120" fill="#D97706" stroke="#78350F" stroke-width="4"/>
</svg>''',
        'questions': [
          {
            'number': 1,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'A warehouse worker is operating a forklift truck.',
              'Boxes are stacked neatly on wooden shipping pallets.',
              'An overhead industrial crane is lowering a shipping container.',
              'Workers are painting safety lines on the warehouse floor.'
            ],
            'answer': 'B',
            'explanation': 'Các thùng hàng được xếp gọn gàng trên pallet gỗ vận chuyển → Chọn (B).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 1 - Q2
      {
        'part': 1,
        'image': 'p1_q2.png',
        'audio': 'p1_q2.m4a',
        'transcript': '(A) Cargo containers are stacked along the seaport dock. (B) A cruise ship is boarding passengers at the terminal. (C) Fishermen are casting nets into the harbor. (D) Seamen are coiling ropes on the wooden pier.',
        '_speech': 'Number 2. Look at the picture marked number 2 in your test book. (A) Cargo containers are stacked along the seaport dock. (B) A cruise ship is boarding passengers at the terminal. (C) Fishermen are casting nets into the harbor. (D) Seamen are coiling ropes on the wooden pier.',
        '_svg': '''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
  <rect width="800" height="600" fill="#E0F2FE"/>
  <circle cx="100" cy="120" r="45" fill="#FBBF24"/>
  <rect y="360" width="800" height="240" fill="#0284C7"/>
  <rect y="440" width="800" height="160" fill="#475569"/>
  <rect x="160" y="320" width="180" height="120" fill="#DC2626" rx="4"/>
  <rect x="360" y="320" width="180" height="120" fill="#2563EB" rx="4"/>
  <rect x="260" y="200" width="180" height="120" fill="#16A34A" rx="4"/>
  <line x1="180" y1="330" x2="180" y2="430" stroke="#B91C1C" stroke-width="4"/>
  <line x1="220" y1="330" x2="220" y2="430" stroke="#B91C1C" stroke-width="4"/>
</svg>''',
        'questions': [
          {
            'number': 2,
            'content': 'Choose the statement that best describes the picture.',
            'options': [
              'Cargo containers are stacked along the seaport dock.',
              'A cruise ship is boarding passengers at the terminal.',
              'Fishermen are casting nets into the harbor.',
              'Seamen are coiling ropes on the wooden pier.'
            ],
            'answer': 'A',
            'explanation': 'Các thùng container hàng hóa nhiều màu sắc được xếp chồng dọc bến cảng biển → Chọn (A).',
            'tags': ['listening', 'photographs']
          }
        ]
      },
      // Part 2 - Q7
      {
        'part': 2,
        'audio': 'p2_q7.m4a',
        'transcript': 'M: When will the freight cargo from Kaohsiung arrive at our port terminal?\nW: (A) Early Thursday morning according to the shipping agent. (B) Forty metric tons of precision parts. (C) Yes, it has already been loaded.',
        '_speech': 'Number 7. When will the freight cargo from Kaohsiung arrive at our port terminal? (A) Early Thursday morning according to the shipping agent. (B) Forty metric tons of precision parts. (C) Yes, it has already been loaded.',
        'questions': [
          {
            'number': 7,
            'content': 'When will the freight cargo from Kaohsiung arrive at our port terminal?',
            'options': [
              'Early Thursday morning according to the shipping agent.',
              'Forty metric tons of precision parts.',
              'Yes, it has already been loaded.'
            ],
            'answer': 'A',
            'explanation': 'Hỏi "When" về thời gian hàng cập bến cảng → Chọn (A) "Sáng sớm thứ Năm theo đại lý vận chuyển".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q8
      {
        'part': 2,
        'audio': 'p2_q8.m4a',
        'transcript': 'W: Who is inspecting the automated sorting conveyor in building C?\nM: (A) Senior technician Martinez and his apprentice. (B) It operates at high speeds. (C) Next to the freight loading bay.',
        '_speech': 'Number 8. Who is inspecting the automated sorting conveyor in building C? (A) Senior technician Martinez and his apprentice. (B) It operates at high speeds. (C) Next to the freight loading bay.',
        'questions': [
          {
            'number': 8,
            'content': 'Who is inspecting the automated sorting conveyor in building C?',
            'options': [
              'Senior technician Martinez and his apprentice.',
              'It operates at high speeds.',
              'Next to the freight loading bay.'
            ],
            'answer': 'A',
            'explanation': 'Hỏi "Who" về người kiểm tra băng chuyền tự động → Chọn (A) "Kỹ thuật viên trưởng Martinez và phụ tá".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 2 - Q9
      {
        'part': 2,
        'audio': 'p2_q9.m4a',
        'transcript': 'M: Would you like me to reserve the freight elevator for the furniture delivery tomorrow?\nW: (A) That would be wonderful, thank you so much. (B) On the twelfth floor executive suite. (C) Yes, three heavy mahogany desks.',
        '_speech': 'Number 9. Would you like me to reserve the freight elevator for the furniture delivery tomorrow? (A) That would be wonderful, thank you so much. (B) On the twelfth floor executive suite. (C) Yes, three heavy mahogany desks.',
        'questions': [
          {
            'number': 9,
            'content': 'Would you like me to reserve the freight elevator for the furniture delivery tomorrow?',
            'options': [
              'That would be wonderful, thank you so much.',
              'On the twelfth floor executive suite.',
              'Yes, three heavy mahogany desks.'
            ],
            'answer': 'A',
            'explanation': 'Lời đề nghị đặt trước thang máy chở hàng "Would you like me to reserve..." → nhận lời cảm ơn (A) "That would be wonderful, thank you so much".',
            'tags': ['listening', 'question-response']
          }
        ]
      },
      // Part 3 - Q32-34
      {
        'part': 3,
        'audio': 'p3_q32-34.m4a',
        'transcript': 'W: Hello, Carlos. Has the fleet maintenance crew finished inspecting our delivery vans? We have thirty express shipments scheduled for delivery this afternoon.\nM: Good news, Elena. All five refrigerated vans passed their safety brake checks and are ready for loading. However, Van Number 3 needs a headlight bulb replaced before evening.\nW: That\'s a quick fix. I\'ll ask our mechanic to replace the bulb right now while the drivers load the parcels.\nM: Perfect. That way all drivers will be on the road before 1:00 P.M.',
        '_speech': 'Questions 32 through 34 refer to the following conversation. Hello, Carlos. Has the fleet maintenance crew finished inspecting our delivery vans? We have thirty express shipments scheduled for delivery this afternoon. Good news, Elena. All five refrigerated vans passed their safety brake checks and are ready for loading. However, Van Number 3 needs a headlight bulb replaced before evening. That\'s a quick fix. I\'ll ask our mechanic to replace the bulb right now while the drivers load the parcels. Perfect. That way all drivers will be on the road before 1:00 P.M.',
        'questions': [
          {
            'number': 32,
            'content': 'What are the speakers discussing?',
            'options': [
              'The safety inspection of company delivery vans',
              'The purchase of new freight transport vehicles',
              'A delay in manufacturing automotive replacement parts',
              'A customer complaint regarding late package deliveries'
            ],
            'answer': 'A',
            'explanation': 'Người phụ nữ hỏi: "Has the fleet maintenance crew finished inspecting our delivery vans?" → Cuộc hội thoại nói về việc kiểm định xe tải giao hàng (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 33,
            'content': 'What minor issue does Carlos mention regarding Van Number 3?',
            'options': [
              'A headlight bulb needs to be replaced',
              'Its refrigeration compressor is broken',
              'Its side cargo door cannot be locked',
              'Its windshield has a visible crack'
            ],
            'answer': 'A',
            'explanation': 'Carlos cho biết: "Van Number 3 needs a headlight bulb replaced before evening" → Cần thay bóng đèn pha (A).',
            'tags': ['listening', 'conversation']
          },
          {
            'number': 34,
            'content': 'When do the speakers expect drivers to depart?',
            'options': [
              'Before 1:00 P.M.',
              'Tomorrow morning at 8:00 A.M.',
              'At 5:00 P.M.',
              'Next Friday'
            ],
            'answer': 'A',
            'explanation': 'Carlos nói: "That way all drivers will be on the road before 1:00 P.M." → Chọn (A).',
            'tags': ['listening', 'conversation']
          }
        ]
      },
      // Part 4 - Q71-73
      {
        'part': 4,
        'audio': 'p4_q71-73.m4a',
        'transcript': 'Attention all distribution center staff. This is a safety announcement from Facilities Operations. Beginning tomorrow morning at 7:00 A.M., contractors will be repainting safety pedestrian walkways and installing heavy-duty safety railings along the southern loading bays. As a result, Loading Bays 4 through 7 will be temporarily closed until Friday afternoon. All incoming freight carriers should be routed to Loading Bays 1 through 3 on the northern concourse. Please remember that high-visibility reflective vests and steel-toe work boots are mandatory in all active staging areas. Thank you for your continued dedication to workplace safety.',
        '_speech': 'Questions 71 through 73 refer to the following announcement. Attention all distribution center staff. This is a safety announcement from Facilities Operations. Beginning tomorrow morning at 7:00 A.M., contractors will be repainting safety pedestrian walkways and installing heavy-duty safety railings along the southern loading bays. As a result, Loading Bays 4 through 7 will be temporarily closed until Friday afternoon. All incoming freight carriers should be routed to Loading Bays 1 through 3 on the northern concourse. Please remember that high-visibility reflective vests and steel-toe work boots are mandatory in all active staging areas. Thank you for your continued dedication to workplace safety.',
        'questions': [
          {
            'number': 71,
            'content': 'What work will contractors begin tomorrow morning?',
            'options': [
              'Repainting pedestrian walkways and installing safety railings',
              'Replacing automated sorting conveyors',
              'Re-roofing the primary distribution warehouse',
              'Installing digital inventory scanning monitors'
            ],
            'answer': 'A',
            'explanation': 'Thông báo nêu: "contractors will be repainting safety pedestrian walkways and installing heavy-duty safety railings..." → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 72,
            'content': 'Which loading bays will be closed until Friday afternoon?',
            'options': [
              'Loading Bays 4 through 7',
              'Loading Bays 1 through 3',
              'All bays on the northern concourse',
              'Only the underground freight bay'
            ],
            'answer': 'A',
            'explanation': 'Thông báo: "As a result, Loading Bays 4 through 7 will be temporarily closed until Friday afternoon" → Chọn (A).',
            'tags': ['listening', 'talks']
          },
          {
            'number': 73,
            'content': 'What safety equipment must all staff wear in staging areas?',
            'options': [
              'High-visibility vests and steel-toe boots',
              'Full-face protective shields and earplugs',
              'Waterproof rubber aprons and gloves',
              'Insulated winter thermal jackets'
            ],
            'answer': 'A',
            'explanation': 'Thông báo nhắc: "...high-visibility reflective vests and steel-toe work boots are mandatory in all active staging areas" → Chọn (A).',
            'tags': ['listening', 'talks']
          }
        ]
      },
      // Part 5 - Q101-105
      {
        'part': 5,
        'questions': [
          {
            'number': 101,
            'content': 'Warehouse safety regulations will be ------- enforced across all regional logistics hubs beginning next Monday.',
            'options': ['strictly', 'strict', 'strictness', 'strictest'],
            'answer': 'A',
            'explanation': 'Đứng giữa trợ động từ "will be" và động từ phân từ hai "enforced" cần một phó từ (adverb) chỉ mức độ → chọn "strictly" (một cách nghiêm ngặt).',
            'tags': ['reading', 'word-form']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 102,
            'content': 'The certified inspector will ------- the automated conveyor belt before regular production shifts resume.',
            'options': ['inspect', 'inspection', 'inspector', 'inspects'],
            'answer': 'A',
            'explanation': 'Sau động từ khuyết thiếu "will" cần một động từ nguyên mẫu không "to" (bare infinitive) → chọn "inspect" (thanh tra, kiểm tra).',
            'tags': ['reading', 'grammar']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 103,
            'content': 'Commercial truck drivers must submit ------- daily delivery mileage logs to dispatch every evening.',
            'options': ['their', 'they', 'them', 'theirs'],
            'answer': 'A',
            'explanation': 'Đứng trước cụm danh từ "daily delivery mileage logs" cần tính từ sở hữu số nhiều tương ứng với "Commercial truck drivers" → chọn "their" (của họ).',
            'tags': ['reading', 'pronoun']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 104,
            'content': 'The container vessel remained anchored outside the harbor ------- port customs officials reviewed the shipping manifests.',
            'options': ['while', 'during', 'despite', 'between'],
            'answer': 'A',
            'explanation': 'Theo sau là mệnh đề ("port customs officials reviewed the shipping manifests") diễn tả hành động diễn ra đồng thời → chọn liên từ thời gian "while" (trong khi).',
            'tags': ['reading', 'conjunction']
          }
        ]
      },
      {
        'part': 5,
        'questions': [
          {
            'number': 105,
            'content': 'Perishable food supplies arriving at the fulfillment center must be placed ------- designated refrigeration rooms.',
            'options': ['inside', 'above', 'along', 'onto'],
            'answer': 'A',
            'explanation': 'Giới từ chỉ vị trí bên trong phòng lạnh bảo quản hàng tươi sống → chọn "inside" (bên trong).',
            'tags': ['reading', 'preposition']
          }
        ]
      },
      // Part 6 - Q131-134
      {
        'part': 6,
        'passage': 'PACIFIC CARGO LOGISTICS\nCustomer Advisory: Shipment Tracking #PC-884920\nDate: October 18\nRecipient: Starlight Electronics Ltd.\n\nDear Valued Client,\n\nWe are writing to provide an important update regarding your shipment of precision semiconductor components (Tracking ID: PC-884920). Due to severe weather conditions along the Western Pacific maritime corridor, your container vessel was required to seek temporary anchorage outside Kaohsiung Harbor for maritime safety.\n\nAs a direct consequence of this necessary detour, the estimated arrival at the Port of Long Beach has been [131] ------- from October 22 to October 27. [132] -------. Our customs brokerage unit has already pre-filed all electronic import documentation to ensure cargo is discharged rapidly upon berthing.\n\nOnce the container is unloaded, our certified transport partner will deliver the freight [133] ------- to your Irvine assembly facility. We sincerely regret any inconvenience caused by this unavoidable maritime delay. For continuous real-time container updates, please log in to your account dashboard or [134] ------- with your dedicated client manager.',
        'questions': [
          {
            'number': 131,
            'content': 'Choose the best verb form to fill in blank [131].',
            'options': ['rescheduled', 'rescheduling', 'reschedule', 'reschedules'],
            'answer': 'A',
            'explanation': 'Cấu trúc bị động thì hiện tại hoàn thành: "has been + V3/ed" → chọn "rescheduled" (đã được dời lịch từ 22 sang 27 tháng 10).',
            'tags': ['reading', 'grammar']
          },
          {
            'number': 132,
            'content': 'Choose the best sentence to fill in blank [132].',
            'options': [
              'We are monitoring maritime advisories closely and will alert you to further updates.',
              'Our corporate headquarters will host an executive banquet this weekend.',
              'Please ensure all personal luggage is tagged before boarding the flight.',
              'The annual software subscription fee has already been deducted.'
            ],
            'answer': 'A',
            'explanation': 'Câu trước vừa thông báo lùi ngày giao hàng do bão. Câu (A) nối tiếp thông tin trấn an và theo dõi sát sao ("Chúng tôi đang theo dõi sát sao và sẽ thông báo cho bạn").',
            'tags': ['reading', 'context']
          },
          {
            'number': 133,
            'content': 'Choose the best adverb to fill in blank [133].',
            'options': ['directly', 'direct', 'direction', 'directness'],
            'answer': 'A',
            'explanation': 'Bổ nghĩa cho động từ "will deliver the freight" cần phó từ chỉ thể cách → chọn "directly" (giao hàng trực tiếp tới cơ sở lắp ráp của bạn).',
            'tags': ['reading', 'word-form']
          },
          {
            'number': 134,
            'content': 'Choose the best verb to fill in blank [134].',
            'options': ['consult', 'consulting', 'consultation', 'consulted'],
            'answer': 'A',
            'explanation': 'Cấu trúc song hành với động từ nguyên mẫu đứng trước liên từ "or": "please log in ... or consult with ...".',
            'tags': ['reading', 'grammar']
          }
        ]
      },
      // Part 7 - Group 1 (Passage 1: Q147-148)
      {
        'part': 7,
        'passage': 'METRO TOWER MANAGEMENT\nTenant Advisory: Ground Lobby & Passenger Elevator Modernization\nDate: July 15\nTo: All Building Occupants & Visitors\n\nPlease be advised that Metro Tower Management will begin comprehensive modernization work on our ground-floor entrance lobby and high-rise passenger elevator system starting Saturday, August 1.\n\nProject Phases & Work Scope:\n• Phase 1 (August 1 – August 14): Lobby flooring replacement and energy-efficient lighting installation. The main revolving entrance will be inaccessible; all tenants and guests must enter through the West Plaza side doors.\n• Phase 2 (August 15 – August 31): High-rise elevator cab overhaul. Elevators 1 and 2 will be temporarily suspended, while Elevators 3 and 4 will operate express service servicing floors 12 through 25.\n\nNoise & After-Hours Schedule:\nTo minimize business disruption, all noisy tile drilling and structural removal will occur strictly between 7:00 P.M. and 5:00 A.M. on weekdays, and throughout the weekend. Security officers will remain on duty at the West Plaza entrance 24 hours a day to assist guests and verify electronic access cards.',
        'questions': [
          {
            'number': 147,
            'content': 'What is the primary objective of this notice?',
            'options': [
              'To inform tenants about scheduled lobby and elevator renovations',
              'To announce an increase in monthly parking stall fees',
              'To invite building occupants to an annual social reception',
              'To warn employees about unexpected electrical power cuts'
            ],
            'answer': 'A',
            'explanation': 'Tiêu đề và nội dung thông báo đều tập trung vào việc hiện đại hóa sảnh chính tầng trệt và thang máy tòa nhà Metro Tower → Chọn (A).',
            'tags': ['reading', 'main-idea']
          },
          {
            'number': 148,
            'content': 'Where must tenants enter the building during Phase 1?',
            'options': [
              'Through the West Plaza side doors',
              'Through the main revolving entrance',
              'Via the underground parking loading dock',
              'Through the fire escape stairwell'
            ],
            'answer': 'A',
            'explanation': 'Mục Phase 1: "The main revolving entrance will be inaccessible; all tenants and guests must enter through the West Plaza side doors" → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      },
      // Part 7 - Group 2 (Passage 2: Q152-154)
      {
        'part': 7,
        'passage': 'MEMORANDUM 1\nTo: Distribution Center Personnel\nFrom: Kenji Sato, Operations Director, QuickFreight Logistics\nDate: November 10\nSubject: Implementation of Autonomous Guided Vehicles (AGVs)\n\nBeginning December 1, our primary fulfillment center in Indianapolis will integrate twelve Autonomous Guided Vehicles (AGVs) into our warehouse pallet transport operations. These robotic units are engineered to transport loaded pallets from the packaging lines directly to the dispatch staging lanes, reducing manual forklift transit by forty percent.\n\nTo ensure smooth integration and maintain workplace safety, all warehouse associates must attend a mandatory 45-minute training session on AGV navigation sensors and emergency-stop protocols. Training sessions will be held daily in the main training room from November 20 to November 24.\n\n────────────────────────────────────────────────────────\n\nMEMORANDUM 2\nTo: Kenji Sato, Operations Director\nFrom: Maria Hernandez, Shift Supervisor\nDate: November 25\nSubject: AGV Training Attendance Completion\n\nDear Kenji,\nI am pleased to report that 100% of our 85 shift workers have completed the AGV safety certification course as of this morning. Technician Davis from the robotics supplier conducted thorough demonstrations on battery charging docks and safety beacon indicators.\n\nOur shift leads noted that the designated transit lanes for the AGVs along Corridor B are somewhat narrow. We suggest repainting the floor markings to give human foot traffic an extra two feet of clearance before the robots go live on December 1. Please let me know if maintenance can proceed with this adjustment over the holiday weekend.\n\nBest regards,\nMaria Hernandez',
        'questions': [
          {
            'number': 152,
            'content': 'What is the purpose of introducing Autonomous Guided Vehicles (AGVs)?',
            'options': [
              'To transport pallets from packaging lines to dispatch staging areas',
              'To replace the warehouse security guard personnel',
              'To package delicate glass items for international air freight',
              'To inspect incoming freight delivery vehicles'
            ],
            'answer': 'A',
            'explanation': 'Mục đích AGVs: "transport loaded pallets from the packaging lines directly to the dispatch staging lanes" → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 153,
            'content': 'What did Maria Hernandez report regarding the safety training?',
            'options': [
              'All 85 shift associates successfully completed the course',
              'The training sessions were postponed until December',
              'The robotics technician failed to attend the demonstration',
              'Half of the workers requested additional training sessions'
            ],
            'answer': 'A',
            'explanation': 'Maria Hernandez báo cáo: "100% of our 85 shift workers have completed the AGV safety certification course as of this morning" → Chọn (A).',
            'tags': ['reading', 'detail']
          },
          {
            'number': 154,
            'content': 'What modification did Maria suggest before December 1?',
            'options': [
              'Repainting floor markings in Corridor B to widen pedestrian clearance',
              'Purchasing six additional robotic units from the supplier',
              'Canceling the forklift maintenance contracts',
              'Extending the battery charging time of the vehicles'
            ],
            'answer': 'A',
            'explanation': 'Maria đề xuất: "We suggest repainting the floor markings to give human foot traffic an extra two feet of clearance..." → Chọn (A).',
            'tags': ['reading', 'detail']
          }
        ]
      }
    ],
  );
}
