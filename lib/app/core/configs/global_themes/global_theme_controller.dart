import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalThemeController extends GetxController {
  static const String _keyDarkMode = 'dark_mode';

  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode.value = prefs.getBool(_keyDarkMode) ?? false;
    } catch (e) {
      _isDarkMode.value = false;
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode.value = !_isDarkMode.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyDarkMode, _isDarkMode.value);
    } catch (e) {
      // Em caso de erro, reverter a mudança
      _isDarkMode.value = !_isDarkMode.value;
    }
  }

  Future<void> setDarkMode(bool isDark) async {
    try {
      _isDarkMode.value = isDark;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyDarkMode, isDark);
    } catch (e) {
      // Manter valor atual em caso de erro
    }
  }
}
