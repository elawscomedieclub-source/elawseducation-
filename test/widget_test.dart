import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/core/theme/app_theme.dart';

void main() {
  test('les thèmes clair et sombre sont configurés pour Material 3', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.brightness, Brightness.dark);
  });
}
