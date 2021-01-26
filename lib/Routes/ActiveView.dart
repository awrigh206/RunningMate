import 'dart:async';
import 'package:application/Logic/ActiveLogic.dart';
import 'package:application/Models/Pair.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  ActiveLogic logic;

  @override
  void initState() {
    logic = ActiveLogic(widget.currentPair);
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
        await logic.sendData();
      }
      setState(() {});
    });
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
                    trailing: Text(this.widget.currentPair.issuingUser),
                  ),
                  ListTile(
                    title: Text('Player Two: '),
                    trailing: Text(this.widget.currentPair.challengedUser),
                  )
                ],
              ));
            } else {
              return new Text('Waiting for your opponent');
            }
          } else {
            return new CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
