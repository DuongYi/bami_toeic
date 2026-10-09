import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../data/models/vocab_models.dart';
import '../controllers/vocab_controller.dart';

/// Bottom sheet thêm / sửa từ vựng.
Future<void> showVocabForm(
  BuildContext context, {
  VocabItem? item,
  String? defaultTopic,
  String? initialWord,
  String? initialExample,
}) {
  return showAppBottomSheet<void>(
    context,
    builder: (_) => _VocabForm(
      item: item,
      defaultTopic: defaultTopic,
      initialWord: initialWord,
      initialExample: initialExample,
    ),
  );
}

class _VocabForm extends ConsumerStatefulWidget {
  const _VocabForm({this.item, this.defaultTopic, this.initialWord, this.initialExample});

  final VocabItem? item;
  final String? defaultTopic;

  /// Điền sẵn khi thêm từ lúc tra trong đề.
  final String? initialWord;
  final String? initialExample;

  @override
  ConsumerState<_VocabForm> createState() => _VocabFormState();
}

class _VocabFormState extends ConsumerState<_VocabForm> {
  final _formKey = GlobalKey<FormState>();
  late final _word = TextEditingController(text: widget.item?.word ?? widget.initialWord);
  late final _ipa = TextEditingController(text: widget.item?.ipa);
  late final _pos = TextEditingController(text: widget.item?.pos);
  late final _meaning = TextEditingController(text: widget.item?.meaning);
  late final _example = TextEditingController(text: widget.item?.example ?? widget.initialExample);
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
      String? clean(String s) => s.trim().isEmpty ? null : s.trim();
      await ref
          .read(vocabListProvider.notifier)
          .save(
            VocabInput(
              word: _word.text.trim(),
              ipa: clean(_ipa.text),
              pos: clean(_pos.text),
              meaning: _meaning.text.trim(),
              example: clean(_example.text),
              exampleMeaning: clean(_exampleMeaning.text),
              topic: clean(_topic.text) ?? 'General',
            ),
            id: widget.item?.id,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnackBar(
        context,
        'Lưu thất bại: ${AppException.from(e).message}',
        tone: AppTone.danger,
      );
    }
  }

  Future<void> _delete() async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Xoá "${widget.item!.word}"?',
      message: 'Lịch ôn của từ này cũng bị xoá.',
      confirmLabel: 'Xoá',
      destructive: true,
    );
    if (!ok || !mounted) return;
    try {
      await ref.read(vocabListProvider.notifier).delete(widget.item!.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Xoá thất bại: ${AppException.from(e).message}',
        tone: AppTone.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null;
    const gap = Gaps.v12;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.item == null ? 'Thêm từ' : 'Sửa từ', style: context.textStyles.titleLarge),
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
                Gaps.h12,
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
            Gaps.v24,
            AppPrimaryButton(label: 'Lưu', loading: _saving, onPressed: _save),
            if (widget.item != null)
              TextButton(
                onPressed: _saving ? null : _delete,
                style: TextButton.styleFrom(foregroundColor: context.colors.error),
                child: const Text('Xoá từ này'),
              ),
          ],
        ),
      ),
    );
  }
}
