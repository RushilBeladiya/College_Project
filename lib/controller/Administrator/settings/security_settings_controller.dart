import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsController extends GetxController {
  final LocalAuthentication _localAuth = LocalAuthentication();
  late final SharedPreferences _prefs;

  // Biometric Authentication
  RxBool isBiometricAvailable = false.obs;
  RxBool isBiometricEnabled = false.obs;
  RxString biometricMessage = "Checking biometric availability...".obs;
  RxList<BiometricType> availableBiometrics = <BiometricType>[].obs;

  // Auto-Lock
  RxBool isAutoLockEnabled = false.obs;
  RxInt autoLockTime = 1.obs;
  DateTime? _lastInteractionTime;
  Timer? _autoLockTimer;

  // Two-Factor Authentication
  RxBool isTwoFactorEnabled = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
    await _checkBiometrics();
    _setupAutoLockListener();
  }

  @override
  void onClose() {
    _autoLockTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadSettings() async {
    isBiometricEnabled.value = _prefs.getBool('biometric_enabled') ?? false;
    isAutoLockEnabled.value = _prefs.getBool('auto_lock_enabled') ?? false;
    autoLockTime.value = _prefs.getInt('auto_lock_time') ?? 1;
    isTwoFactorEnabled.value = _prefs.getBool('two_factor_enabled') ?? false;
  }

  Future<void> _checkBiometrics() async {
    try {
      isBiometricAvailable.value = await _localAuth.canCheckBiometrics &&
          await _localAuth.isDeviceSupported();

      if (isBiometricAvailable.value) {
        availableBiometrics.value = await _localAuth.getAvailableBiometrics();
        _updateBiometricMessage();
      } else {
        biometricMessage.value = "Biometric authentication not available";
      }
    } catch (e) {
      isBiometricAvailable.value = false;
      biometricMessage.value = "Error checking biometric availability";
    }
  }

  void _updateBiometricMessage() {
    final List<String> methods = [];

    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      methods.add("Fingerprint");
    }
    if (availableBiometrics.contains(BiometricType.face)) {
      methods.add("Face ID");
    }
    if (availableBiometrics.contains(BiometricType.iris)) {
      methods.add("Iris");
    }

    biometricMessage.value = methods.isNotEmpty
        ? "Available: ${methods.join(", ")}"
        : "No biometric methods available";
  }

  Future<bool> _authenticateWithBiometrics() async {
    if (!isBiometricAvailable.value) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometric login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      _handleBiometricError(e);
      return false;
    }
  }

  Future<void> toggleBiometric(bool value) async {
    if (value && await _authenticateWithBiometrics()) {
      isBiometricEnabled.value = true;
      await _prefs.setBool('biometric_enabled', true);
      biometricMessage.value = "Biometric authentication enabled";
    } else if (!value) {
      isBiometricEnabled.value = false;
      await _prefs.setBool('biometric_enabled', false);
      biometricMessage.value = "Biometric authentication disabled";
    }
  }

  Future<void> _enableBiometric() async {
    isBiometricEnabled.value = true;
    await _prefs.setBool('biometric_enabled', true);
    biometricMessage.value = "Biometric authentication enabled";
    Get.snackbar(
      'Success',
      'Biometric authentication enabled successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _disableBiometric() async {
    final bool confirmed = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Disable Biometric Authentication'),
            content:
                const Text('Are you sure you want to disable biometric login?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Disable'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      isBiometricEnabled.value = false;
      await _prefs.setBool('biometric_enabled', false);
      biometricMessage.value = "Biometric authentication disabled";
      Get.snackbar(
        'Success',
        'Biometric authentication disabled',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Future<void> toggleAutoLock(bool value) async {
    isAutoLockEnabled.value = value;
    await _prefs.setBool('auto_lock_enabled', value);

    if (value) {
      _startAutoLockTimer();
    } else {
      _autoLockTimer?.cancel();
    }
  }

  Future<void> setAutoLockTime(int minutes) async {
    autoLockTime.value = minutes;
    await _prefs.setInt('auto_lock_time', minutes);
    if (isAutoLockEnabled.value) {
      _startAutoLockTimer();
    }
  }

  void _setupAutoLockListener() {
    if (isAutoLockEnabled.value) {
      _startAutoLockTimer();
    }
  }

  void _startAutoLockTimer() {
    _autoLockTimer?.cancel();
    _lastInteractionTime = DateTime.now();
    _autoLockTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        if (DateTime.now().difference(_lastInteractionTime!) >=
            Duration(minutes: autoLockTime.value)) {
          _lockApp();
          timer.cancel();
        }
      },
    );
  }

  void _lockApp() {
    if (isBiometricEnabled.value) {
      Get.offAllNamed('/lock-screen');
    } else {
      Get.offAllNamed('/login');
    }
  }

  void updateLastInteractionTime() {
    _lastInteractionTime = DateTime.now();
    if (isAutoLockEnabled.value) {
      _startAutoLockTimer();
    }
  }

  Future<void> toggleTwoFactor(bool value) async {
    isTwoFactorEnabled.value = value;
    await _prefs.setBool('two_factor_enabled', value);
    Get.snackbar(
      'Success',
      value
          ? 'Two-factor authentication enabled'
          : 'Two-factor authentication disabled',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _handleBiometricError(dynamic error) {
    String errorMessage = "Authentication failed";
    if (error is PlatformException) {
      errorMessage = error.message ?? errorMessage;
    }
    biometricMessage.value = errorMessage;
    Get.snackbar(
      'Error',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
