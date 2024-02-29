import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() {
    return _instance;
  }
  AppState._internal() {
    initializePersistedState();
  }
  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool("isAuthenticated") ?? false;
  }

  late SharedPreferences prefs;

  int _currentIssuedBooks = 0;
  int get currentIssuedBooks => _currentIssuedBooks;
  set currentIssuedBooks(int value) {
    _currentIssuedBooks = value;
  }

  int _totalIssuedBooks = 0;
  int get totalIssuedBooks => _totalIssuedBooks;
  set totalIssuedBooks(int value) {
    _totalIssuedBooks = value;
  }

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    prefs.setBool("isAuthenticated", value);
  }
}
