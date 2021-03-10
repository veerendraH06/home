
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_landscape.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_portrait..dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("RouteGenerator->name=${settings.name}");
    switch (settings.name) {

      case PatientAppointment.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => PatientBloc(),
            child: PatientAppointment(),
          ),
        );

      case PatientDetail.routName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PatientDetail(),
        );

      case HomePortrait.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomePortrait(),
        );

      case HomeLandScape.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomeLandScape(),
        );

      default:
        return null;
    }
  }
}
