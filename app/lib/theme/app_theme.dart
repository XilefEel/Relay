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

class StatColorsLight {
  static const cpu = Color(0xFFCECBF6);
  static const cpuOn = Color(0xFF3C3489);

  static const ram = Color(0xFF9FE1CB);
  static const ramOn = Color(0xFF085041);

  static const gpu = Color(0xFFF5C4B3);
  static const gpuOn = Color(0xFF712B13);

  static const actionFills = [
    Color(0xFFCECBF6),
    Color(0xFF9FE1CB),
    Color(0xFFF5C4B3),
    Color(0xFFF4C0D1),
    Color(0xFFB5D4F4),
    Color(0xFFFAC775),
  ];

  static const actionOnFills = [
    Color(0xFF3C3489),
    Color(0xFF085041),
    Color(0xFF712B13),
    Color(0xFF72243E),
    Color(0xFF0C447C),
    Color(0xFF854F0B),
  ];
}

class StatColorsDark {
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

class StatColors {
  final Color cpu, cpuOn, ram, ramOn, gpu, gpuOn;
  final List<Color> actionFills, actionOnFills;

  const StatColors._({
    required this.cpu,
    required this.cpuOn,
    required this.ram,
    required this.ramOn,
    required this.gpu,
    required this.gpuOn,
    required this.actionFills,
    required this.actionOnFills,
  });

  static const _light = StatColors._(
    cpu: StatColorsLight.cpu,
    cpuOn: StatColorsLight.cpuOn,
    ram: StatColorsLight.ram,
    ramOn: StatColorsLight.ramOn,
    gpu: StatColorsLight.gpu,
    gpuOn: StatColorsLight.gpuOn,
    actionFills: StatColorsLight.actionFills,
    actionOnFills: StatColorsLight.actionOnFills,
  );

  static const _dark = StatColors._(
    cpu: StatColorsDark.cpu,
    cpuOn: StatColorsDark.cpuOn,
    ram: StatColorsDark.ram,
    ramOn: StatColorsDark.ramOn,
    gpu: StatColorsDark.gpu,
    gpuOn: StatColorsDark.gpuOn,
    actionFills: StatColorsDark.actionFills,
    actionOnFills: StatColorsDark.actionOnFills,
  );

  static StatColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _dark : _light;
  }
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
