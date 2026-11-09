class RegistrationCountryInfo {
  final String countryName;
  final String countryCode;
  final String currencyCode;
  final String phoneCode;
  final String defaultRegistrationLabel;

  const RegistrationCountryInfo({
    required this.countryName,
    required this.countryCode,
    required this.currencyCode,
    required this.phoneCode,
    required this.defaultRegistrationLabel,
  });
}

const List<RegistrationCountryInfo> mboaPosCountries = [
  RegistrationCountryInfo(
    countryName: 'Cameroon',
    countryCode: 'CM',
    currencyCode: 'XAF',
    phoneCode: '+237',
    defaultRegistrationLabel: 'NIU',
  ),
  RegistrationCountryInfo(
    countryName: 'Nigeria',
    countryCode: 'NG',
    currencyCode: 'NGN',
    phoneCode: '+234',
    defaultRegistrationLabel: 'TIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Kenya',
    countryCode: 'KE',
    currencyCode: 'KES',
    phoneCode: '+254',
    defaultRegistrationLabel: 'KRA PIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Ghana',
    countryCode: 'GH',
    currencyCode: 'GHS',
    phoneCode: '+233',
    defaultRegistrationLabel: 'TIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Uganda',
    countryCode: 'UG',
    currencyCode: 'UGX',
    phoneCode: '+256',
    defaultRegistrationLabel: 'TIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Tanzania',
    countryCode: 'TZ',
    currencyCode: 'TZS',
    phoneCode: '+255',
    defaultRegistrationLabel: 'TIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Rwanda',
    countryCode: 'RW',
    currencyCode: 'RWF',
    phoneCode: '+250',
    defaultRegistrationLabel: 'TIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Senegal',
    countryCode: 'SN',
    currencyCode: 'XOF',
    phoneCode: '+221',
    defaultRegistrationLabel: 'NINEA',
  ),
  RegistrationCountryInfo(
    countryName: 'Côte d’Ivoire',
    countryCode: 'CI',
    currencyCode: 'XOF',
    phoneCode: '+225',
    defaultRegistrationLabel: 'NIF',
  ),
  RegistrationCountryInfo(
    countryName: 'South Africa',
    countryCode: 'ZA',
    currencyCode: 'ZAR',
    phoneCode: '+27',
    defaultRegistrationLabel: 'VAT Number',
  ),
  RegistrationCountryInfo(
    countryName: 'France',
    countryCode: 'FR',
    currencyCode: 'EUR',
    phoneCode: '+33',
    defaultRegistrationLabel: 'SIRET / VAT',
  ),
  RegistrationCountryInfo(
    countryName: 'United States',
    countryCode: 'US',
    currencyCode: 'USD',
    phoneCode: '+1',
    defaultRegistrationLabel: 'EIN',
  ),
  RegistrationCountryInfo(
    countryName: 'United Kingdom',
    countryCode: 'GB',
    currencyCode: 'GBP',
    phoneCode: '+44',
    defaultRegistrationLabel: 'UTR / VAT',
  ),
  RegistrationCountryInfo(
    countryName: 'Germany',
    countryCode: 'DE',
    currencyCode: 'EUR',
    phoneCode: '+49',
    defaultRegistrationLabel: 'VAT ID',
  ),
  RegistrationCountryInfo(
    countryName: 'Spain',
    countryCode: 'ES',
    currencyCode: 'EUR',
    phoneCode: '+34',
    defaultRegistrationLabel: 'CIF / VAT',
  ),
  RegistrationCountryInfo(
    countryName: 'Italy',
    countryCode: 'IT',
    currencyCode: 'EUR',
    phoneCode: '+39',
    defaultRegistrationLabel: 'VAT ID',
  ),
  RegistrationCountryInfo(
    countryName: 'Belgium',
    countryCode: 'BE',
    currencyCode: 'EUR',
    phoneCode: '+32',
    defaultRegistrationLabel: 'VAT Number',
  ),
  RegistrationCountryInfo(
    countryName: 'Netherlands',
    countryCode: 'NL',
    currencyCode: 'EUR',
    phoneCode: '+31',
    defaultRegistrationLabel: 'VAT Number',
  ),
  RegistrationCountryInfo(
    countryName: 'Portugal',
    countryCode: 'PT',
    currencyCode: 'EUR',
    phoneCode: '+351',
    defaultRegistrationLabel: 'NIF',
  ),
  RegistrationCountryInfo(
    countryName: 'Morocco',
    countryCode: 'MA',
    currencyCode: 'MAD',
    phoneCode: '+212',
    defaultRegistrationLabel: 'ICE / Tax ID',
  ),
  RegistrationCountryInfo(
    countryName: 'Algeria',
    countryCode: 'DZ',
    currencyCode: 'DZD',
    phoneCode: '+213',
    defaultRegistrationLabel: 'NIF',
  ),
  RegistrationCountryInfo(
    countryName: 'Tunisia',
    countryCode: 'TN',
    currencyCode: 'TND',
    phoneCode: '+216',
    defaultRegistrationLabel: 'Tax ID',
  ),
  RegistrationCountryInfo(
    countryName: 'Egypt',
    countryCode: 'EG',
    currencyCode: 'EGP',
    phoneCode: '+20',
    defaultRegistrationLabel: 'Tax ID',
  ),
  RegistrationCountryInfo(
    countryName: 'Saudi Arabia',
    countryCode: 'SA',
    currencyCode: 'SAR',
    phoneCode: '+966',
    defaultRegistrationLabel: 'CR / VAT',
  ),
  RegistrationCountryInfo(
    countryName: 'United Arab Emirates',
    countryCode: 'AE',
    currencyCode: 'AED',
    phoneCode: '+971',
    defaultRegistrationLabel: 'TRN',
  ),
  RegistrationCountryInfo(
    countryName: 'India',
    countryCode: 'IN',
    currencyCode: 'INR',
    phoneCode: '+91',
    defaultRegistrationLabel: 'GSTIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Australia',
    countryCode: 'AU',
    currencyCode: 'AUD',
    phoneCode: '+61',
    defaultRegistrationLabel: 'ABN / ACN',
  ),
  RegistrationCountryInfo(
    countryName: 'Brazil',
    countryCode: 'BR',
    currencyCode: 'BRL',
    phoneCode: '+55',
    defaultRegistrationLabel: 'CNPJ / CPF',
  ),
  RegistrationCountryInfo(
    countryName: 'Mexico',
    countryCode: 'MX',
    currencyCode: 'MXN',
    phoneCode: '+52',
    defaultRegistrationLabel: 'RFC',
  ),
  RegistrationCountryInfo(
    countryName: 'Argentina',
    countryCode: 'AR',
    currencyCode: 'ARS',
    phoneCode: '+54',
    defaultRegistrationLabel: 'CUIT',
  ),
  RegistrationCountryInfo(
    countryName: 'Colombia',
    countryCode: 'CO',
    currencyCode: 'COP',
    phoneCode: '+57',
    defaultRegistrationLabel: 'NIT',
  ),
  RegistrationCountryInfo(
    countryName: 'Peru',
    countryCode: 'PE',
    currencyCode: 'PEN',
    phoneCode: '+51',
    defaultRegistrationLabel: 'RUC',
  ),
  RegistrationCountryInfo(
    countryName: 'Singapore',
    countryCode: 'SG',
    currencyCode: 'SGD',
    phoneCode: '+65',
    defaultRegistrationLabel: 'UEN',
  ),
  RegistrationCountryInfo(
    countryName: 'Malaysia',
    countryCode: 'MY',
    currencyCode: 'MYR',
    phoneCode: '+60',
    defaultRegistrationLabel: 'SSM / Tax ID',
  ),
  RegistrationCountryInfo(
    countryName: 'Indonesia',
    countryCode: 'ID',
    currencyCode: 'IDR',
    phoneCode: '+62',
    defaultRegistrationLabel: 'NPWP',
  ),
  RegistrationCountryInfo(
    countryName: 'Philippines',
    countryCode: 'PH',
    currencyCode: 'PHP',
    phoneCode: '+63',
    defaultRegistrationLabel: 'TIN',
  ),
  RegistrationCountryInfo(
    countryName: 'Thailand',
    countryCode: 'TH',
    currencyCode: 'THB',
    phoneCode: '+66',
    defaultRegistrationLabel: 'VAT Number',
  ),
  RegistrationCountryInfo(
    countryName: 'Vietnam',
    countryCode: 'VN',
    currencyCode: 'VND',
    phoneCode: '+84',
    defaultRegistrationLabel: 'MST',
  ),
];

class MboaPosRegistrationForm {
  final String businessName;
  final String countryCode;
  final String currencyCode;
  final String phoneCode;
  final String phoneNumber;
  final String businessEmail;
  final String taxRegistrationNumber;
  final String registrationLabel;
  final String addressLine1;
  final String city;
  final String state;
  final String postalCode;
  final String? website;
  final bool acceptsTerms;
  final bool acceptsPrivacyPolicy;

  const MboaPosRegistrationForm({
    required this.businessName,
    required this.countryCode,
    required this.currencyCode,
    required this.phoneCode,
    required this.phoneNumber,
    required this.businessEmail,
    required this.taxRegistrationNumber,
    required this.registrationLabel,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.postalCode,
    this.website,
    required this.acceptsTerms,
    required this.acceptsPrivacyPolicy,
  });

  MboaPosRegistrationForm copyWith({
    String? businessName,
    String? countryCode,
    String? currencyCode,
    String? phoneCode,
    String? phoneNumber,
    String? businessEmail,
    String? taxRegistrationNumber,
    String? registrationLabel,
    String? addressLine1,
    String? city,
    String? state,
    String? postalCode,
    String? website,
    bool? acceptsTerms,
    bool? acceptsPrivacyPolicy,
  }) {
    return MboaPosRegistrationForm(
      businessName: businessName ?? this.businessName,
      countryCode: countryCode ?? this.countryCode,
      currencyCode: currencyCode ?? this.currencyCode,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessEmail: businessEmail ?? this.businessEmail,
      taxRegistrationNumber:
          taxRegistrationNumber ?? this.taxRegistrationNumber,
      registrationLabel: registrationLabel ?? this.registrationLabel,
      addressLine1: addressLine1 ?? this.addressLine1,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      website: website ?? this.website,
      acceptsTerms: acceptsTerms ?? this.acceptsTerms,
      acceptsPrivacyPolicy: acceptsPrivacyPolicy ?? this.acceptsPrivacyPolicy,
    );
  }

  static MboaPosRegistrationForm empty() {
    return const MboaPosRegistrationForm(
      businessName: '',
      countryCode: '',
      currencyCode: '',
      phoneCode: '',
      phoneNumber: '',
      businessEmail: '',
      taxRegistrationNumber: '',
      registrationLabel: '',
      addressLine1: '',
      city: '',
      state: '',
      postalCode: '',
      website: null,
      acceptsTerms: false,
      acceptsPrivacyPolicy: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
      'phoneCode': phoneCode,
      'phoneNumber': phoneNumber,
      'businessEmail': businessEmail,
      'taxRegistrationNumber': taxRegistrationNumber,
      'registrationLabel': registrationLabel,
      'addressLine1': addressLine1,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'website': website,
      'acceptsTerms': acceptsTerms,
      'acceptsPrivacyPolicy': acceptsPrivacyPolicy,
    };
  }
}

class RegistrationValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const RegistrationValidationResult({
    required this.isValid,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;

  factory RegistrationValidationResult.valid() {
    return const RegistrationValidationResult(
      isValid: true,
      errors: {},
    );
  }
}

class RegistrationValidator {
  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );

  static final RegExp phoneDigitsOnly = RegExp(r'^[0-9]+$');

  static RegistrationValidationResult validate(MboaPosRegistrationForm form) {
    final errors = <String, String>{};

    if (form.businessName.trim().length < 2) {
      errors['businessName'] = 'Business name is required.';
    } else if (form.businessName.trim().length > 120) {
      errors['businessName'] = 'Business name is too long.';
    }

    if (form.countryCode.trim().isEmpty) {
      errors['countryCode'] = 'Please select a country.';
    }

    if (form.currencyCode.trim().isEmpty) {
      errors['currencyCode'] = 'Please select a currency.';
    }

    if (form.phoneCode.trim().isEmpty) {
      errors['phoneCode'] = 'Phone country code is required.';
    } else if (!form.phoneCode.startsWith('+')) {
      errors['phoneCode'] = 'Phone code must start with +.';
    }

    if (form.phoneNumber.trim().isEmpty) {
      errors['phoneNumber'] = 'Phone number is required.';
    } else {
      final normalisedPhoneNumber = form.phoneNumber.replaceAll(
        RegExp(r'[\s\-\(\)]'),
        '',
      );
      if (!phoneDigitsOnly.hasMatch(normalisedPhoneNumber)) {
        errors['phoneNumber'] = 'Phone number must contain digits only.';
      } else if (normalisedPhoneNumber.length < 6 ||
          normalisedPhoneNumber.length > 15) {
        errors['phoneNumber'] = 'Phone number length is invalid.';
      }
    }

    if (form.businessEmail.trim().isEmpty) {
      errors['businessEmail'] = 'Business email is required.';
    } else if (!emailRegex.hasMatch(form.businessEmail.trim())) {
      errors['businessEmail'] = 'Enter a valid email address.';
    }

    if (form.taxRegistrationNumber.trim().isEmpty) {
      errors['taxRegistrationNumber'] =
          'Tax or registration number is required.';
    } else if (form.taxRegistrationNumber.trim().length < 4 ||
        form.taxRegistrationNumber.trim().length > 50) {
      errors['taxRegistrationNumber'] =
          'Tax or registration number is invalid.';
    }

    if (form.registrationLabel.trim().isEmpty) {
      errors['registrationLabel'] = 'Registration type is required.';
    }

    if (form.addressLine1.trim().length < 5) {
      errors['addressLine1'] = 'Address line 1 is required.';
    }

    if (form.city.trim().length < 2) {
      errors['city'] = 'City is required.';
    }

    if (form.state.trim().length < 2) {
      errors['state'] = 'State/Province is required.';
    }

    if (form.postalCode.trim().isEmpty) {
      errors['postalCode'] = 'Postal code is required.';
    }

    if (!form.acceptsTerms) {
      errors['acceptsTerms'] = 'You must accept the terms and conditions.';
    }

    if (!form.acceptsPrivacyPolicy) {
      errors['acceptsPrivacyPolicy'] =
          'You must accept the privacy policy to continue.';
    }

    if (form.countryCode == 'CM') {
      final registrationType = form.registrationLabel.trim().toUpperCase();
      if (registrationType != 'NIU') {
        errors['registrationLabel'] =
            'For Cameroon, the registration type should be NIU.';
      }

      final niuValue = form.taxRegistrationNumber.trim();
      if (niuValue.isNotEmpty && niuValue.length < 6) {
        errors['taxRegistrationNumber'] =
            'Cameroon NIU looks too short. Check the number.';
      }
    }

    return RegistrationValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
