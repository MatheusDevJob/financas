import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static final PrefService _instance = PrefService._internal();
  factory PrefService() => _instance;
  PrefService._internal();

  SharedPreferences? _prefs;
  String? globalEmail;
  String? globalNome;

  final String _token = 'token';
  final String _email = 'email';
  final String _nome = 'nome';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    globalEmail = _prefs!.getString(_email) ?? "";
    globalNome = _prefs!.getString(_nome) ?? "";
  }

  Future<void> setToken(String token) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString('token', token);
  }

  Future<void> rmToken() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs!.clear();
  }

  Future<String> getToken() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!.getString(_token) ?? "";
  }

  Future<void> setEmail(String email) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString(_email, email);
    globalEmail = email;
  }

  Future<String> getEmail() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!.getString(_email) ?? "";
  }

  Future<void> setNome(String nome) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString(_nome, nome);
    globalNome = nome;
  }

  Future<String> getnome() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!.getString(_nome) ?? "";
  }
}
