import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/theory_models.dart';

final theoryRepositoryProvider = Provider<TheoryRepository>((ref) {
  return TheoryRepository();
});

class TheoryRepository {
  TheoryRepository();

  static const _keyCompleted = 'theory_completed_topics';
  static const _keyBookmarks = 'theory_bookmarked_topics';
  static const _keyScores = 'theory_quiz_scores';

  // ==================== KHO DỮ LIỆU LÝ THUYẾT 29 CHỦ ĐIỂM CHUYÊN SÂU ====================
  static const List<TheoryTopic> _allTopics = [
    // =========================================================================
    // NHÓM 1: 12 THÌ NGỮ PHÁP (TENSES)
    // =========================================================================
    TheoryTopic(
      id: 'tenses-present-simple-continuous',
      category: TheoryCategory.tenses,
      title: 'Hiện tại đơn & Hiện tại tiếp diễn',
      subtitle: 'Phân biệt thói quen, lịch trình cố định và hành động tạm thời',
      readTimeMinutes: 6,
      difficulty: 'Cơ bản',
      tags: ['tenses', 'verb-form'],
      overview:
          'Trong đề thi TOEIC Part 5 & 6, đây là hai thì nền tảng xuất hiện liên tục. Nắm chắc sự khác biệt giữa lịch trình cố định và hành động đang diễn ra giúp bạn chọn đáp án ngay trong 5 giây.',
      sections: [
        TheorySection(
          title: '1. Hiện tại đơn (Present Simple)',
          content:
              'Diễn tả thói quen, lịch trình tàu xe/sự kiện cố định hoặc chân lý, sự thật hiển nhiên.',
          formula: 'S + V(s/es) | S + do/does not + V_inf',
          bulletPoints: [
            'Dấu hiệu nhận biết: always, usually, often, regularly, frequently, every day/month, once a week.',
            'Lịch trình cố định: "The international flight departs at 8:00 AM tomorrow." (dù có "tomorrow" vẫn chia hiện tại đơn vì là lịch bay cố định).',
          ],
          tips: [
            'Bẫy TOEIC: Sau các liên từ chỉ thời gian (when, as soon as, once, until, before, after) trong mệnh đề trạng ngữ, dùng Hiện tại đơn để diễn tả hành động tương lai, KHÔNG dùng "will".',
          ],
        ),
        TheorySection(
          title: '2. Hiện tại tiếp diễn (Present Continuous)',
          content:
              'Diễn tả hành động đang diễn ra tại thời điểm nói hoặc xu hướng biến đổi tạm thời.',
          formula: 'S + am/is/are + V-ing',
          bulletPoints: [
            'Dấu hiệu: now, right now, at present, currently, at the moment.',
            'Động từ chỉ trạng thái (Stative verbs): like, love, hate, know, agree, believe, understand, smell, seem KHÔNG BAO GIỜ chia ở thì tiếp diễn.',
          ],
          tips: [
            'Từ "currently" trong đề TOEIC đi với Hiện tại tiếp diễn hoặc Hiện tại đơn: "We are currently renovating the main lobby."',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The train to Boston departs from Platform 4 at 9:30 AM every weekday.',
          vietnamese: 'Chuyến tàu đi Boston khởi hành từ Sân ga số 4 lúc 9:30 sáng các ngày trong tuần.',
          explanation: 'Lịch trình tàu xe cố định kèm "every weekday" -> chia Hiện tại đơn "departs".',
          highlight: 'departs ... at 9:30 AM every weekday',
          partTag: 'Part 5',
        ),
        TheoryExample(
          english: 'As soon as the CEO arrives at the venue, the keynote presentation will begin.',
          vietnamese: 'Ngay khi Tổng giám đốc đến địa điểm, bài thuyết trình chính sẽ bắt đầu.',
          explanation: 'Mệnh đề sau "As soon as" dùng Hiện tại đơn "arrives" để chỉ hành động tương lai.',
          highlight: 'As soon as the CEO arrives',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pres-1',
          question: 'The accounting team _______ financial statements at the end of every fiscal month.',
          options: ['reviews', 'is reviewing', 'will review', 'reviewed'],
          answerIndex: 0,
          explanation: '"at the end of every fiscal month" chỉ thói quen/lịch trình lặp lại định kỳ -> chọn "reviews".',
        ),
        TheoryQuizQuestion(
          id: 'q-pres-2',
          question: 'Once the shipment _______ at our facility, our quality team will inspect it.',
          options: ['arrives', 'will arrive', 'arriving', 'arrived'],
          answerIndex: 0,
          explanation: 'Mệnh đề trạng ngữ sau "Once" dùng hiện tại đơn chỉ hành động trong tương lai -> chọn "arrives".',
        ),
        TheoryQuizQuestion(
          id: 'q-pres-3',
          question: 'The IT department is currently _______ new cybersecurity software across all laptops.',
          options: ['install', 'installed', 'installing', 'installation'],
          answerIndex: 2,
          explanation: 'Sau "is currently" cần một V-ing để tạo thành thì hiện tại tiếp diễn -> chọn "installing".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'tenses-present-perfect',
      category: TheoryCategory.tenses,
      title: 'Hiện tại hoàn thành & Hoàn thành tiếp diễn',
      subtitle: 'Dấu hiệu Since, For, Over the past years & Sự kéo dài đến hiện tại',
      readTimeMinutes: 7,
      difficulty: 'Cơ bản',
      tags: ['tenses', 'verb-form'],
      overview:
          'Hiện tại hoàn thành là một trong những thì xuất hiện nhiều nhất trong đề thi TOEIC. Nắm rõ các cụm từ tăng điểm như "over the past three years" hay quy tắc "since" sẽ giúp bạn giải đề cực kỳ chuẩn xác.',
      sections: [
        TheorySection(
          title: '1. Hiện tại hoàn thành (Present Perfect)',
          content:
              'Diễn tả hành động xảy ra trong quá khứ kéo dài đến hiện tại, hoặc vừa mới xảy ra, hoặc trải nghiệm.',
          formula: 'S + have/has + V3/ed',
          bulletPoints: [
            'Dấu hiệu kinh điển: since + mốc thời gian, for + khoảng thời gian, already, yet, recently, lately.',
            'Cụm từ tăng điểm: over/in/during the past/last + [khoảng thời gian] (vd: over the past two years) luôn đi với Hiện tại hoàn thành.',
          ],
          tips: [
            'Quy tắc Since: Mệnh đề chứa Since chia Quá khứ đơn, mệnh đề chính bắt buộc chia Hiện tại hoàn thành: "Since he joined the firm, revenue has increased by 20%."',
          ],
        ),
        TheorySection(
          title: '2. Hiện tại hoàn thành tiếp diễn (Present Perfect Continuous)',
          content:
              'Nhấn mạnh tính liên tục không ngừng nghỉ của hành động từ quá khứ đến hiện tại.',
          formula: 'S + have/has + been + V-ing',
          bulletPoints: [
            'Dấu hiệu: all morning, all day, for the last 5 hours.',
            'Nhấn mạnh vào quá trình hành động hơn là kết quả.',
          ],
          tips: [
            'Trong TOEIC nếu có cả 2 phương án, đề bài thường kiểm tra Hiện tại hoàn thành đơn hơn, trừ khi muốn nhấn mạnh quá trình liên tục.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Mr. Tanaka has worked at our branch for more than ten years.',
          vietnamese: 'Ông Tanaka đã làm việc tại chi nhánh của chúng tôi hơn mười năm rồi.',
          explanation: 'Dấu hiệu "for more than ten years" chỉ khoảng thời gian kéo dài đến hiện tại -> chia "has worked".',
          highlight: 'has worked ... for more than ten years',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-perf-1',
          question: 'Over the past quarter, our marketing team _______ the advertising budget significantly.',
          options: ['reduces', 'has reduced', 'reducing', 'will reduce'],
          answerIndex: 1,
          explanation: '"Over the past quarter" là dấu hiệu của thì Hiện tại hoàn thành -> chọn "has reduced".',
        ),
        TheoryQuizQuestion(
          id: 'q-perf-2',
          question: 'Ms. Davis has served as lead architect since she _______ the company in 2021.',
          options: ['joins', 'joined', 'has joined', 'joining'],
          answerIndex: 1,
          explanation: 'Sau "since" là mốc thời gian quá khứ nên chia Quá khứ đơn -> chọn "joined".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'tenses-past-simple-continuous',
      category: TheoryCategory.tenses,
      title: 'Quá khứ đơn & Quá khứ tiếp diễn',
      subtitle: 'Mốc thời gian xác định & Phối thì hành động cắt ngang',
      readTimeMinutes: 6,
      difficulty: 'Cơ bản',
      tags: ['tenses', 'verb-form'],
      overview:
          'Thì quá khứ đơn miêu tả các sự kiện, hợp đồng, báo cáo kinh doanh đã hoàn thành trong quá khứ. Cần chú ý phân biệt mốc thời gian rõ ràng để không nhầm với Hiện tại hoàn thành.',
      sections: [
        TheorySection(
          title: '1. Quá khứ đơn (Past Simple)',
          content:
              'Diễn tả hành động đã chấm dứt hoàn toàn trong quá khứ, có mốc thời gian cụ thể.',
          formula: 'S + V2/ed | S + did not + V_inf',
          bulletPoints: [
            'Dấu hiệu: yesterday, ago, last week/month/year, in + [năm quá khứ, ví dụ in 2022], previously, formerly.',
            'Bắt buộc dùng Quá khứ đơn khi có mốc năm quá khứ hoặc "ago", KHÔNG dùng Hiện tại hoàn thành.',
          ],
          tips: [
            'Phân biệt: "in 2020" -> chia Quá khứ đơn. "Since 2020" -> chia Hiện tại hoàn thành.',
          ],
        ),
        TheorySection(
          title: '2. Quá khứ tiếp diễn (Past Continuous)',
          content:
              'Diễn tả hành động đang xảy ra tại một thời điểm xác định trong quá khứ hoặc hành động đang xảy ra thì có hành động khác cắt ngang.',
          formula: 'S + was/were + V-ing',
          bulletPoints: [
            'Cấu trúc cắt ngang: When + S + V2/ed, S + was/were V-ing.',
            'Cấu trúc song song: While S + was/were V-ing, S + was/were V-ing.',
          ],
          tips: [
            'Trong bài đọc Part 7: thường dùng miêu tả ngữ cảnh sự cố phát sinh ("While technicians were repairing the server, power went out").',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The board of directors approved the merger proposal two days ago.',
          vietnamese: 'Hội đồng quản trị đã thông qua đề xuất sáp nhập hai ngày trước.',
          explanation: 'Dấu hiệu "two days ago" chỉ mốc thời gian quá khứ chấm dứt hoàn toàn -> dùng "approved".',
          highlight: 'approved ... two days ago',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-past-1',
          question: 'Last year, the corporation _______ three new regional branches across Europe.',
          options: ['opens', 'opened', 'has opened', 'is opening'],
          answerIndex: 1,
          explanation: 'Dấu hiệu "Last year" đòi hỏi thì Quá khứ đơn -> chọn "opened".',
        ),
        TheoryQuizQuestion(
          id: 'q-past-2',
          question: 'While Ms. Gomez _______ the client presentation, the projector malfunctioned.',
          options: ['gives', 'has given', 'was giving', 'will give'],
          answerIndex: 2,
          explanation: 'Hành động đang diễn ra trong quá khứ bị hành động khác xen vào -> chọn "was giving".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'tenses-past-perfect',
      category: TheoryCategory.tenses,
      title: 'Quá khứ hoàn thành (Past Perfect)',
      subtitle: 'Hành động xảy ra trước một hành động khác trong quá khứ',
      readTimeMinutes: 5,
      difficulty: 'Trung cấp',
      tags: ['tenses', 'verb-form'],
      overview:
          'Quá khứ hoàn thành được dùng để thể hiện thứ tự trước - sau của hai hành động trong quá khứ. Đặc biệt thường gặp với các liên từ By the time, Before, After trong Part 5 và Part 6.',
      sections: [
        TheorySection(
          title: 'Cấu trúc & Nguyên tắc cốt lõi',
          content:
              'Hành động xảy ra trước chia Quá khứ hoàn thành (had + V3), hành động xảy ra sau chia Quá khứ đơn (V2/ed).',
          formula: 'S + had + V3/ed',
          bulletPoints: [
            'By the time + S + V2/ed, S + had + V3/ed.',
            'Before + S + V2/ed, S + had + V3/ed.',
            'After + S + had + V3/ed, S + V2/ed.',
          ],
          tips: [
            'Bẫy TOEIC: Nếu cả câu chỉ có 1 hành động trong quá khứ có mốc thời gian, KHÔNG dùng Quá khứ hoàn thành mà chỉ dùng Quá khứ đơn!',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'By the time the conference began, all participants had received their badges.',
          vietnamese: 'Vào thời điểm hội nghị bắt đầu, tất cả người tham gia đều đã nhận được thẻ đeo của họ.',
          explanation: 'Việc nhận thẻ diễn ra trước khi hội nghị bắt đầu trong quá khứ -> "had received".',
          highlight: 'had received ... By the time ... began',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pastperf-1',
          question: 'By the time the inspectors arrived, the staff _______ the entire production line.',
          options: ['cleans', 'has cleaned', 'had cleaned', 'will clean'],
          answerIndex: 2,
          explanation: 'Cấu trúc "By the time + V2/ed, S + had V3/ed" -> chọn "had cleaned".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'tenses-future-simple-near',
      category: TheoryCategory.tenses,
      title: 'Tương lai đơn (Will) & Tương lai gần (Be going to)',
      subtitle: 'Dự đoán, quyết định tức thời và kế hoạch định sẵn',
      readTimeMinutes: 5,
      difficulty: 'Cơ bản',
      tags: ['tenses', 'verb-form'],
      overview:
          'Diễn tả các kế hoạch kinh doanh, ra mắt sản phẩm hoặc mở rộng thị trường sắp tới. Cần lưu ý các từ báo hiệu như upcoming, forthcoming, tomorrow, next week.',
      sections: [
        TheorySection(
          title: '1. Tương lai đơn (Will + V_inf)',
          content:
              'Dùng cho quyết định đưa ra ngay tại thời điểm nói, lời hứa, đề nghị hoặc dự đoán không có căn cứ chắc chắn.',
          formula: 'S + will + V_inf',
          bulletPoints: [
            'Dấu hiệu: tomorrow, next week/month, soon, shortly, upcoming, forthcoming, probably.',
          ],
          tips: [
            'Từ "shortly" và "soon" là 2 từ khóa vàng thường xuyên đi kèm với thì tương lai đơn trong Part 5.',
          ],
        ),
        TheorySection(
          title: '2. Tương lai gần (Be going to + V_inf)',
          content:
              'Dùng cho kế hoạch, dự định đã được chuẩn bị từ trước hoặc dự đoán có bằng chứng cụ thể ở hiện tại.',
          formula: 'S + am/is/are + going to + V_inf',
          bulletPoints: [
            'Chỉ kế hoạch đã lên lịch sẵn trước thời điểm nói.',
          ],
          tips: [
            'Trong văn bản email thương mại TOEIC, cấu trúc "be scheduled to + V" hoặc "plan to + V" cũng thường được dùng thay cho thì tương lai.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The revised employee handbook will be distributed to all staff shortly.',
          vietnamese: 'Cuốn sổ tay nhân viên sửa đổi sẽ sớm được gửi đến toàn thể nhân viên.',
          explanation: 'Dấu hiệu "shortly" đi cùng thì tương lai bị động -> "will be distributed".',
          highlight: 'will be distributed ... shortly',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-fut-1',
          question: 'The management team _______ the survey results at next Monday’s meeting.',
          options: ['announces', 'announced', 'will announce', 'has announced'],
          answerIndex: 2,
          explanation: 'Dấu hiệu "at next Monday’s meeting" chỉ sự kiện trong tương lai -> chọn "will announce".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'tenses-future-perfect-continuous',
      category: TheoryCategory.tenses,
      title: 'Tương lai hoàn thành (Future Perfect)',
      subtitle: 'Dấu hiệu By + mốc tương lai & Hoàn thành trước một thời điểm',
      readTimeMinutes: 5,
      difficulty: 'Trung cấp',
      tags: ['tenses', 'verb-form'],
      overview:
          'Đây là "câu hỏi ăn điểm" trong Part 5. Cứ thấy "By the end of next month" hay "By tomorrow" thì khả năng cao đáp án là Tương lai hoàn thành.',
      sections: [
        TheorySection(
          title: 'Công thức & Dấu hiệu vàng',
          content:
              'Diễn tả hành động sẽ hoàn tất trước một thời điểm hoặc một hành động khác trong tương lai.',
          formula: 'S + will have + V3/ed',
          bulletPoints: [
            'Dấu hiệu: By + mốc tương lai (By next Friday, By the end of this year, By 2030).',
            'By the time + S + V(hiện tại đơn), S + will have + V3/ed.',
          ],
          tips: [
            'Bẫy: Nhầm lẫn giữa "By the time + V(hiện tại)" (đi với will have V3) và "By the time + V(quá khứ)" (đi với had V3).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'By next December, our lead engineer will have completed his overseas assignment.',
          vietnamese: 'Trước tháng 12 tới, kỹ sư trưởng của chúng ta sẽ hoàn thành nhiệm vụ công tác nước ngoài.',
          explanation: 'Dấu hiệu "By next December" chỉ mốc thời gian tương lai -> chọn "will have completed".',
          highlight: 'By next December ... will have completed',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-futperf-1',
          question: 'By the time the contract expires, we _______ with them for five years.',
          options: ['partnered', 'will have partnered', 'partner', 'were partnering'],
          answerIndex: 1,
          explanation: 'Cấu trúc "By the time + Hiện tại đơn, S + will have V3" -> chọn "will have partnered".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'tenses-sequence',
      category: TheoryCategory.tenses,
      title: 'Bảng tổng hợp Quy tắc Phối hợp thì trong TOEIC',
      subtitle: 'Mệnh đề chính vs Mệnh đề phụ & Sự ăn khớp thì logic',
      readTimeMinutes: 6,
      difficulty: 'Trung cấp',
      tags: ['tenses', 'verb-form'],
      overview:
          'Trong câu phức có 2 mệnh đề nối bằng liên từ (when, because, although, since, until), việc chọn đúng thì phụ thuộc vào quan hệ nhân quả và dòng thời gian của cả 2 vế.',
      sections: [
        TheorySection(
          title: 'Bảng quy tắc phối thì cơ bản',
          content: 'Không được tùy tiện ghép thì quá khứ với tương lai trong cùng một chuỗi hành động.',
          formula: 'Mệnh đề 1 [Thì X] + Liên từ + Mệnh đề 2 [Thì Y]',
          bulletPoints: [
            'Hiện tại đơn + Tương lai đơn (If it rains, we will cancel).',
            'Hiện tại hoàn thành + Since + Quá khứ đơn (We have known each other since we graduated).',
            'Quá khứ đơn + Quá khứ đơn (When he arrived, the meeting started).',
            'Quá khứ tiếp diễn + Quá khứ đơn (While I was driving, my phone rang).',
            'Quá khứ hoàn thành + Quá khứ đơn (After he had signed, he left).',
          ],
          tips: [
            'Quy tắc vàng: Nếu mệnh đề chính ở thì Quá khứ thì mệnh đề phụ hầu như chỉ có thể ở Quá khứ hoặc Quá khứ hoàn thành (không nhảy sang hiện tại/tương lai).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Mr. Vance explained that the delivery had been delayed due to severe weather.',
          vietnamese: 'Ông Vance giải thích rằng việc giao hàng đã bị chậm trễ do thời tiết khắc nghiệt.',
          explanation: 'Mệnh đề chính "explained" (quá khứ) kéo theo mệnh đề sau lùi thì thành quá khứ hoàn thành "had been delayed".',
          highlight: 'explained that ... had been delayed',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-seq-1',
          question: 'The director confirmed that the budget _______ approved at the previous meeting.',
          options: ['is', 'will be', 'had been', 'has been'],
          answerIndex: 2,
          explanation: 'Mệnh đề chính "confirmed" ở quá khứ, hành động duyệt ngân sách diễn ra trước đó -> chọn "had been".',
        ),
      ],
    ),

    // =========================================================================
    // NHÓM 2: MẪU CÂU & CẤU TRÚC ĐẶC BIỆT (SENTENCE PATTERNS)
    // =========================================================================
    TheoryTopic(
      id: 'pattern-conditionals',
      category: TheoryCategory.sentencePatterns,
      title: 'Câu điều kiện loại 0, 1, 2, 3 & Đảo ngữ câu điều kiện',
      subtitle: 'Công thức 4 loại câu điều kiện & Dấu hiệu Should / Were / Had đảo ngữ',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['conditionals', 'inversion'],
      overview:
          'Câu điều kiện là cấu trúc trọng tâm trong TOEIC. Đặc biệt, đề thi rất thích ra dạng đảo ngữ câu điều kiện (bỏ If đưa trợ động từ lên đầu).',
      sections: [
        TheorySection(
          title: '1. Câu điều kiện loại 1 & Đảo ngữ với Should',
          content: 'Diễn tả giả định có thể xảy ra ở hiện tại hoặc tương lai.',
          formula: 'If + S + V(hiện tại), S + will/can + V_inf\nĐảo ngữ: Should + S + V_inf, S + will/can + V_inf',
          bulletPoints: [
            'Khi thấy đầu câu có "Should" và cuối câu không có dấu hỏi chấm "?" -> Đó là đảo ngữ câu điều kiện loại 1!',
            'Động từ sau chủ ngữ luôn ở dạng nguyên mẫu: "Should you have any questions, please contact us."',
          ],
          tips: [
            'Trong email công việc: "Should you need further assistance" thay cho "If you need further assistance".',
          ],
        ),
        TheorySection(
          title: '2. Câu điều kiện loại 2 & 3 và Đảo ngữ',
          content: 'Loại 2 giả định trái với hiện tại; Loại 3 giả định trái với quá khứ.',
          formula: 'Loại 2: If + S + V2/were, S + would + V_inf (Đảo ngữ: Were + S + to V / Were + S + Adj)\nLoại 3: If + S + had V3, S + would have V3 (Đảo ngữ: Had + S + V3, S + would have V3)',
          bulletPoints: [
            'Đảo ngữ loại 3 xuất hiện ở các câu Part 5 nâng cao: "Had the flight not been delayed, we would have attended the opening ceremony."',
          ],
          tips: [
            'Cụm từ tương đương: "Provided that / As long as" mang nghĩa như "If"; "Unless" = "If not".',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Should you require any additional information, please do not hesitate to reach out.',
          vietnamese: 'Nếu bạn cần thêm bất kỳ thông tin nào, xin đừng ngần ngại liên hệ.',
          explanation: 'Đảo ngữ câu điều kiện loại 1: Đưa "Should" lên đầu câu, động từ "require" giữ nguyên mẫu.',
          highlight: 'Should you require ... please do not hesitate',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-cond-1',
          question: '_______ you experience any technical difficulties, our support hotline is available 24/7.',
          options: ['Unless', 'Should', 'Whether', 'Although'],
          answerIndex: 1,
          explanation: 'Đầu câu có động từ nguyên thể "experience", vế sau là câu điều kiện -> đảo ngữ với "Should".',
        ),
        TheoryQuizQuestion(
          id: 'q-cond-2',
          question: 'Had we known about the scheduling conflict, we _______ the conference date.',
          options: ['change', 'will change', 'would have changed', 'have changed'],
          answerIndex: 2,
          explanation: 'Đảo ngữ câu điều kiện loại 3 "Had we known" -> mệnh đề chính dùng "would have changed".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-passive-voice',
      category: TheoryCategory.sentencePatterns,
      title: 'Thể Bị động toàn diện & Bị động đặc biệt',
      subtitle: 'Nhận biết tân ngữ, nội động từ không bị động & Cấu trúc Have/Get sth done',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['passive', 'verb-form'],
      overview:
          'Để làm nhanh câu chủ động / bị động trong 5 giây: Nhìn phía sau chỗ trống có Tân ngữ (danh từ) hay không. Nếu có tân ngữ -> thường là Chủ động; nếu không có tân ngữ (chỉ có giới từ/trạng từ) -> Bị động.',
      sections: [
        TheorySection(
          title: '1. Quy tắc xác định Bị động nhanh',
          content: 'Công thức chung của câu bị động luôn có dạng Be + V3/ed.',
          formula: 'S + be + V3/ed (+ by O)',
          bulletPoints: [
            'Động từ khiếm khuyết bị động: modal + be + V3 (can be installed, must be submitted).',
            'Hiện tại hoàn thành bị động: have/has been + V3 (has been approved).',
            'Hiện tại tiếp diễn bị động: is/are being + V3 (is being repaired).',
          ],
          tips: [
            'NGOẠI LỆ SỐNG CÒN: Các nội động từ (Intransitive verbs) KHÔNG BAO GIỜ chia bị động: happen, occur, arrive, remain, exist, expire, disappear, participate.',
          ],
        ),
        TheorySection(
          title: '2. Cấu trúc Bị động đặc biệt',
          content: 'Cấu trúc nhờ vả và bị động của động từ tường thuật.',
          formula: 'Have/Get sth done (nhờ/thuê ai làm gì)\nIt is believed/reported/expected that...',
          bulletPoints: [
            'Ví dụ: "We will have the air conditioning system inspected next week." (inspected chia V3 vì bổ nghĩa cho vật air conditioning).',
          ],
          tips: [
            'Cấu trúc: "be expected to V", "be required to V", "be scheduled to V" gặp cực nhiều trong TOEIC.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'All expense reports must be submitted to the finance department by Friday.',
          vietnamese: 'Tất cả các báo cáo chi phí phải được nộp cho phòng tài chính trước thứ Sáu.',
          explanation: 'Chủ ngữ "expense reports" là vật, không tự nộp -> chia bị động "must be submitted".',
          highlight: 'must be submitted to',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pass-1',
          question: 'The defective machinery is currently _______ by certified technicians.',
          options: ['repair', 'repaired', 'being repaired', 'repairing'],
          answerIndex: 2,
          explanation: 'Chủ ngữ máy móc đang được sửa chữa bởi kỹ thuật viên -> chia hiện tại tiếp diễn bị động "being repaired".',
        ),
        TheoryQuizQuestion(
          id: 'q-pass-2',
          question: 'The product warranty _______ at the end of next month.',
          options: ['is expired', 'expires', 'has been expired', 'will be expired'],
          answerIndex: 1,
          explanation: '"expire" là nội động từ, KHÔNG chia bị động -> chọn "expires" (hoặc will expire).',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-relative-clauses',
      category: TheoryCategory.sentencePatterns,
      title: 'Mệnh đề quan hệ & Rút gọn mệnh đề quan hệ',
      subtitle: 'Who, Whom, Which, That, Whose & Rút gọn V-ing / V3',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['relative-clause', 'participle'],
      overview:
          'Kỹ năng rút gọn mệnh đề quan hệ thành cụm phân từ (Present & Past Participles) là chìa khóa giải quyết các câu Part 5 dài và phức tạp.',
      sections: [
        TheorySection(
          title: '1. Đại từ quan hệ cơ bản',
          content: 'Nối hai mệnh đề với nhau dựa trên danh từ đứng trước.',
          formula: 'N_person + WHO + V | N_person + WHOM + S + V\nN_thing + WHICH + V/S + V\nN + WHOSE + Noun (chỉ sở hữu)',
          bulletPoints: [
            'That có thể thay cho Who/Which trong mệnh đề xác định (không có dấu phẩy).',
            'Không dùng "that" sau dấu phẩy hoặc sau giới từ.',
          ],
          tips: [
            'Whose luôn đi kèm một danh từ không có mạo từ: "the applicant whose resume was impressive".',
          ],
        ),
        TheorySection(
          title: '2. Rút gọn mệnh đề quan hệ (Cực kỳ quan trọng)',
          content: 'Lược bỏ đại từ quan hệ và to be, biến đổi động từ.',
          formula: 'Chủ động -> V-ing | Bị động -> V3/ed',
          bulletPoints: [
            'Chủ động: "Passengers who travel overseas" -> "Passengers traveling overseas".',
            'Bị động: "Items which are purchased online" -> "Items purchased online".',
          ],
          tips: [
            'Bẫy: Trong câu đã có động từ chính rồi, chỗ trống bổ nghĩa cho danh từ đứng trước chỉ có thể là V-ing (chủ động) hoặc V3 (bị động).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Anyone interested in attending the leadership seminar should register online.',
          vietnamese: 'Bất kỳ ai quan tâm đến việc tham gia hội thảo lãnh đạo nên đăng ký trực tuyến.',
          explanation: 'Rút gọn từ "Anyone who is interested in" -> "Anyone interested in".',
          highlight: 'Anyone interested in ... should register',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-rel-1',
          question: 'Candidates _______ a degree in computer engineering are encouraged to apply.',
          options: ['holding', 'held', 'hold', 'are holding'],
          answerIndex: 0,
          explanation: 'Câu đã có vị ngữ chính "are encouraged". Chỗ trống rút gọn mệnh đề quan hệ chủ động "who hold" -> chọn "holding".',
        ),
        TheoryQuizQuestion(
          id: 'q-rel-2',
          question: 'We need to hire an IT manager _______ expertise includes cloud architecture.',
          options: ['who', 'whom', 'whose', 'which'],
          answerIndex: 2,
          explanation: 'Sau chỗ trống là danh từ "expertise" (chuyên môn của người đó) -> chọn đại từ sở hữu "whose".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-inversion',
      category: TheoryCategory.sentencePatterns,
      title: 'Cấu trúc Đảo ngữ nâng cao trong đề TOEIC',
      subtitle: 'Đảo ngữ với trạng từ phủ định, Only when & Cụm giới từ vị trí',
      readTimeMinutes: 6,
      difficulty: 'Nâng cao',
      tags: ['inversion', 'sentence-structure'],
      overview:
          'Đảo ngữ xảy ra khi trạng từ phủ định hoặc bán phủ định được đẩy lên đầu câu nhằm mục đích nhấn mạnh. Lúc này ta mượn trợ động từ đảo lên trước chủ ngữ.',
      sections: [
        TheorySection(
          title: '1. Đảo ngữ với Trạng từ phủ định',
          content: 'Khi các từ phủ định đứng đầu câu, đảo Trợ động từ / To be / Modal lên trước Chủ ngữ.',
          formula: 'Negative Word + Trợ động từ + S + V_inf',
          bulletPoints: [
            'Từ phủ định: Seldom, Rarely, Hardly, Scarcely, Barely, Never, Little.',
            'Cụm phủ định: At no time, Under no circumstances, In no way.',
            'Ví dụ: "Seldom does our company launch a product without extensive beta testing."',
          ],
          tips: [
            'Cấu trúc vừa mới... thì đã: "Hardly had S + V3 when S + V2" / "No sooner had S + V3 than S + V2".',
          ],
        ),
        TheorySection(
          title: '2. Đảo ngữ với ONLY',
          content: 'Only after, Only when, Only by đứng đầu câu thì mệnh đề chính phía sau sẽ đảo ngữ.',
          formula: 'Only after / Only when + S + V, Trợ động từ + S + V_inf',
          bulletPoints: [
            '"Only after reviewing the feedback did the team finalize the design."',
          ],
          tips: [
            'Lưu ý: Mệnh đề ngay sau Only KHÔNG đảo, chỉ đảo ngữ ở mệnh đề chính phía sau.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Under no circumstances should confidential client files be removed from the office.',
          vietnamese: 'Dưới bất kỳ hoàn cảnh nào, tài liệu bảo mật của khách hàng cũng không được mang ra khỏi văn phòng.',
          explanation: '"Under no circumstances" đứng đầu câu -> đảo trợ động từ "should" lên trước chủ ngữ "confidential client files".',
          highlight: 'Under no circumstances should ... be removed',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-inv-1',
          question: 'Rarely _______ such a comprehensive warranty offered on commercial equipment.',
          options: ['is', 'are', 'has', 'will'],
          answerIndex: 0,
          explanation: '"Rarely" đứng đầu câu đảo ngữ. Chủ ngữ là "such a comprehensive warranty" (số ít) -> chọn "is".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-comparisons',
      category: TheoryCategory.sentencePatterns,
      title: 'Cấu trúc So sánh (Bằng, Hơn, Nhất & Càng... càng)',
      subtitle: 'Từ nhấn mạnh so sánh hơn (Much, Far) & So sánh kép',
      readTimeMinutes: 6,
      difficulty: 'Trung cấp',
      tags: ['comparisons', 'adjective', 'adverb'],
      overview:
          'So sánh xuất hiện thường xuyên ở Part 5. Đề bài hay kiểm tra từ bổ nghĩa cho so sánh hơn hoặc dạng so sánh kép "The more... the more...".',
      sections: [
        TheorySection(
          title: '1. So sánh bằng, hơn, nhất',
          content: 'Quy tắc chia tính từ/trạng từ ngắn và dài.',
          formula: 'Bằng: as + adj/adv + as\nHơn: adj-er / more + adj + than\nNhất: the + adj-est / the most + adj',
          bulletPoints: [
            'Các trạng từ nhấn mạnh mức độ so sánh hơn (CỰC KỲ QUAN TRỌNG): much, far, significantly, substantially, considerably, slightly.',
            'KHÔNG dùng "very" hoặc "more" để bổ nghĩa cho so sánh hơn: nói "much higher", KHÔNG nói "very higher".',
          ],
          tips: [
            'Bẫy: Giữa "as... as" có thể là Tính từ hoặc Trạng từ. Nhìn động từ phía trước: nếu là V thường -> dùng Adv; nếu là Be/Linking verb -> dùng Adj.',
          ],
        ),
        TheorySection(
          title: '2. So sánh kép (Càng... càng)',
          content: 'Hai vế tương hỗ nhau diễn tả mối quan hệ tỉ lệ thuận.',
          formula: 'The + comparative + S + V, the + comparative + S + V',
          bulletPoints: [
            '"The more experienced the candidate is, the higher the salary offered."',
          ],
          tips: [
            'Khi thấy đầu vế 1 có "The + so sánh hơn", vế 2 cũng phải bắt đầu bằng "The + so sánh hơn".',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The new processor operates significantly faster than the previous model.',
          vietnamese: 'Bộ vi xử lý mới hoạt động nhanh hơn đáng kể so với mẫu trước đó.',
          explanation: '"significantly" là trạng từ nhấn mạnh cho cấu trúc so sánh hơn "faster than".',
          highlight: 'significantly faster than',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-comp-1',
          question: 'This quarter’s revenue was _______ higher than our initial financial forecasts.',
          options: ['substantially', 'very', 'too', 'more'],
          answerIndex: 0,
          explanation: '"substantially" là trạng từ chuẩn dùng để nhấn mạnh cho so sánh hơn "higher" -> chọn "substantially".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-subjunctive',
      category: TheoryCategory.sentencePatterns,
      title: 'Thể giả định trong tiếng Anh thương mại',
      subtitle: 'Cấu trúc Suggest, Recommend, Require + that + S + (should) + V-inf',
      readTimeMinutes: 5,
      difficulty: 'Trung cấp',
      tags: ['subjunctive', 'verb-form'],
      overview:
          'Thể giả định diễn tả đề xuất, yêu cầu, mệnh lệnh cấp thiết. Trong mệnh đề THAT, động từ luôn ở dạng nguyên mẫu không "to", kể cả khi chủ ngữ là He, She, It.',
      sections: [
        TheorySection(
          title: 'Công thức & Động từ giả định',
          content: 'Động từ sau THAT bỏ qua mọi quy tắc chia thì/số ít số nhiều.',
          formula: 'S + V(đề xuất) + that + S + (should) + V_inf\nIt is + Adj(cần thiết) + that + S + (should) + V_inf',
          bulletPoints: [
            'Động từ: recommend, suggest, insist, request, require, demand, ask, advise, propose.',
            'Tính từ: essential, vital, necessary, imperative, important, mandatory.',
            'Ví dụ: "The CEO recommended that Mr. Baker attend the seminar." (attend giữ nguyên mẫu dù chủ ngữ là Mr. Baker).',
          ],
          tips: [
            'Nếu ở dạng bị động: dùng "be + V3/ed": "It is mandatory that all visitors be accompanied by security."',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The safety inspector requested that the factory halt operations immediately.',
          vietnamese: 'Thanh tra an toàn đã yêu cầu nhà máy tạm dừng hoạt động ngay lập tức.',
          explanation: 'Sau "requested that", động từ "halt" ở dạng nguyên mẫu giả định (không chia -s hay -ed).',
          highlight: 'requested that the factory halt',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-subj-1',
          question: 'Human Resources insists that each new employee _______ the ethics training session.',
          options: ['complete', 'completes', 'completed', 'completing'],
          answerIndex: 0,
          explanation: 'Theo cấu trúc giả định sau "insists that", động từ giữ nguyên mẫu không chia -> chọn "complete".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-parallelism',
      category: TheoryCategory.sentencePatterns,
      title: 'Cấu trúc Song hành (Parallel Structure / Parallelism)',
      subtitle: 'Quy tắc cân bằng ngữ pháp với And, But, Or & Not only... but also',
      readTimeMinutes: 6,
      difficulty: 'Trung cấp',
      tags: ['parallelism', 'sentence-structure'],
      overview:
          'Cấu trúc song hành đòi hỏi các thành phần nối với nhau bằng liên từ kết hợp (and, but, or) hoặc liên từ tương quan (both... and, not only... but also) phải cùng một dạng ngữ pháp (cùng là Noun, cùng là V-ing, cùng là Tính từ hoặc cùng là Mệnh đề).',
      sections: [
        TheorySection(
          title: '1. Quy tắc cân bằng với Liên từ kết hợp (And, But, Or)',
          content: 'Hai hoặc nhiều từ/cụm từ nối bởi liên từ phải đồng nhất về dạng thức.',
          formula: 'Noun and Noun | Adj and Adj | V-ing and V-ing | To-V and To-V',
          bulletPoints: [
            'Ví dụ đúng: "The candidate is hardworking, intelligent, and dedicated." (tất cả đều là tính từ).',
            'Ví dụ sai: "The candidate is hardworking, intelligent, and has dedication." (sai vì vế cuối là cụm động từ).',
          ],
          tips: [
            'Khi thấy liên từ "and / or / but" nằm giữa chỗ trống và một từ khác, hãy nhìn dạng từ của vế đối diện để chọn từ loại y hệt.',
          ],
        ),
        TheorySection(
          title: '2. Song hành với Liên từ tương quan',
          content: 'Áp dụng cho các cặp từ đi liền nhau.',
          formula: 'Both A and B | Not only A but also B | Either A or B | Neither A nor B',
          bulletPoints: [
            'Cả 2 vế A và B phải có cấu trúc đối xứng tuyệt đối.',
            '"The new policy aims not only to reduce costs but also to improve efficiency." (cả 2 vế đều là to-V).',
          ],
          tips: [
            'Bẫy TOEIC: Vế trước là "to inspect" nhưng vế sau lừa bằng danh từ "inspection" -> phải chọn "to repair".',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Our software engineers are responsible for designing, testing, and maintaining cloud applications.',
          vietnamese: 'Các kỹ sư phần mềm của chúng tôi chịu trách nhiệm thiết kế, kiểm thử và bảo trì các ứng dụng đám mây.',
          explanation: 'Chuỗi ba hành động nối bởi "and" đều ở dạng V-ing song hành: designing, testing, maintaining.',
          highlight: 'designing, testing, and maintaining',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-par-1',
          question: 'The executive committee praised Ms. Lin for her creativity, professionalism, and _______ under pressure.',
          options: ['calm', 'calmness', 'calmly', 'to calm'],
          answerIndex: 1,
          explanation: 'Vế trước có "creativity" và "professionalism" là danh từ, nên sau "and" bắt buộc là danh từ -> chọn "calmness".',
        ),
        TheoryQuizQuestion(
          id: 'q-par-2',
          question: 'The management decided not only to upgrade hardware but also _______ comprehensive training for all employees.',
          options: ['providing', 'to provide', 'provided', 'provides'],
          answerIndex: 1,
          explanation: 'Cấu trúc "not only to upgrade ... but also [to V]" cân bằng với to-infinitive -> chọn "to provide".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-noun-clauses',
      category: TheoryCategory.sentencePatterns,
      title: 'Mệnh đề Danh từ (Noun Clauses: That, Whether, What)',
      subtitle: 'Mệnh đề đóng vai trò Chủ ngữ, Tân ngữ & Phân biệt That vs What',
      readTimeMinutes: 7,
      difficulty: 'Nâng cao',
      tags: ['noun-clause', 'conjunctions'],
      overview:
          'Mệnh đề danh từ là một mệnh đề đầy đủ (S + V) đứng ở vị trí của một danh từ (làm chủ ngữ hoặc tân ngữ trong câu). Các câu hỏi phân biệt That / What / Whether xuất hiện thường xuyên ở Part 5 mức điểm 750+.',
      sections: [
        TheorySection(
          title: '1. Mệnh đề THAT và WHAT',
          content: 'Phân biệt mệnh đề hoàn chỉnh vs mệnh đề thiếu thành phần.',
          formula: 'THAT + S + V + O (mệnh đề đầy đủ)\nWHAT + V / S + V (mệnh đề thiếu chủ ngữ hoặc tân ngữ)',
          bulletPoints: [
            'That the project was approved surprised everyone. (Mệnh đề That làm chủ ngữ, vế sau đầy đủ S+V).',
            'What the client requested is beyond our current budget. (What thay thế cho danh từ bị thiếu của requested).',
          ],
          tips: [
            'Bí quyết: Sau chỗ trống nếu câu đã ĐẦY ĐỦ chủ ngữ + vị ngữ + tân ngữ -> chọn THAT. Nếu phía sau THIẾU tân ngữ hoặc chủ ngữ -> chọn WHAT.',
          ],
        ),
        TheorySection(
          title: '2. Mệnh đề WHETHER / IF (Liệu rằng... hay không)',
          content: 'Dùng diễn tả sự không chắc chắn hoặc cân nhắc lựa chọn.',
          formula: 'Whether + S + V + (or not) | Discuss / Wonder + whether + S + V',
          bulletPoints: [
            'Làm tân ngữ cho động từ: "The board is considering whether to expand into Asia."',
            'Làm tân ngữ cho giới từ: CHỈ DÙNG WHETHER, KHÔNG DÙNG IF ("We are concerned about whether the deal will close").',
            'Làm chủ ngữ đầu câu: CHỈ DÙNG WHETHER, KHÔNG DÙNG IF ("Whether we succeed depends on preparation").',
          ],
          tips: [
            'Đi kèm "or not": dùng "Whether or not" đứng liền nhau được, nhưng "If or not" là SAI ngữ pháp.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'What impressed the hiring committee the most was her extensive leadership experience.',
          vietnamese: 'Điều gây ấn tượng mạnh nhất với hội đồng tuyển dụng là kinh nghiệm lãnh đạo sâu rộng của cô ấy.',
          explanation: '"What" làm chủ ngữ cho mệnh đề danh từ "What impressed the hiring committee the most".',
          highlight: 'What impressed ... was her experience',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-nc-1',
          question: '_______ the local community supports the highway construction remains uncertain.',
          options: ['Whether', 'If', 'Unless', 'Despite'],
          answerIndex: 0,
          explanation: 'Đứng đầu câu làm chủ ngữ cho mệnh đề danh từ mang nghĩa "liệu rằng... hay không" chỉ dùng "Whether", không dùng "If".',
        ),
        TheoryQuizQuestion(
          id: 'q-nc-2',
          question: 'The survey results indicate _______ customer satisfaction has risen by 15%.',
          options: ['what', 'that', 'which', 'whether or'],
          answerIndex: 1,
          explanation: 'Phía sau là một mệnh đề hoàn chỉnh đầy đủ S + V ("customer satisfaction has risen") -> chọn liên từ "that".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-cleft-emphasis',
      category: TheoryCategory.sentencePatterns,
      title: 'Cấu trúc Câu chẻ & Nhấn mạnh (Cleft Sentences)',
      subtitle: 'It is... that & Dùng trợ động từ Do/Does/Did để nhấn mạnh',
      readTimeMinutes: 6,
      difficulty: 'Trung cấp',
      tags: ['emphasis', 'sentence-structure'],
      overview:
          'Trong giao tiếp và email thương mại, câu chẻ được dùng để hướng sự chú ý tối đa của người đọc vào một đối tượng, thời gian hoặc địa điểm cụ thể.',
      sections: [
        TheorySection(
          title: '1. Câu chẻ với IT IS / IT WAS ... THAT',
          content: 'Nhấn mạnh Chủ ngữ, Tân ngữ hoặc Trạng từ thời gian/nơi chốn.',
          formula: 'It is/was + [Thành phần cần nhấn mạnh] + THAT/WHO + S + V',
          bulletPoints: [
            'Nhấn mạnh chủ ngữ (người): "It was Ms. Patel who proposed the reorganization." (Chính cô Patel là người đã đề xuất).',
            'Nhấn mạnh thời gian: "It was only yesterday that we received the formal approval."',
            'Nhấn mạnh địa điểm: "It is in Tokyo that our flagship store is situated."',
          ],
          tips: [
            'Để kiểm tra câu chẻ: Nếu bỏ "It is/was" và "that" đi, phần còn lại vẫn tạo thành một câu hoàn chỉnh có nghĩa.',
          ],
        ),
        TheorySection(
          title: '2. Nhấn mạnh bằng trợ động từ DO / DOES / DID',
          content: 'Đặt trước động từ nguyên thể trong câu khẳng định.',
          formula: 'S + do / does / did + V_inf',
          bulletPoints: [
            '"I do believe that our strategy will yield positive outcomes." (Tôi thực sự tin rằng...).',
            '"The courier did deliver the parcel on time yesterday." (Người chuyển phát thực sự đã giao đúng giờ).',
          ],
          tips: [
            'Động từ sau Do/Does/Did luôn giữ nguyên mẫu, không chia thì hay số ít.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'It was the international marketing campaign that boosted our third-quarter revenue.',
          vietnamese: 'Chính chiến dịch tiếp thị quốc tế là yếu tố đã thúc đẩy doanh thu quý 3 của chúng ta.',
          explanation: 'Cấu trúc câu chẻ "It was [Noun] that [V]" để nhấn mạnh chủ thể hành động.',
          highlight: 'It was ... that boosted our revenue',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-cleft-1',
          question: 'It was during the annual general meeting _______ the CEO announced his planned retirement.',
          options: ['when', 'which', 'that', 'where'],
          answerIndex: 2,
          explanation: 'Cấu trúc câu chẻ chuẩn nhấn mạnh trạng từ chỉ thời gian: "It was ... that" -> chọn "that".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-cause-effect-purpose',
      category: TheoryCategory.sentencePatterns,
      title: 'Mẫu câu Nguyên nhân, Kết quả & Mục đích',
      subtitle: 'So... that, Such... that, Too... to, Enough to & In order to / So that',
      readTimeMinutes: 7,
      difficulty: 'Cơ bản',
      tags: ['sentence-structure', 'adjective', 'conjunctions'],
      overview:
          'Các mẫu câu chỉ kết quả (quá đến nỗi mà) và chỉ mục đích (để mà) là điểm ngữ pháp nền tảng xuất hiện dày đặc ở cả bài đọc Part 6 và Part 7.',
      sections: [
        TheorySection(
          title: '1. Cấu trúc Quá... đến nỗi mà (So... that & Such... that)',
          content: 'Chỉ mức độ dẫn đến kết quả.',
          formula: 'S + be/V + SO + Adj/Adv + THAT + S + V\nS + V + SUCH + (a/an) + Adj + Noun + THAT + S + V',
          bulletPoints: [
            '"The demands were so high that extra staff had to be hired."',
            '"It was such a demanding project that the team worked overtime."',
          ],
          tips: [
            'Ghi nhớ: "SO" đi với Tính từ/Trạng từ đơn lẻ. "SUCH" bắt buộc phải đi kèm Cụm danh từ (có Noun).',
          ],
        ),
        TheorySection(
          title: '2. Cấu trúc Too... to & Enough to',
          content: 'Quá không thể làm gì vs Đủ để làm gì.',
          formula: 'TOO + Adj/Adv + (for sb) + TO V (quá... không thể)\nAdj/Adv + ENOUGH + (for sb) + TO V (đủ... để làm gì)\nENOUGH + Noun + TO V',
          bulletPoints: [
            '"The instructions were clear enough for newcomers to follow."',
            '"We had enough financial resources to acquire the competitor."',
          ],
          tips: [
            'Lưu ý vị trí: Tính từ đứng TRƯỚC enough ("clear enough"), nhưng Danh từ đứng SAU enough ("enough time").',
          ],
        ),
        TheorySection(
          title: '3. Mẫu câu chỉ mục đích (In order to & So that)',
          content: 'Chỉ lý do hướng tới kết quả mong muốn.',
          formula: 'In order to / So as to + V_inf\nSo that / In order that + S + can/could/will + V_inf',
          bulletPoints: [
            '"The firm updated its servers in order to safeguard customer data."',
            '"We sent an alert so that subscribers could renew before the expiration date."',
          ],
          tips: [
            'Sau "in order to" là động từ nguyên mẫu V-inf; sau "so that" là cả một mệnh đề có S + Modal verb.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The keynote address was so inspiring that the entire audience gave a standing ovation.',
          vietnamese: 'Bài phát biểu chính truyền cảm hứng đến nỗi toàn bộ khán giả đã đứng dậy vỗ tay.',
          explanation: '"so + inspiring (adj) + that" diễn tả mức độ dẫn đến kết quả.',
          highlight: 'so inspiring that',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-cep-1',
          question: 'The logistics system was _______ efficient that delivery times dropped by half.',
          options: ['so', 'such', 'too', 'very'],
          answerIndex: 0,
          explanation: 'Trước tính từ "efficient" và theo sau là mệnh đề "that" -> dùng cấu trúc "so... that".',
        ),
        TheoryQuizQuestion(
          id: 'q-cep-2',
          question: 'Please submit your reimbursement claims promptly _______ the accounting team can process them.',
          options: ['in order to', 'so that', 'because of', 'due to'],
          answerIndex: 1,
          explanation: 'Phía sau là mệnh đề có chủ ngữ và động từ khuyết thiếu "the team can process" -> dùng "so that".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-participle-clauses',
      category: TheoryCategory.sentencePatterns,
      title: 'Mệnh đề Trạng ngữ Rút gọn & Bẫy Chủ ngữ treo',
      subtitle: 'Rút gọn V-ing / V3 đứng đầu câu & Quy tắc đồng chủ ngữ',
      readTimeMinutes: 7,
      difficulty: 'Nâng cao',
      tags: ['participle', 'sentence-structure'],
      overview:
          'Khi hai mệnh đề có cùng chủ ngữ, ta có thể rút gọn mệnh đề trạng ngữ đứng đầu câu thành dạng V-ing (chủ động) hoặc V3/ed (bị động). Dạng bài này phân hóa điểm số cao trong Part 5.',
      sections: [
        TheorySection(
          title: '1. Rút gọn Chủ động & Bị động',
          content: 'Lược bỏ liên từ và chủ ngữ của mệnh đề đầu.',
          formula: 'Chủ động: V-ing, S + V + O\nBị động: V3/ed, S + V + O\nNhấn mạnh hoàn thành trước: Having + V3/ed, S + V + O',
          bulletPoints: [
            'Chủ động: "After he reviewed the budget, Mr. Lin signed it." -> "Reviewing the budget, Mr. Lin signed it."',
            'Bị động: "Because it was built in 1920, the hall needed repairs." -> "Built in 1920, the hall needed repairs."',
            'Hoàn thành trước: "Having finished the audit, the inspectors submitted their report."',
          ],
          tips: [
            'Bí quyết vàng: Nhìn ngay CHỦ NGỮ sau dấu phẩy. Nếu chủ ngữ đó TỰ LÀM được hành động -> chọn V-ing. Nếu chủ ngữ đó BỊ TÁC ĐỘNG -> chọn V3/ed.',
          ],
        ),
        TheorySection(
          title: '2. Bẫy Chủ ngữ treo (Dangling Modifiers)',
          content: 'Lỗi ngữ pháp khi chủ ngữ chính không ăn khớp với phân từ đứng đầu.',
          formula: '[V-ing / V3], S(phải là chủ thể của hành động) + V',
          bulletPoints: [
            'Sai: "Walking into the office, the lights turned on." (Cái đèn không thể tự đi bộ được!).',
            'Đúng: "Walking into the office, the manager turned on the lights."',
          ],
          tips: [
            'Trong Part 5: Nếu 4 đáp án có cả V-ing và V3/ed đứng đầu câu trước dấu phẩy, hãy dịch nghĩa chủ ngữ đứng ngay sau dấu phẩy để quyết định.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Located in the heart of the business district, our headquarters offers state-of-the-art facilities.',
          vietnamese: 'Nằm tại trung tâm khu thương mại, trụ sở chính của chúng tôi cung cấp các tiện ích hiện đại bậc nhất.',
          explanation: 'Trụ sở chính (headquarters) được đặt vị trí (bị động) -> dùng quá khứ phân từ "Located" đứng đầu câu.',
          highlight: 'Located in ... our headquarters offers',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-part-1',
          question: '_______ by the unexpected market decline, the board convened an emergency strategy session.',
          options: ['Alarming', 'Alarmed', 'Alarm', 'To alarm'],
          answerIndex: 1,
          explanation: 'Hội đồng quản trị (the board) bị làm cho hoang mang bởi sự sụt giảm thị trường (bị động) -> chọn "Alarmed".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-causative',
      category: TheoryCategory.sentencePatterns,
      title: 'Cấu trúc Truyền khiến & Sai khiến (Causative Verbs)',
      subtitle: 'Have, Get, Make, Let, Help & Cấu trúc nhờ vả chủ động / bị động',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['causative', 'verb-form'],
      overview:
          'Cấu trúc truyền khiến diễn tả việc nhờ, yêu cầu, thuê hoặc cho phép người khác làm việc gì đó, hoặc có một đồ vật được bảo dưỡng, sửa chữa.',
      sections: [
        TheorySection(
          title: '1. Cấu trúc với HAVE & GET',
          content: 'Khác biệt giữa Chủ động (người làm) và Bị động (đồ vật được làm).',
          formula: 'Chủ động: S + have + O(người) + V_inf\nChủ động: S + get + O(người) + TO V\nBị động chung: S + have / get + O(vật) + V3/ed',
          bulletPoints: [
            '"The director had the assistant prepare the presentation." (prepare nguyên mẫu).',
            '"The director got the assistant to prepare the presentation." (to prepare).',
            '"We had our office air conditioning repaired yesterday." (repaired V3).',
          ],
          tips: [
            'Quy tắc ghi nhớ: "Have người V_inf" nhưng "Get người TO V". Với đồ vật thì cả 2 đều đi với V3/ed.',
          ],
        ),
        TheorySection(
          title: '2. Cấu trúc với MAKE, LET, HELP',
          content: 'Động từ chỉ ép buộc, cho phép và giúp đỡ.',
          formula: 'S + make + O + V_inf (bắt buộc ai làm gì)\nS + let + O + V_inf (cho phép ai làm gì)\nS + help + O + (to) V_inf (giúp ai làm gì)',
          bulletPoints: [
            '"New regulations make all drivers carry safety kits." (carry nguyên mẫu).',
            'Thể bị động của Make: "Be made TO V" (Bị động thì xuất hiện lại to: "Employees were made to attend the training").',
          ],
          tips: [
            'Sau Help có thể dùng cả động từ nguyên mẫu không "to" hoặc có "to": "help you install" hoặc "help you to install" đều đúng.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The facility manager had the security locks replaced following the policy review.',
          vietnamese: 'Quản lý cơ sở đã cho thay thế các khóa an ninh sau đợt xem xét chính sách.',
          explanation: 'Tân ngữ là đồ vật "the security locks" được thay thế (bị động) -> dùng V3 "replaced".',
          highlight: 'had the security locks replaced',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-caus-1',
          question: 'The supervisor got the maintenance crew _______ the leaking pipes immediately.',
          options: ['fix', 'to fix', 'fixing', 'fixed'],
          answerIndex: 1,
          explanation: 'Cấu trúc "Get + O(người) + TO V" -> chọn "to fix".',
        ),
        TheoryQuizQuestion(
          id: 'q-caus-2',
          question: 'We need to have the promotional banners _______ before the trade show begins.',
          options: ['print', 'printed', 'printing', 'to print'],
          answerIndex: 1,
          explanation: 'Cấu trúc "Have + O(vật: banners) + V3" (bị động) -> chọn "printed".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-perception-verbs',
      category: TheoryCategory.sentencePatterns,
      title: 'Động từ Tri giác & Động từ Chỉ thị',
      subtitle: 'See, Hear, Watch, Notice + V-inf vs V-ing & Dạng bị động',
      readTimeMinutes: 6,
      difficulty: 'Trung cấp',
      tags: ['perception-verbs', 'verb-form'],
      overview:
          'Động từ tri giác (chỉ giác quan: nhìn, nghe, nhận thấy) có hai cấu trúc đi kèm tùy thuộc vào việc người nói chứng kiến trọn vẹn hành động hay chỉ nhìn thấy một phần hành động đang diễn ra.',
      sections: [
        TheorySection(
          title: '1. Phân biệt V-inf vs V-ing sau Động từ tri giác',
          content: 'See, hear, watch, observe, notice + O + V_inf / V-ing.',
          formula: 'See/Hear + O + V_inf (chứng kiến TOÀN BỘ từ đầu đến cuối)\nSee/Hear + O + V-ing (chứng kiến MỘT PHẦN hành động đang diễn ra)',
          bulletPoints: [
            '"I saw the delivery driver drop the parcel." (chứng kiến toàn bộ sự việc rơi bưu kiện).',
            '"We heard technicians discussing the network issue in the hallway." (nghe thấy họ đang thảo luận lúc đi ngang qua).',
          ],
          tips: [
            'Bị động của động từ tri giác: Bắt buộc dùng "to V" ("He was seen to enter the building", KHÔNG dùng "was seen enter").',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Several witnesses noticed an unauthorized vehicle enter the restricted compound.',
          vietnamese: 'Nhiều nhân chứng nhận thấy một chiếc xe không được phép đi vào khu vực cấm.',
          explanation: 'Sau "noticed + O", động từ "enter" ở dạng nguyên mẫu miêu tả toàn bộ sự việc đi vào.',
          highlight: 'noticed an unauthorized vehicle enter',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-perc-1',
          question: 'The security guard observed a suspicious person _______ around the perimeter fence.',
          options: ['loitered', 'loitering', 'was loitering', 'to loitered'],
          answerIndex: 1,
          explanation: 'Sau "observed + O", hành động đang diễn ra được diễn tả bằng V-ing -> chọn "loitering".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-modal-past',
      category: TheoryCategory.sentencePatterns,
      title: 'Động từ Khuyết thiếu trong Quá khứ (Modal Verbs in Past)',
      subtitle: 'Must have, Should have, Could have, Can’t have + V3/ed',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['modals', 'verb-form'],
      overview:
          'Diễn tả sự suy đoán hoặc nuối tiếc về một sự việc đã xảy ra trong quá khứ. Cực kỳ thường gặp trong các bài hội thoại Part 3 và bài nói Part 4 khi nhân vật giải thích nguyên nhân sự cố.',
      sections: [
        TheorySection(
          title: '1. Bảng suy đoán mức độ chắc chắn trong quá khứ',
          content: 'Dựa vào căn cứ thực tế để suy luận.',
          formula: 'Must have + V3 (chắc chắn đã làm gì)\nCan’t / Couldn’t have + V3 (chắc chắn đã KHÔNG làm gì)\nMay / Might have + V3 (có lẽ đã làm gì, không chắc chắn)',
          bulletPoints: [
            '"The package arrived yesterday, so the supplier must have dispatched it on Monday."',
            '"He can\'t have received the memo because his computer was offline all day."',
          ],
          tips: [
            'Trong TOEIC: "Must have + V3" thường đi kèm với các bằng chứng thực tế xác đáng trong ngữ cảnh.',
          ],
        ),
        TheorySection(
          title: '2. Diễn tả sự nuối tiếc: SHOULD HAVE + V3',
          content: 'Lẽ ra nên làm gì trong quá khứ nhưng thực tế đã không làm.',
          formula: 'Should have + V3/ed (lẽ ra nên làm)\nShould not have + V3/ed (lẽ ra không nên làm)',
          bulletPoints: [
            '"We should have booked the convention hall earlier; now it is fully occupied."',
            '"You shouldn\'t have shared confidential passwords over unencrypted email."',
          ],
          tips: [
            '"Could have + V3": Đã có thể làm gì nhưng đã không làm.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'We should have reserved the conference tickets earlier because the event is now completely sold out.',
          vietnamese: 'Lẽ ra chúng ta nên đặt vé hội nghị sớm hơn vì sự kiện hiện đã bán hết sạch vé.',
          explanation: '"should have reserved" thể hiện sự tiếc nuối về việc đã không đặt vé sớm trong quá khứ.',
          highlight: 'should have reserved',
          partTag: 'Part 3 & 4',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-modp-1',
          question: 'The financial audit revealed several discrepancies; the accounts team _______ verified the receipts earlier.',
          options: ['must', 'should have', 'would have been', 'could'],
          answerIndex: 1,
          explanation: 'Ngữ cảnh thể hiện sự phê bình/nuối tiếc rằng lẽ ra phòng kế toán nên kiểm tra hóa đơn sớm hơn -> chọn "should have".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-wish-time',
      category: TheoryCategory.sentencePatterns,
      title: 'Cấu trúc Ước muốn & It’s high time',
      subtitle: 'Wish, If only & Cấu trúc đã đến lúc phải làm gì',
      readTimeMinutes: 6,
      difficulty: 'Trung cấp',
      tags: ['wish', 'subjunctive'],
      overview:
          'Cấu trúc giả định với Wish và It\'s high time dùng để diễn tả mong muốn trái với thực tế hoặc nhấn mạnh tính cấp bách của một hành động cần thực hiện ngay.',
      sections: [
        TheorySection(
          title: '1. Cấu trúc với WISH & IF ONLY',
          content: 'Lùi thì so với thời điểm mong muốn.',
          formula: 'Ước ở hiện tại: S + wish + S + V2/ed (were cho mọi ngôi)\nƯớc ở quá khứ: S + wish + S + had + V3/ed\nƯớc ở tương lai: S + wish + S + would/could + V_inf',
          bulletPoints: [
            '"I wish we had more time to finalize the proposal." (hiện tại không có đủ thời gian).',
            '"The director wishes he had attended yesterday\'s negotiation." (quá khứ đã không tham dự).',
          ],
          tips: [
            'Sau Wish ở hiện tại, động từ to be dùng "were" cho tất cả các ngôi (I wish he were here).',
          ],
        ),
        TheorySection(
          title: '2. Cấu trúc IT\'S (HIGH / ABOUT) TIME',
          content: 'Đã đến lúc ai đó PHẢI làm việc gì (mang tính nhắc nhở cấp bách).',
          formula: 'It is high time + S + V2/ed\nIt is time + (for sb) + TO V',
          bulletPoints: [
            '"It is high time we upgraded our cybersecurity infrastructure." (đã đến lúc phải nâng cấp ngay).',
            '"It is time for the committee to make a definitive decision."',
          ],
          tips: [
            'Bẫy TOEIC: Sau "It is high time + S", động từ bắt buộc chia ở QUÁ KHỨ ĐƠN (V2/ed).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'It is high time the company reviewed its remote work policies to attract younger talent.',
          vietnamese: 'Đã đến lúc công ty phải xem xét lại các chính sách làm việc từ xa để thu hút nhân tài trẻ.',
          explanation: 'Cấu trúc "It is high time + S + V2/ed" -> động từ chia quá khứ "reviewed".',
          highlight: 'It is high time the company reviewed',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-wt-1',
          question: 'It is about time our marketing department _______ a new customer loyalty program.',
          options: ['launches', 'launched', 'has launched', 'launching'],
          answerIndex: 1,
          explanation: 'Theo cấu trúc "It is about time + S + V2/ed" -> chọn "launched".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-tag-agreement',
      category: TheoryCategory.sentencePatterns,
      title: 'Câu hỏi đuôi & Mẫu câu Đồng tình',
      subtitle: 'Tag Questions & Cấu trúc So, Too, Either, Neither trong giao tiếp',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['tag-questions', 'agreement', 'listening'],
      overview:
          'Câu hỏi đuôi và mẫu câu đồng tình xuất hiện với tần suất cực lớn trong Part 2 và Part 3 của bài thi Listening nhằm xác nhận thông tin hoặc thể hiện sự tán thành.',
      sections: [
        TheorySection(
          title: '1. Quy tắc Câu hỏi đuôi (Tag Questions)',
          content: 'Đối nghịch khẳng định - phủ định giữa mệnh đề chính và phần đuôi.',
          formula: 'Mệnh đề khẳng định (+) , đuôi phủ định (-)?\nMệnh đề phủ định (-) , đuôi khẳng định (+)?',
          bulletPoints: [
            '"The shipment arrived on time, didn\'t it?"',
            '"Mr. Gomez isn\'t attending the workshop, is he?"',
            'Trường hợp đặc biệt: "Let\'s + V, shall we?" | Câu mệnh lệnh: "Open the window, will you?" | "I am ..., aren\'t I?"',
          ],
          tips: [
            'Nếu câu chính chứa từ phủ định (never, seldom, hardly, scarcely, neither, nobody) thì phần đuôi tính là KHẲNG ĐỊNH ("He never complains, does he?").',
          ],
        ),
        TheorySection(
          title: '2. Mẫu câu Đồng tình (So, Too, Neither, Either)',
          content: 'Đồng tình với ý kiến khẳng định hoặc phủ định của người khác.',
          formula: 'Đồng tình (+): So + Trợ động từ + S  HOẶC  S + Trợ động từ + too\nĐồng tình (-): Neither + Trợ động từ + S  HOẶC  S + Trợ động từ (not) + either',
          bulletPoints: [
            '"A: I like the new layout. - B: So do I / I do too."',
            '"A: I didn\'t receive the file. - B: Neither did I / I didn\'t either."',
          ],
          tips: [
            'Lưu ý: "Neither" đã mang nghĩa phủ định nên trợ động từ đi sau nó ở dạng KHẲNG ĐỊNH (Neither do I, KHÔNG nói Neither don\'t I).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Speaker A: "I haven’t had a chance to read the quarterly report." - Speaker B: "Neither have I."',
          vietnamese: 'Người A: "Tôi chưa có cơ hội đọc báo cáo quý." - Người B: "Tôi cũng chưa."',
          explanation: 'Đồng tình với câu phủ định ở thì hiện tại hoàn thành -> dùng "Neither have I".',
          highlight: 'Neither have I',
          partTag: 'Part 2 & 3',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-tag-1',
          question: 'The management team hardly ever approves overtime requests without prior notice, _______?',
          options: ['do they', 'don’t they', 'does it', 'doesn’t it'],
          answerIndex: 0,
          explanation: '"hardly ever" là trạng từ mang nghĩa phủ định, chủ ngữ "the team" thay bằng "they" -> đuôi khẳng định "do they".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-concession-advanced',
      category: TheoryCategory.sentencePatterns,
      title: 'Mẫu câu Nhượng bộ nâng cao trong bài đọc',
      subtitle: 'No matter what/how, However + Adj & Cấu trúc Adj + as/though + S + V',
      readTimeMinutes: 7,
      difficulty: 'Nâng cao',
      tags: ['concession', 'sentence-structure'],
      overview:
          'Các mẫu câu nhượng bộ nâng cao mang sắc thái trang trọng, thường xuất hiện trong các bài báo kinh tế, thư từ chính thức hoặc thông báo chính sách ở Part 6 & 7.',
      sections: [
        TheorySection(
          title: '1. Cấu trúc NO MATTER HOW / HOWEVER + ADJ',
          content: 'Dù cho... đến mức nào đi chăng nữa.',
          formula: 'No matter how + Adj/Adv + S + V, Mệnh đề chính\nHowever + Adj/Adv + S + V, Mệnh đề chính',
          bulletPoints: [
            '"However challenging the project may be, we will deliver on schedule."',
            '"No matter how experienced candidates are, all must undergo onboarding."',
          ],
          tips: [
            'Khác biệt: "However," đứng trước dấu phẩy mang nghĩa "Tuy nhiên". Còn "However + Adj" đứng liền nhau mang nghĩa "Dù... đến đâu".',
          ],
        ),
        TheorySection(
          title: '2. Đảo Tính từ lên đầu với AS / THOUGH',
          content: 'Cấu trúc nhượng bộ mang tính văn phong báo chí.',
          formula: 'Adj / Adv + AS / THOUGH + S + V, Mệnh đề chính',
          bulletPoints: [
            '"Hard as the team worked, they could not prevent the software glitch."',
            '"Successful though the product was, profit margins remained narrow."',
          ],
          tips: [
            'Công thức tương đương: "Although the team worked hard...".',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'However complex the technical specifications may seem, our support staff can guide you through each step.',
          vietnamese: 'Dù các thông số kỹ thuật có vẻ phức tạp đến đâu, đội ngũ hỗ trợ của chúng tôi có thể hướng dẫn bạn từng bước.',
          explanation: '"However + complex (adj) + S + V" thể hiện sự nhượng bộ "dù phức tạp đến đâu".',
          highlight: 'However complex the specifications may seem',
          partTag: 'Part 5 & 6',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-conc-1',
          question: '_______ difficult the financial circumstances, the corporation maintained its philanthropic contributions.',
          options: ['No matter how', 'Although', 'Despite', 'Even though'],
          answerIndex: 0,
          explanation: 'Đứng trước tính từ "difficult" tạo thành cấu trúc nhượng bộ -> chọn "No matter how".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pattern-used-to',
      category: TheoryCategory.sentencePatterns,
      title: 'Phân biệt Used to V, Be used to V-ing & Be used to V',
      subtitle: 'Thói quen quá khứ vs Đã quen với việc gì vs Được dùng để làm gì',
      readTimeMinutes: 6,
      difficulty: 'Cơ bản',
      tags: ['used-to', 'verb-form'],
      overview:
          'Ba cấu trúc chứa từ "used to" có hình thức rất giống nhau nhưng ý nghĩa và dạng động từ theo sau hoàn toàn khác biệt. Đây là một trong những câu bẫy quen thuộc của đề thi TOEIC.',
      sections: [
        TheorySection(
          title: '1. Ba công thức cốt lõi',
          content: 'Xác định dạng thức dựa trên ý nghĩa và động từ đi kèm.',
          formula: '1. S + used to + V_inf (đã từng làm gì trong quá khứ, nay không làm nữa)\n2. S + be / get used to + V-ing / Noun (đã quen / đang làm quen với việc gì ở hiện tại)\n3. S(vật) + be used to + V_inf (được dùng ĐỂ làm gì - thể bị động)',
          bulletPoints: [
            '"Mr. Lee used to manage the regional office before he transferred." (quá khứ từng quản lý).',
            '"Our sales reps are used to traveling long distances." (quen với việc đi lại nhiều).',
            '"This encrypted flash drive is used to store sensitive data." (được dùng để lưu trữ dữ liệu).',
          ],
          tips: [
            'Bí quyết: Nếu chủ ngữ là VẬT thì thường là nghĩa "được dùng để làm gì" -> chia "be used to + V_inf".',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'After two months in the international branch, Elena has gotten used to working with multicultural teams.',
          vietnamese: 'Sau hai tháng tại chi nhánh quốc tế, Elena đã dần quen với việc làm việc cùng các nhóm đa văn hóa.',
          explanation: 'Cấu trúc "get used to + V-ing" diễn tả việc dần quen với một hoạt động ở hiện tại.',
          highlight: 'gotten used to working',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-ut-1',
          question: 'The accounting team is accustomed to long hours, so they are used to _______ under tight deadlines.',
          options: ['work', 'working', 'worked', 'be worked'],
          answerIndex: 1,
          explanation: 'Sau "are used to" (đã quen với việc gì) cần một V-ing -> chọn "working".',
        ),
        TheoryQuizQuestion(
          id: 'q-ut-2',
          question: 'The specialized diagnostic scanner is used to _______ engine errors quickly.',
          options: ['detect', 'detecting', 'detected', 'detection'],
          answerIndex: 0,
          explanation: 'Chủ ngữ là đồ vật "scanner", mang nghĩa bị động "được dùng để làm gì" -> dùng V nguyên thể "detect".',
        ),
      ],
    ),

    // =========================================================================
    // NHÓM 3: TỪ LOẠI & SỰ HÒA HỢP (PARTS OF SPEECH)
    // =========================================================================
    TheoryTopic(
      id: 'pos-nouns',
      category: TheoryCategory.partsOfSpeech,
      title: 'Danh từ đếm được, không đếm được & Đuôi danh từ',
      subtitle: 'Nhận diện đuôi chỉ người/vật & Danh từ không đếm được kinh điển',
      readTimeMinutes: 6,
      difficulty: 'Cơ bản',
      tags: ['nouns', 'word-form'],
      overview:
          'Part 5 thường xuyên bẫy sự phân biệt giữa danh từ chỉ người và danh từ chỉ vật/khái niệm, hoặc danh từ không đếm được không thể đi với mạo từ "a/an" hay thêm "-s".',
      sections: [
        TheorySection(
          title: '1. Đuôi danh từ chỉ vật & chỉ người',
          content: 'Hậu tố giúp bạn nhận biết ngay từ loại danh từ.',
          formula: 'Vật: -tion, -sion, -ment, -ance, -ence, -ity, -ness, -ship\nNgười: -er, -or, -ant, -ee, -ist',
          bulletPoints: [
            'Cặp từ hay bẫy: application (đơn xin việc) vs applicant (người nộp đơn).',
            'attendance (sự tham dự) vs attendee (người tham dự).',
            'supervision (sự giám sát) vs supervisor (người giám sát).',
          ],
          tips: [
            'Nhìn vào động từ của câu: nếu hành động chỉ người làm được (sign, speak, submit) -> chọn danh từ chỉ người.',
          ],
        ),
        TheorySection(
          title: '2. Danh từ không đếm được trong đề TOEIC',
          content: 'Không bao giờ thêm "-s" và không đứng sau "a/an" hay số đếm trực tiếp.',
          formula: 'Uncountable Nouns: KHÔNG "a/an", KHÔNG "-s"',
          bulletPoints: [
            'Bảng danh từ không đếm được kinh điển: information, equipment, furniture, luggage, baggage, advice, machinery, clothing, merchandise.',
            'Để đếm cần dùng từ định lượng: "a piece of advice", "a piece of equipment".',
          ],
          tips: [
            'Bẫy: Đề thi hay cho "an equipment" hoặc "equipments" là SAI. Đáp án đúng là "equipment" hoặc "pieces of equipment".',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The successful applicant will be notified by email within two weeks.',
          vietnamese: 'Ứng viên thành công sẽ được thông báo qua email trong vòng hai tuần.',
          explanation: 'Chủ ngữ nhận email thông báo phải là người -> chọn "applicant" thay vì "application".',
          highlight: 'The successful applicant will be notified',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-noun-1',
          question: 'The warehouse installed modern _______ to speed up the packaging process.',
          options: ['equipment', 'equipments', 'an equipment', 'equipping'],
          answerIndex: 0,
          explanation: '"equipment" là danh từ không đếm được, không có số nhiều "-s" và không đi với "an" -> chọn "equipment".',
        ),
        TheoryQuizQuestion(
          id: 'q-noun-2',
          question: 'More than fifty _______ registered for the annual renewable energy conference.',
          options: ['attend', 'attendant', 'attendees', 'attendance'],
          answerIndex: 2,
          explanation: 'Sau "fifty" (50) cần danh từ đếm được số nhiều chỉ người tham dự -> chọn "attendees".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pos-adj-adv',
      category: TheoryCategory.partsOfSpeech,
      title: 'Vị trí Tính từ & Trạng từ và Bẫy vị trí',
      subtitle: 'Trật tự Adv + Adj + Noun & Vị trí vàng của Trạng từ trong câu',
      readTimeMinutes: 6,
      difficulty: 'Cơ bản',
      tags: ['adjective', 'adverb', 'word-form'],
      overview:
          'Tính từ bổ nghĩa cho danh từ, trạng từ bổ nghĩa cho động từ, tính từ và trạng từ khác. Nắm chắc "vị trí vàng" của trạng từ giúp bạn ghi điểm trọn vẹn ở các câu Word-form Part 5.',
      sections: [
        TheorySection(
          title: '1. Vị trí Tính từ & Trạng từ chuẩn',
          content: 'Trật tự cụm danh từ kinh điển trong tiếng Anh.',
          formula: 'Mạo từ / Sở hữu + [Trạng từ] + [Tính từ] + Danh từ',
          bulletPoints: [
            'Ví dụ: "an extremely (adv) profitable (adj) investment (noun)".',
            'Sau động từ nối (Linking verbs: be, become, remain, seem, appear, look) dùng TÍNH TỪ: "The report remains confidential."',
          ],
          tips: [
            'Tính từ có đuôi -ly dễ nhầm là trạng từ: friendly, timely, costly, lovely, orderly, likely.',
          ],
        ),
        TheorySection(
          title: '2. Vị trí vàng của Trạng từ (Adv)',
          content: 'Trạng từ cực kỳ linh hoạt nhưng xuất hiện nhiều nhất ở các khe kẹp sau:',
          formula: 'Have/Has + [ADV] + V3\nBe + [ADV] + V3/ed / Adj\nModal + [ADV] + V_inf',
          bulletPoints: [
            '"The team has successfully completed the project." (adv đứng giữa has và V3).',
            '"The system was completely redesigned." (adv đứng giữa was và V3).',
          ],
          tips: [
            'Khi câu đã đầy đủ Chủ ngữ, Động từ và Tân ngữ (S + V + O) mà cuối câu còn chỗ trống -> 99% điền Trạng từ để bổ nghĩa cho hành động.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The marketing team has consistently delivered outstanding results throughout the year.',
          vietnamese: 'Đội ngũ tiếp thị đã liên tục mang lại kết quả xuất sắc trong suốt cả năm.',
          explanation: 'Chỗ trống nằm kẹp giữa trợ động từ "has" và động từ chính "delivered" -> chọn trạng từ "consistently".',
          highlight: 'has consistently delivered',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-adjadv-1',
          question: 'The newly launched tablet is _______ lightweight and portable.',
          options: ['remark', 'remarkable', 'remarkably', 'remarked'],
          answerIndex: 2,
          explanation: 'Chỗ trống đứng trước tính từ "lightweight" để bổ nghĩa cho tính từ đó -> cần một trạng từ "remarkably".',
        ),
        TheoryQuizQuestion(
          id: 'q-adjadv-2',
          question: 'The committee was _______ impressed by the candidate’s credentials.',
          options: ['deep', 'deeply', 'depth', 'deepen'],
          answerIndex: 1,
          explanation: 'Kẹp giữa "was" và "impressed" (bị động) là vị trí vàng của trạng từ -> chọn "deeply".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pos-pronouns',
      category: TheoryCategory.partsOfSpeech,
      title: 'Đại từ nhân xưng, sở hữu, phản thân & bất định',
      subtitle: 'Bẫy By oneself vs On one’s own & Phân biệt Another vs Other vs The other',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['pronouns', 'word-form'],
      overview:
          'Bài tập đại từ kiểm tra khả năng xác định vai trò ngữ pháp: làm chủ ngữ, tân ngữ, tính từ sở hữu hay đại từ phản thân mang tính tự lực.',
      sections: [
        TheorySection(
          title: '1. Bảng đại từ & Đại từ phản thân',
          content: 'Mỗi dạng đại từ đảm nhận một vị trí ngữ pháp riêng.',
          formula: 'Chủ ngữ (He/They) | Tân ngữ (Him/Them)\nTính từ sở hữu (His/Their + N) | Đại từ sở hữu (His/Theirs = Adj + N)\nĐại từ phản thân (Himself/Themselves)',
          bulletPoints: [
            'Cấu trúc tự mình làm: "by oneself" = "on one\'s own". Ví dụ: "She finished the report by herself / on her own."',
            'Đại từ phản thân cũng dùng để nhấn mạnh ngay sau chủ ngữ: "The CEO himself addressed the press."',
          ],
          tips: [
            'Trước danh từ luôn dùng Tính từ sở hữu (their cars, her decision), KHÔNG dùng đại từ sở hữu hay đại từ phản thân.',
          ],
        ),
        TheorySection(
          title: '2. Bẫy Another, Other, The other, Others',
          content: 'Phân biệt cách đi kèm danh từ.',
          formula: 'Another + N_singular (một cái khác)\nOther + N_plural / N_uncountable (những cái khác)\nThe other + N_singular / N_plural (cái còn lại trong nhóm xác định)\nOthers (đại từ đứng một mình = other + N_plural)',
          bulletPoints: [
            '"We need to consider another option." (option số ít).',
            '"Some employees prefer remote work, while others prefer the office." (others đứng độc lập).',
          ],
          tips: [
            'Bẫy: "Every other + N" nghĩa là "cứ mỗi... một lần" (every other week: 2 tuần 1 lần).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Mr. Davis completed the complex financial analysis all on his own.',
          vietnamese: 'Ông Davis đã tự mình hoàn thành toàn bộ bài phân tích tài chính phức tạp.',
          explanation: '"on his own" = "by himself" mang nghĩa tự mình làm không cần ai giúp.',
          highlight: 'on his own',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pro-1',
          question: 'The interns organized the orientation event _______ without any external help.',
          options: ['they', 'them', 'their', 'themselves'],
          answerIndex: 3,
          explanation: 'Cuối câu sau một hành động hoàn chỉnh chỉ sự tự lực của nhóm thực tập sinh -> chọn "themselves".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pos-sv-agreement',
      category: TheoryCategory.partsOfSpeech,
      title: 'Sự hòa hợp Chủ ngữ - Vị ngữ (Subject-Verb Agreement)',
      subtitle: 'Each, Every, Either/Neither, The number of vs A number of',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['agreement', 'verb-form'],
      overview:
          'Quy tắc hòa hợp giữa chủ ngữ và động từ là điểm kiểm tra thường xuyên trong Part 5 & 6. Bẫy xuất hiện khi giữa chủ ngữ và động từ có cụm giới từ chen ngang làm thí sinh nhìn nhầm danh từ.',
      sections: [
        TheorySection(
          title: '1. Quy tắc số ít kinh điển',
          content: 'Các chủ ngữ sau BẮT BUỘC chia động từ ở số ít (V-s/es / is / has):',
          formula: 'S_singular -> V(s/es)',
          bulletPoints: [
            'Each / Every + N_singular (Each participant receives a certificate).',
            'Neither of / Either of + N_plural (Neither of the proposals is acceptable).',
            'The number of + N_plural (The number of applicants has increased).',
            'Đại từ bất định: Everyone, Someone, Anyone, No one, Everything, Something.',
            'V-ing làm chủ ngữ: "Designing sustainable buildings requires expertise."',
          ],
          tips: [
            'Nhớ khẩu quyết: "The number of" chia số ÍT (chỉ một con số); "A number of" chia số NHIỀU (nghĩa là nhiều người/vật).',
          ],
        ),
        TheorySection(
          title: '2. Cụm từ chen giữa & Quy tắc gần nhất',
          content: 'Bỏ qua cụm giới từ hoặc từ nối để tìm đúng chủ ngữ gốc.',
          formula: 'S1 + along with / as well as / together with + S2 -> Chia theo S1\nEither A or B / Neither A nor B / Not only A but also B -> Chia theo B (gần động từ nhất)',
          bulletPoints: [
            '"The director, along with his assistants, is attending the summit." (chia theo "The director" số ít).',
            '"Neither the manager nor the employees were informed." (chia theo "employees" số nhiều).',
          ],
          tips: [
            'Gặp chủ ngữ có dạng "N1 + of + N2": 95% động từ chia theo N1 (ví dụ: The quality of the products is high).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The quality of the manufactured components has improved significantly.',
          vietnamese: 'Chất lượng của các linh kiện được sản xuất đã được cải thiện đáng kể.',
          explanation: 'Chủ ngữ chính là "The quality" (danh từ số ít không đếm được), "of components" chỉ là cụm phụ -> chia "has improved".',
          highlight: 'The quality ... has improved',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-sva-1',
          question: 'A number of international investors _______ expressed interest in the green energy project.',
          options: ['has', 'have', 'is', 'was'],
          answerIndex: 1,
          explanation: '"A number of + N_plural" mang nghĩa số nhiều -> chia "have".',
        ),
        TheoryQuizQuestion(
          id: 'q-sva-2',
          question: 'Neither of the candidate resumes _______ the minimum technical requirements.',
          options: ['meets', 'meet', 'meeting', 'have met'],
          answerIndex: 0,
          explanation: '"Neither of + N_plural" chia động từ số ít -> chọn "meets".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pos-gerund-infinitive',
      category: TheoryCategory.partsOfSpeech,
      title: 'Danh động từ (V-ing) và Động từ nguyên mẫu (To-V)',
      subtitle: 'Động từ đi với V-ing, Động từ đi với To-V & Cụm từ cố định',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['gerund', 'infinitive', 'verb-form'],
      overview:
          'Học thuộc các động từ đi với V-ing và To-V sẽ giúp bạn chọn đáp án ngay trong 3 giây mà không cần dịch nghĩa cả câu.',
      sections: [
        TheorySection(
          title: '1. Động từ theo sau bởi V-ing & To-V',
          content: 'Bảng phân loại các động từ thông dụng nhất trong TOEIC.',
          formula: 'V + V-ing | V + to V',
          bulletPoints: [
            'Theo sau bởi V-ing: consider, enjoy, avoid, delay, postpone, recommend, suggest, mind, finish, practice, quit.',
            'Theo sau bởi To-V: decide, plan, hope, want, agree, refuse, offer, manage, intend, promise, afford, tend.',
            'Cấu trúc V + O + to V: allow, require, ask, encourage, remind, invite, enable, expect, permit.',
          ],
          tips: [
            'Cụm từ đặc biệt có "to" nhưng theo sau là V-ing: look forward to V-ing, be used to V-ing, in addition to V-ing, prior to V-ing, object to V-ing.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'We are looking forward to receiving your constructive feedback on the proposal.',
          vietnamese: 'Chúng tôi rất mong nhận được phản hồi mang tính xây dựng của bạn về đề xuất.',
          explanation: 'Sau cụm cố định "look forward to" bắt buộc dùng V-ing -> "receiving".',
          highlight: 'looking forward to receiving',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-gi-1',
          question: 'The committee decided _______ the product launch until next spring.',
          options: ['postpone', 'to postpone', 'postponing', 'postponed'],
          answerIndex: 1,
          explanation: 'Sau "decide" dùng động từ nguyên thể có "to" -> chọn "to postpone".',
        ),
        TheoryQuizQuestion(
          id: 'q-gi-2',
          question: 'Due to inclement weather, flight operations had to consider _______ all departures.',
          options: ['cancel', 'to cancel', 'canceling', 'cancellation'],
          answerIndex: 2,
          explanation: 'Sau "consider" đi với V-ing -> chọn "canceling".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pos-conjunctions-prepositions',
      category: TheoryCategory.partsOfSpeech,
      title: 'Liên từ vs Giới từ (Bẫy kinh điển Part 5)',
      subtitle: 'Although vs Despite, Because vs Due to, While vs During',
      readTimeMinutes: 7,
      difficulty: 'Cơ bản',
      tags: ['conjunctions', 'prepositions', 'word-form'],
      overview:
          'Bẫy phổ biến số 1 trong Part 5 là cho 4 đáp án có cùng nghĩa nhưng 2 từ là Liên từ (đi với mệnh đề S+V) và 2 từ là Giới từ (đi với cụm danh từ/V-ing).',
      sections: [
        TheorySection(
          title: '1. Bảng đối ứng Liên từ vs Giới từ',
          content: 'Nhìn phía sau chỗ trống là Mệnh đề (S+V) hay Cụm danh từ (Noun phrase) để quyết định.',
          formula: 'Liên từ + Mệnh đề (S + V)\nGiới từ + Cụm danh từ / V-ing',
          bulletPoints: [
            'Mặc dù: Although / Even though / Though (Liên từ) vs Despite / In spite of (Giới từ).',
            'Bởi vì: Because / Since / As (Liên từ) vs Because of / Due to / Owing to (Giới từ).',
            'Trong khi: While (Liên từ) vs During (Giới từ).',
          ],
          tips: [
            'Trạng từ liên kết (Conjunctive adverbs) đứng đầu câu ngăn cách bởi dấu phẩy: However, Therefore, Furthermore, Moreover, Consequently.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Despite heavy traffic, the delivery arrived at the warehouse on schedule.',
          vietnamese: 'Mặc dù giao thông đông đúc, chuyến giao hàng vẫn cập bến kho đúng giờ.',
          explanation: '"heavy traffic" là cụm danh từ (không có động từ) -> dùng giới từ "Despite" thay vì "Although".',
          highlight: 'Despite heavy traffic',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-cp-1',
          question: '_______ the economic downturn, the tech startup expanded its workforce by 30%.',
          options: ['Although', 'Despite', 'Even though', 'Whereas'],
          answerIndex: 1,
          explanation: 'Sau chỗ trống là cụm danh từ "the economic downturn" -> chọn giới từ "Despite".',
        ),
        TheoryQuizQuestion(
          id: 'q-cp-2',
          question: 'The flight was delayed _______ there was dense fog over the runway.',
          options: ['because', 'because of', 'due to', 'owing to'],
          answerIndex: 0,
          explanation: 'Phía sau là mệnh đề có chủ ngữ và vị ngữ "there was dense fog" -> chọn liên từ "because".',
        ),
      ],
    ),

    // =========================================================================
    // NHÓM 4: CHIẾN THUẬT & MẸO THI PART 1–7 (STRATEGY)
    // =========================================================================
    TheoryTopic(
      id: 'strategy-part1',
      category: TheoryCategory.strategy,
      title: 'Mẹo thi Part 1 (Mô tả tranh & Bẫy Being)',
      subtitle: 'Chiến thuật quan sát, bẫy hành động vs trạng thái & Bẫy vật không tự di chuyển',
      readTimeMinutes: 7,
      difficulty: 'Cơ bản',
      tags: ['part1', 'listening', 'strategy'],
      overview:
          'Part 1 có 6 bức tranh. Tận dụng thời gian băng đọc hướng dẫn để quan sát nhanh các yếu tố: người, hành động, vị trí đồ vật và không gian nền.',
      sections: [
        TheorySection(
          title: '1. Mẹo vàng "Being + V3" (Bẫy vật không tự di chuyển)',
          content: 'Nguyên tắc loại suy mạnh nhất trong Part 1.',
          formula: 'Tranh không người + Nghe thấy "being + V3" -> 99% LOẠI BỎ',
          bulletPoints: [
            'Cấu trúc "is/are being + V3" diễn tả hành động đang được một NGƯỜI tác động lên đồ vật (ví dụ: "The car is being repaired").',
            'Nếu trong tranh KHÔNG có bóng dáng con người mà nghe thấy "being" -> loại ngay lập tức!',
            'Ngoại lệ hiếm hoi: "The display is being shown" hoặc cây cối đổ bóng "Trees are casting shadows".',
          ],
          tips: [
            'Phân biệt: "is displayed" (đang được trưng bày sẵn - trạng thái tĩnh) vs "is being displayed" (đang có người mang ra trưng bày).',
          ],
        ),
        TheorySection(
          title: '2. Phân biệt Trạng thái vs Hành động',
          content: 'Bẫy trang phục và phụ kiện thường xuyên xuất hiện.',
          formula: 'Wearing (đang mặc trên người) vs Putting on (hành động đang xỏ tay áo vào)',
          bulletPoints: [
            'Nếu người trong tranh đã mặc sẵn áo/đeo kính -> chọn "wearing".',
            'Nếu tay đang cầm áo chuẩn bị mặc vào -> chọn "putting on".',
          ],
          tips: [
            'Bẫy âm tương đồng: Từ phát âm na ná các vật trong hình nhưng sai nghĩa (vd: "coffee" vs "copy").',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Picture shows books neatly arranged on shelves with no people. Option: "Books are being placed on the shelf."',
          vietnamese: 'Tranh chỉ có sách xếp ngăn nắp trên kệ, không có người. Đáp án: "Sách đang được xếp lên kệ."',
          explanation: 'Không có người thì không thể có hành động "being placed" -> loại ngay đáp án này.',
          highlight: 'being placed on the shelf -> LOẠI',
          partTag: 'Part 1',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-strat-p1-1',
          question: 'Trong bức tranh chỉ có một chiếc xe đỗ trong gara trống, không có người. Nghe thấy: "The vehicle is being washed." Ta nên làm gì?',
          options: ['Chọn ngay vì có chiếc xe', 'Loại bỏ vì tranh không có người tác động hành động being', 'Chờ nghe lại', 'Đoán bừa'],
          answerIndex: 1,
          explanation: '"Being washed" đòi hỏi phải có người đang rửa xe. Tranh không có người thì loại ngay câu chứa "being".',
        ),
      ],
    ),

    TheoryTopic(
      id: 'strategy-part2',
      category: TheoryCategory.strategy,
      title: 'Mẹo thi Part 2 (Hỏi - Đáp 25 câu & Bẫy Yes/No)',
      subtitle: 'Quy tắc loại suy câu hỏi Wh-, bẫy từ đồng âm & Mẹo câu trả lời gián tiếp',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['part2', 'listening', 'strategy'],
      overview:
          'Part 2 không có chữ trên đề thi, đòi hỏi sự tập trung cao độ vào từ để hỏi đầu tiên (Who, Where, When, Why, How, What).',
      sections: [
        TheorySection(
          title: '1. Quy tắc loại trừ thần tốc',
          content: 'Không cần hiểu 100% câu vẫn có thể loại bỏ 2 đáp án sai.',
          formula: 'Wh- Questions -> KHÔNG chọn Yes/No/Sure/Of course',
          bulletPoints: [
            'Khi câu hỏi bắt đầu bằng Who, Where, When, Why, How, What: đáp án nào bắt đầu bằng "Yes", "No", "Sure", "Certainly" -> LOẠI 100%.',
            'Bẫy lặp lại từ (Same sound trap): Đáp án lặp lại từ y hệt hoặc từ phát âm na ná câu hỏi thường là 80% bẫy đánh lừa.',
          ],
          tips: [
            'Ví dụ: Câu hỏi có "project", đáp án có "projection" -> bẫy lặp âm, hãy cẩn thận!',
          ],
        ),
        TheorySection(
          title: '2. Mẹo "Câu trả lời gián tiếp" luôn đúng 90%',
          content: 'Dạng đáp án né tránh hoặc không biết thông tin.',
          formula: 'I have no idea / Let me check / It hasn’t been decided yet',
          bulletPoints: [
            '"I\'m not sure."',
            '"Let me check with the department head."',
            '"It hasn\'t been announced yet."',
            '"Why don\'t you ask Sarah in accounting?"',
          ],
          tips: [
            'Khi nghe thấy đáp án thể hiện việc hỏi người khác hoặc thông tin chưa chốt, thường đó là đáp án đúng.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Question: "Where should I file these client invoices?" - Option: "Yes, I did yesterday." vs "Ask Ms. Gomez in accounting."',
          vietnamese: 'Câu hỏi: "Tôi nên lưu các hóa đơn khách hàng này ở đâu?" - Đáp án: "Hỏi cô Gomez ở phòng kế toán nhé."',
          explanation: 'Câu hỏi Where không chọn "Yes". Đáp án chỉ dẫn hỏi người khác là câu trả lời gián tiếp chuẩn xác.',
          highlight: 'Where ... -> Ask Ms. Gomez',
          partTag: 'Part 2',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-strat-p2-1',
          question: 'Question: "When will the quarterly review meeting start?" - Đáp án nào sau đây khả năng cao là ĐÚNG?',
          options: ['Yes, at 2 PM.', 'It hasn’t been scheduled yet.', 'Meeting with clients.', 'Start the engine.'],
          answerIndex: 1,
          explanation: 'Câu hỏi When không chọn "Yes" (loại A). C & D là bẫy lặp từ. Đáp án gián tiếp "It hasn’t been scheduled yet" là đáp án đúng.',
        ),
      ],
    ),

    TheoryTopic(
      id: 'strategy-part3-4',
      category: TheoryCategory.strategy,
      title: 'Chiến thuật Part 3 & 4 (Đọc trước đề & 8 giây vàng)',
      subtitle: 'Kỹ thuật đọc trước 3 câu hỏi, bắt từ khóa & Câu hỏi nhìn bảng biểu Graphics',
      readTimeMinutes: 8,
      difficulty: 'Trung cấp',
      tags: ['part3', 'part4', 'listening', 'strategy'],
      overview:
          'Điểm số Part 3 & 4 phụ thuộc 70% vào khả năng đọc trước câu hỏi trong "khoảng thời gian vàng" giữa các đoạn hội thoại.',
      sections: [
        TheorySection(
          title: '1. Quy tắc "8 giây vàng"',
          content: 'Tận dụng thời gian đọc hướng dẫn và thời gian nghỉ giữa 2 đoạn.',
          formula: 'Vừa nghe vừa tô đáp án -> Dành trọn 8 giây nghỉ để đọc 3 câu tiếp theo',
          bulletPoints: [
            'Khi đoạn audio vừa kết thúc, bạn phải hoàn thành việc chọn cả 3 câu.',
            'Khi người đọc bắt đầu đọc câu hỏi 1, 2, 3 thì mắt bạn đã phải nhìn xuống 3 câu của ĐOẠN TIẾP THEO để gạch chân từ khóa.',
          ],
          tips: [
            'Từ khóa cần gạch: Danh từ riêng, nghề nghiệp người nói, vấn đề phàn nàn, hành động tiếp theo (next).',
          ],
        ),
        TheorySection(
          title: '2. Chiến thuật câu hỏi nhìn bảng biểu (Graphics)',
          content: 'Không nhìn vào thông tin đã có sẵn trong các đáp án A/B/C/D.',
          formula: 'Nghe thông tin ở Cột A -> Tìm đáp án tương ứng ở Cột B',
          bulletPoints: [
            'Ví dụ: 4 đáp án A, B, C, D là tên phòng (Room 101, Room 102...). Khi nghe, người nói sẽ KHÔNG nói số phòng mà nói tên chủ đề cuộc họp tương ứng ở cột bên cạnh!',
          ],
          tips: [
            'Nguyên tắc đối chiếu chéo thông tin giúp bắt trọn điểm câu hỏi hình ảnh trong Part 3 & 4.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Graphic shows: Table with Workshop names and Room numbers. Question asks: "Which room will the woman go to?"',
          vietnamese: 'Bảng biểu hiển thị tên hội thảo và số phòng. Câu hỏi: "Người phụ nữ sẽ đến phòng nào?"',
          explanation: 'Người nói sẽ nhắc đến tên buổi hội thảo "Digital Marketing", nhìn vào bảng thấy phòng 304 -> chọn phòng 304.',
          highlight: 'Cross-reference audio clue with chart column',
          partTag: 'Part 3',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-strat-p3-1',
          question: 'Khi làm Part 3 & 4, thời điểm lý tưởng nhất để đọc 3 câu hỏi của đoạn tiếp theo là khi nào?',
          options: ['Khi đoạn băng tiếp theo bắt đầu nói', 'Khi người đọc băng đang đọc 3 câu hỏi của đoạn trước', 'Sau khi kết thúc toàn bộ bài thi', 'Không cần đọc trước'],
          answerIndex: 1,
          explanation: 'Tận dụng lúc băng đọc lại các câu hỏi của đoạn vừa xong để tranh thủ đọc trước 3 câu của bài tiếp theo.',
        ),
      ],
    ),

    TheoryTopic(
      id: 'strategy-part5',
      category: TheoryCategory.strategy,
      title: 'Chiến thuật Part 5 (Hoàn thành câu trong 10-15 giây)',
      subtitle: 'Phân loại câu ngữ pháp vs từ vựng & Kỹ thuật canh giờ 10 phút',
      readTimeMinutes: 7,
      difficulty: 'Cơ bản',
      tags: ['part5', 'reading', 'strategy'],
      overview:
          'Part 5 gồm 30 câu. Mục tiêu chuẩn: Hoàn thành trong 10–12 phút để dành tối đa thời gian cho bài đọc dài Part 7.',
      sections: [
        TheorySection(
          title: '1. Phân loại câu hỏi trong 1 giây đầu tiên',
          content: 'Nhìn 4 đáp án trước khi đọc câu hỏi.',
          formula: '4 đáp án chung gốc từ -> Câu Ngữ pháp (xử lý 10s)\n4 đáp án khác nghĩa -> Câu Từ vựng (xử lý 20-30s)',
          bulletPoints: [
            'Câu ngữ pháp: Chỉ cần nhìn từ đứng ngay trước và ngay sau chỗ trống để xác định từ loại còn thiếu (Noun, Adj, Adv, Verb-form). Không cần dịch cả câu!',
            'Câu từ vựng: Tìm nhanh chủ ngữ, vị ngữ và tân ngữ chính để nắm ý nghĩa cốt lõi, tìm collocations quen thuộc.',
          ],
          tips: [
            'Nếu gặp câu từ vựng lạ quá 30 giây không nghĩ ra -> chọn đáp án cảm tính và ĐI TIẾP, không được dừng lại quá lâu.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The CEO _______ announced the opening of a new research center. (Options: recent, recently, recency, more recent)',
          vietnamese: 'Tổng giám đốc vừa mới công bố việc mở trung tâm nghiên cứu mới.',
          explanation: '4 đáp án cùng gốc từ "recent". Chỗ trống đứng giữa chủ ngữ "The CEO" và động từ "announced" -> cần trạng từ "recently" (giải quyết trong 5s).',
          highlight: 'The CEO [recently] announced',
          partTag: 'Part 5',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-strat-p5-1',
          question: 'Thời gian tối đa nên dành cho toàn bộ 30 câu Part 5 là bao nhiêu phút?',
          options: ['10–12 phút', '25 phút', '35 phút', '50 phút'],
          answerIndex: 0,
          explanation: '30 câu Part 5 nên làm trong 10-12 phút (khoảng 20s/câu) để dành trọn vẹn 55 phút cho Part 7.',
        ),
      ],
    ),

    TheoryTopic(
      id: 'strategy-part6',
      category: TheoryCategory.strategy,
      title: 'Chiến thuật Part 6 (Điền đoạn văn & Câu điền nguyên câu)',
      subtitle: 'Kỹ thuật định vị câu điền nguyên câu & Dấu hiệu liên từ nối logic',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['part6', 'reading', 'strategy'],
      overview:
          'Part 6 gồm 16 câu chia làm 4 đoạn văn. Thách thức lớn nhất là dạng câu "Chọn câu văn thích hợp nhất điền vào chỗ trống".',
      sections: [
        TheorySection(
          title: '1. Xử lý câu điền nguyên câu (Sentence Insertion)',
          content: 'Quy tắc nhìn câu trước và câu sau chỗ trống.',
          formula: 'Câu phía trước -> [CÂU CẦN ĐIỀN] -> Câu phía sau',
          bulletPoints: [
            'Tìm đại từ thay thế (This, These, Such, It, They) trong câu đáp án kết nối với nội dung câu phía trước.',
            'Tìm từ nối chỉ quan hệ: "For example" (đưa ra minh chứng), "However" (phản bác), "Therefore" (kết quả), "In addition" (bổ sung).',
          ],
          tips: [
            'Nếu câu sau chỗ trống bắt đầu bằng "Please contact...", câu điền vào thường là thông báo về sự cố hoặc thông tin cần liên hệ.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Sentence before: "Our annual budget has been reduced." Blank. Sentence after: "Consequently, we must postpone our equipment upgrade."',
          vietnamese: 'Câu trước: Ngân sách bị cắt giảm. Chỗ trống. Câu sau: Do đó chúng ta phải hoãn nâng cấp.',
          explanation: 'Câu điền vào giải thích lý do cần thắt chặt chi tiêu để logic với từ nối "Consequently" ở câu sau.',
          highlight: 'budget reduced -> consequently postpone',
          partTag: 'Part 6',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-strat-p6-1',
          question: 'Dấu hiệu quan trọng nhất để chọn đúng câu điền nguyên câu trong Part 6 là gì?',
          options: ['Chọn câu dài nhất', 'Tìm mối liên kết logic, từ nối và đại từ thay thế với câu trước và câu sau', 'Chọn câu chứa từ vựng khó nhất', 'Luôn chọn câu có từ However'],
          answerIndex: 1,
          explanation: 'Tính mạch lạc của đoạn văn dựa vào từ nối logic (Therefore, However) và đại từ liên kết (This, These) giữa các câu.',
        ),
      ],
    ),

    TheoryTopic(
      id: 'strategy-part7',
      category: TheoryCategory.strategy,
      title: 'Chiến thuật Part 7 (Đọc hiểu 54 câu - Quét bài & Móc xích)',
      subtitle: 'Phân bổ 55 phút vàng, kỹ thuật Paraphrase & Xử lý bài đọc kép/ba',
      readTimeMinutes: 8,
      difficulty: 'Nâng cao',
      tags: ['part7', 'reading', 'strategy'],
      overview:
          'Part 7 chiếm 54 câu trên tổng số 100 câu Reading. Phân bổ thời gian hợp lý và làm chủ kỹ thuật Paraphrase (diễn đạt lại bằng từ đồng nghĩa) quyết định điểm số 800+ TOEIC.',
      sections: [
        TheorySection(
          title: '1. Chiến thuật phân bổ 55 phút vàng',
          content: 'Đừng để bị thiếu giờ làm bài ở các đoạn cuối!',
          formula: 'Đoạn đơn (Single passages - 29 câu): 30 phút\nĐoạn kép & ba (Double & Triple - 25 câu): 25 phút',
          bulletPoints: [
            'Đoạn đơn: Trung bình 55 giây/câu.',
            'Đoạn kép & ba: Trung bình 60 giây/câu.',
            'Đọc lướt câu hỏi trước để ghi nhớ từ khóa (tên riêng, ngày tháng, chức vụ, số tiền) rồi quét bài đọc.',
          ],
          tips: [
            'Nếu còn 5 phút mà còn 10 câu: hãy dùng trực giác tô nhanh tất cả đáp án, tuyệt đối không để trống phiếu trả lời!',
          ],
        ),
        TheorySection(
          title: '2. Kỹ thuật bắt bẫy Cross-Passage (Bài đọc kép/ba)',
          content: 'Câu hỏi móc xích thông tin giữa 2 đoạn văn.',
          formula: 'Dữ kiện 1 (Đoạn 1) + Dữ kiện 2 (Đoạn 2) -> Đáp án suy luận',
          bulletPoints: [
            'Trong bài đọc kép/ba, câu hỏi số 3 hoặc 4 thường KHÔNG nằm trọn trong 1 đoạn.',
            'Ví dụ: Đoạn 1 là email đặt món ăn "Gold package", Đoạn 2 là hóa đơn ghi giá từng món -> Câu hỏi hỏi tổng chi phí là bao nhiêu.',
          ],
          tips: [
            'Bẫy Paraphrase: Đáp án ĐÚNG hầu như luôn dùng TỪ ĐỒNG NGHĨA. Từ nào trong bài đọc lặp lại y hệt 100% trong đáp án thường là bẫy đánh lừa!',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Passage 1 mentions "Gold members receive 20% discount". Passage 2 shows an invoice with total \$80. Question asks: How much was the original price?',
          vietnamese: 'Đoạn 1 nói thành viên Vàng giảm 20%. Đoạn 2 hóa đơn \$80. Hỏi: Giá gốc là bao nhiêu? -> \$100.',
          explanation: 'Câu hỏi móc xích điển hình kết hợp thông tin mức giảm giá ở đoạn 1 và số tiền thanh toán ở đoạn 2.',
          highlight: 'Cross-passage inference (Móc xích 2 đoạn)',
          partTag: 'Part 7',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-strat-p7-1',
          question: 'Trong Part 7, đặc điểm điển hình của đáp án ĐÚNG cho câu hỏi chi tiết là gì?',
          options: ['Lặp lại y hệt từng từ có trong bài đọc', 'Sử dụng từ đồng nghĩa (Paraphrase) để diễn đạt lại nội dung', 'Chứa các từ tuyệt đối như always, never', 'Là đáp án dài nhất trong 4 lựa chọn'],
          answerIndex: 1,
          explanation: 'ETS luôn kiểm tra vốn từ vựng bằng cách dùng từ đồng nghĩa (paraphrase) trong đáp án đúng.',
        ),
      ],
    ),

    // =========================================================================
    // NHÓM 5: PHÁT ÂM & KỸ NĂNG NGHE THỰC CHIẾN (PRONUNCIATION)
    // =========================================================================
    TheoryTopic(
      id: 'pronunciation-vowels',
      category: TheoryCategory.pronunciation,
      title: 'Bảng Nguyên âm IPA (Nguyên âm đơn & Nguyên âm đôi)',
      subtitle: 'Phân biệt nguyên âm ngắn / dài & Sự khác biệt giọng US - UK',
      readTimeMinutes: 7,
      difficulty: 'Cơ bản',
      tags: ['pronunciation', 'ipa', 'listening'],
      overview:
          'Bảng 44 âm IPA là nền móng để nghe chuẩn từng từ trong đề thi TOEIC. Phân biệt được nguyên âm ngắn và dài giúp bạn tránh nghe nhầm các từ có nghĩa hoàn toàn khác nhau.',
      sections: [
        TheorySection(
          title: '1. Cặp nguyên âm ngắn vs dài',
          content: 'Âm dài có dấu hai chấm ":" và cần kéo dài hơi hơn.',
          formula: '/iː/ vs /ɪ/ | /uː/ vs /ʊ/ | /ɔː/ vs /ɒ/ | /ɑː/ vs /ʌ/',
          bulletPoints: [
            '/iː/ vs /ɪ/: sheep (con cừu) vs ship (tàu thủy); leave (rời đi) vs live (sống).',
            '/uː/ vs /ʊ/: fool (kẻ ngốc) vs full (đầy); pool (bể bơi) vs pull (kéo).',
            '/ɔː/ vs /ɒ/: port (cảng) vs pot (nồi); caught (bắt) vs cot (giường cũi).',
          ],
          tips: [
            'Luyện tập khẩu hình miệng: Âm ngắn bật hơi nhanh, dứt khoát; âm dài giữ hơi ổn định trong cổ họng.',
          ],
        ),
        TheorySection(
          title: '2. Nguyên âm đôi (Diphthongs)',
          content: 'Sự trượt mượt mà từ âm này sang âm khác.',
          formula: '/eɪ/, /aɪ/, /ɔɪ/, /aʊ/, /əʊ/, /ɪə/, /eə/',
          bulletPoints: [
            '/eɪ/: pay, late, make, explain.',
            '/aɪ/: price, client, flight, sign.',
            '/əʊ/ (US: /oʊ/): phone, notice, propose, open.',
          ],
          tips: [
            'Khác biệt US - UK: Giọng Mỹ phát âm rõ âm /r/ ở cuối từ (car, board, floor), trong khi giọng Anh kéo dài nguyên âm và nuốt âm /r/.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Please take a seat /siːt/ while we check your ticket. (Don’t confuse with sit /sɪt/)',
          vietnamese: 'Xin vui lòng ngồi xuống trong khi chúng tôi kiểm tra vé của bạn.',
          explanation: 'Danh từ "seat" có âm /iː/ dài, khác với động từ "sit" có âm /ɪ/ ngắn.',
          highlight: 'seat /siːt/ vs sit /sɪt/',
          partTag: 'Part 1 & 2',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pron-v1',
          question: 'Từ "leave" (rời đi) chứa nguyên âm nào trong bảng phiên âm IPA?',
          options: ['/ɪ/ (ngắn)', '/iː/ (dài)', '/e/', '/aɪ/'],
          answerIndex: 1,
          explanation: '"leave" phát âm là /liːv/ với nguyên âm /iː/ dài, phân biệt với "live" /lɪv/ có nguyên âm /ɪ/ ngắn.',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pronunciation-consonants',
      category: TheoryCategory.pronunciation,
      title: 'Cặp Phụ âm dễ nhầm lẫn trong đề nghe TOEIC',
      subtitle: 'Phụ âm vô thanh vs hữu thanh, cặp âm /s/ - /ʃ/ và /θ/ - /ð/',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['pronunciation', 'ipa', 'listening'],
      overview:
          'Trong băng nghe TOEIC Part 1 & 2, người đọc thường dùng các từ có phụ âm na ná nhau để gài bẫy thí sinh không nghe rõ âm cuối hoặc cặp âm gió.',
      sections: [
        TheorySection(
          title: '1. Phụ âm vô thanh vs hữu thanh',
          content: 'Âm vô thanh chỉ có luồng hơi, âm hữu thanh làm rung dây thanh quản.',
          formula: '/p/ - /b/ | /t/ - /d/ | /k/ - /g/ | /f/ - /v/',
          bulletPoints: [
            '/p/ vs /b/: pack (đóng gói) vs back (phía sau); copy vs coffee.',
            '/t/ vs /d/: write (viết) vs ride (cưỡi xe); tie (cà vạt) vs die.',
          ],
          tips: [
            'Đặt ngón tay lên cổ họng: khi phát âm /b/, /d/, /g/ cổ họng phải rung; khi phát âm /p/, /t/, /k/ cổ họng không rung.',
          ],
        ),
        TheorySection(
          title: '2. Cặp âm gió hay nhầm lẫn nhất',
          content: 'Đặc biệt quan trọng với người học Việt Nam.',
          formula: '/s/ vs /ʃ/ | /θ/ vs /ð/ | /tʃ/ vs /dʒ/',
          bulletPoints: [
            '/s/ (xè răng) vs /ʃ/ (chu môi): see vs she; sell vs shell; sign vs shine.',
            '/θ/ (đặt lưỡi giữa 2 hàm răng, đẩy hơi) vs /ð/ (rung lưỡi): think vs this; thank vs that.',
            '/tʃ/ vs /dʒ/: cheap (rẻ) vs jeep (xe díp); choose vs juice.',
          ],
          tips: [
            'Phụ âm đuôi (Ending sounds) quyết định nghĩa: "nice" /naɪs/ vs "nine" /naɪn/ vs "night" /naɪt/.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'She sells /selz/ seashells by the seashore. Notice the shift between /s/ and /ʃ/.',
          vietnamese: 'Cô ấy bán vỏ sò bên bờ biển. Chú ý sự luân chuyển giữa âm /s/ và /ʃ/.',
          explanation: '"sells" có âm /s/, "she" và "shell" có âm /ʃ/.',
          highlight: '/s/ (sells) vs /ʃ/ (she, shell)',
          partTag: 'Part 1 & 2',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pron-c1',
          question: 'Âm đầu tiên của từ "think" trong tiếng Anh được phát âm như thế nào?',
          options: ['/t/', '/s/', '/θ/ (đặt lưỡi giữa răng đẩy hơi)', '/f/'],
          answerIndex: 2,
          explanation: '"think" bắt đầu bằng âm vô thanh /θ/, phát âm bằng cách đặt đầu lưỡi giữa hai hàm răng và đẩy luồng hơi ra.',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pronunciation-stress',
      category: TheoryCategory.pronunciation,
      title: 'Quy tắc đánh Trọng âm từ 2-3 âm tiết',
      subtitle: 'Quy tắc Danh - Động từ, hậu tố nhận trọng âm & Hậu tố dịch chuyển trọng âm',
      readTimeMinutes: 7,
      difficulty: 'Trung cấp',
      tags: ['pronunciation', 'stress', 'listening'],
      overview:
          'Nắm được trọng âm giúp bạn nhận diện từ khi người bản xứ nói nhanh. Trong tiếng Anh, âm tiết mang trọng âm sẽ được phát âm to hơn, cao hơn và dài hơn.',
      sections: [
        TheorySection(
          title: '1. Quy tắc từ 2 âm tiết',
          content: 'Quy tắc phân biệt Danh từ / Tính từ vs Động từ.',
          formula: 'Danh từ & Tính từ: Trọng âm âm tiết 1\nĐộng từ: Trọng âm âm tiết 2',
          bulletPoints: [
            'Danh từ: \'contract (hợp đồng), \'record (kỷ lục), \'present (món quà), \'project (dự án).',
            'Động từ: con\'tract (co lại), re\'cord (ghi âm), pre\'sent (thuyết trình), pro\'ject (phóng ra).',
          ],
          tips: [
            'Các ngoại lệ thông dụng: ho\'tel (danh từ nhưng nhấn âm 2), \'machine (danh từ nhấn âm 2).',
          ],
        ),
        TheorySection(
          title: '2. Quy tắc hậu tố (Suffixes)',
          content: 'Hậu tố chi phối vị trí trọng âm.',
          formula: '-ic, -tion, -sion: Nhấn âm NGAY TRƯỚC nó\n-ee, -eer, -ese: Nhấn CHÍNH NÓ',
          bulletPoints: [
            'Hậu tố -ic, -tion, -sion: eco\'nomic, prepa\'ration, de\'cision.',
            'Hậu tố -ee, -eer: employ\'ee, volunt\'eer, engin\'eer.',
            'Hậu tố không làm đổi trọng âm: -ful, -less, -ness, -ment, -ly (care -> \'careful, \'carefully).',
          ],
          tips: [
            'Từ có đuôi -cy, -ty, -phy, -gy: Trọng âm rơi vào âm tiết thứ 3 tính từ cuối lên (e\'conomy, pho\'tography).',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'The company will pre\'sent a special \'present to the retiring manager.',
          vietnamese: 'Công ty sẽ trao tặng một món quà đặc biệt cho người quản lý sắp về hưu.',
          explanation: 'Động từ "pre\'sent" nhấn âm 2, danh từ "present" nhấn âm 1.',
          highlight: 'pre\'sent (Verb) vs \'present (Noun)',
          partTag: 'Part 2 & 3',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pron-s1',
          question: 'Từ "decision" có trọng âm rơi vào âm tiết thứ mấy?',
          options: ['Âm tiết thứ 1', 'Âm tiết thứ 2', 'Âm tiết thứ 3', 'Không có trọng âm'],
          answerIndex: 1,
          explanation: 'Hậu tố "-sion" khiến trọng âm rơi vào âm tiết ngay trước nó -> de\'ci.sion (âm tiết 2).',
        ),
      ],
    ),

    TheoryTopic(
      id: 'pronunciation-connected-speech',
      category: TheoryCategory.pronunciation,
      title: 'Nối âm, Nuốt âm & Biến âm Flap T thực chiến',
      subtitle: 'Linking sounds, Elision và kỹ thuật nghe âm lướt trong đề thi ETS',
      readTimeMinutes: 8,
      difficulty: 'Nâng cao',
      tags: ['pronunciation', 'listening', 'connected-speech'],
      overview:
          'Lý do lớn nhất khiến học viên không nghe kịp Part 3 và Part 4 là vì người bản ngữ không đọc từng từ rời rạc mà luôn sử dụng hiện tượng Connected Speech (nói liền mạch).',
      sections: [
        TheorySection(
          title: '1. Nối âm (Linking Sounds)',
          content: 'Phụ âm cuối của từ trước nối sang nguyên âm đầu của từ sau.',
          formula: 'Phụ âm + Nguyên âm -> Nối liền mạch',
          bulletPoints: [
            '"Hold on" -> nghe như /həʊl dɒn/.',
            '"Check in" -> nghe như /tʃek kɪn/.',
            '"Pick it up" -> nghe như /pɪ kɪ tʌp/.',
          ],
          tips: [
            'Khi nghe thấy từ lạ tai, hãy thử tách âm đầu của từ đó trả lại cho từ đứng trước.',
          ],
        ),
        TheorySection(
          title: '2. Nuốt âm (Elision) & Biến âm Flap T',
          content: 'Âm /t/ và /d/ bị lược bỏ hoặc biến đổi trong giọng Mỹ.',
          formula: 'Nuốt /t/, /d/ khi đứng giữa 2 phụ âm\nFlap T: /t/ kẹp giữa 2 nguyên âm -> đọc thành /d/ nhẹ',
          bulletPoints: [
            'Nuốt âm: "last night" -> đọc thành /lɑːs naɪt/; "next door" -> /neks dɔː/.',
            'Flap T (Mỹ): "water" -> nghe như "wa-der"; "meeting" -> nghe như "mee-ding"; "city" -> "ci-dy".',
            'Giảm âm (Weak forms): Các từ chức năng (of, for, can, to) được đọc thành âm schwa /ə/ rất nhẹ: "cup of tea" -> /kʌp əv tiː/.',
          ],
          tips: [
            'Luyện tập kỹ thuật Shadowing (nói nhại theo băng) là cách duy nhất để tai bắt kịp hiện tượng Connected Speech.',
          ],
        ),
      ],
      examples: [
        TheoryExample(
          english: 'Could you pick it up at the front desk? -> Pronounced as /kʊdʒuː pɪ kɪ tʌp æt ðə frʌnt desk/',
          vietnamese: 'Bạn có thể lấy nó ở bàn lễ tân được không?',
          explanation: 'Nối âm "pick it up" và nối âm "Could you" -> /kʊdʒuː/.',
          highlight: 'pick it up /pɪ kɪ tʌp/',
          partTag: 'Part 2 & 3',
        ),
      ],
      quiz: [
        TheoryQuizQuestion(
          id: 'q-pron-cs1',
          question: 'Trong giọng Anh-Mỹ (General American), từ "meeting" thường được phát âm theo quy tắc nào?',
          options: ['Nuốt hoàn toàn âm t thành /miːɪŋ/', 'Biến âm Flap T: âm /t/ kẹp giữa 2 nguyên âm phát âm thành âm /d/ lướt nhẹ', 'Nhấn mạnh âm /t/ bật hơi mạnh', 'Đọc ngắt quãng từng âm'],
          answerIndex: 1,
          explanation: 'Quy tắc Flap T trong giọng Mỹ biến âm /t/ giữa hai nguyên âm thành âm /d/ lướt nhẹ -> nghe như "mee-ding".',
        ),
      ],
    ),
  ];

  // ==================== CÁC PHƯƠNG THỨC TRUY XUẤT DỮ LIỆU ====================

  List<TheoryTopic> getAllTopics() => _allTopics;

  List<TheoryTopic> getTopicsByCategory(TheoryCategory category) {
    return _allTopics.where((t) => t.category == category).toList();
  }

  TheoryTopic? getTopicById(String id) {
    try {
      return _allTopics.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Tìm chủ đề liên quan đến tag câu hỏi sai (vd: 'word-form', 'verb-form', 'tenses')
  TheoryTopic? findTopicByQuestionTag(String tag) {
    try {
      return _allTopics.firstWhere((t) => t.tags.contains(tag));
    } catch (_) {
      return null;
    }
  }

  // ==================== LƯU TRỮ TRẠNG THÁI HỌC TẬP (LOCAL) ====================

  Future<Set<String>> getCompletedTopicIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCompleted) ?? [];
    return list.toSet();
  }

  Future<void> setTopicCompleted(String id, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_keyCompleted) ?? []).toSet();
    if (completed) {
      set.add(id);
    } else {
      set.remove(id);
    }
    await prefs.setStringList(_keyCompleted, set.toList());
  }

  Future<Set<String>> getBookmarkedTopicIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyBookmarks) ?? [];
    return list.toSet();
  }

  Future<bool> toggleBookmark(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_keyBookmarks) ?? []).toSet();
    final willBookmark = !set.contains(id);
    if (willBookmark) {
      set.add(id);
    } else {
      set.remove(id);
    }
    await prefs.setStringList(_keyBookmarks, set.toList());
    return willBookmark;
  }

  Future<Map<String, int>> getQuizScores() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyScores);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveQuizScore(String topicId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getQuizScores();
    scores[topicId] = score;
    await prefs.setString(_keyScores, jsonEncode(scores));
  }
}
