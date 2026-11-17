import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _startupStorageTimeout = Duration(seconds: 4);

final entryLocaleProvider =
    NotifierProvider<EntryLocaleNotifier, Locale>(EntryLocaleNotifier.new);

class EntryLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('fr');

  void setLocale(Locale locale) {
    if (locale.languageCode == 'fr' || locale.languageCode == 'en') {
      state = locale;
    }
  }
}

final firstRunWelcomeProvider =
    AsyncNotifierProvider<FirstRunWelcomeNotifier, bool>(
  FirstRunWelcomeNotifier.new,
);

class FirstRunWelcomeNotifier extends AsyncNotifier<bool> {
  static const _welcomeCompletedKey = 'mboapos.welcome_completed';
  static const _storage = FlutterSecureStorage();

  @override
  Future<bool> build() async {
    _logStartup('Secure-storage welcome read started');
    try {
      final value = await _storage
          .read(key: _welcomeCompletedKey)
          .timeout(_startupStorageTimeout);
      _logStartup('Secure-storage welcome read completed');
      return value == 'true';
    } on Object catch (error, stackTrace) {
      developer.log(
        'Secure-storage welcome read failed',
        name: 'mboapos.startup',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void _logStartup(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'mboapos.startup');
      debugPrint('[mboapos.startup] $message');
    }
  }

  Future<void> completeWelcome() async {
    await _storage
        .write(key: _welcomeCompletedKey, value: 'true')
        .timeout(_startupStorageTimeout);
    state = const AsyncData(true);
  }
}
