import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';

class RemoteConfigProvider with ChangeNotifier {
  final RemoteConfigService _remoteConfigService;

  RemoteConfigProvider()
      : _remoteConfigService =
            RemoteConfigService(remoteConfig: FirebaseRemoteConfig.instance) {
    initialize();
  }

  bool _showDiscountedPrice = true;

  bool get showDiscountedPrice => _showDiscountedPrice;

  Future<void> initialize() async {
    await _remoteConfigService.initialize();
    _showDiscountedPrice = _remoteConfigService.showDiscountedPrice;
    notifyListeners();
  }

  Future<void> fetchRemoteConfig() async {
    await _remoteConfigService.initialize();
    _showDiscountedPrice = _remoteConfigService.showDiscountedPrice;
    notifyListeners();
  }
}
