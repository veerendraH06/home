import 'dart:async';

import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc_event.dart';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc_state.dart';

import 'package:YOURDRS_FlutterAPP/network/models/appointment.dart';
import 'package:YOURDRS_FlutterAPP/network/models/schedule.dart';
import 'package:YOURDRS_FlutterAPP/network/services/appointment_service.dart';

class PatientBloc
    extends BaseBloc<PatientAppointmentBlocEvent, PatientAppointmentBlocState> {
  PatientBloc() : super(PatientAppointmentBlocState.initial());

  @override
  Stream<PatientAppointmentBlocState> mapEventToState(
      PatientAppointmentBlocEvent event) async* {
    print("mapEventToState=$event");

    // Get patient appointment event
    // if (event is GetPatientAppointmentBlocEvent) {
    //   yield state.copyWith(
    //     isLoading: true,
    //   );
    //
    //   List<Patients> users;
    //   users = await Services.getUsers();
    //
    //   if (users == null || users.isEmpty) {
    //     yield state.copyWith(
    //         isLoading: false, errorMsg: 'No patients available', users: users);
    //   } else {
    //     yield state.copyWith(isLoading: false, errorMsg: null, users: users);
    //   }
    // }

    // search patient event
    if (event is SearchPatientEvent) {
      yield state.copyWith(keyword: event.keyword);
    }

    //schedule patient list event
    if (event is GetSchedulePatientsList) {
      yield state.reset();
      yield state.copyWith(
        isLoading: true,
      );
      List<ScheduleList> patients;
      patients = await Services.getSchedule(
          event.keyword1,
          event.providerId,
          event.locationId,
          event.dictationId,
          event.startDate,
          event.endDate,
          event.searchString);
      if (patients == null || patients.isEmpty) {
        yield state.copyWith(
            isLoading: false,
            errorMsg: "No Patients Available",
            patients: patients);
      } else {
        yield state.copyWith(
            isLoading: false, errorMsg: null, patients: patients);
      }
    }
  }
}
