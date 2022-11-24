import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String useridKey = "USERIDKEY";
  static String usergroupKey = "USERGROUPKEY";
  static String userpeanutsKey = "USERPEANUTKEY";
  static String recentgroupKey = "RECENTGROUPKEY";
  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserIDSF(String userID) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userID);
  }

  static Future<bool> saveUserusergroupSF(String usergroup) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(usergroupKey, usergroup);
  }

  static Future<bool> saveUserpeanutsKey(int peanut) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setInt(userpeanutsKey, peanut);
  }

  static Future<bool> saverecentgroupKey(String gid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(recentgroupKey, gid);
  }
  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserIDFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useridKey);
  }

  static Future<String?> getUserusergroupSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usergroupKey);
  }

  static Future<int?> getUserpeanutsKey() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getInt(userpeanutsKey);
  }

  static Future<String?> getrecentgroupKey() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(recentgroupKey);
  }
}
