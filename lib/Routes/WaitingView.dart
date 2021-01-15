import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WaitingView extends StatefulWidget {
  WaitingView({Key key, @required this.myUser}) : super(key: key);
  final User myUser;
  final TcpHelper tcp = TcpHelper();

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  final TcpHelper tcp = TcpHelper();

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
                    return ListTile(
                      leading: Text(currentUser),
                      trailing: RaisedButton(
                        onPressed: () {
                          User myUser = this.widget.myUser;
                          //code to start a run  goes here
                          // Pair pair = Pair(myUser, currentUser);
                          // Payload payload = new Payload(pair.toJson(), 'pair');
                          // tcp.sendPayload(payload);
                        },
                        child: Text("Challenge"),
                      ),
                    );
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
    HttpHelper helper = HttpHelper(this.widget.myUser);
    final response = await helper.postRequest(
        'https://192.168.0.45:9090/user/make_ready',
        this.widget.myUser.toJson());
  }

  Future<List<String>> getWaitingUsers() async {
    HttpHelper helper = HttpHelper(this.widget.myUser);
    List<String> waitingList = List();
    Response res = await helper.getRequest(
        'https://192.168.0.45:9090' + "/user/ready", true);
    waitingList = res.data != null ? List.from(res.data) : null;
    return waitingList;
  }
}
