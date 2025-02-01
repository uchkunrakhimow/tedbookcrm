import 'package:shared_preferences/shared_preferences.dart';
import 'package:tedbook/model/response/login_response.dart';

class UserData {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserData._();

  // Attention!!
  // Don't use create or default constructor. Use getInstance() method to get UserData object
  factory UserData.create() => UserData._();

  Future<void> saveGeneralUserData(UserModel user) async {
    final SharedPreferences prefs = await _prefs;
    if (user.id?.isNotEmpty == true) await prefs.setString('user_id', user.id!);
    if (user.username?.isNotEmpty == true)
      await prefs.setString('user_name', user.username!);
    if (user.role?.isNotEmpty == true)
      await prefs.setString('role', user.role!);
  }

  Future<void> saveGeneralToken(TokenModel tokens) async {
    final SharedPreferences prefs = await _prefs;
    if (tokens.accessToken?.isNotEmpty == true)
      await prefs.setString('access_token', tokens.accessToken!);
    if (tokens.refreshToken?.isNotEmpty == true)
      await prefs.setString('refresh_token', tokens.refreshToken!);
  }

  Future<void> saveAccessToken(String accessToken) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('access_token', accessToken);
  }

  Future<void> saveRefreshToken(String accessToken) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('refresh_token', accessToken);
  }

  Future<String?> userId() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    return prefs.getString('user_id');
  }

  Future<String?> userName() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    return prefs.getString('user_name');
  }

  Future<String?> userRole() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    return prefs.getString('user_role');
  }

  Future<String?> accessToken() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    return prefs.getString('access_token');
  }

  Future<String?> refreshToken() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    return prefs.getString('refresh_token');
  }

  Future<void> clearAllData() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getKeys().toList();
    for (int i = 0; i < a.length; i++) {
      await prefs.remove(a[i]);
    }
  }
}
