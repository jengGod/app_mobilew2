import 'dart:developer';

import 'package:test1/models/response/trip_idx_res.dart';
import 'package:flutter/material.dart';
import 'package:test1/config/config.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TripPage extends StatefulWidget {
  //Attribute of tripage
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() =>  TripPageState();
}


class  TripPageState extends State <TripPage> {
  String url = '';
  late TripGetResponse trip;
  late Future<void> loadData;
  

  @override
  void initState() {
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loadData, 
        builder: (context,snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(trip.name,style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15 , top: 15 ,left: 15),
                  child: Text(trip.country),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Image.network(trip.coverimage),
                ),
                Row(
                  //ลองหาวิธีอื่นที่ดีกว่านี้
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('ราคา ${trip.price} บาท'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 110),
                      child: Text(trip.destinationZone),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(trip.detail),
                ),
                Center(
                  child: FilledButton(
                    onPressed: () {},
                    child:  const Text('จองทริปนี้'),
                  )
                )
              ],
            ),
          );
        }
        ),

    );
  }

  Future<void> loadDataAsync() async{
    //load data from api (async function)
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];

    var data = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(data.body);
    trip = tripGetResponseFromJson(data.body);
  }
}