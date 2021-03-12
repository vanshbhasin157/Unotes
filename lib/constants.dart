import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color darkColor = new Color(0XFE0d1b21);
Color lightColor = new Color(0XFE5e4c35);


class HelperFunction {
  static String userId = "USERID";
  static String authToken = "AUTHTOKEN";
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static Future<bool> signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic result;
    try {
      result = await preferences.clear();

      return result;
    } catch (e) {
      throw Exception('Problem in Signing Out.');
    }
  }

  static Future<bool> saveAuthToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(authToken, token);
  }

  static Future<bool> saveUserId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userId, id);
  }

  static Future<String> getAuthToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(authToken);
  }

  static Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userId);
  }

  static Future<bool> saveUserInSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }
}
