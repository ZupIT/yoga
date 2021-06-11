/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
    child1.setWidth(40);
    child1.setHeight(40);

    YogaNode child2 = YogaNode();
    child2.setFlexDirection(YGFlexDirection.YGFlexDirectionRow);

    YogaNode child3 = YogaNode();

    YogaNode root = YogaNode();
    root.setWidth(300);
    root.setHeight(300);
    root.setFlexDirection(YGFlexDirection.YGFlexDirectionRow);
    // root.setAlignItems(YGAlign.YGAlignCenter);

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
              YogaTree(
                yogaNode: child2,
                children: [
                  YogaLeaf(
                    yogaNode: child3,
                    child: ColoredBox(
                      color: Colors.cyan,
                      child: Text('Child 2'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
