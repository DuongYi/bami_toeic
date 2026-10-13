import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import '../theme/context_ext.dart';

/// Đại diện cho một nét vẽ trên màn hình hoặc trang vở.
class DrawStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isHighlighter;

  const DrawStroke({
    required this.points,
    required this.color,
    this.strokeWidth = 2.5,
    this.isHighlighter = false,
  });

  DrawStroke copyWith({List<Offset>? points}) => DrawStroke(
    points: points ?? this.points,
    color: color,
    strokeWidth: strokeWidth,
    isHighlighter: isHighlighter,
  );
}

/// Các công cụ thao tác bút
enum AnnotationTool {
  /// Chạm/cuộn/chọn đáp án bình thường (không vẽ)
  select,

  /// Bút mực viết/gạch chân
  pen,

  /// Bút dạ quang highlight màu vàng mờ
  highlighter,

  /// Cục tẩy nét vẽ
  eraser,
}

/// Painter vẽ các nét lên Canvas bằng đường cong mượt mà (Quadratic Bezier)
class AnnotationPainter extends CustomPainter {
  final List<DrawStroke> strokes;
  final DrawStroke? currentStroke;

  const AnnotationPainter({required this.strokes, this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!);
    }
  }

  void _drawStroke(Canvas canvas, DrawStroke stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke.isHighlighter
          ? stroke.color.withValues(alpha: 0.38)
          : stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (stroke.points.length == 1) {
      canvas.drawCircle(
        stroke.points.first,
        stroke.strokeWidth / 2,
        paint..style = PaintingStyle.fill,
      );
      return;
    }

    final path = Path();
    path.moveTo(stroke.points[0].dx, stroke.points[0].dy);
    for (int i = 1; i < stroke.points.length; i++) {
      final p0 = stroke.points[i - 1];
      final p1 = stroke.points[i];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    path.lineTo(stroke.points.last.dx, stroke.points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AnnotationPainter oldDelegate) => true;
}

/// Scope cung cấp trạng thái công cụ vẽ và ScrollPhysics cho các widget con (để khoá cuộn khi đang vẽ)
class AnnotationScope extends InheritedWidget {
  final bool isDrawingMode;
  final AnnotationTool currentTool;
  final ScrollPhysics scrollPhysics;
  final VoidCallback onSelectScroll;

  const AnnotationScope({
    super.key,
    required this.isDrawingMode,
    required this.currentTool,
    required this.scrollPhysics,
    required this.onSelectScroll,
    required super.child,
  });

  static AnnotationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AnnotationScope>();

  static AnnotationScope of(BuildContext context) =>
      maybeOf(context)!;

  @override
  bool updateShouldNotify(covariant AnnotationScope oldWidget) =>
      isDrawingMode != oldWidget.isDrawingMode || currentTool != oldWidget.currentTool;
}

/// Lớp phủ vẽ trực tiếp lên đề thi (Annotation Overlay) với thanh công cụ nổi
class AnnotationOverlay extends StatefulWidget {
  final Widget child;
  final List<DrawStroke> initialStrokes;
  final ValueChanged<List<DrawStroke>>? onStrokesChanged;
  final bool enableFloatingToolbar;

  const AnnotationOverlay({
    super.key,
    required this.child,
    this.initialStrokes = const [],
    this.onStrokesChanged,
    this.enableFloatingToolbar = true,
  });

  @override
  State<AnnotationOverlay> createState() => _AnnotationOverlayState();
}

class _AnnotationOverlayState extends State<AnnotationOverlay> {
  late List<DrawStroke> _strokes;
  DrawStroke? _currentStroke;
  AnnotationTool _tool = AnnotationTool.select;
  bool _toolbarExpanded = false;

  @override
  void initState() {
    super.initState();
    _strokes = List.from(widget.initialStrokes);
  }

  @override
  void didUpdateWidget(AnnotationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStrokes != widget.initialStrokes) {
      _strokes = List.from(widget.initialStrokes);
    }
  }

  void _notifyChange() {
    widget.onStrokesChanged?.call(List.unmodifiable(_strokes));
  }

  /// Đã thấy Apple Pencil → bỏ qua chạm bằng tay khi đang vẽ (lòng bàn tay tì màn hình).
  bool _stylusSeen = false;

  bool _acceptPointer(PointerDownEvent e) {
    final stylus = e.kind == PointerDeviceKind.stylus || e.kind == PointerDeviceKind.invertedStylus;
    if (stylus) _stylusSeen = true;
    return stylus || !_stylusSeen;
  }

  void _onPanStart(Offset pos) {
    if (_tool == AnnotationTool.select) return;

    if (_tool == AnnotationTool.eraser) {
      _eraseAt(pos);
      return;
    }

    final isHighlighter = _tool == AnnotationTool.highlighter;
    final color = isHighlighter
        ? AppTone.warning.colorsOf(context).main
        : context.colors.primary;
    final strokeWidth = isHighlighter ? 18.0 : 2.5;

    setState(() {
      _currentStroke = DrawStroke(
        points: [pos],
        color: color,
        strokeWidth: strokeWidth,
        isHighlighter: isHighlighter,
      );
    });
  }

  void _onPanUpdate(Offset pos) {
    if (_tool == AnnotationTool.select) return;

    if (_tool == AnnotationTool.eraser) {
      _eraseAt(pos);
      return;
    }

    if (_currentStroke != null) {
      setState(() {
        _currentStroke = _currentStroke!.copyWith(
          points: [..._currentStroke!.points, pos],
        );
      });
    }
  }

  void _onPanEnd() {
    if (_tool == AnnotationTool.select) return;
    if (_currentStroke != null) {
      setState(() {
        _strokes.add(_currentStroke!);
        _currentStroke = null;
      });
      _notifyChange();
    }
  }

  void _eraseAt(Offset pos) {
    const threshold = 20.0;
    final before = _strokes.length;
    _strokes.removeWhere((stroke) => stroke.points.any((p) => (p - pos).distance <= threshold));
    if (_strokes.length != before) {
      setState(() {});
      _notifyChange();
    }
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      _notifyChange();
    }
  }

  void _clearAll() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.clear();
      });
      _notifyChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaces = context.surfaces;
    final isDrawing = _tool != AnnotationTool.select;
    final scrollPhysics = isDrawing
        ? const NeverScrollableScrollPhysics()
        : const AlwaysScrollableScrollPhysics();

    return AnnotationScope(
      isDrawingMode: isDrawing,
      currentTool: _tool,
      scrollPhysics: scrollPhysics,
      onSelectScroll: () => setState(() => _tool = AnnotationTool.select),
      child: Stack(
        children: [
          // Nội dung chính bên dưới (đề thi, bài đọc, câu hỏi)
          widget.child,

          // Lớp vẽ CustomPaint
          Positioned.fill(
            child: _tool == AnnotationTool.select
                ? IgnorePointer(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: AnnotationPainter(
                          strokes: _strokes,
                          currentStroke: _currentStroke,
                        ),
                      ),
                    ),
                  )
                : RawGestureDetector(
                    behavior: HitTestBehavior.opaque,
                    gestures: {
                      StrokeGestureRecognizer:
                          GestureRecognizerFactoryWithHandlers<StrokeGestureRecognizer>(
                            StrokeGestureRecognizer.new,
                            (r) => r
                              ..acceptPointer = _acceptPointer
                              ..onStart = _onPanStart
                              ..onUpdate = _onPanUpdate
                              ..onEnd = _onPanEnd,
                          ),
                    },
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: AnnotationPainter(
                          strokes: _strokes,
                          currentStroke: _currentStroke,
                        ),
                      ),
                    ),
                  ),
          ),

          // Thanh công cụ nổi (Floating Pencil Toolbar)
          if (widget.enableFloatingToolbar)
            Positioned(
              right: AppSpacing.s16,
              bottom: AppSpacing.s16,
              child: Material(
                color: Colors.transparent, // ds-ignore: transparent
                child: AnimatedContainer(
                  duration: AppMotion.of(context, AppMotion.short),
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  decoration: BoxDecoration(
                    color: surfaces.raised,
                    borderRadius: AppRadius.brFull,
                    border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_toolbarExpanded) ...[
                        if (isDrawing) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s8,
                              vertical: AppSpacing.s4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: AppRadius.brFull,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline_rounded, size: AppSizes.iconXs, color: colors.primary),
                                Gaps.h4,
                                Text(
                                  'Đã khoá cuộn',
                                  style: context.textStyles.labelSmall?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gaps.h4,
                        ],
                        // Nút chọn / cuộn bình thường
                        _ToolIconButton(
                          tooltip: 'Chạm chọn & cuộn',
                          icon: Icons.touch_app_rounded,
                          isSelected: _tool == AnnotationTool.select,
                          onPressed: () => setState(() => _tool = AnnotationTool.select),
                        ),
                      Gaps.h4,
                      // Bút mực
                      _ToolIconButton(
                        tooltip: 'Bút mực',
                        icon: Icons.edit_rounded,
                        isSelected: _tool == AnnotationTool.pen,
                        onPressed: () => setState(() => _tool = AnnotationTool.pen),
                      ),
                      Gaps.h4,
                      // Bút dạ quang (Highlighter)
                      _ToolIconButton(
                        tooltip: 'Bút dạ quang (Highlight)',
                        icon: Icons.border_color_rounded,
                        isSelected: _tool == AnnotationTool.highlighter,
                        selectedColor: AppTone.warning.colorsOf(context).main,
                        onPressed: () => setState(() => _tool = AnnotationTool.highlighter),
                      ),
                      Gaps.h4,
                      // Cục tẩy
                      _ToolIconButton(
                        tooltip: 'Tẩy nét vẽ',
                        icon: Icons.auto_fix_high_rounded,
                        isSelected: _tool == AnnotationTool.eraser,
                        onPressed: () => setState(() => _tool = AnnotationTool.eraser),
                      ),
                      Gaps.h4,
                      // Hoàn tác (Undo)
                      IconButton(
                        tooltip: 'Hoàn tác (Undo)',
                        iconSize: AppSizes.iconSm,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.undo_rounded),
                        onPressed: _strokes.isEmpty ? null : _undo,
                      ),
                      // Xoá tất cả (Clear)
                      IconButton(
                        tooltip: 'Xoá tất cả nét vẽ',
                        iconSize: AppSizes.iconSm,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.delete_sweep_rounded),
                        onPressed: _strokes.isEmpty ? null : _clearAll,
                      ),
                      Gaps.h4,
                    ],

                    // Nút thu gọn / mở rộng toolbar
                    IconButton.filledTonal(
                      tooltip: _toolbarExpanded ? 'Thu nhỏ bút' : 'Mở bút viết Apple Pencil',
                      iconSize: AppSizes.iconSm,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        _toolbarExpanded
                            ? Icons.chevron_right_rounded
                            : (_tool == AnnotationTool.select
                                ? Icons.draw_rounded
                                : Icons.edit_note_rounded),
                      ),
                      onPressed: () {
                        setState(() {
                          _toolbarExpanded = !_toolbarExpanded;
                          if (_toolbarExpanded && _tool == AnnotationTool.select) {
                            _tool = AnnotationTool.pen;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
  }
}

class _ToolIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool isSelected;
  final Color? selectedColor;
  final VoidCallback onPressed;

  const _ToolIconButton({
    required this.tooltip,
    required this.icon,
    required this.isSelected,
    this.selectedColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeColor = selectedColor ?? colors.primary;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.brFull,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.18) : Colors.transparent, // ds-ignore: transparent
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: activeColor, width: 1.5) : null,
          ),
          child: Icon(
            icon,
            size: AppSizes.iconSm,
            color: isSelected ? activeColor : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Painter vẽ các dòng kẻ tập học sinh mờ cho trang vở viết tay
class RuledLinesPainter extends CustomPainter {
  final Color lineColor;
  final double lineSpacing;

  /// Vị trí dòng kẻ đầu tiên (mặc định = [lineSpacing]); đặt bằng chân chữ dòng 1 để chữ nằm trên dòng.
  final double? firstLine;

  const RuledLinesPainter({required this.lineColor, this.lineSpacing = 32.0, this.firstLine});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;

    double y = firstLine ?? lineSpacing;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += lineSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant RuledLinesPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.lineSpacing != lineSpacing ||
      oldDelegate.firstLine != firstLine;
}

/// Bắt nét vẽ NGAY khi chạm (không chờ ngưỡng kéo ~18px như Pan) và giành quyền với thanh cuộn.
/// Nhờ vậy đầu nét, dấu chấm (i, j, .) không bị mất và trang không cuộn khi viết nét dọc.
class StrokeGestureRecognizer extends OneSequenceGestureRecognizer {
  StrokeGestureRecognizer({super.debugOwner});

  bool Function(PointerDownEvent event) acceptPointer = _always;
  ValueChanged<Offset>? onStart;
  ValueChanged<Offset>? onUpdate;
  VoidCallback? onEnd;

  static bool _always(PointerDownEvent _) => true;

  @override
  bool isPointerAllowed(PointerDownEvent event) => super.isPointerAllowed(event) && acceptPointer(event);

  @override
  void addAllowedPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer, event.transform);
    resolve(GestureDisposition.accepted);
    onStart?.call(event.localPosition);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      onUpdate?.call(event.localPosition);
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      onEnd?.call();
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  String get debugDescription => 'stroke';
}

/// Khung viết tay chép chính tả (Handwriting Notebook Pad) với dòng kẻ tập
class HandwritingPad extends StatefulWidget {
  final List<DrawStroke> initialStrokes;
  final ValueChanged<List<DrawStroke>>? onStrokesChanged;
  final double height;
  final VoidCallback? onReplay3s;
  final bool enabled;

  const HandwritingPad({
    super.key,
    this.initialStrokes = const [],
    this.onStrokesChanged,
    this.height = 240,
    this.onReplay3s,
    this.enabled = true,
  });

  @override
  State<HandwritingPad> createState() => _HandwritingPadState();
}

class _HandwritingPadState extends State<HandwritingPad> {
  late List<DrawStroke> _strokes;
  DrawStroke? _currentStroke;
  bool _isEraser = false;

  /// Đã thấy Apple Pencil trên bảng → từ đó bỏ qua chạm bằng tay (lòng bàn tay tì lên màn hình).
  bool _stylusSeen = false;

  bool _acceptPointer(PointerDownEvent e) {
    final stylus = e.kind == PointerDeviceKind.stylus || e.kind == PointerDeviceKind.invertedStylus;
    if (stylus) _stylusSeen = true;
    return stylus || !_stylusSeen;
  }

  @override
  void initState() {
    super.initState();
    _strokes = List.from(widget.initialStrokes);
  }

  @override
  void didUpdateWidget(HandwritingPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStrokes != widget.initialStrokes) {
      _strokes = List.from(widget.initialStrokes);
    }
  }

  void _notifyChange() {
    widget.onStrokesChanged?.call(List.unmodifiable(_strokes));
  }

  void _onPanStart(Offset pos) {
    if (_isEraser) {
      _eraseAt(pos);
      return;
    }
    setState(() {
      _currentStroke = DrawStroke(
        points: [pos],
        color: context.colors.primary,
        strokeWidth: 2.5,
      );
    });
  }

  void _onPanUpdate(Offset pos) {
    if (_isEraser) {
      _eraseAt(pos);
      return;
    }
    if (_currentStroke != null) {
      setState(() {
        _currentStroke = _currentStroke!.copyWith(
          points: [..._currentStroke!.points, pos],
        );
      });
    }
  }

  void _onPanEnd() {
    if (_currentStroke != null) {
      setState(() {
        _strokes.add(_currentStroke!);
        _currentStroke = null;
      });
      _notifyChange();
    }
  }

  void _eraseAt(Offset pos) {
    const threshold = 20.0;
    final before = _strokes.length;
    _strokes.removeWhere((stroke) => stroke.points.any((p) => (p - pos).distance <= threshold));
    if (_strokes.length != before) {
      setState(() {});
      _notifyChange();
    }
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      _notifyChange();
    }
  }

  void _clearAll() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.clear();
      });
      _notifyChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaces = context.surfaces;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: surfaces.raised,
        borderRadius: AppRadius.brMd,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          // Thanh công cụ nhỏ phía trên trang vở
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: surfaces.raised,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              border: Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.edit_note_rounded, size: AppSizes.iconSm, color: colors.primary),
                Gaps.h8,
                // Co lại (…) trên màn hẹp để các nút bút/tẩy/hoàn tác luôn bấm được.
                Expanded(
                  child: Text(
                    'Vở viết tay (Apple Pencil)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ),
                if (widget.onReplay3s != null) ...[
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s8,
                        vertical: AppSpacing.s4,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.replay_rounded, size: AppSizes.iconXs),
                    label: const Text('3s'),
                    onPressed: widget.enabled ? widget.onReplay3s : null,
                  ),
                  Gaps.h4,
                ],
                // Nút chuyển bút / tẩy
                IconButton(
                  tooltip: _isEraser ? 'Đổi sang Bút mực' : 'Đổi sang Cục tẩy',
                  iconSize: AppSizes.iconSm,
                  visualDensity: VisualDensity.compact,
                  isSelected: _isEraser,
                  icon: const Icon(Icons.edit_rounded),
                  selectedIcon: const Icon(Icons.auto_fix_high_rounded),
                  onPressed: widget.enabled ? () => setState(() => _isEraser = !_isEraser) : null,
                ),
                // Undo
                IconButton(
                  tooltip: 'Hoàn tác nét vẽ',
                  iconSize: AppSizes.iconSm,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.undo_rounded),
                  onPressed: (!widget.enabled || _strokes.isEmpty) ? null : _undo,
                ),
                // Xoá hết
                IconButton(
                  tooltip: 'Xoá trang vở',
                  iconSize: AppSizes.iconSm,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_sweep_rounded),
                  onPressed: (!widget.enabled || _strokes.isEmpty) ? null : _clearAll,
                ),
              ],
            ),
          ),

          // Vùng vẽ có dòng kẻ vở học sinh
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.md)),
              child: Stack(
                children: [
                  // Dòng kẻ vở
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RuledLinesPainter(
                        lineColor: colors.outlineVariant.withValues(alpha: 0.25),
                        lineSpacing: 32.0,
                      ),
                    ),
                  ),

                  // Nét vẽ tay
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: !widget.enabled,
                      child: RawGestureDetector(
                        behavior: HitTestBehavior.opaque,
                        gestures: {
                          StrokeGestureRecognizer:
                              GestureRecognizerFactoryWithHandlers<StrokeGestureRecognizer>(
                                StrokeGestureRecognizer.new,
                                (r) => r
                                  ..acceptPointer = _acceptPointer
                                  ..onStart = _onPanStart
                                  ..onUpdate = _onPanUpdate
                                  ..onEnd = _onPanEnd,
                              ),
                        },
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: AnnotationPainter(
                              strokes: _strokes,
                              currentStroke: _currentStroke,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Khung hiển thị tĩnh các nét vẽ viết tay (ví dụ đối chiếu kết quả bài chép)
class HandwritingViewer extends StatelessWidget {
  final List<DrawStroke> strokes;
  final double height;

  const HandwritingViewer({
    super.key,
    required this.strokes,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaces = context.surfaces;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: surfaces.raised,
        borderRadius: AppRadius.brMd,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.brMd,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: RuledLinesPainter(
                  lineColor: colors.outlineVariant.withValues(alpha: 0.25),
                  lineSpacing: 32.0,
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: AnnotationPainter(
                  strokes: strokes,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
