import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_sizes.dart';

/// کلاس مدیریت تم‌های اپلیکیشن
class AppThemes {
  // تم روشن (Light Theme)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // رنگ‌های اصلی
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryRed,
      brightness: Brightness.light,
    ),

    // رنگ اصلی اپ
    primaryColor: AppColors.primaryRed,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // تم AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundWhite,
      foregroundColor: AppColors.textPrimary,
      elevation: AppSizes.elevationNone,
      centerTitle: true,
      titleTextStyle: AppTextStyles.appBarTitle,
      iconTheme: IconThemeData(
        color: AppColors.iconPrimary,
        size: AppSizes.iconL,
      ),
    ),

    // تم کارت‌ها
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: AppSizes.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      margin: const EdgeInsets.all(AppSizes.marginS),
    ),

    // تم دکمه‌های elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.textWhite,
        elevation: AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXL,
          vertical: AppSizes.paddingM,
        ),
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),

    // تم دکمه‌های outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryRed,
        side: const BorderSide(
          color: AppColors.primaryRed,
          width: AppSizes.borderThin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXL,
          vertical: AppSizes.paddingM,
        ),
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),

    // تم دکمه‌های متنی
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryRed,
        textStyle: AppTextStyles.buttonMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingS,
        ),
      ),
    ),

    // تم فیلدهای ورودی
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.cardBorder,
          width: AppSizes.borderThin,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.cardBorder,
          width: AppSizes.borderThin,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.primaryRed,
          width: AppSizes.borderMedium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.textError,
          width: AppSizes.borderThin,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
      labelStyle: AppTextStyles.labelMedium,
    ),

    // تم سوییچ‌ها
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.switchActiveThumb;
        }
        return AppColors.switchInactiveThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.switchActiveTrack;
        }
        return AppColors.switchInactiveTrack;
      }),
    ),

    // تم آیکون‌ها
    iconTheme: const IconThemeData(
      color: AppColors.iconPrimary,
      size: AppSizes.iconL,
    ),

    // تم متن‌ها
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.titleLarge,
      displayMedium: AppTextStyles.titleMedium,
      displaySmall: AppTextStyles.titleSmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleMedium,
      titleMedium: AppTextStyles.titleSmall,
      titleSmall: AppTextStyles.labelLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // تم Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.textWhite,
      elevation: AppSizes.elevationHigh,
      shape: CircleBorder(),
    ),

    // تم Drawer
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.backgroundLight,
      elevation: AppSizes.elevationHigh,
      width: AppSizes.drawerWidth,
    ),

    // تم Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder,
      thickness: AppSizes.borderThin,
      space: AppSizes.spaceM,
    ),
  );

  // تم تاریک (Dark Theme)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // رنگ‌های اصلی
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryRed,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
    ),

    primaryColor: AppColors.primaryRed,
    scaffoldBackgroundColor: AppColors.darkBackground,

    // تم AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: AppSizes.elevationNone,
      centerTitle: true,
      titleTextStyle: AppTextStyles.appBarTitle,
      iconTheme: IconThemeData(
        color: AppColors.darkIconPrimary,
        size: AppSizes.iconL,
      ),
    ),

    // تم کارت‌ها
    cardTheme: CardThemeData(
      color: AppColors.darkCardBackground,
      elevation: AppSizes.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      margin: const EdgeInsets.all(AppSizes.marginS),
    ),

    // تم دکمه‌های elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.textWhite,
        elevation: AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXL,
          vertical: AppSizes.paddingM,
        ),
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),

    // تم دکمه‌های outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryRed,
        side: const BorderSide(
          color: AppColors.primaryRed,
          width: AppSizes.borderThin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXL,
          vertical: AppSizes.paddingM,
        ),
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),

    // تم دکمه‌های متنی
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryRed,
        textStyle: AppTextStyles.buttonMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingS,
        ),
      ),
    ),

    // تم فیلدهای ورودی
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.darkBorder,
          width: AppSizes.borderThin,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.darkBorder,
          width: AppSizes.borderThin,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.primaryRed,
          width: AppSizes.borderMedium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(
          color: AppColors.textError,
          width: AppSizes.borderThin,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextLight,
      ),
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    ),

    // تم سوییچ‌ها
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.switchActiveThumb;
        }
        return AppColors.switchInactiveThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.switchActiveTrack;
        }
        return AppColors.switchInactiveTrack;
      }),
    ),

    // تم آیکون‌ها
    iconTheme: const IconThemeData(
      color: AppColors.darkIconPrimary,
      size: AppSizes.iconL,
    ),

    // تم متن‌ها
    textTheme: TextTheme(
      displayLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      displayMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      displaySmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleLarge: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleMedium: AppTextStyles.titleSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleSmall: AppTextStyles.labelLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.darkTextLight,
      ),
    ),

    // تم Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.textWhite,
      elevation: AppSizes.elevationHigh,
      shape: CircleBorder(),
    ),

    // تم Drawer
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.darkDrawerBackground,
      elevation: AppSizes.elevationHigh,
      width: AppSizes.drawerWidth,
    ),

    // تم Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: AppSizes.borderThin,
      space: AppSizes.spaceM,
    ),
  );
}
