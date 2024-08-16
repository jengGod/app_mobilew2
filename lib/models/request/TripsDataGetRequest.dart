// To parse this JSON data, do
//
//     final tripsDataGetRequest = tripsDataGetRequestFromJson(jsonString);

import 'dart:convert';

List<TripsDataGetRequest> tripsDataGetRequestFromJson(String str) => List<TripsDataGetRequest>.from(json.decode(str).map((x) => TripsDataGetRequest.fromJson(x)));

String tripsDataGetRequestToJson(List<TripsDataGetRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsDataGetRequest {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripsDataGetRequest({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripsDataGetRequest.fromJson(Map<String, dynamic> json) => TripsDataGetRequest(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}