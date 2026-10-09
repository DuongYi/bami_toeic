/// Nhãn tiếng Việt của thẻ dạng câu hỏi (đồng bộ với tool/ets/tagging.py).
const questionTagLabels = <String, String>{
  'photo': 'Mô tả tranh',
  'wh-question': 'Câu hỏi Wh-',
  'yes-no': 'Câu hỏi Yes/No',
  'tag-question': 'Câu hỏi đuôi',
  'choice': 'Câu hỏi lựa chọn',
  'request': 'Đề nghị / yêu cầu',
  'statement': 'Câu trần thuật',
  'main-idea': 'Ý chính / mục đích',
  'speaker-identity': 'Người nói / địa điểm',
  'detail': 'Chi tiết',
  'next-action': 'Hành động tiếp theo',
  'request-suggestion': 'Đề xuất / yêu cầu',
  'implied-meaning': 'Ý định người nói',
  'graphic': 'Đọc biểu đồ',
  'inference': 'Suy luận',
  'vocab-in-context': 'Từ đồng nghĩa',
  'sentence-insertion': 'Chèn câu',
  'multi-passage': 'Nhiều đoạn văn',
  'word-form': 'Từ loại',
  'verb-form': 'Thì / dạng động từ',
  'pronoun': 'Đại từ',
  'preposition-conjunction': 'Giới từ / liên từ',
  'vocabulary': 'Từ vựng',
};

String tagLabel(String tag) => questionTagLabels[tag] ?? tag;
