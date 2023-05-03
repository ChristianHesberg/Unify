import 'package:firebase_core/firebase_core.dart';
import 'package:unify/match_service.dart';

import 'firebase_options.dart';

main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MatchService service = MatchService();
  service.writeLocation();
  service.getUsersWithinRadius(50);
}