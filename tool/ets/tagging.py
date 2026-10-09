"""Gắn thẻ dạng câu hỏi TOEIC (heuristic, tất định). Nhãn tiếng Việt hiển thị trong app."""
import os
import re

TAG_LABELS = {
    'photo': 'Mô tả tranh',
    'wh-question': 'Câu hỏi Wh-', 'yes-no': 'Câu hỏi Yes/No', 'tag-question': 'Câu hỏi đuôi',
    'choice': 'Câu hỏi lựa chọn', 'request': 'Đề nghị / yêu cầu', 'statement': 'Câu trần thuật',
    'main-idea': 'Ý chính / mục đích', 'speaker-identity': 'Người nói / địa điểm',
    'detail': 'Chi tiết', 'next-action': 'Hành động tiếp theo', 'request-suggestion': 'Đề xuất / yêu cầu',
    'implied-meaning': 'Ý định người nói', 'graphic': 'Đọc biểu đồ', 'inference': 'Suy luận',
    'vocab-in-context': 'Từ đồng nghĩa', 'sentence-insertion': 'Chèn câu', 'multi-passage': 'Nhiều đoạn văn',
    'word-form': 'Từ loại', 'verb-form': 'Thì / dạng động từ', 'pronoun': 'Đại từ',
    'preposition-conjunction': 'Giới từ / liên từ', 'vocabulary': 'Từ vựng',
}

PRONOUNS = {'i', 'me', 'my', 'mine', 'myself', 'you', 'your', 'yours', 'yourself', 'yourselves', 'he', 'him',
            'his', 'himself', 'she', 'her', 'hers', 'herself', 'it', 'its', 'itself', 'we', 'us', 'our', 'ours',
            'ourselves', 'they', 'them', 'their', 'theirs', 'themselves', 'one', 'ones', 'whoever', 'anybody',
            'anyone', 'someone', 'neither', 'either', 'each other', 'those', 'these', 'that', 'this', 'other',
            'others', 'another', 'whose', 'who', 'whom', 'which', 'what'}
FUNCTION_WORDS = {
    'about', 'above', 'across', 'after', 'against', 'along', 'among', 'around', 'as', 'at', 'before', 'behind',
    'below', 'beside', 'between', 'beyond', 'by', 'despite', 'during', 'except', 'for', 'from', 'in', 'inside',
    'into', 'like', 'near', 'of', 'off', 'on', 'onto', 'out', 'over', 'past', 'since', 'through', 'throughout',
    'to', 'toward', 'towards', 'under', 'until', 'up', 'upon', 'with', 'within', 'without', 'via', 'per',
    'and', 'but', 'or', 'so', 'yet', 'nor', 'because', 'although', 'though', 'even though', 'even if', 'if',
    'unless', 'whereas', 'while', 'when', 'whenever', 'where', 'whether', 'once', 'so that', 'in order to',
    'as soon as', 'as long as', 'as well as', 'rather than', 'instead of', 'in addition', 'in addition to',
    'however', 'therefore', 'moreover', 'furthermore', 'nevertheless', 'otherwise', 'consequently',
    'meanwhile', 'likewise', 'besides', 'thus', 'hence', 'accordingly', 'regardless', 'regardless of',
    'prior to', 'due to', 'owing to', 'according to', 'in spite of', 'because of', 'apart from', 'along with',
    'up to', 'as though', 'as if', 'such as', 'both', 'either', 'neither', 'not only', 'then', 'also', 'still',
    'for instance', 'for example', 'as a result', 'in fact', 'in contrast', 'alternatively', 'similarly',
    'nonetheless', 'afterward', 'afterwards', 'beforehand', 'instead', 'whereby', 'what', 'whatever',
    'which', 'whichever', 'who', 'whom', 'whose', 'that'}
AUX = re.compile(r'\b(will|would|has|have|had|been|being|be|is|are|was|were|to|can|could|should|must|may)\b')


def _common_prefix(words):
    s = min(words)
    e = max(words)
    i = 0
    while i < len(s) and i < len(e) and s[i] == e[i]:
        i += 1
    return s[:i]


def tag_question(part, content, options, group_passage=None, transcript_first_line=None):
    c = (content or '').lower()
    opts = [o.strip().lower().rstrip('.') for o in (options or []) if o.strip()]
    if part == 1:
        return ['photo']
    if part == 2:
        q = (transcript_first_line or '').strip().lower()
        if not q:
            return []
        if re.search(r",\s*(isn't|aren't|don't|doesn't|didn't|won't|haven't|hasn't|can't|right|wasn't|"
                     r"weren't|shouldn't|wouldn't|aren't|is|are|do|does|did|will|have|has)\b[^,]*\?$", q):
            return ['tag-question']
        if re.match(r'^(who|what|when|where|why|how|which|whose)\b', q):
            return ['wh-question']
        if re.search(r'\bor\b', q) and q.endswith('?'):
            return ['choice']
        if re.match(r'^(could|would|can|will) you|^(why don\'t|how about|let\'s|would you like|do you want|'
                     r'shall|please)', q):
            return ['request']
        if q.endswith('?'):
            return ['yes-no']
        return ['statement']
    if part in (5, 6):
        if part == 6 and opts and min(len(o.split()) for o in opts) >= 4:
            return ['sentence-insertion']
        if opts and all(o in PRONOUNS for o in opts):
            return ['pronoun']
        if opts and all(o in FUNCTION_WORDS for o in opts):
            return ['preposition-conjunction']
        heads = [re.sub(r'^(to|will|has|have|had|been|being|be)\s+', '', o).split()[-1] for o in opts] if opts else []
        prefix = _common_prefix(heads) if heads else ''
        # cùng gốc từ: tiền tố chung ≥ 4, hoặc ≥ 3 khi mọi lựa chọn ≥ 4 ký tự (caring/careful, acts/action)
        if heads and (len(prefix) >= 4 or (len(prefix) >= 3 and min(len(h) for h in heads) >= 4)):
            if any(AUX.search(o) for o in opts) or all(re.search(r'(ed|ing|s|e)$', h) for h in heads):
                if any(AUX.search(o) for o in opts):
                    return ['verb-form']
            return ['word-form']
        return ['vocabulary']
    # Part 3, 4, 7
    tags = []
    if 'look at the graphic' in c:
        tags.append('graphic')
    if 'positions marked' in c:
        return ['sentence-insertion']
    if 'closest in meaning' in c:
        return ['vocab-in-context']
    if re.search(r'mean when|why does the (speaker|man|woman)\b.*\bsay|imply when|most likely mean', c):
        tags.append('implied-meaning')
    elif re.search(r'mainly (about|discussing)|main purpose|purpose of|main topic|why is the \w+ (calling|writing)|'
                   r'what is the (talk|announcement|message|broadcast|article|e-mail|letter|notice|memo)', c):
        tags.append('main-idea')
    elif re.search(r'^who (most likely )?(is|are)|where (does|do|most likely does|most likely do) the|'
                   r'where is the (conversation|talk|announcement)|what (type|kind) of (business|company|event)|'
                   r'who most likely|what is the \w+\'s (job|profession)|where most likely', c):
        tags.append('speaker-identity')
    elif re.search(r'(do|happen|take place) next|what will (the )?\w+ (do|most likely do)|what will happen|'
                   r'offer to do|plan to do|what is .* going to do', c):
        tags.append('next-action')
    elif re.search(r'suggest|recommend|ask(s|ed)? (the )?\w+ to|request', c):
        tags.append('request-suggestion')
    elif part == 7 and re.search(r'most likely|suggested|implied|inferred|concluded|indicated|probably', c):
        tags.append('inference')
    if not tags or tags == ['graphic']:
        tags.append('detail')
    return tags  # 'multi-passage' gắn theo số câu (176–200) ở build_ets.py
