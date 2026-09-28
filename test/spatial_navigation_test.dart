import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spatial_navigation/spatial_navigation.dart';

void main() {
  group('TvNavigationDirectionExtension', () {
    test('opposite directions', () {
      expect(TvNavigationDirection.up.opposite, TvNavigationDirection.down);
      expect(TvNavigationDirection.down.opposite, TvNavigationDirection.up);
      expect(TvNavigationDirection.left.opposite, TvNavigationDirection.right);
      expect(TvNavigationDirection.right.opposite, TvNavigationDirection.left);
    });

    test('isHorizontal & isVertical', () {
      expect(TvNavigationDirection.left.isHorizontal, true);
      expect(TvNavigationDirection.right.isHorizontal, true);
      expect(TvNavigationDirection.up.isHorizontal, false);
      expect(TvNavigationDirection.down.isHorizontal, false);

      expect(TvNavigationDirection.up.isVertical, true);
      expect(TvNavigationDirection.down.isVertical, true);
      expect(TvNavigationDirection.left.isVertical, false);
      expect(TvNavigationDirection.right.isVertical, false);
    });
  });

  group('SpatialNavigationNode Overlap & Geometry', () {
    late FocusNode focusNodeA;
    late FocusNode focusNodeB;

    setUp(() {
      focusNodeA = FocusNode();
      focusNodeB = FocusNode();
    });

    tearDown(() {
      focusNodeA.dispose();
      focusNodeB.dispose();
    });

    test('exact segment overlap calculations', () {
      final nodeA = SpatialNavigationNode(
        id: 'nodeA',
        rect: const Rect.fromLTWH(0, 0, 100, 50),
        focusNode: focusNodeA,
      );

      final nodeB = SpatialNavigationNode(
        id: 'nodeB',
        rect: const Rect.fromLTWH(150, 10, 100, 30),
        focusNode: focusNodeB,
      );

      // Horizontal navigation: overlap along Y-axis
      // NodeA Y: 0..50 (height 50)
      // NodeB Y: 10..40 (height 30)
      // Overlap: 10..40 (30 length), minHeight = 30 -> ratio = 1.0 (100% overlap of smaller node)
      final overlapRatio = nodeA.getOverlap(nodeB, TvNavigationDirection.right);
      expect(overlapRatio, 1.0);
    });

    test('no overlap returns 0', () {
      final nodeA = SpatialNavigationNode(
        id: 'nodeA',
        rect: const Rect.fromLTWH(0, 0, 100, 50),
        focusNode: focusNodeA,
      );

      final nodeB = SpatialNavigationNode(
        id: 'nodeB',
        rect: const Rect.fromLTWH(150, 60, 100, 50),
        focusNode: focusNodeB,
      );

      final overlapRatio = nodeA.getOverlap(nodeB, TvNavigationDirection.right);
      expect(overlapRatio, 0.0);
    });
  });

  group('SpatialNavigationRegistry', () {
    late SpatialNavigationRegistry registry;
    late FocusNode node1Focus;
    late FocusNode node2Focus;

    setUp(() {
      registry = SpatialNavigationRegistry();
      node1Focus = FocusNode();
      node2Focus = FocusNode();
    });

    tearDown(() {
      node1Focus.dispose();
      node2Focus.dispose();
      registry.dispose();
    });

    test('register and retrieve nodes', () {
      final node1 = SpatialNavigationNode(
        id: 'node1',
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        groupId: 'group1',
        focusNode: node1Focus,
      );

      registry.registerNode(node1);
      expect(registry.getNode('node1'), isNotNull);
      expect(registry.getGroupNodeIds('group1'), contains('node1'));
    });

    test('updating node group correctly cleans up old group', () {
      final node1 = SpatialNavigationNode(
        id: 'node1',
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        groupId: 'group1',
        focusNode: node1Focus,
      );

      registry.registerNode(node1);
      expect(registry.getGroupNodeIds('group1'), contains('node1'));

      final updatedNode = node1.copyWith(groupId: 'group2');
      registry.registerNode(updatedNode);

      expect(registry.getGroupNodeIds('group1'), isNot(contains('node1')));
      expect(registry.getGroupNodeIds('group2'), contains('node1'));
    });
  });

  group('SpatialNavigationEngine Navigation', () {
    late SpatialNavigationRegistry registry;
    late SpatialNavigationEngine engine;
    late FocusNode focusA;
    late FocusNode focusB;
    late FocusNode focusC;

    setUp(() {
      registry = SpatialNavigationRegistry();
      engine = SpatialNavigationEngine(registry: registry);
      focusA = FocusNode();
      focusB = FocusNode();
      focusC = FocusNode();

      registry.registerNode(SpatialNavigationNode(
        id: 'A',
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        focusNode: focusA,
      ));

      registry.registerNode(SpatialNavigationNode(
        id: 'B',
        rect: const Rect.fromLTWH(150, 0, 100, 100),
        focusNode: focusB,
      ));

      registry.registerNode(SpatialNavigationNode(
        id: 'C',
        rect: const Rect.fromLTWH(300, 0, 100, 100),
        focusNode: focusC,
      ));
    });

    tearDown(() {
      focusA.dispose();
      focusB.dispose();
      focusC.dispose();
      engine.dispose();
      registry.dispose();
    });

    test('navigates to closest node to the right', () {
      final nodeA = registry.getNode('A')!;
      final result = engine.navigate(TvNavigationDirection.right, currentNode: nodeA);

      expect(result.success, isTrue);
      expect(result.targetNode?.id, 'B');
    });

    test('respects explicit navigation overrides', () {
      final nodeAWithOverride = registry.getNode('A')!.copyWith(
        navigationOverrides: {TvNavigationDirection.right: 'C'},
      );
      registry.registerNode(nodeAWithOverride);

      final result = engine.navigate(TvNavigationDirection.right, currentNode: nodeAWithOverride);
      expect(result.success, isTrue);
      expect(result.targetNode?.id, 'C');
    });
  });

  group('SpatialNavigationController & Shared Registry', () {
    test('shared registry instance between engine and controller', () {
      final controller = SpatialNavigationController();
      expect(identical(controller.registry, controller.engine.registry), isTrue);
    });
  });
}
