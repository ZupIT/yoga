# yoga_engine

A plugin that uses yoga to implements flexbox layout in Flutter.

## Installation

To use this plugin, add `yoga_engine` as a dependency in your `pubspec.yalm` file.

## Usage

First, import the dependency `package:yoga_engine/yoga_engine.dart` to your dart code to be able 
to use all the widgets and helpers provided by the Yoga Engine. Then, before `runApp` 
method, call `Yoga.init()` to initialize all Yoga Engine dependencies.

All that done, just configure each `YogaNode` to all `YogaTree` and `YogaLeaf` widgets in 
your layout, to yoga calculate each widget size and position them.

## Example

### Import
```dart
import 'package:yoga_engine/yoga_engine.dart';
```

### Initialization
```dart
void main() {
  Yoga.init();
}
```

### Configuration
```dart
YogaNode root = YogaNode();
root.setWidth(300);
root.setHeight(300);
root.setFlexDirection(YGFlexDirection.YGFlexDirectionRow);
root.setAlignItems(YGAlign.YGAlignCenter);

YogaNode child = YogaNode();
```

### Placement
```dart
YogaTree(
  yogaNode: root,
  children: [
    YogaLeaf(
      yogaNode: child,
      child: Text('Child'),
    ),
  ],
 )
```

## Yoga layout rules
- `YogaTree` widgets can only have children of `YogaTree` or `YogaLeaf` types.
- `YogaLeaf` widgets can have any type of child, except themselves.
- `YogaLeaf` widgets cannot be placed outside `YogaTree`.
