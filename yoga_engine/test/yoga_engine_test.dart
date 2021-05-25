import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yoga_engine/yoga_engine.dart';

void main() {
  const MethodChannel channel = MethodChannel('yoga_engine');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await YogaEngine.platformVersion, '42');
  });
}
