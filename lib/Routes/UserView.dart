import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/CustomWidgets/Slideable.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:application/Routes/SettingsView.dart';
import 'package:application/Routes/WaitingView.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  Future<List<String>> challengers;
  GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();
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
                        Pair pair = new Pair(user.userName, current);
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
        getIt<String>() + 'user/not_ready', user.toJson());
  }

  Future<List<String>> getWaiting() async {
    HttpHelper helper = getIt<HttpHelper>();
    List<String> waitingList = List();
    Response res = await helper.getRequest(
        getIt<String>() + "user/challenges?name=" + getIt<User>().userName,
        true);
    //waitingList = jsonDecode(res.data);
    waitingList = res.data != null ? List.from(res.data) : null;
    return waitingList;
  }

  void updatePage() {
    setState(() {});
  }
}
