import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/CustomWidgets/Slideable.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/StringPair.dart';
import 'package:application/Models/User.dart';
import 'package:application/Routes/SettingsView.dart';
import 'package:application/Routes/WaitingView.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);
  //final User currentUser;

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  TcpHelper tcpHelper;
  Future<List<String>> challengers;

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
  }

  Future<List<String>> getWaiting() async {
    HttpHelper helper = GetIt.instance<HttpHelper>();
    List<String> waitingList = List();
    Response res = await helper.getRequest(
        'https://192.168.0.45:9090' + "/user/ready", true);
    //waitingList = jsonDecode(res.data);
    waitingList = res.data != null ? List.from(res.data) : null;
    return waitingList;
  }

  Future<String> getServer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("server");
  }

  @override
  Widget build(BuildContext context) {
    challengers = getWaiting();
    User user = GetIt.instance<User>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            ListTile(
                title: Text(user.userName),
                subtitle: Text(user.email),
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.blue[500],
                )),
            FutureBuilder<dynamic>(
                future: challengers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return new ListTile(
                      title: Text('Checking for challenges'),
                      trailing: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return new ListTile(
                      title: Text('There has been an error'),
                      subtitle: Text('Please try again later'),
                      trailing: Icon(Icons.error),
                    );
                  }
                  List<String> challangers = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: challangers.length,
                      primary: false,
                      itemBuilder: (context, index) {
                        String current = challangers[index];
                        //Pair pair = new Pair(this.widget.currentUser, current);
                        StringPair pair =
                            new StringPair(user.userName, current);
                        return new Slideable(
                            pair: pair, updatePage: updatePage);
                      });
                }),
            ListTile(
              title: Text('Run against another user'),
              subtitle: Text("Go for a run it's lots of fun"),
              leading: Icon(Icons.directions_run),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingView()),
                ).then((value) => setNotWaiting(user));
              },
              onLongPress: () {},
            ),
            ListTile(
              title: Text('Cycle against another user'),
              subtitle: Text('Good luck!'),
              leading: Icon(Icons.directions_bike),
            ),
            ListTile(
              title: Text('Change account details'),
              subtitle: Text('Quick and painless'),
              leading: Icon(Icons.account_box),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsView()));
              },
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: "Refresh the page",
        child: Icon(Icons.refresh),
      ),
      drawer: SideDrawer(),
    );
  }

  Future<void> setNotWaiting(User user) async {
    HttpHelper helper = GetIt.instance<HttpHelper>();
    final response = await helper.postRequest(
        'https://192.168.0.45:9090/user/not_ready', user.toJson());
  }

  void updatePage() {
    setState(() {});
  }
}
