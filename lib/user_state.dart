import 'models/appUser.dart';

class UserState {
  static AppUser? user;
  static bool userInit = false;

  static void clearState() {
    user = null;
    userInit = false;
  }
}
