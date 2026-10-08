// Bảo vệ design system: UI ngoài lib/core/design_system/ không được hard-code giá trị style.
// Ngoại lệ có lý do: thêm comment `// ds-ignore: <lý do>` ở cuối dòng.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _rules = <String, RegExp>{
  'Màu hard-code → dùng context.colors / context.appColors / AppTone': RegExp(
    r'Color\(0x|Colors\.(?!transparent\b)',
  ),
  'Cỡ chữ hard-code → dùng context.textStyles.*': RegExp(r'fontSize\s*:'),
  'Bo góc hard-code → dùng AppRadius': RegExp(r'(BorderRadius|Radius)\.circular\(\s*\d'),
  'Padding hard-code → dùng AppSpacing / AppInsets': RegExp(
    r'EdgeInsets\.(all|symmetric|only|fromLTRB)\([^)]*?\b[1-9]\d*(\.\d+)?\b',
  ),
  'Khoảng trống hard-code → dùng Gaps / AppSizes': RegExp(
    r'SizedBox(\.square)?\(\s*(height|width|dimension)\s*:\s*[1-9]',
  ),
  'Kích thước hard-code → dùng AppSizes': RegExp(
    r'Size(\.fromHeight|\.fromWidth|\.square)?\(\s*[1-9]',
  ),
  'Thời lượng animation hard-code → dùng AppMotion': RegExp(r'Duration\(milliseconds\s*:'),
  'Dialog/SnackBar tự chế → dùng showAppConfirmDialog / showAppSnackBar': RegExp(
    r'\bAlertDialog\(|\bshowDialog<bool>|SnackBar\(content',
  ),
  'Import theme cũ → dùng design_system.dart': RegExp(
    r"config/theme\.dart|AppTheme\.(correct|wrong)",
  ),
};

void main() {
  test('UI tuân thủ design system (không hard-code style)', () {
    final violations = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart') && !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.contains('lib/core/design_system/'));

    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('ds-ignore') || line.trimLeft().startsWith('//')) continue;
        for (final MapEntry(key: msg, value: re) in _rules.entries) {
          if (re.hasMatch(line)) violations.add('${file.path}:${i + 1}  $msg\n    ${line.trim()}');
        }
      }
    }

    if (violations.isNotEmpty) {
      fail('${violations.length} vi phạm design system:\n${violations.join('\n')}');
    }
  });
}
