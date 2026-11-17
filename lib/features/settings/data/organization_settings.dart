import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_database.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class OrganizationSettings {
  const OrganizationSettings({
    required this.organizationId,
    required this.businessName,
    required this.organizationNiu,
    required this.address,
    required this.taxEnabled,
    required this.taxRateBasisPoints,
    required this.fiscalProfileVerified,
    required this.isServerConfigured,
  });

  final String organizationId;
  final String businessName;
  final String? organizationNiu;
  final String? address;
  final bool taxEnabled;
  final int? taxRateBasisPoints;
  final bool fiscalProfileVerified;
  final bool isServerConfigured;

  factory OrganizationSettings.defaults(String organizationId) =>
      OrganizationSettings(
        organizationId: organizationId,
        businessName: '',
        organizationNiu: null,
        address: null,
        taxEnabled: false,
        taxRateBasisPoints: 1925,
        fiscalProfileVerified: false,
        isServerConfigured: false,
      );

  factory OrganizationSettings.fromMap(
    String organizationId,
    Map<String, dynamic> data, {
    bool isServerConfigured = true,
  }) =>
      OrganizationSettings(
        organizationId: organizationId,
        businessName: data['businessName'] as String? ?? '',
        organizationNiu: _optionalString(data['organizationNiu']),
        address: _optionalString(data['address']),
        taxEnabled: data['taxEnabled'] as bool? ?? false,
        taxRateBasisPoints: data['taxRateBasisPoints'] as int?,
        fiscalProfileVerified: data['fiscalProfileVerified'] as bool? ?? false,
        isServerConfigured: isServerConfigured,
      );

  Map<String, dynamic> toMap() => {
        'businessName': businessName,
        'organizationNiu': organizationNiu,
        'address': address,
        'taxEnabled': taxEnabled,
        'taxRateBasisPoints': taxRateBasisPoints,
        'fiscalProfileVerified': fiscalProfileVerified,
      };

  static String? _optionalString(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;
    return value.trim();
  }
}

final organizationSettingsProvider =
    AsyncNotifierProvider<OrganizationSettingsNotifier, OrganizationSettings>(
  OrganizationSettingsNotifier.new,
);

class OrganizationSettingsNotifier extends AsyncNotifier<OrganizationSettings> {
  @override
  Future<OrganizationSettings> build() async {
    final staff = ref.watch(authProvider).value;
    if (staff == null) {
      throw StateError('A staff session is required to load shop settings.');
    }

    final cached = await localDatabase.cachedSettings(staff.organizationId);
    final cachedSettings = cached == null
        ? null
        : OrganizationSettings.fromMap(
            staff.organizationId,
            cached,
            isServerConfigured: true,
          );
    try {
      return await _loadFromServer(staff.organizationId);
    } on Object {
      if (cachedSettings != null) return cachedSettings;
      return OrganizationSettings.defaults(staff.organizationId);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> saveTax({
    required bool enabled,
    required int? rateBasisPoints,
  }) async {
    if (enabled &&
        (rateBasisPoints == null ||
            rateBasisPoints < 0 ||
            rateBasisPoints > 10000)) {
      throw ArgumentError('The tax rate must be between 0% and 100%.');
    }
    final current = state.requireValue;
    await FirebaseFirestore.instance
        .doc('organizations/${current.organizationId}/settings/general')
        .update({
      'taxEnabled': enabled,
      'taxRateBasisPoints': rateBasisPoints,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    state = AsyncData(await _loadFromServer(current.organizationId));
  }

  Future<void> saveBusinessProfile({
    required String businessName,
    required String? niu,
    required String? address,
  }) async {
    final current = state.requireValue;
    await FirebaseFirestore.instance
        .doc('organizations/${current.organizationId}/settings/general')
        .update({
      'businessName': businessName.trim(),
      'organizationNiu': _emptyToNull(niu),
      'address': _emptyToNull(address),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    state = AsyncData(await _loadFromServer(current.organizationId));
  }

  Future<OrganizationSettings> _loadFromServer(String organizationId) async {
    final snapshot = await FirebaseFirestore.instance
        .doc('organizations/$organizationId/settings/general')
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 8));
    if (!snapshot.exists) {
      throw StateError(
          'Shop settings have not been provisioned on the server.');
    }
    final settings = OrganizationSettings.fromMap(
      organizationId,
      snapshot.data()!,
    );
    await localDatabase.cacheSettings(organizationId, settings.toMap());
    return settings;
  }

  String? _emptyToNull(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}
