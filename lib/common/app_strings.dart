import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';

class AppStrings {
  static const welcome = 'Welcome';
  static const search='Search Patients';
  static const selectfilter = 'Select a Filter';
  static const provider='Provider';
  static const selectprovider='Select provider';
  static const dictation ='Dictation';
  static const location='Location';
  static const selectdictation='Select Dictation';
  static const selectlocation ='Select Location';
  static const datefilter = 'Date Filter';
  static const searchpatient ='Search Patient';

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
  //for getting dictations
  static const getDictations=
      AppConstants.dioBaseUrl +"api/Dictation/GetAllDictations";
}
