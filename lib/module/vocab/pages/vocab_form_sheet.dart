import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../vocab_repository.dart';

/// Bottom sheet thêm / sửa từ vựng.
Future<void> showVocabForm(BuildContext context, {VocabItem? item, String? defaultTopic}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _VocabForm(item: item, defaultTopic: defaultTopic),
  );
}

class _VocabForm extends ConsumerStatefulWidget {
  const _VocabForm({this.item, this.defaultTopic});

  final VocabItem? item;
  final String? defaultTopic;

  @override
  ConsumerState<_VocabForm> createState() => _VocabFormState();
}

class _VocabFormState extends ConsumerState<_VocabForm> {
  final _formKey = GlobalKey<FormState>();
  late final _word = TextEditingController(text: widget.item?.word);
  late final _ipa = TextEditingController(text: widget.item?.ipa);
  late final _pos = TextEditingController(text: widget.item?.pos);
  late final _meaning = TextEditingController(text: widget.item?.meaning);
  late final _example = TextEditingController(text: widget.item?.example);
  late final _exampleMeaning = TextEditingController(text: widget.item?.exampleMeaning);
  late final _topic = TextEditingController(
    text: widget.item?.topic ?? widget.defaultTopic ?? 'General',
  );
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_word, _ipa, _pos, _meaning, _example, _exampleMeaning, _topic]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(vocabRepositoryProvider)
          .save(
            id: widget.item?.id,
            word: _word.text,
            ipa: _ipa.text,
            pos: _pos.text,
            meaning: _meaning.text,
            example: _example.text,
            exampleMeaning: _exampleMeaning.text,
            topic: _topic.text,
          );
      ref.invalidate(vocabListProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lưu thất bại: $e')));
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xoá "${widget.item!.word}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xoá')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(vocabRepositoryProvider).delete(widget.item!.id);
    ref.invalidate(vocabListProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null;
    const gap = SizedBox(height: 12);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.item == null ? 'Thêm từ' : 'Sửa từ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gap,
              TextFormField(
                controller: _word,
                decoration: const InputDecoration(labelText: 'Từ *'),
                validator: required,
                textInputAction: TextInputAction.next,
              ),
              gap,
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _ipa,
                      decoration: const InputDecoration(labelText: 'Phiên âm'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _pos,
                      decoration: const InputDecoration(labelText: 'Loại từ'),
                    ),
                  ),
                ],
              ),
              gap,
              TextFormField(
                controller: _meaning,
                decoration: const InputDecoration(labelText: 'Nghĩa *'),
                validator: required,
              ),
              gap,
              TextFormField(
                controller: _example,
                decoration: const InputDecoration(labelText: 'Ví dụ'),
                maxLines: null,
              ),
              gap,
              TextFormField(
                controller: _exampleMeaning,
                decoration: const InputDecoration(labelText: 'Nghĩa ví dụ'),
                maxLines: null,
              ),
              gap,
              TextFormField(
                controller: _topic,
                decoration: const InputDecoration(labelText: 'Chủ đề'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Đang lưu…' : 'Lưu'),
              ),
              if (widget.item != null)
                TextButton(
                  onPressed: _saving ? null : _delete,
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                  child: const Text('Xoá từ này'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
