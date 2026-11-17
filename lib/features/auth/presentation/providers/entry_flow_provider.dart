import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _startupStorageTimeout = Duration(seconds: 15);

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
  Future<bool> build() async =>
      await _storage
          .read(key: _welcomeCompletedKey)
          .timeout(_startupStorageTimeout) ==
      'true';

  Future<void> completeWelcome() async {
    await _storage
        .write(key: _welcomeCompletedKey, value: 'true')
        .timeout(_startupStorageTimeout);
    state = const AsyncData(true);
  }
}
