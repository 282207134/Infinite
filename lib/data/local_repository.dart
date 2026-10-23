import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// The persistence boundary. Replace with an API-backed implementation later.
class LocalRepository {
  LocalRepository(this.preferences);
  final SharedPreferences preferences;
  Map<String, dynamic> read() {
    try {
      return jsonDecode(preferences.getString('infinite.state.v1') ?? '{}')
          as Map<String, dynamic>;
    } on FormatException {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> state) async {
    await preferences.setString('infinite.state.v1', jsonEncode(state));
  }
}
