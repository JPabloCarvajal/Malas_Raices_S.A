import 'package:flutter/foundation.dart';

//  REEMPLAZA por la IP de TU PC (ipconfig en PowerShell)
const String _tuIpLocal = '192.168.1.12';

const String _physicalDeviceBaseUrl = 'http://$_tuIpLocal:8000';
const String _emulatorBaseUrl = 'http://10.0.2.2:8000';
const String _desktopBaseUrl = 'http://127.0.0.1:8000';

final String kBaseUrl = defaultTargetPlatform == TargetPlatform.android
    ? _physicalDeviceBaseUrl // cámbialo a _emulatorBaseUrl si vuelves al emulador
    : _desktopBaseUrl;

const int kTimeoutSeconds = 30;
const String kTokenKey = 'auth_token';
const String kUsuarioKey = 'usuario_actual';
const String kBiometricEnabledKey = 'biometric_enabled';
