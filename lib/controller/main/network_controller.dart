import 'dart:async';

import 'package:college_project/views/screens/splash_screen/error_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isConnected = true.obs;
  String? _lastRouteBeforeOffline;
  bool _isErrorScreenActive = false;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      // Initial check
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      // Listen for changes
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      Get.log('NetworkController error: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Consider connected if any connection type is available
    final isNowConnected = results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);

    if (isConnected.value != isNowConnected) {
      isConnected.value = isNowConnected;

      if (isNowConnected) {
        _handleOnlineState();
      } else {
        _handleOfflineState();
      }
    }
  }

  void _handleOfflineState() {
    // Store current route only if we're not already showing error screen
    if (!_isErrorScreenActive) {
      _lastRouteBeforeOffline = Get.currentRoute;
    }

    // Immediately show error screen if not already showing
    if (!_isErrorScreenActive && Get.currentRoute != '/error-screen') {
      _isErrorScreenActive = true;
      Get.offAll(
        () => ErrorScreen(),
        routeName: '/error-screen',
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 200),
      );
    }

    // Show persistent offline notification
    _showOfflineStatus();
  }

  void _handleOnlineState() {
    // Hide offline notification
    Get.closeAllSnackbars();

    // Return to previous screen if we were showing error screen
    if (_isErrorScreenActive && _lastRouteBeforeOffline != null) {
      _isErrorScreenActive = false;
      Get.offAllNamed(_lastRouteBeforeOffline!);
    }

    // Show brief online notification
    _showOnlineStatus();
  }

  void _showOfflineStatus() {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      message: 'No internet connection',
      backgroundColor: Colors.red[400]!,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
      isDismissible: false,
      // duration: const Duration(days: 1), // Persistent until connection returns
    );
  }

  void _showOnlineStatus() {
    Get.rawSnackbar(
      message: 'Internet connection restored',
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green[400]!,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
      return results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      Get.log('Connection check error: $e');
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
