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

import 'package:flutter_test/flutter_test.dart';
import 'package:yoga_engine/src/ffi/mapper.dart';
import 'package:yoga_engine/src/layout/yoga_render.dart';
import 'package:yoga_engine/src/utils/methods.dart';
import 'package:yoga_engine/src/utils/node_helper.dart';
import 'package:yoga_engine/src/yoga_initializer.dart';
import 'package:yoga_engine/yoga_engine.dart';

void main() {
  serviceLocator.registerSingleton<DynamicLibrary>(loadYoga());
  final _mapper = Mapper(serviceLocator.get());
  serviceLocator.registerSingleton<Mapper>(_mapper);
  final _nodeHelper = NodeHelper(serviceLocator.get());
  serviceLocator.registerSingleton<NodeHelper>(_nodeHelper);

  group('Given a NodeHelper', () {

    group('When setRenderBoxToNode is called', () {
      test('Then should set the renderBox to the given node', () {
        // Given
        final node = _mapper.yGNodeNew();
        final renderBox = RenderYoga(yogaNode: YogaNode());

        // When
        _nodeHelper.setRenderBoxToNode(renderBox, node);

        // Then
        expect(_nodeHelper.getRenderBoxFromNode(node), renderBox);
      });
    });

    group('When getRenderBoxFromNode is called', () {
      test('Then should remove the node index', () {
        // Given
        final node = _mapper.yGNodeNew();
        final renderBox = RenderYoga(yogaNode: YogaNode());

        // When
        _nodeHelper.setRenderBoxToNode(renderBox, node);
        _nodeHelper.getRenderBoxFromNode(node);

        // Then
        expect(_nodeHelper.getRenderBoxFromNode(node), null);
      });
    });
  });
}
