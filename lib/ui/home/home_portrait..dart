import 'dart:async';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc.dart';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc_event.dart';
import 'package:YOURDRS_FlutterAPP/blocs/patient/patient_bloc_state.dart';
import 'package:YOURDRS_FlutterAPP/common/app_colors.dart';
import 'package:YOURDRS_FlutterAPP/common/app_constants.dart';
import 'package:YOURDRS_FlutterAPP/common/app_pop_menu.dart';
import 'package:YOURDRS_FlutterAPP/network/models/dictation_status.dart';
import 'package:YOURDRS_FlutterAPP/network/models/provider.dart';
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
import 'package:grouped_list/grouped_list.dart';

class HomePortrait extends StatefulWidget {
  HomePortrait({key}) : super(key: key);
  @override
  _HomePortraitState createState() => _HomePortraitState();
}

/// searching data from search bar its delay some times
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

class _HomePortraitState extends State<HomePortrait> {
  GlobalKey _key = GlobalKey();
  final _debouncer = Debouncer(milliseconds: 500);


  Map<String, dynamic> appointment;
  var _currentSelectedProviderId;
  var _currentSelectedLocationId;
  var _currentSelectedDictationId;

  /// List out data as per the  patients , filtered patients
  List<ScheduleList> patients = List();
  List<ScheduleList> filteredPatients = List();

  String startDate;
  String endDate;
  bool visibleSearchFilter = false;
  bool visibleClearFilter = true;
  String codeDialog;
  String valueText;

  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PatientBloc>(context).add(GetSchedulePatientsList(
        keyword1: null,
        providerId: null,
        locationId: null,
        dictationId: null,
        startDate: null,
        endDate: null));
  }

//filter method  for selected date

//Date Picker Controller related code
  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();

  @override
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
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Dr.sciliaris",
                style: TextStyle(
                    color: CustomizedColors.textColor,
                    fontSize: 16.0,
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
                    visibleClearFilter != false ? Icons.segment : Icons.filter,
                    color: CustomizedColors.iconColor,
                  ),
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (ctx) => ListView(
                        children: [
                          AlertDialog(
                            title: Text(
                              "Select a filter",
                              style: TextStyle(),
                            ),
                            actions: <Widget>[
                              //provider searchable Dropdown
                              ProviderDropDowns(
                                  onTapOfProviders: (newValue) {
                                    print('onTap newValue $newValue');
                                    setState(() {
                                      _currentSelectedProviderId = (newValue as ProviderList).providerId;
                                      print(
                                          'onTap _currentSelectedProviderId $_currentSelectedProviderId');
                                    },
                                    );
                                  }
                              ),

                              //Dictation Searchable Dropdown
                              DictationSearch(onTapOfDictation: ( newValue) {
                                setState(() {
                                  _currentSelectedDictationId =  (newValue as DictationStatus).dictationstatusid;

                                  print(_currentSelectedDictationId);
                                });
                              }),

                              //location searchable dropdown
                              LocationDropDown(
                                  onTapOfLocation: ( newValue) {
                                    _currentSelectedLocationId = newValue.locationId;
                                    print(_currentSelectedLocationId);

                              }),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 245,
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: CustomizedColors
                                                .homeSubtitleColor)),
                                    child: RaisedButton.icon(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        onPressed: () async { //date filter package it will show selected date
                                          final List<String> result =
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DateFilter())
                                              );
                                          //select more than one date
                                          startDate = result.first;

                                          endDate = result.last;

                                          print("range1" + startDate);

                                          print("range2" + endDate);
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
                                        icon: Icon(Icons.date_range),

                                        splashColor:
                                            CustomizedColors.primaryColor,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 245,
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: CustomizedColors
                                                .homeSubtitleColor)),
                                    child: RaisedButton.icon(
                                        padding: EdgeInsets.only(left: 25),
                                        onPressed: () {
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('Search Patients'),  // search patient alert dialog box
                                                  content: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        valueText = value;

                                                        print(valueText);
                                                      });
                                                    },
                                                    controller: this
                                                        ._textFieldController,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Search Patients"),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      color: CustomizedColors
                                                          .accentColor,
                                                      textColor: Colors.white,
                                                      child: Text('CANCEL'),
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                    ),
                                                    FlatButton(
                                                      color: CustomizedColors
                                                          .accentColor,
                                                      textColor: Colors.white,
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        setState(() {
                                                          codeDialog =
                                                              valueText;

                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        // search patients search bar
                                        label: Text(
                                          "Search Patient" ??
                                              "${this._textFieldController.text}",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: CustomizedColors
                                                .buttonTitleColor,
                                          ),
                                        ),
                                        icon: Icon(Icons.search),
                                        splashColor:
                                            CustomizedColors.primaryColor,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 245,
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: CustomizedColors
                                                .homeSubtitleColor)),
                                    child: RaisedButton.icon(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        onPressed: () {
                                          setState(() {
                                            visibleSearchFilter = false;

                                            visibleClearFilter = true;
                                          });

                                          Navigator.pop(context);

                                          BlocProvider.of<PatientBloc>(context)
                                              .add(GetSchedulePatientsList(
                                                  keyword1: null,
                                                  providerId: null,
                                                  locationId: null,
                                                  dictationId: null,
                                                  startDate: null,
                                                  endDate: null,
                                                  searchString: null));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        label: Text(
                                          'Clear Filter',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: CustomizedColors
                                                  .buttonTitleColor),
                                        ),
                                        icon: Icon(Icons.filter_alt_sharp),

                                        // textColor: Colors.red,

                                        splashColor:
                                            CustomizedColors.primaryColor,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              providerId: _currentSelectedProviderId !=
                                                      null
                                                  ? _currentSelectedProviderId
                                                  : null,
                                              locationId:
                                                  _currentSelectedLocationId !=
                                                          null
                                                      ?
                                                          _currentSelectedLocationId

                                                      : null,
                                              dictationId:
                                                  _currentSelectedDictationId !=
                                                          null
                                                      ?
                                                  int.tryParse(
                                                          _currentSelectedDictationId
                                          )
                                                      : null,
                                              startDate:
                                                  startDate !=
                                                          ""
                                                      ? startDate
                                                      : null,
                                              endDate: endDate != ""
                                                  ? endDate
                                                  : null,
                                              searchString: this
                                                          ._textFieldController
                                                          .text !=
                                                      null
                                                  ? this._textFieldController.text
                                                  : null));
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
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
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "Select a filter",
                          style: TextStyle(),
                        ),
                        actions: <Widget>[
                          ProviderDropDowns(
                              onTapOfProviders: (newValue) {
                              print('onTap newValue $newValue');
                              setState(() {
                              _currentSelectedProviderId = (newValue as ProviderList).providerId;
                              // print('onTap _currentSelectedProviderId $_currentSelectedProviderId');

                            },
                          );
                            }),

                          DictationSearch(onTapOfDictation: (newValue) {
                            setState(() {
                              _currentSelectedDictationId =  (newValue as DictationStatus).dictationstatusid;
                              print(_currentSelectedDictationId);
                            });
                          }),

                          LocationDropDown(
                              onTapOfLocation: (String newValue) {

                            _currentSelectedLocationId = newValue;
                            print(_currentSelectedLocationId);

                          }
                          ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 55,
                                width: 250,
                                child: RaisedButton.icon(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    onPressed: () {
                                      setState(() {
                                        visibleSearchFilter = false;
                                        visibleClearFilter = true;
                                      });
                                      Navigator.pop(context);
                                      BlocProvider.of<PatientBloc>(context).add(
                                          GetSchedulePatientsList(
                                              keyword1: null,
                                              providerId: null,
                                              locationId: null,
                                              dictationId: null,
                                              startDate: null,
                                              endDate: null,
                                              searchString: null
                                          ));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    label: Text(
                                      'Clear Filter',
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
                                  BlocProvider.of<PatientBloc>(context)
                                      .add(GetSchedulePatientsList(
                                    keyword1: null,
                                    providerId:
                                        _currentSelectedProviderId != null
                                            ?

                                                _currentSelectedProviderId

                                            : null,
                                    locationId:
                                        _currentSelectedLocationId != null
                                            ?

                                                _currentSelectedLocationId

                                            : null,
                                    dictationId:
                                        _currentSelectedDictationId != null
                                            ? int.tryParse(
                                                _currentSelectedDictationId)
                                            : null,
                                  ));
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
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
              top: 45,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: <Widget>[
                    PatientSerach(
                      width: 250,
                      height: 60,
                      onChanged: (string) {
                        // isSearching = true;
                        _debouncer.run(() {
                          BlocProvider.of<PatientBloc>(context)
                              .add(SearchPatientEvent(keyword: string));
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.grey[100],
                      child: DatePicker(
                        DateTime.now().subtract(Duration(days: 3)),
                        width: 45.0,
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
                          maxChildSize: .7,
                          initialChildSize: .7,
                          minChildSize: .6,
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
                                physics: BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //   "HEMA 54-DEAN (4)",
                                        //   textAlign: TextAlign.center,
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 18.0),
                                        // )
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
                                         ?
                                      // ListView.separated(
                                          //     separatorBuilder:
                                          //         (context, index) => Divider(
                                          //       color: CustomizedColors.title,
                                          //     ),
                                          //     physics:
                                          //         NeverScrollableScrollPhysics(),
                                          //     shrinkWrap: true,
                                          //     itemCount:
                                          //         filteredPatients.length,
                                          //     itemBuilder:
                                          //         (BuildContext context,
                                          //             int index) {
                                          //       return Hero(
                                          //         tag: filteredPatients[index],
                                          //         child: Material(
                                          //           child: ListTile(
                                          //             contentPadding:
                                          //                 EdgeInsets.all(0),
                                          //             leading: Icon(
                                          //               Icons.bookmark,
                                          //               color: Colors.green,
                                          //             ),
                                          //             onTap: () {
                                          //               Navigator.push(
                                          //                 context,
                                          //                 MaterialPageRoute(
                                          //                   builder: (context) =>
                                          //                       PatientDetail(),
                                          //                   // Pass the arguments as part of the RouteSettings. The
                                          //                   // DetailScreen reads the arguments from these settings.
                                          //                   settings:
                                          //                       RouteSettings(
                                          //                     arguments:
                                          //                         filteredPatients[
                                          //                             index],
                                          //                   ),
                                          //                 ),
                                          //               );
                                          //             },
                                          //             title: Text(
                                          //                 filteredPatients[
                                          //                         index]
                                          //                     .patient
                                          //                     .displayName),
                                          //             subtitle: Column(
                                          //               children: [
                                          //                 Container(
                                          //                   child: Text("Dr." +
                                          //                           "" +
                                          //                           filteredPatients[
                                          //                                   index]
                                          //                               .providerName ??
                                          //                       ""),
                                          //                 ),
                                          //                 Row(
                                          //                   children: [
                                          //                     Container(
                                          //                       width: 50,
                                          //                       child: Text(
                                          //                           filteredPatients[index]
                                          //                                   .appointmentType ??
                                          //                               "",
                                          //                           style: TextStyle(
                                          //                               fontSize:
                                          //                                   12.0)),
                                          //                     ),
                                          //                     Container(
                                          //                       width: 75,
                                          //                       child: Text(
                                          //                         filteredPatients[
                                          //                                     index]
                                          //                                 .appointmentStatus ??
                                          //                             "",
                                          //                         style: TextStyle(
                                          //                             fontSize:
                                          //                                 12.0),
                                          //                       ),
                                          //                     )
                                          //                   ],
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //             trailing: Column(
                                          //               children: [
                                          //                 Spacer(),
                                          //                 Spacer(),
                                          //                 RichText(
                                          //                   text: TextSpan(
                                          //                     text: '• ',
                                          //                     style: TextStyle(
                                          //                         color: Colors
                                          //                             .red,
                                          //                         fontSize: 14),
                                          //                     children: <
                                          //                         TextSpan>[
                                          //                       TextSpan(
                                          //                           text: 'Dictation' +
                                          //                                   filteredPatients[index].dictationStatus ??
                                          //                               ""),
                                          //                     ],
                                          //                   ),
                                          //                 )
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //   )

                                      //Grouped list view as per doctors practice location
                                      Card(
                                        child: GroupedListView<dynamic,
                                            String>(
                                            elements: filteredPatients,
                                            shrinkWrap: true,
                                            groupBy: (element) {
                                              print(
                                                  'groupBy ${element.practice}');

                                              return element.practice;
                                            },
                                            groupSeparatorBuilder: (String
                                            practice) =>
                                                TransactionGroupSeparator(
                                                  practice: practice,
                                                ),
                                            order: GroupedListOrder.ASC,
                                            itemBuilder:
                                                (context, element) =>
                                                Hero(
                                                  tag: element,
                                                  child: Material(
                                                    child: ListTile(
                                                      contentPadding:
                                                      EdgeInsets
                                                          .all(0),
                                                      leading: Icon(
                                                        Icons
                                                            .bookmark,
                                                        color: Colors
                                                            .green,
                                                      ),
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                PatientDetail(),
                                                            // Pass the arguments as part of the RouteSettings. The
                                                            // DetailScreen reads the arguments from these settings.
                                                            settings:
                                                            RouteSettings(
                                                              arguments:
                                                              element,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      title: Text(element
                                                          .patient
                                                          .displayName),
                                                      subtitle:
                                                      Column(
                                                        children: [
                                                          Container(
                                                            child: Text("Dr." +
                                                                "" +
                                                                element.providerName ??
                                                                ""),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                50,
                                                                child: Text(
                                                                    element.appointmentType ?? "",
                                                                    style: TextStyle(fontSize: 12.0)),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                Container(
                                                                  width:
                                                                  75,
                                                                  child:
                                                                  Text(
                                                                    element.appointmentStatus ?? "",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12.0),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      trailing:
                                                      Column(
                                                        children: [
                                                          Spacer(),
                                                          Spacer(),
                                                          RichText(
                                                            text:
                                                            TextSpan(
                                                              text:
                                                              '• ',
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.red,
                                                                  fontSize: 14),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: 'Dictation' + element.dictationStatus ?? ""),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )),
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
class TransactionGroupSeparator extends StatelessWidget {
  final String practice;
  TransactionGroupSeparator({this.practice});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "${this.practice}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
