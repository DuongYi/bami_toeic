import 'package:flutter/material.dart';

import '../widgets/dictionary_browser.dart';

/// Từ điển Anh – Việt / Anh – Anh: tra, nghe phát âm, lưu vào sổ từ để ôn SRS.
class DictionaryPage extends StatelessWidget {
  const DictionaryPage({super.key, this.initialWord});

  /// `/dictionary?q=` – mở sẵn 1 từ.
  final String? initialWord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Từ điển')),
      body: SafeArea(
        top: false,
        child: DictionaryBrowser(initialWord: initialWord, autofocus: initialWord == null),
      ),
    );
  }
}
