# spatial_navigation

[![pub package](https://img.shields.io/pub/v/spatial_navigation.svg)](https://pub.dev/packages/spatial_navigation)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.19.0-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20TV%20%7C%20FireTV%20%7C%20Desktop%20%7C%20Web-blue)](#)

A production-grade, high-performance **2D Spatial Navigation Engine** for Flutter Android TV, Fire TV, Desktop, and D-Pad applications.

Designed specifically for 60fps/120fps TV UI performance, `spatial_navigation` provides intelligent focus calculation, dynamic auto-scrolling alignment, modal focus isolation, navigation boundaries, and real-time visual debugging overlay.

---

## 🌟 Key Features

- 🎯 **Intelligent 2D Spatial Engine**: Computes candidate target focus using weighted primary distance, secondary axis deviation, 1D segment intersection overlap, and directional alignment.
- ⚡ **60fps / 120fps Performance**: Optimized layout notifier lifecycle that eliminates frame drops during rapid D-Pad scrolling.
- 📺 **Android TV & Gamepad Native**: Built-in mapping for D-Pad directional arrows, D-Pad Center, Select, WASD, Gamepad buttons (12–15, A, B), Spacebar, and Escape/Back keys.
- 🔒 **Modal Scopes & Boundaries**: Trap focus inside modal dialogs (`isModal: true`) or restrict direction movement using `NavigationBoundaries(canExitLeft: false)`.
- 📜 **Auto-Aligning TV Scrollables**: `TvScrollableRow`, `TvScrollableGrid`, `TvScrollableList`, and `TvLazyScrollableRow` with configurable pivot offsets (`pivotFraction`).
- 🛠️ **Visual Spatial Debugger**: Real-time bounding box overlay painter (`SpatialNavigationDebugger`) showing active focus, candidate nodes, and directional scoring vectors.

---

## 📦 Installation

Add `spatial_navigation` to your `pubspec.yaml`:

```yaml
dependencies:
  spatial_navigation: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

### 1. Basic Spatial Navigation Setup

Wrap your application in `TvNavigationListener` and define focusable elements using `TvFocusable`:

```dart
import 'package:flutter/material.dart';
import 'package:spatial_navigation/spatial_navigation.dart';

class TvHomeScreen extends StatefulWidget {
  const TvHomeScreen({super.key});

  @override
  State<TvHomeScreen> createState() => _TvHomeScreenState();
}

class _TvHomeScreenState extends State<TvHomeScreen> {
  late final SpatialNavigationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpatialNavigationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvNavigationListener(
      controller: _controller,
      child: TvNavigationScope(
        controller: _controller,
        groupId: 'home_scope',
        child: Scaffold(
          body: Row(
            children: [
              TvFocusable(
                id: 'button_1',
                groupId: 'home_scope',
                focusBuilder: (context, child, isFocused) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    color: isFocused ? Colors.red : Colors.grey[800],
                    child: const Text('Button 1', style: TextStyle(color: Colors.white)),
                  );
                },
                child: const SizedBox(),
              ),
              const SizedBox(width: 20),
              TvFocusable(
                id: 'button_2',
                groupId: 'home_scope',
                focusBuilder: (context, child, isFocused) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    color: isFocused ? Colors.red : Colors.grey[800],
                    child: const Text('Button 2', style: TextStyle(color: Colors.white)),
                  );
                },
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 📜 Scrollable Collections

Use `TvScrollableRow` or `TvScrollableList` to automatically pivot and scroll active focused elements into view:

```dart
TvScrollableRow(
  groupId: 'movie_shelf',
  pivotFraction: 0.3, // Keeps focused item at 30% viewport offset
  scrollDuration: const Duration(milliseconds: 250),
  children: List.generate(10, (index) {
    return TvFocusable(
      id: 'movie_card_$index',
      groupId: 'movie_shelf',
      focusBuilder: (context, child, isFocused) {
        return AnimatedScale(
          scale: isFocused ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Card(
            color: isFocused ? Colors.red : Colors.blueGrey,
            child: SizedBox(
              width: 140,
              height: 180,
              child: Center(child: Text('Item #$index')),
            ),
          ),
        );
      },
      child: const SizedBox(),
    );
  }),
)
```

---

## 🔒 Modal Dialogs & Focus Isolation

Prevent focus from leaving popups or modals by setting `isModal: true` or calling `controller.showModal()`:

```dart
// Display modal and constrain D-Pad focus inside dialog scope
void openDetailModal() {
  controller.showModal('detail_modal_group');
}

// Dismiss modal and restore previous focus
void closeDetailModal() {
  controller.hideModal('detail_modal_group');
}

// Modal Widget Definition
Widget buildModalDialog() {
  return TvNavigationScope(
    controller: controller,
    groupId: 'detail_modal_group',
    isModal: true, // Traps D-Pad focus inside modal
    child: Dialog(
      child: Column(
        children: [
          TvFocusable(
            id: 'modal_action_btn',
            groupId: 'detail_modal_group',
            focusBuilder: (context, child, isFocused) => ...,
            child: const SizedBox(),
          ),
        ],
      ),
    ),
  );
}
```

---

## 🚫 Navigation Boundaries

Restrict focus from exiting a specific direction (e.g., side menu drawers):

```dart
TvNavigationScope(
  controller: controller,
  groupId: 'sidebar_menu',
  boundaries: const NavigationBoundaries(
    canExitLeft: false, // Prevents left D-Pad press from leaving sidebar
  ),
  child: SidebarWidget(),
)
```

---

## 🛠️ Visual Spatial Debugger

Enable real-time bounding box painter and directional score lines during development:

```dart
SpatialNavigationDebugger(
  controller: controller,
  enabled: kDebugMode, // Toggle overlay painter
  child: MyAppContent(),
)
```

---

## 📖 API Summary

| Class / Widget | Description |
| :--- | :--- |
| `SpatialNavigationController` | Central coordinator managing focus state, modal stack, and history. |
| `SpatialNavigationEngine` | Spatial calculation engine scoring candidate focus targets. |
| `SpatialNavigationRegistry` | High-performance spatial indexing store. |
| `SpatialNavigationScope` | Defines navigation scope groups, modal states, and boundary locks. |
| `TvFocusable` | Widget wrapper registering bounding geometry and focus state. |
| `TvNavigationListener` | D-Pad key event handler mapping hardware input to controller moves. |
| `TvScrollableRow` | Horizontal TV scrollable list with auto-pivoting alignment. |
| `SpatialNavigationDebugger` | Canvas painter rendering spatial debug bounds and candidate scores. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
