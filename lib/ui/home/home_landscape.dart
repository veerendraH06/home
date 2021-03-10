import 'dart:async';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc_event.dart';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_pop_menu.dart';
import 'package:YOURDRS_FlutterAPP/network/models/schedule.dart';
import 'package:YOURDRS_FlutterAPP/ui/home/patient_details.dart';
import 'package:YOURDRS_FlutterAPP/widget/date_range_picker.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/dictation.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/location.dart';
import 'package:YOURDRS_FlutterAPP/widget/dropdowns/provider.dart';
import 'package:YOURDRS_FlutterAPP/widget/input_fields/search_bar.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLandScape extends StatefulWidget {
  static const String routeName = '/HomeLandScape';
  HomeLandScape({key}) : super(key: key);
  @override
  _HomeLandScapeState createState() => _HomeLandScapeState();
}

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

class _HomeLandScapeState extends State<HomeLandScape> {
  final _debouncer = Debouncer(milliseconds: 500);
  GlobalKey _key = GlobalKey();

  Map<String, dynamic> appointment;
  var _currentSelectedProviderId;
  var _currentSelectedLocationId;
  var _currentSelectedDictationId;

  List<ScheduleList> patients = List();
  List<ScheduleList> filteredPatients = List();

  bool visibleSearchFilter = false;
  bool visibleClearFilter = true;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PatientBloc>(context).add(GetSchedulePatientsList(
        keyword1: null, providerId: null, locationId: null, dictationId: null));
  }

//filter method  for selected date

//Date Picker Controller related code
  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();

//Date Picker Controller related code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: CustomizedColors.primaryColor,
        title: ListTile(
          leading: CircleAvatar(
            radius: 18,
            child: ClipOval(
              child: Image.network(
                  "https://image.freepik.com/free-vector/doctor-icon-avatar-white_136162-58.jpg"),
            ),
          ),
          title: Row(
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  color: CustomizedColors.textColor,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Dr.sciliaris",
                style: TextStyle(
                    color: CustomizedColors.textColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Column(
            children: [
              Offstage(
                offstage: visibleSearchFilter,
                key: _key,
                child: FlatButton(
                  minWidth: 2,
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(
                    Icons.segment,
                    color: CustomizedColors.iconColor,
                  ),
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "Select a filter",
                          style: TextStyle(),
                        ),
                        actions: <Widget>[
                          ProviderDropDowns(
                            // selectedValue: _currentSelectedProviderId,
                              onTapOfProviders: (newValue) {
                                print('onTap newValue $newValue');
                                setState(() {
                                  _currentSelectedProviderId = newValue;
                                  print(
                                      'onTap _currentSelectedProviderId $_currentSelectedProviderId');
                                  // });
                                },
                                );
                              }
                            // selectedValue: _currentSelectedProviderId,
                            // onTap: (String newValue) {
                            //   print('onTap newValue $newValue');
                            //   // setState(() {
                            //   _currentSelectedProviderId = newValue;
                            //   print(
                            //       'onTap _currentSelectedProviderId $_currentSelectedProviderId');
                            //   // });
                            // },
                          ),
                          DictationSearch(onTapOfDictation: (String newValue) {
                            setState(() {
                              _currentSelectedDictationId = newValue;
                              print(_currentSelectedDictationId);
                            });
                          }),
                          LocationDropDown(onTapOfLocation: (String newValue) {
                            // setState(() {
                            _currentSelectedLocationId = newValue;
                            print(_currentSelectedLocationId);
                            // });
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 55,
                                width: 250,
                                child: RaisedButton.icon(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DateFilter()));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    label: Text(
                                      'Date Filter',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: CustomizedColors
                                              .buttonTitleColor),
                                    ),
                                    icon: Icon(null),
                                    // textColor: Colors.red,
                                    splashColor: CustomizedColors.primaryColor,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    visibleSearchFilter = true;
                                    visibleClearFilter = false;
                                  });
                                  BlocProvider.of<PatientBloc>(context).add(
                                      GetSchedulePatientsList(
                                          keyword1: null,
                                          providerId:
                                              _currentSelectedProviderId != null
                                                  ? int.tryParse(
                                                      _currentSelectedProviderId)
                                                  : null,
                                          dictationId:
                                              _currentSelectedDictationId !=
                                                      null
                                                  ? int.tryParse(
                                                      _currentSelectedDictationId)
                                                  : null,
                                          locationId:
                                              _currentSelectedLocationId != null
                                                  ? int.tryParse(
                                                      _currentSelectedLocationId)
                                                  : null));
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
//
                  },
                ),
              ),
              Offstage(
                offstage: visibleClearFilter,
                child: FlatButton(
                  minWidth: 2,
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(
                    Icons.clear_all,
                    color: CustomizedColors.iconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      visibleSearchFilter = false;
                      visibleClearFilter = true;
                    });
                    BlocProvider.of<PatientBloc>(context).add(
                        GetSchedulePatientsList(
                            keyword1: null,
                            providerId: null,
                            locationId: null,
                            dictationId: null));
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //color: Colors.black,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.10,
              color: CustomizedColors.primaryColor,
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: <Widget>[
                    PatientSerach(
                      width: 250,
                      height: 57.0,
                      onChanged: (string) {
                        _debouncer.run(() {
                          BlocProvider.of<PatientBloc>(context)
                              .add(SearchPatientEvent(keyword: string));
                        });
                      },
                    ),
                    Container(
                      color: Colors.grey[100],
                      child: DatePicker(
                        DateTime.now().subtract(Duration(days: 3)),
                        width: 40,
                        height: 80,
                        controller: _controller,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: CustomizedColors.primaryColor,
                        selectedTextColor: CustomizedColors.textColor,
                        dayTextStyle: TextStyle(fontSize: 10.0),
                        dateTextStyle: TextStyle(fontSize: 14.0),
                        onDateChange: (date) {
                          // New date selected

                          setState(() {
                            _selectedValue = date;
                            var selectedDate = AppConstants.parseDate(
                                -1, AppConstants.MMDDYYYY,
                                dateTime: _selectedValue);

                            // getSelectedDateAppointments();
                            BlocProvider.of<PatientBloc>(context).add(
                                GetSchedulePatientsList(
                                    keyword1: selectedDate,
                                    providerId: null,
                                    locationId: null,
                                    dictationId: null));
                            print(selectedDate);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Stack(
                children: <Widget>[
                  SafeArea(
                    bottom: false,
                    child: Stack(
                      children: <Widget>[
                        DraggableScrollableSheet(
                          maxChildSize: .6,
                          initialChildSize: .6,
                          minChildSize: .5,
                          builder: (context, scrollController) {
                            return Container(
                              height: 100,
                              padding: EdgeInsets.only(
                                  left: 19,
                                  right: 19,
                                  top:
                                      16), //symmetric(horizontal: 19, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                color: CustomizedColors.textColor,
                              ),
                              child: SingleChildScrollView(
                                // physics: BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "HEMA 54-DEAN (4)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        )
                                      ],
                                    ),
                                    BlocBuilder<PatientBloc,
                                            PatientAppointmentBlocState>(
                                        builder: (context, state) {
                                      print('BlocBuilder state $state');
                                      if (state.isLoading) {
                                        return CircularProgressIndicator();
                                      }

                                      if (state.errorMsg != null &&
                                          state.errorMsg.isNotEmpty) {
                                        return Text(state.errorMsg);
                                      }

                                      if (state.patients == null ||
                                          state.patients.isEmpty) {
                                        return Text(
                                          "No patients found",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: CustomizedColors
                                                  .noAppointment),
                                        );
                                      }

                                      // if (!isSearching) {
                                      patients = state.patients;
                                      // }

                                      if (state.keyword != null &&
                                          state.keyword.isNotEmpty) {
                                        print(
                                            'patients ${patients?.length} filtered ${filteredPatients?.length}');
                                        filteredPatients = patients
                                            .where((u) => (u.patient.displayName
                                                .toLowerCase()
                                                .contains(state.keyword
                                                    .toLowerCase())))
                                            .toList();
                                      } else {
                                        filteredPatients = patients;
                                      }

                                      return filteredPatients != null &&
                                              filteredPatients.isNotEmpty
                                          ? ListView.separated(
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                color: CustomizedColors.title,
                                              ),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  filteredPatients.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Hero(
                                                  tag: filteredPatients[index],
                                                  child: Material(
                                                    child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                      leading: Icon(
                                                        Icons.bookmark,
                                                        color: Colors.green,
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PatientDetail(),
                                                            // Pass the arguments as part of the RouteSettings. The
                                                            // DetailScreen reads the arguments from these settings.
                                                            settings:
                                                                RouteSettings(
                                                              arguments:
                                                                  filteredPatients[
                                                                      index],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      title: Text(
                                                          filteredPatients[
                                                                  index]
                                                              .patient
                                                              .displayName),
                                                      subtitle: Column(
                                                        children: [
                                                          Container(
                                                            child: Text("Dr." +
                                                                    "" +
                                                                    filteredPatients[
                                                                            index]
                                                                        .providerName ??
                                                                ""),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 50,
                                                                child: Text(
                                                                    filteredPatients[index]
                                                                            .appointmentType ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0)),
                                                              ),
                                                              Container(
                                                                width: 75,
                                                                child: Text(
                                                                  filteredPatients[
                                                                              index]
                                                                          .appointmentStatus ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: Column(
                                                        children: [
                                                          Spacer(),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: '• ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                              children: <
                                                                  TextSpan>[
                                                                // TextSpan(
                                                                //   text: 'Dictation' +

                                                                // ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              50, 25, 50, 45)),
                                                  Text(
                                                    "No results found for related search",
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: CustomizedColors
                                                            .noAppointment),
                                                  )
                                                ],
                                              ),
                                            );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    backgroundColor: CustomizedColors.primaryColor,
                    onPressed: () {},
                    tooltip: 'Increment',
                    child: Pop(
                      initialValue: 1,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
