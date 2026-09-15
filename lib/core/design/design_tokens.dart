import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color brandSeed    = Color(0xFF00A651);
  static const Color success      = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning      = Color(0xFFF57F17);
  static const Color warningLight = Color(0xFFFFFDE7);
  static const Color info         = Color(0xFF01579B);
  static const Color infoLight    = Color(0xFFE1F5FE);
  static const Color mtnYellow     = Color(0xFFFFCC00);
  static const Color mtnYellowDark = Color(0xFFCC9900);
  static const Color orangeOrange  = Color(0xFFFF6600);

  static ColorScheme lightScheme() => ColorScheme.fromSeed(
    seedColor: brandSeed,
    brightness: Brightness.light,
  );

  static ColorScheme darkScheme() => ColorScheme.fromSeed(
    seedColor: brandSeed,
    brightness: Brightness.dark,
  );
}

class AppSpacing {
  AppSpacing._();
  static const double xxs = 2;
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
  static const double buttonHeight = 48;
  static const double inputHeight  = 56;
}

class AppRadius {
  AppRadius._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double full = 9999;

  static BorderRadius card   = BorderRadius.circular(sm);
  static BorderRadius input  = BorderRadius.circular(sm);
  static BorderRadius button = BorderRadius.circular(full);
  static BorderRadius badge  = BorderRadius.circular(xs);
}

class AppTypography {
  AppTypography._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 57, fontWeight: FontWeight.w400, height: 1.12,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w400, height: 1.25,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w400, height: 1.29,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w400, height: 1.27,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.50,
    letterSpacing: 0.15,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.43,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.50,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.43,
    letterSpacing: 0.25,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.33,
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.43,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, height: 1.33,
    letterSpacing: 0.50,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500, height: 1.45,
    letterSpacing: 0.50,
  );

  static const TextStyle buttonLabel   = labelLarge;
  static const TextStyle priceDisplay  = headlineMedium;
  static const TextStyle caption       = bodySmall;
}

class AppElevation {
  AppElevation._();
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark()  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colors = brightness == Brightness.light
        ? AppColors.lightScheme()
        : AppColors.darkScheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      textTheme: const TextTheme(
        displayLarge:   AppTypography.displayLarge,
        headlineLarge:  AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge:     AppTypography.titleLarge,
        titleMedium:    AppTypography.titleMedium,
        titleSmall:     AppTypography.titleSmall,
        bodyLarge:      AppTypography.bodyLarge,
        bodyMedium:     AppTypography.bodyMedium,
        bodySmall:      AppTypography.bodySmall,
        labelLarge:     AppTypography.labelLarge,
        labelMedium:    AppTypography.labelMedium,
        labelSmall:     AppTypography.labelSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: AppRadius.input),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: AppElevation.level1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(88, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.buttonLabel,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(height: 72),
    );
  }
}
