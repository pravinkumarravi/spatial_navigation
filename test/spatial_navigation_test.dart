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

    test('horizontal navigation stays within current row and moves across all cards sequentially', () {
      // Row 1: cards 0, 1, 2, 3 at Y: 100..200
      final focusR1_0 = FocusNode();
      final focusR1_1 = FocusNode();
      final focusR1_2 = FocusNode();
      final focusR1_3 = FocusNode();
      // Row 2: cards 0, 1, 2, 3 at Y: 300..400
      final focusR2_0 = FocusNode();
      final focusR2_1 = FocusNode();
      final focusR2_2 = FocusNode();

      addTearDown(() {
        focusR1_0.dispose();
        focusR1_1.dispose();
        focusR1_2.dispose();
        focusR1_3.dispose();
        focusR2_0.dispose();
        focusR2_1.dispose();
        focusR2_2.dispose();
      });

      final r = SpatialNavigationRegistry();
      addTearDown(r.dispose);
      final eng = SpatialNavigationEngine(registry: r);
      addTearDown(eng.dispose);

      r.registerNode(SpatialNavigationNode(id: 'r1_0', rect: const Rect.fromLTWH(0, 100, 100, 100), focusNode: focusR1_0));
      r.registerNode(SpatialNavigationNode(id: 'r1_1', rect: const Rect.fromLTWH(150, 100, 100, 100), focusNode: focusR1_1));
      r.registerNode(SpatialNavigationNode(id: 'r1_2', rect: const Rect.fromLTWH(300, 100, 100, 100), focusNode: focusR1_2));
      r.registerNode(SpatialNavigationNode(id: 'r1_3', rect: const Rect.fromLTWH(450, 100, 100, 100), focusNode: focusR1_3));

      // Row 2 has a node with slightly closer X coordinate to r1_1
      r.registerNode(SpatialNavigationNode(id: 'r2_0', rect: const Rect.fromLTWH(0, 300, 100, 100), focusNode: focusR2_0));
      r.registerNode(SpatialNavigationNode(id: 'r2_1', rect: const Rect.fromLTWH(140, 300, 100, 100), focusNode: focusR2_1));
      r.registerNode(SpatialNavigationNode(id: 'r2_2', rect: const Rect.fromLTWH(290, 300, 100, 100), focusNode: focusR2_2));

      // 0 -> 1
      var res = eng.navigate(TvNavigationDirection.right, currentNode: r.getNode('r1_0'));
      expect(res.targetNode?.id, 'r1_1');

      // 1 -> 2 (must NOT jump to r2_2 or r2_1!)
      res = eng.navigate(TvNavigationDirection.right, currentNode: r.getNode('r1_1'));
      expect(res.targetNode?.id, 'r1_2');

      // 2 -> 3
      res = eng.navigate(TvNavigationDirection.right, currentNode: r.getNode('r1_2'));
      expect(res.targetNode?.id, 'r1_3');

      // 3 -> right at end of row: should NOT jump down to row 2!
      res = eng.navigate(TvNavigationDirection.right, currentNode: r.getNode('r1_3'));
      expect(res.success, isFalse, reason: 'Should not jump down to row 2 at the end of row 1');
    });
  });

  group('SpatialNavigationController & Shared Registry', () {
    test('shared registry instance between engine and controller', () {
      final controller = SpatialNavigationController();
      expect(identical(controller.registry, controller.engine.registry), isTrue);
    });
  });
}
