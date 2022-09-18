//flutter run -d chrome --web-renderer html

import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shelly_controller/utils/api_calls.dart';
import 'dart:convert';

class TimeSeriesModel extends ChangeNotifier {
  var data = {};

  init() async {
    data = await getPowerData();
    data['prodSerieSum'] = sumSeries(data['prodSeries']);
    data['consSerieSum'] = sumSeries(data['consSeries']);
    notifyListeners();
  }

  getData() {
    return data;
  }

  toFlSpots(List list, int interval) {
    List<FlSpot> spots = [];
    for (var i = 0; i < list.length; i += interval) {
      spots.add(FlSpot(list[i][0], list[i][1] ?? 0));
    }

    return spots;
  }

//Get the whole timestamp list
  getTimestamp(items) async {
    var timestamps = [];

    for (var item in items) {
      String url =
          'https://www.smard.de/app/chart_data/$item/DE/index_quarterhour.json';
      var response = await fetchGet(url);
      timestamps.add(jsonDecode(response.body)['timestamps'].last);
    }

    timestamps.sort();
    return timestamps[0];
  }

//Retrive the whole time series and trim the end null values
  getTimeSeries(items, timeStamp) async {
    var timeSeries = [];
    var index = [];
    for (var item in items) {
      String url =
          'https://www.smard.de/app/chart_data/$item/DE/${item}_DE_quarterhour_$timeStamp.json';
      var response = await fetchGet(url);
      var timeSerie = jsonDecode(response.body)['series'];
      for (var i = timeSerie.length - 1; i > 0; i--) {
        if (timeSerie[i][1] != null) {
          index.add(i);
          break;
        }
      }
      timeSeries.add(timeSerie);
    }
    index.sort();

    var timeSeriesClean = [];
    for (var timeSerie in timeSeries) {
      timeSeriesClean.add(timeSerie.sublist(0, index[0]));
    }
    return timeSeriesClean;
  }

  getPowerData() async {
    var itemsGen = [
      1223,
      1224,
      1225,
      1226,
      1227,
      1228,
      4066,
      4067,
      4068,
      4069,
      4070,
      4071
    ];

    var itemsCons = [410];

    var items = [...itemsGen, ...itemsCons];
    int timeStamp = await getTimestamp(items);
    var timeSeries = await getTimeSeries(items, timeStamp);

    return {
      "prodSeries": timeSeries.sublist(0, 11),
      "consSeries": [timeSeries[12]]
    };
  }
}

//Sum all the series
sumSeries(timeSeries) {
  var timeSerie = timeSeries[0];
  for (var i = 1; i < timeSeries.length; i++) {
    for (var j = 0; j < timeSerie.length; j++) {
      timeSerie[j][1] = (timeSerie[j][1] ?? 0) + (timeSeries[i][j][1] ?? 0);
    }
  }

  return timeSerie;
}
