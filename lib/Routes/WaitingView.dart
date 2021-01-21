import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class WaitingView extends StatefulWidget {
  WaitingView({Key key}) : super(key: key);

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  GetIt getIt = GetIt.I;
  User user = GetIt.I<User>();
  @override
  Widget build(BuildContext context) {
    setReady();
    Future<List<String>> waitingUsers = getWaitingUsers();
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiting Room"),
      ),
      body: Center(
        child: FutureBuilder(
          future: waitingUsers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else {
              List<String> users = snapshot.data;
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    String currentUser = users[index];
                    if (currentUser != user.userName) {
                      return ListTile(
                        leading: Text(currentUser),
                        trailing: RaisedButton(
                          onPressed: () {
                            Pair pair = Pair(user.userName, currentUser);
                            sendChallenge(pair);
                          },
                          child: Text("Challenge"),
                        ),
                      );
                    } else {
                      return ListTile(
                        leading: Text('You are in the waiting list'),
                      );
                    }
                  });
            }
          },
        ),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: "Refresh the waiting room",
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<void> setReady() async {
    HttpHelper helper = HttpHelper(user);
    final response = await helper.postRequest(
        getIt<String>() + 'user/make_ready', user.toJson());
  }

  Future<List<String>> getWaitingUsers() async {
    HttpHelper helper = HttpHelper(user);
    List<String> waitingList = List();
    Response res =
        await helper.getRequest(getIt<String>() + "user/ready", true);
    waitingList = res.data != null ? List.from(res.data) : null;
    return waitingList;
  }

  Future<void> sendChallenge(Pair pair) async {
    HttpHelper helper = HttpHelper(user);
    final res = await helper.putRequest(
        getIt<String>() + 'user/challenge', pair.toJson());
  }
}
