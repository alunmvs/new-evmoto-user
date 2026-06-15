import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);
  await testMain();
}
