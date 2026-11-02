
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service/app_preferences_service.dart';

part 'theme_view_model.g.dart';

@riverpod
class ThemeViewModel extends _$ThemeViewModel {
  @override
  Future<int> build() async {
    final savedColor = await AppPreferencesService().getColor();

    return savedColor ?? Colors.blue.toARGB32();
  }

  // Thay đổi màu AppBar
  Future<void> changeColor(Color color) async {
    final colorValue = color.toARGB32();

    state = AsyncData(colorValue);

    await AppPreferencesService().saveColor(colorValue);
  }
}
