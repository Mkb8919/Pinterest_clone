import 'package:hive/hive.dart';

class SaveService {
  static late Box _box;

  /// MUST CALL THIS BEFORE USING SERVICE
  static Future<void> init() async {
    _box = await Hive.openBox("saved_pins");
  }

  /// Get saved pins
  static List<String> getSavedPins() {
    return _box.get("pins", defaultValue: <String>[])!.cast<String>();
  }

  /// Save pin
  static Future<void> savePin(String url) async {
    final List<String> pins = getSavedPins();

    if (!pins.contains(url)) {
      pins.add(url);
      await _box.put("pins", pins);
    }
  }

  /// Remove pin
  static Future<void> removePin(String url) async {
    final List<String> pins = getSavedPins();

    pins.remove(url);
    await _box.put("pins", pins);
  }

  /// Check if saved
  static bool isSaved(String url) {
    return getSavedPins().contains(url);
  }
}
