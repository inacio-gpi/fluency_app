import 'package:fluency_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('should have correct primary color', () {
      expect(AppTheme.primaryColor, const Color(0xFF6C63FF));
    });

    test('should have correct secondary color', () {
      expect(AppTheme.secondaryColor, const Color(0xFFFF6584));
    });

    test('should have correct accent color', () {
      expect(AppTheme.accentColor, const Color(0xFF4CAF50));
    });

    test('should have correct background color', () {
      expect(AppTheme.backgroundColor, const Color(0xFFF8F9FE));
    });

    test('should have correct text colors', () {
      expect(AppTheme.textPrimaryColor, const Color(0xFF2D3142));
      expect(AppTheme.textSecondaryColor, const Color(0xFF9E9E9E));
    });

    test('should have correct status colors', () {
      expect(AppTheme.successColor, const Color(0xFF4CAF50));
      expect(AppTheme.errorColor, const Color(0xFFE53935));
      expect(AppTheme.warningColor, const Color(0xFFFFA726));
      expect(AppTheme.lockedColor, const Color(0xFFBDBDBD));
    });

    group('ThemeData', () {
      test('should have correct color scheme', () {
        final theme = AppTheme.lightTheme;
        expect(theme.colorScheme.primary, AppTheme.primaryColor);
        expect(theme.scaffoldBackgroundColor, AppTheme.backgroundColor);
      });

      test('should have correct text theme', () {
        final theme = AppTheme.lightTheme;
        expect(theme.textTheme.displayLarge?.color, AppTheme.textPrimaryColor);
        expect(theme.textTheme.bodyLarge?.color, AppTheme.textPrimaryColor);
        expect(theme.textTheme.bodySmall?.color, AppTheme.textSecondaryColor);
      });

      test('should have custom card theme', () {
        final theme = AppTheme.lightTheme;
        expect(theme.cardTheme.elevation, 2);
        expect(theme.cardTheme.color, AppTheme.cardColor);
      });

      test('should have custom app bar theme', () {
        final theme = AppTheme.lightTheme;
        expect(theme.appBarTheme.backgroundColor, Colors.transparent);
        expect(theme.appBarTheme.elevation, 0);
      });

      test('should use Material 3', () {
        final theme = AppTheme.lightTheme;
        expect(theme.useMaterial3, true);
      });

      test('should have custom elevated button theme', () {
        final theme = AppTheme.lightTheme;
        expect(
          theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          AppTheme.primaryColor,
        );
      });
    });
  });
}
