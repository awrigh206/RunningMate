import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:application/Routes/ActiveView.dart';
import 'package:application/Routes/MessageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';

class Slideable extends StatelessWidget {
  Slideable({Key key, @required this.pair, @required this.updatePage})
      : super(key: key);
  final Pair pair;
  final Function updatePage;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text("Challenged by: " + pair.involvedUsers.last),
          leading: CircleAvatar(
            backgroundColor: Colors.purpleAccent,
          ),
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Accept',
          color: Colors.greenAccent,
          icon: Icons.check,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActiveView(currentPair: pair)),
            ).then((value) => notReadyToRun());
          },
        ),
        IconSlideAction(
          caption: 'Decline',
          color: Colors.redAccent,
          icon: Icons.remove_circle,
          onTap: () {
            declineChallenge();
            updatePage();
          },
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Message',
          icon: Icons.message,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MessageView(
                          pair: pair,
                        )));
          },
        )
      ],
    );
  }

  Future<void> notReadyToRun() async {
    final res = await GetIt.I<HttpHelper>().putRequest(
        GetIt.I<String>() + 'user/run/no', GetIt.I<User>().toJson());
  }

  Future<void> declineChallenge() async {
    GetIt getIt = GetIt.I;
    final res = await getIt<HttpHelper>()
        .putRequest(getIt<String>() + 'user/challenges/remove', pair.toJson());
  }
}
