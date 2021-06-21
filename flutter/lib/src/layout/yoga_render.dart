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

import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:yoga_engine/src/ffi/types.dart';
import 'package:yoga_engine/src/utils/node_helper.dart';

import '../yoga_initializer.dart';
import 'yoga_node.dart';

class YogaParentData extends ContainerBoxParentData<RenderBox> {
  bool? isLeaf;
  YogaNode? yogaNode;

  @override
  String toString() => '${super.toString()}; node=$yogaNode; isLeaf=$isLeaf';
}

/// Class responsible to measure any flutter widget by the YogaNode properties.
/// This can only be placed inside a YogaTree widget and cannot have another
/// YogaLeaf as a direct child.
/// Pass false to isLeaf property when this class is not placed at the end of
/// the widget tree.
class YogaLeaf extends ParentDataWidget<YogaParentData> {
  const YogaLeaf({
    Key? key,
    this.isLeaf = true,
    required this.yogaNode,
    required Widget child,
  }) : super(key: key, child: child);

  final bool isLeaf;
  final YogaNode yogaNode;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is YogaParentData);
    final parentData = renderObject.parentData! as YogaParentData;
    bool needsLayout = false;

    if (parentData.isLeaf != isLeaf) {
      parentData.isLeaf = isLeaf;
      needsLayout = true;
    }

    if (parentData.yogaNode != yogaNode) {
      parentData.yogaNode = yogaNode;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => YogaTree;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('isLeaf', isLeaf.toString()));
    properties.add(StringProperty('yogaNode', yogaNode.toString()));
  }
}

class RenderYoga extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, YogaParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, YogaParentData>,
        DebugOverflowIndicatorMixin {
  RenderYoga({
    List<RenderBox>? children,
    required YogaNode yogaNode,
  }) : _yogaNode = yogaNode {
    addAll(children);
  }

  YogaNode get yogaNode => _yogaNode;
  YogaNode _yogaNode;

  set yogaNode(YogaNode value) {
    if (_yogaNode != value) {
      _yogaNode = value;
      markNeedsLayout();
    }
  }

  final _helper = serviceLocator.get<NodeHelper>();

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! YogaParentData) {
      child.parentData = YogaParentData();
    }
  }

  bool _isLeaf(YogaParentData yogaParentData) {
    return yogaParentData.isLeaf ?? false;
  }

  YogaNode _getYogaNode(YogaParentData yogaParentData) {
    return yogaParentData.yogaNode!;
  }

  @override
  void performLayout() {
    if (!yogaNode.isCalculated()) {
      _attachNodesFromWidgetsHierarchy(this);
      yogaNode.calculateLayout(
        constraints.maxWidth.floorToDouble(),
        constraints.maxHeight.floorToDouble(),
      );
    }
    _applyLayoutToWidgetsHierarchy(getChildrenAsList());

    size = Size(
      yogaNode.getLayoutWidth(),
      yogaNode.getLayoutHeight(),
    );
  }

  void _attachNodesFromWidgetsHierarchy(RenderYoga renderYoga) {
    final children = renderYoga.getChildrenAsList();
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (child is RenderYoga) {
        renderYoga.yogaNode.insertChildAt(child.yogaNode, i);
        _attachNodesFromWidgetsHierarchy(child);
      } else {
        final yogaParentData = child.parentData as YogaParentData;
        assert(() {
          if (yogaParentData.yogaNode != null) {
            return true;
          }
          throw FlutterError('To use YogaTree, '
              'you must declare every child inside a YogaLeaf component');
        }());
        final yogaNodeLeaf = _getYogaNode(yogaParentData);
        renderYoga.yogaNode.insertChildAt(yogaNodeLeaf, i);
        if (_isLeaf(yogaParentData)) {
          _helper.setRenderBoxToNode(child, yogaNodeLeaf.node);
          yogaNodeLeaf.setMeasureFunc();
        } else {
          _iterateOverYogaLeaves(child, yogaNodeLeaf);
        }
      }
    }
  }

  _iterateOverYogaLeaves(RenderBox child, YogaNode yogaNodeLeaf) {
    int index = 0;
    child.visitChildren((innerChild) {
      if (innerChild is RenderYoga) {
        yogaNodeLeaf.insertChildAt(innerChild.yogaNode, index);
        _attachNodesFromWidgetsHierarchy(innerChild);
      } else {
        _iterateOverYogaLeaves(innerChild as RenderBox, yogaNodeLeaf);
      }
      index++;
    });
  }

  void _applyLayoutToWidgetsHierarchy(List<RenderBox> children) {
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final yogaParentData = child.parentData as YogaParentData;
      late Pointer<YGNode> node;
      if (child is RenderYoga) {
        node = child.yogaNode.node;
      } else {
        node = _getYogaNode(yogaParentData).node;
      }
      yogaParentData.offset = Offset(
        _helper.getLeft(node),
        _helper.getTop(node),
      );
      late BoxConstraints childConstraints;
      if (yogaParentData.isLeaf!) {
        childConstraints = BoxConstraints.tight(
          Size(
            _helper.getLayoutWidth(node),
            _helper.getLayoutHeight(node),
          ),
        );
      } else {
        childConstraints = BoxConstraints.loose(
          Size(
            _helper.getLayoutWidth(node),
            _helper.getLayoutHeight(node),
          ),
        );
      }
      child.layout(childConstraints, parentUsesSize: true);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

/// Class responsible to measure each YogaLeaf by the YogaNode properties.
/// Only YogaLeaf widgets are enabled to be children.
/// This widget has no restriction to be positioned.
class YogaTree extends MultiChildRenderObjectWidget {
  YogaTree({
    Key? key,
    required this.yogaNode,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  final YogaNode yogaNode;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderYoga(yogaNode: yogaNode);
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant RenderYoga renderObject,) {
    renderObject.yogaNode = yogaNode;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('yogaNode', yogaNode.toString()));
  }
}
