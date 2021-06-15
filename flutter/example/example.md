# Cookbook

Simple example of how to use the yoga_engine plugin.

```dart
import 'package:flutter/material.dart';
import 'package:yoga_engine/yoga_engine.dart';

void main() {
  Yoga.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YogaNode child1 = YogaNode();
    child1.setWidth(50);
    child1.setHeight(50);

    YogaNode child2 = YogaNode();

    YogaNode child3 = YogaNode();
    child3.setFlexDirection(YGFlexDirection.YGFlexDirectionRow);
    child3.setHeight(100);

    YogaNode child4 = YogaNode();
    child4.setHeight(50);

    YogaNode root = YogaNode();
    root.setWidth(300);
    root.setHeight(300);
    root.setFlexDirection(YGFlexDirection.YGFlexDirectionRow);
    root.setAlignItems(YGAlign.YGAlignCenter);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ColoredBox(
          color: Colors.orange,
          child: YogaTree(
            yogaNode: root,
            children: [
              YogaLeaf(
                yogaNode: child1,
                child: ColoredBox(
                  color: Colors.yellow,
                  child: Text('Child 1'),
                ),
              ),
              YogaLeaf(
                isLeaf: false,
                yogaNode: child2,
                child: ColoredBox(
                  color: Colors.pink,
                  child: YogaTree(
                    yogaNode: child3,
                    children: [
                      YogaLeaf(
                        yogaNode: child4,
                        child: ColoredBox(
                          color: Colors.cyan,
                          child: Text('Child 2'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
