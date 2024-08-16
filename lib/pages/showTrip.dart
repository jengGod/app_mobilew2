import 'dart:developer';

import 'package:test1/config/config.dart';
import 'package:test1/models/request/TripsDataGetRequest.dart';
import 'package:test1/pages/login.dart';
import 'package:test1/pages/profile.dart';
import 'package:test1/pages/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:test1/config/internal_config.dart';

// ignore: must_be_immutable
class ShowtripsPage extends StatefulWidget {
  int idx = 0;
  ShowtripsPage({super.key, required this.idx});

  @override
  State<ShowtripsPage> createState() => _ShowtripsPageState();
}

class _ShowtripsPageState extends State<ShowtripsPage> {
  List<TripsDataGetRequest> trips = [];
  //initstate here
  String url = '';

  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(idx: widget.idx)));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: SizedBox(
              height: 25,
              width: 200,
              child: Text('ปลายทาง',
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilledButton(
                    onPressed: () => getTrip(null),
                    child:
                        const Text('ทั้งหมด', style: TextStyle(fontSize: 15))),
                FilledButton(
                    onPressed: () => getTrip('เอเชีย'),
                    child:
                        const Text('เอเชีย', style: TextStyle(fontSize: 15))),
                FilledButton(
                    onPressed: () => getTrip('ยุโรป'),
                    child: const Text('ยุโรป', style: TextStyle(fontSize: 15))),
                FilledButton(
                    onPressed: () => getTrip('เอเชียตะวันออกเฉียงใต้'),
                    child:
                        const Text('อาเซียน', style: TextStyle(fontSize: 15))),
                FilledButton(
                    onPressed: () => getTrip('ประเทศไทย'),
                    child: const Text('ประเทศไทย',
                        style: TextStyle(fontSize: 15))),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: trips
                          .map((trip) => Card(
                                //child: Text(trip.name),

                                shadowColor: Colors.black,
                                child: SizedBox(
                                    width: 450,
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ประเทศ ${trip.country}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              Image.network(
                                                  // ignore: unnecessary_string_interpolations
                                                  '${trip.coverimage}',
                                                  width: 200),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15, top: 10),
                                                    child: SizedBox(
                                                        height: 140,
                                                        width: 140,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'ประเทศ${trip.country}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black)),
                                                            Text(
                                                                'ระยะเวลา ${trip.duration} วัน',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black)),
                                                            Text(
                                                                'ราคา ${trip.price} บาท',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black)),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            20),
                                                                child: FilledButton(
                                                                    onPressed: () =>
                                                                        gotoTrip(trip
                                                                            .idx),
                                                                    child: const Text(
                                                                        'รายละเอียดเพิ่มเติม',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10))))
                                                          ],
                                                        )),
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              ))
                          .toList(),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  void gotoTrip(int idx) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripPage(idx: idx)));
  }

  Future<void> loadDataAsync() async {
    //load data from api (async function)
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];

    var data = await http.get(Uri.parse('$url/trips'));
    trips = tripsDataGetRequestFromJson(data.body);
  }

  void allTrips() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));
    log(res.body);
    setState(() {
      trips = tripsDataGetRequestFromJson(res.body);
    });
    log(trips.length.toString());
  }

  void getTrip(String? zone) {
    http.get(Uri.parse('$url/trips')).then((value) {
      trips = tripsDataGetRequestFromJson(value.body);
      List<TripsDataGetRequest> filterdTrips = [];
      if (zone != null) {
        for (var trip in trips) {
          if (trip.destinationZone == zone) {
            filterdTrips.add(trip);
          }
        }
        trips = filterdTrips;
      }
      setState(() {});
    });
  }
}
