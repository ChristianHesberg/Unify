import 'models/appUser.dart';

class MatchState {
  static String lastDoc = ':lastDoc';
  static List<AppUser> peopleList = [];
  static int index = 0;

  static void clearState() {
    lastDoc = ':lastDoc';
    peopleList = [];
    index = 0;
  }
}
