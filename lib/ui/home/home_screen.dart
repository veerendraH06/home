import 'dart:async';
import 'dart:convert';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_filter_menu.dart';
import 'package:YOURDRS_FlutterAPP/common/app_pop_menu.dart';
import 'package:YOURDRS_FlutterAPP/network/models/appointment.dart';
import 'package:YOURDRS_FlutterAPP/network/services/appointment_service.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_landscape.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/home_portrait..dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:YOURDRS_FlutterAPP/widget/input_fields/search_bar.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';

class PatientAppointment extends StatefulWidget {
  @override
  _PatientAppointmentState createState() => _PatientAppointmentState();
}

//Time delay related code
class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _PatientAppointmentState extends State<PatientAppointment> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    try {
      if (width > 600) {
        return HomeLandScape();
      } else {
        return HomePortrait();
      }
    } catch (e) {}
  }
}
