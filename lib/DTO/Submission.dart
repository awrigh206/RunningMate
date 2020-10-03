import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';

class Submission {
  bool isRegistering;
  User user;
  TcpHelper tcpHelper;

  Submission(this.isRegistering, this.user, this.tcpHelper);
}
