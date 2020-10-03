import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';

class Submission {
  bool isRegistering;
  User user;
  Function goToUserPage;
  Function play;
  TcpHelper tcpHelper;

  Submission(this.isRegistering, this.user, this.goToUserPage, this.play,
      this.tcpHelper);
}
