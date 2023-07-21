import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static String? firstName, lastName, token, profilePic, mobile, email;

  /// Save user authentication (information)
  static Future<void> saveUserData(String uFirstName, String uLastName,
      String uToken, String uProfilePic, String uMobile, String uEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', uToken);
    await sharedPreferences.setString('firstName', uFirstName);
    await sharedPreferences.setString('lastName', uLastName);
    await sharedPreferences.setString('mobile', uMobile);
    await sharedPreferences.setString('photo', uProfilePic);
    await sharedPreferences.setString('email', uEmail);
    firstName = uFirstName;
    lastName = uLastName;
    token = uToken;
    profilePic = uProfilePic;
    mobile = uMobile;
    email = uEmail;
  }

  /// this is check function for really saved the user information or not (T/F)
  static Future<bool> checkLoginState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> getAuthData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    token = sharedPreferences.getString('token');
    firstName = sharedPreferences.getString('firstName');
    lastName = sharedPreferences.getString('lastName');
    profilePic = sharedPreferences.getString('photo');
    mobile = sharedPreferences.getString('mobile');
    email = sharedPreferences.getString('email');
  }

  static Future<void> clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  static showBase64Image(base64Image){
    UriData? data = Uri.parse(base64Image).data;
    Uint8List myImage = data!.contentAsBytes();
    return myImage;
  }
}
