import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';

class AppStrings {
  static const welcome = 'Welcome';
  static const signIn = "Signin";
  static const tryAgain = "tryAgain";
  static const notNow = "notNow";
  static const dictationJson = "assets/json/appointment.json";
}

class ApiUrlConstants {
  // for getting Locations//
  static const getLocation =
      AppConstants.dioBaseUrl + "api/Schedule/GetMemberLocations";
  // for getting Provider
  static const getProviders =
      AppConstants.dioBaseUrl + "api/Schedule/GetAssociatedProvider";
  //for getting Schedules
  static const getSchedules =
      AppConstants.dioBaseUrl + "api/Schedule/GetSchedules";
  static const getDictations=
      AppConstants.dioBaseUrl +"api/Dictation/GetAllDictations";
}
