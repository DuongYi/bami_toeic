import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Thanh tiến độ bo góc. Không truyền [tone] thì tự chọn theo [AppTone.fromRatio].
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.tone,
    this.thickness = AppSizes.progressThick,
    this.semanticLabel,
  });

  final double value;
  final AppTone? tone;
  final double thickness;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = tone ?? AppTone.fromRatio(value);
    return ClipRRect(
      borderRadius: AppRadius.brXs,
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: thickness,
        color: t.colorsOf(context).main,
        semanticsLabel: semanticLabel,
        semanticsValue: '${(value * 100).round()}%',
      ),
    );
  }
}

/// Dòng "nhãn ……… 12/20" + thanh tiến độ bên dưới.
class LabeledProgress extends StatelessWidget {
  const LabeledProgress({
    super.key,
    required this.label,
    required this.value,
    required this.trailing,
  });

  final String label;
  final double value;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text(trailing, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        Gaps.v4,
        AppProgressBar(value: value, semanticLabel: label),
      ],
    );
  }
}
