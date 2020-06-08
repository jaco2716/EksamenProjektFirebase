import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  List<dynamic> location;
  bool paid;
  List<dynamic> type;
  Timestamp time;

  Reservation(this.location, this.paid, this.time, this.type);

  Reservation.fromJson(Map<String, dynamic> json)
      : location = json['location'],
        paid = json['paid'],
        time = json['time'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'location': location,
        'paid': paid,
        'time': time,
        'type': type,
      };
}
