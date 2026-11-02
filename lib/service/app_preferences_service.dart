import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesService {
  static const String colorKey = 'app_bar_color';

  // Lưu màu
  Future<void> saveColor(int colorValue) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(colorKey, colorValue);
  }

  // Đọc màu đã lưu
  Future<int?> getColor() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(colorKey);
  }
}