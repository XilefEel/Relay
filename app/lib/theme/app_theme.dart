import 'package:flutter/material.dart';

class AppTheme {
  static const seedColor = Color(0xFF7F77DD);

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'GeistMono',
      scaffoldBackgroundColor: scheme.surface,
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}

class StatColors {
  static const cpu = Color(0xFF7F77DD);
  static const cpuOn = Color(0xFF26215C);

  static const ram = Color(0xFF5DCAA5);
  static const ramOn = Color(0xFF04342C);

  static const gpu = Color(0xFFF0997B);
  static const gpuOn = Color(0xFF4A1B0C);

  static const actionFills = [
    Color(0xFF7F77DD),
    Color(0xFF5DCAA5),
    Color(0xFFF0997B),
    Color(0xFFED93B1),
    Color(0xFF378ADD),
    Color(0xFFEF9F27),
  ];

  static const actionOnFills = [
    Color(0xFF26215C),
    Color(0xFF04342C),
    Color(0xFF4A1B0C),
    Color(0xFF4B1528),
    Color(0xFF042C53),
    Color(0xFF412402),
  ];
}

class BlobRadius {
  static const topLeft = BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(28),
    bottomLeft: Radius.circular(28),
    bottomRight: Radius.circular(8),
  );

  static const topRight = BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(28),
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(28),
  );

  static const bottomLeft = BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(8),
    bottomLeft: Radius.circular(28),
    bottomRight: Radius.circular(28),
  );

  static const bottomRight = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(28),
    bottomLeft: Radius.circular(28),
    bottomRight: Radius.circular(28),
  );

  static const pill = BorderRadius.all(Radius.circular(999));

  static const cycle = [topLeft, topRight, bottomRight, bottomLeft, pill];
}
