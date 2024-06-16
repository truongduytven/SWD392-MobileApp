import 'package:flutter/material.dart';

class Piedata {
  static List<Data> data = [
    Data(dataName: 'Đã hoàn thành', percent: 70, color: Colors.green),
    Data(dataName: 'Chưa hoàn thành', percent: 30, color: Colors.red),
  ];
}


class Data {
  final String dataName;
  
  final double percent;

  final Color color;

  Data({ required this.dataName,required this.percent,required this.color});
}