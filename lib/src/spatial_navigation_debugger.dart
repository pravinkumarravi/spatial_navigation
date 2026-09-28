import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'spatial_navigation_node.dart';
import 'spatial_navigation_direction.dart';
import 'spatial_navigation_result.dart';
import 'spatial_navigation_controller.dart';

class SpatialNavigationDebugger extends StatelessWidget {
  final bool enabled;
  final Widget child;
  final SpatialNavigationController? controller;

  const SpatialNavigationDebugger({
    super.key,
    this.enabled = true,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || controller == null) {
      return child;
    }

    return Stack(
      children: [
        child,
        _DebugOverlay(controller: controller!),
      ],
    );
  }
}

class _DebugOverlay extends StatefulWidget {
  final SpatialNavigationController controller;

  const _DebugOverlay({required this.controller});

  @override
  State<_DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<_DebugOverlay> {
  List<SpatialNavigationNode> _visibleNodes = [];
  SpatialNavigationResult? _lastResult;
  TvNavigationDirection? _lastDirection;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {
      _visibleNodes = widget.controller.registry.getVisibleEnabledNodes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DebugPainter(
        nodes: _visibleNodes,
        lastResult: _lastResult,
        lastDirection: _lastDirection,
        focusedNode: widget.controller.lastFocusedNode,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _DebugPainter extends CustomPainter {
  final List<SpatialNavigationNode> nodes;
  final SpatialNavigationResult? lastResult;
  final TvNavigationDirection? lastDirection;
  final SpatialNavigationNode? focusedNode;

  _DebugPainter({
    required this.nodes,
    this.lastResult,
    this.lastDirection,
    this.focusedNode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF00FF00);

    final focusedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFFFF0000);

    final candidatePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF00FFFF);

    final textStyle = TextStyle(
      color: const Color(0xFFFFFFFF),
      fontSize: 10,
      backgroundColor: const Color(0x80000000),
    );

    for (final node in nodes) {
      final paint = node == focusedNode ? focusedPaint : nodePaint;
      canvas.drawRect(node.rect, paint);
      
      final textPainter = TextPainter(
        text: TextSpan(text: node.id, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(node.rect.left, node.rect.top - 12));
    }

    if (lastResult != null && lastResult!.success && lastResult!.targetNode != null) {
      final target = lastResult!.targetNode!;
      final current = lastResult!.currentNode;
      
      if (current != null) {
        final linePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFFFFFF00);
        
        canvas.drawLine(current.center, target.center, linePaint);
        
        final midPoint = Offset(
          (current.center.dx + target.center.dx) / 2,
          (current.center.dy + target.center.dy) / 2,
        );
        
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${lastDirection?.name.toUpperCase()} score: ${lastResult!.candidates.first.score.toStringAsFixed(1)}',
            style: textStyle.copyWith(fontSize: 12),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, midPoint);
      }
    }

    if (lastResult != null && lastResult!.candidates.isNotEmpty) {
      for (final candidate in lastResult!.candidates) {
        if (candidate.node != lastResult!.targetNode) {
          canvas.drawRect(candidate.node.rect, candidatePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _DebugPainter &&
        (oldDelegate.nodes != nodes ||
         oldDelegate.lastResult != lastResult ||
         oldDelegate.lastDirection != lastDirection ||
         oldDelegate.focusedNode != focusedNode);
  }
}

void logNavigation(
  TvNavigationDirection direction,
  SpatialNavigationResult result,
) {
  if (!kDebugMode) return;
  
  final buffer = StringBuffer();
  buffer.write('[DPad] ${direction.name.toUpperCase()}');
  buffer.write('\n[Focus] ${result.currentNode?.id ?? 'none'}');
  buffer.write('\n[Candidates] ${result.candidates.map((c) => c.node.id).join(', ')}');
  
  if (result.success) {
    buffer.write('\n[Selected] ${result.targetNode?.id}');
    if (result.candidates.isNotEmpty) {
      buffer.write('\n[Score] ${result.candidates.first.score.toStringAsFixed(1)}');
    }
  } else {
    buffer.write('\n[Failed] ${result.reason}');
  }
  
  print(buffer.toString());
}