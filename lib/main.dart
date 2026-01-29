import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // routes: routes,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadNeutralColorScheme.light(
          custom: {
            // Feedback
            'success': const Color(0xFF00A63E), // Custom override
            'successForeground': const Color(0xFFFFFFFF),
            'warning': const Color(0xFFE17100), // Custom override
            'warningForeground': const Color(0xFFFFFFFF),
            'info': const Color(0xFF0084D1), // Custom override
            'infoForeground': const Color(0xFFFFFFFF),

            // Days of Week
            'sunday': const Color(0xFFD32F2F),
            'sundayForeground': const Color(0xFFFFFFFF),
            'monday': const Color(0xFFFAB405),
            'mondayForeground': const Color(0xFF09090B),
            'tuesday': const Color(0xFFEB3370),
            'tuesdayForeground': const Color(0xFFFFFFFF),
            'wednesday': const Color(0xFF388E3C),
            'wednesdayForeground': const Color(0xFFFFFFFF),
            'thursday': const Color(0xFFDB4D00),
            'thursdayForeground': const Color(0xFFFFFFFF),
            'friday': const Color(0xFF1976D2),
            'fridayForeground': const Color(0xFFFFFFFF),
            'saturday': const Color(0xFF7B1FA2),
            'saturdayForeground': const Color(0xFFFFFFFF),

            // Extra Colors
            'blue': const Color(0xFF2170E4),
            'blueForeground': const Color(0xFFFFFFFF),
            'orange': const Color(0xFFF59E0B),
            'orangeForeground': const Color(0xFFFFFFFF),
            'gray': const Color(0xFF5F6368),
            'grayForeground': const Color(0xFFFFFFFF),
            'purple': const Color(0xFF8455EF),
            'purpleForeground': const Color(0xFFFFFFFF),
            'green': const Color(0xFF10B981),
            'greenForeground': const Color(0xFFFFFFFF),
          },
        ),
        textTheme: ShadTextTheme(
          family: 'Google Sans',
          custom: {
            'large24': const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.none,
              fontFamily: 'Google Sans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              height: 24 / 18,
              letterSpacing: 0,
            ),
            'medium': TextStyle(
              fontSize: 16,
              decoration: TextDecoration.none,
              fontFamily: 'Google Sans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              letterSpacing: 0,
            ),
          },
        ),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadZincColorScheme.dark(
          custom: {
            // Feedback
            'success': const Color(0xFF00A63E),
            'successForeground': const Color(0xFFFFFFFF),
            'warning': const Color(0xFFE17100),
            'warningForeground': const Color(0xFFFFFFFF),
            'info': const Color(0xFF0084D1),
            'infoForeground': const Color(0xFFFFFFFF),

            // Days of Week
            'sunday': const Color(0xFFD32F2F),
            'sundayForeground': const Color(0xFF690005),
            'monday': const Color(0xFFFBC02D),
            'mondayForeground': const Color(0xFF261900),
            'tuesday': const Color(0xFFEB3370),
            'tuesdayForeground': const Color(0xFF31111D),
            'wednesday': const Color(0xFF388E3C),
            'wednesdayForeground': const Color(0xFF002204),
            'thursday': const Color(0xFFDB4D00),
            'thursdayForeground': const Color(0xFF341100),
            'friday': const Color(0xFF2485E5),
            'fridayForeground': const Color(0xFF003063),
            'saturday': const Color(0xFFAA3AD9),
            'saturdayForeground': const Color(0xFF320045),

            // Extra Colors
            'blue': const Color(0xFF2170E4),
            'blueForeground': const Color(0xFFFFFFFF),
            'orange': const Color(0xFFF59E0B),
            'orangeForeground': const Color(0xFFFFFFFF),
            'gray': const Color(0xFF5F6368),
            'grayForeground': const Color(0xFFFFFFFF),
            'purple': const Color(0xFF8455EF),
            'purpleForeground': const Color(0xFFFFFFFF),
            'green': const Color(0xFF10B981),
            'greenForeground': const Color(0xFFFFFFFF),
          },
        ),
        textTheme: ShadTextTheme(
          family: 'Google Sans',
          custom: {
            'large24': const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.none,
              fontFamily: 'Google Sans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              height: 24 / 18,
              letterSpacing: 0,
            ),
            'medium': TextStyle(
              fontSize: 16,
              decoration: TextDecoration.none,
              fontFamily: 'Google Sans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              letterSpacing: 0,
            ),
          },
        ),
      ),
      home: const MyHomePage(),
      // builder: (context, child) {
      //   return Directionality(textDirection: directionality, child: child!);
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.background,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.foreground,
                ),
                Container(width: 20, height: 20, color: theme.colorScheme.card),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.cardForeground,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.popover,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.popoverForeground,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.primary,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.primaryForeground,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.secondary,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.secondaryForeground,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.muted,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.mutedForeground,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.accent,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.accentForeground,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.destructive,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.destructiveForeground,
                ),

                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.border,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.input,
                ),
                Container(width: 20, height: 20, color: theme.colorScheme.ring),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.selection,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['success'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['successForeground'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['info'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['infoForeground'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['warning'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['warningForeground'],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sunday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['sunday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['sundayForeground'],
                ),

                // Monday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['monday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['mondayForeground'],
                ),

                // Tuesday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['tuesday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['tuesdayForeground'],
                ),

                // Wednesday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['wednesday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['wednesdayForeground'],
                ),

                // Thursday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['thursday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['thursdayForeground'],
                ),

                // Friday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['friday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['fridayForeground'],
                ),

                // Saturday
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['saturday'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['saturdayForeground'],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Blue
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['blue'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['blueForeground'],
                ),

                // Orange
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['orange'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['orangeForeground'],
                ),

                // Gray
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['gray'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['grayForeground'],
                ),

                // Purple
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['purple'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['purpleForeground'],
                ),

                // Green
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['green'],
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: theme.colorScheme.custom['greenForeground'],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('สวัสดี', style: theme.textTheme.h1Large),
                Text('สวัสดี', style: theme.textTheme.h1),
                Text('สวัสดี', style: theme.textTheme.h2),
                Text('สวัสดี', style: theme.textTheme.h3),
                Text('สวัสดี', style: theme.textTheme.h4),
                Text('สวัสดี', style: theme.textTheme.p),
                Text('สวัสดี', style: theme.textTheme.blockquote),
                Text('สวัสดี', style: theme.textTheme.table),
                Text('สวัสดี', style: theme.textTheme.list),
                Text('สวัสดี', style: theme.textTheme.lead),
                Text('สวัสดี', style: theme.textTheme.large),
                Text('สวัสดี', style: theme.textTheme.custom['large24']!),
                Text('สวัสดี', style: theme.textTheme.custom['medium']!),
                Text('สวัสดี', style: theme.textTheme.small),
                Text('สวัสดี', style: theme.textTheme.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
