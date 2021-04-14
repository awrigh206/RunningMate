import 'dart:math';
import 'package:application/DTO/OpponentUpdateDto.dart';
import 'package:application/DTO/UpdateDto.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Helpers/LocationHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_sound/flutter_sound.dart';

class ActiveLogic {
  GetIt getIt = GetIt.I;
  LocationHelper locationHelper = new LocationHelper();
  double totalDistanceTravelled = 0.0;
  Future<LocationData> currentPosition;
  Future<LocationData> lastPosition;
  FlutterSound sound = FlutterSound();
  bool isPlaying = false;
  final Pair pair;
  ActiveLogic(this.pair);

  void soundWhenClose(double opponentDistance) async {
    double difference = totalDistanceTravelled - opponentDistance;
    if (difference.isNegative) {
      //You are behind the opponent
      if (difference > -0.1) {
        await playSound();
      }
    } else {
      if (difference < 0.1) {
        await playSound();
      }
    }
  }

  Future<void> playSound() async {
    final fileName = 'Assets/Sounds/steps.mp3';
    if (!isPlaying) {
      await sound.startPlayer(fileName);
    } else {
      return;
    }
  }

  void buzzWhenClose(double opponentDistance) async {
    double difference = totalDistanceTravelled - opponentDistance;
    if (difference.isNegative) {
      //You are behind the opponent
      if (difference > -0.1) {
        vibrate();
      }
    } else {
      if (difference < 0.1) {
        vibrate();
      }
    }
  }

  void vibrate() async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.vibrate(duration: 1000);
    } else {
      Vibration.vibrate();
    }
  }

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
    double distanceTravelled =
        calculateDistance(await lastPosition, await currentPosition);
    UpdateDto updateDto = UpdateDto(pair, distanceTravelled, 0.0, 2.0);
    totalDistanceTravelled = totalDistanceTravelled + distanceTravelled;
    httpHelper.putRequest(getIt<String>() + 'run/update', updateDto.toJson());
  }

  Future<OpponentUpdateDto> getOppponentData(Pair pair) async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res = await httpHelper.putRequest(
        getIt<String>() + 'run/opponent', pair.toJson());
    OpponentUpdateDto update = OpponentUpdateDto.fromJson(res.data);
    return update;
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
