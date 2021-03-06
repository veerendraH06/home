import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc.dart';
import 'package:YOURDRS_FlutterAPP/route_generator.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_portrait..dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_screen.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: PatientAppointment.routeName,
      // '/home',
      // routes: <String, WidgetBuilder>{
      //   '/home': (BuildContext context) => BlocProvider(
      //         create: (context) => PatientBloc(),
      //         child: PatientAppointment(),
      //       ),
      //   '/details': (BuildContext context) => PatientDetail(),
      // },
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: RouteGenerator.navigatorKey,
    );
  }
}
