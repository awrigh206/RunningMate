import 'dart:async';
import 'package:application/DTO/OpponentUpdateDto.dart';
import 'package:application/DTO/UpdateDto.dart';
import 'package:application/Logic/ActiveLogic.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class ActiveView extends StatefulWidget {
  ActiveView({Key key, @required this.currentPair}) : super(key: key);
  final Pair currentPair;
  @override
  _ActiveViewState createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {
  Timer timer;
  GetIt getIt = GetIt.I;
  Future<bool> otherUserReady;
  Future<OpponentUpdateDto> opponentProgress;
  ActiveLogic logic;
  Future<LottieComposition> composition;
  AnimationController loginAnimation;
  Lottie animation;

  @override
  void initState() {
    logic = ActiveLogic(widget.currentPair);
    composition = fetchAnimation();
    start();
    super.initState();
  }

  Future<void> start() async {
    await logic.beginRun();
    const duration = const Duration(seconds: 2);
    timer = Timer.periodic(duration, (timer) async {
      otherUserReady = logic.isOpponentReady();
      bool ready = await otherUserReady;
      if (ready) {
        opponentProgress = logic.getOppponentData(widget.currentPair);
        await logic.sendData();
      }
      setState(() {});
    });
  }

  Future<LottieComposition> fetchAnimation() async {
    var assetData =
        await rootBundle.load('Assets/Animations/222-trail-loading.json');
    return await LottieComposition.fromByteData(assetData);
  }

  @override
  void dispose() {
    //Stop/ get  rid of timer when view  is popped
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Go!"),
      ),
      body: FutureBuilder(
        future: otherUserReady,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('There has been an error');
          }
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Center(
                  child: ListView(
                children: [
                  ListTile(
                    title: Text('Player One: '),
                    trailing: Text(getIt<User>().userName),
                  ),
                  ListTile(
                    title: Text('Player Two: '),
                    trailing: Text(
                        this.widget.currentPair.involvedUsers.elementAt(1)),
                  ),
                  FutureBuilder(
                    future: opponentProgress,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        OpponentUpdateDto update = snapshot.data;
                        return ListTile(
                            title: Text('Opponent has covered: ' +
                                update.distance.roundToDouble().toString() +
                                'KM'));
                      }
                      if (snapshot.hasError) {
                        return ListTile(
                          title: Text(
                              'There has been an issue in getting updated data from your opponent'),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  ListTile(
                    title: Text('You have gone for: ' +
                        logic.totalDistanceTravelled
                            .roundToDouble()
                            .toString() +
                        'KM'),
                  )
                ],
              ));
            } else {
              return Center(
                child: Column(
                  children: [
                    new Text('Waiting for your opponent'),
                    new FutureBuilder(
                        future: composition,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              child: Lottie(composition: snapshot.data),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ],
                ),
              );
            }
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
