import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class FirebaseRemoteConfigServices extends GetxService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> manualOnInit() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 30),
        minimumFetchInterval: Duration(hours: 12),
      ),
    );

    await remoteConfig.setDefaults({
      "user_base_url": "https://8.215.203.97",
      "customer_cs_whatsapp": "6285167020937",
    });

    await remoteConfig.fetchAndActivate();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }
}
