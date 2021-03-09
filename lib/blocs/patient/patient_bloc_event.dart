import 'package:YOURDRS_FlutterAPP/blocs/base/base_bloc_event.dart';
import 'package:flutter/widgets.dart';

abstract class PatientAppointmentBlocEvent extends BaseBlocEvent {}

class GetPatientAppointmentBlocEvent extends PatientAppointmentBlocEvent {
  @override
  List<Object> get props => [];
}

class SearchPatientEvent extends PatientAppointmentBlocEvent {
  final String keyword;

  SearchPatientEvent({@required this.keyword});

  @override
  List<Object> get props => [this.keyword];
}

class GetProvidersListEvent extends PatientAppointmentBlocEvent {
  final String memberId;

  GetProvidersListEvent({this.memberId});

  @override
  List<Object> get props => [this.memberId];
}

// Creating an event GetSchedulePatientList
class GetSchedulePatientsList extends PatientAppointmentBlocEvent {
  final String keyword1;
  final int providerId;
  final int locationId;
  final int dictationId;
  final String startDate;
  final String endDate;
  final String searchString;
  GetSchedulePatientsList(
      {@required this.keyword1,
      @required this.providerId,
      @required this.locationId,
      @required this.dictationId,
      this.startDate,
      this.endDate,
      this.searchString});
  @override
  List<Object> get props => [
        this.keyword1,
        this.providerId,
        this.locationId,
        this.dictationId,
        this.startDate,
        this.endDate,
        this.searchString
      ];
}
