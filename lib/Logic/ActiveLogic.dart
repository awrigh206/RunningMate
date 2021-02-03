import 'dart:math';
import 'package:application/DTO/UpdateDto.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Helpers/LocationHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

class ActiveLogic {
  GetIt getIt = GetIt.I;
  LocationHelper locationHelper = new LocationHelper();
  Future<LocationData> currentPosition;
  Future<LocationData> lastPosition;
  final Pair pair;

  ActiveLogic(this.pair);

  Future<void> beginRun() async {
    currentPosition = locationHelper.getLocationBasic();
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res =
        await httpHelper.postRequest(getIt<String>() + 'run', pair.toJson());
    final second = await httpHelper.getRequest(
        getIt<String>() + 'run?name=' + getIt<User>().userName, true);
  }

  Future<void> sendData() async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    //Code in this function body is run every two seconds
    lastPosition = currentPosition;
    currentPosition = locationHelper.getLocationBasic();
    UpdateDto updateDto = UpdateDto(pair,
        calculateDistance(await lastPosition, await currentPosition), 0.0, 2.0);
    httpHelper.putRequest(getIt<String>() + 'run/update', updateDto.toJson());
  }

  //calculate difference between two points using the haversine formula
  double calculateDistance(LocationData previous, LocationData current) {
    int radius = 6371; //radius of the earth in km
    var dlat = convertToRadian(current.latitude - previous.latitude);
    var dlon = convertToRadian(current.longitude - previous.longitude);

    var a = sin(dlat / 2) * sin(dlat / 2) +
        cos(convertToRadian(previous.latitude)) *
            cos(convertToRadian(current.latitude)) *
            sin(dlon / 2) *
            sin(dlon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = radius * c;
    return distance;
  }

  double convertToRadian(double deg) {
    return deg * (pi / 180);
  }

  Future<bool> isOpponentReady() async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res = await httpHelper.getRequest(
        getIt<String>() + 'run/challenger?name=' + pair.involvedUsers.last,
        true);
    return res.data;
  }

  Future<void> setWaiting(String name) async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res =
        await httpHelper.getRequest(getIt<String>() + 'run?name=' + name, true);
  }
}
