//Authors: Alexander Okrucký (xokruc00)

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarTasksPage extends StatefulWidget {
  const CalendarTasksPage({super.key});

  @override
  State<CalendarTasksPage> createState() => _WeekTasksPage();
}

class _WeekTasksPage extends State<CalendarTasksPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "152393665335-pnvkvg510fudheejggp66niaecfh8210.apps.googleusercontent.com",
    scopes: <String>[
      "https://www.googleapis.com/auth/calendar",
    ],
  );

  DateTime lastDoneDate = DateTime.now();
  String formatedLastDoneDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

  void onSelectionDateChanged(DateRangePickerSelectionChangedArgs arguments) {
    setState(() {
      lastDoneDate = arguments.value;
      formatedLastDoneDate = DateFormat('dd.MM.yyyy').format(arguments.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SfDateRangePicker(
            showNavigationArrow: true,
            todayHighlightColor: Colors.deepPurple[400],
            selectionColor: Colors.deepPurple[400],
            onSelectionChanged: onSelectionDateChanged,
            selectionMode: DateRangePickerSelectionMode.single,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Events:", style: TextStyle(fontSize: 30)),
              )
            ],
          ),
          FutureBuilder(
              future: getEventsForSpecificDay(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<GoogleAPI.Event> events = snapshot.data!;
                  if(events.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Text("No events for this day", style: TextStyle(fontSize: 25)),
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return eventWidget(events[index]);
                      },
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
          )
        ]
      ),
    );
  }

  Widget eventWidget(GoogleAPI.Event event) {
    bool day = false;
    String s = "";
    String e = "";

    if(event.summary == null) {
      return Container();
    }

    if(event.start != null) {
      if(event.start!.dateTime != null) {
        DateTime etmp = event.start!.dateTime!;
        DateTime ds = DateTime(etmp.year, etmp.month, etmp.day, etmp.hour + 1, etmp.minute);
        s = DateFormat("HH:mm").format(ds);
      } else {
        day = true;
        DateTime etmp = event.start!.date!;
        DateTime ds = DateTime(etmp.year, etmp.month, etmp.day, etmp.hour + 1, etmp.minute);
        s = DateFormat("HH:mm").format(ds);
      }
      if(event.end!.dateTime != null) {
        DateTime stmp = event.end!.dateTime!;
        DateTime de = DateTime(stmp.year, stmp.month, stmp.day, stmp.hour + 1, stmp.minute);
        e = DateFormat("HH:mm").format(de);
      } else {
        day = true;
        DateTime stmp = event.end!.date!;
        DateTime de = DateTime(stmp.year, stmp.month, stmp.day, stmp.hour + 1, stmp.minute);
        e = DateFormat("HH:mm").format(de);
      }


    } else {
      day = true;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: SizedBox(
        height: 100,
        child: Column(
          children: [
            Row(
              children: [
                //CircleAvatar(backgroundColor: ,),
                Text(event.summary!)
              ],
            ),
            Row(
              children: [
                (day) ? Text("All day long") : Text("${s} - $e"),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    if(_googleSignIn.currentUser != null) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }

    super.dispose();
  }

  Future<List<GoogleAPI.Event>> getEventsForSpecificDay() async {
    List<GoogleAPI.Event> events = [];
    await _googleSignIn.signIn();
    final headers = await _googleSignIn.currentUser!.authHeaders;
    final httpClient = GoogleAPIClient(headers);
    final GoogleAPI.CalendarApi calendarAPI = GoogleAPI.CalendarApi(httpClient);

    var calEvents = await calendarAPI.events.list("primary", timeMin: lastDoneDate.toUtc());
    events = calEvents.items!;
    return events;
  }

}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}