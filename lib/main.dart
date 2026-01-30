import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}


// // Test Home Page to showcase Shadcn UI theme colors and text styles
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = ShadTheme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.background,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.foreground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.card,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.cardForeground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.popover,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.popoverForeground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.primary,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.primaryForeground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.secondary,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.secondaryForeground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.muted,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.mutedForeground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.accent,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.accentForeground,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.destructive,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.destructiveForeground,
//                     ),

//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.border,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.input,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.ring,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.selection,
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['success'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['successForeground'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['info'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['infoForeground'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['warning'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['warningForeground'],
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Sunday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['sunday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['sundayForeground'],
//                     ),

//                     // Monday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['monday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['mondayForeground'],
//                     ),

//                     // Tuesday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['tuesday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['tuesdayForeground'],
//                     ),

//                     // Wednesday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['wednesday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['wednesdayForeground'],
//                     ),

//                     // Thursday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['thursday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['thursdayForeground'],
//                     ),

//                     // Friday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['friday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['fridayForeground'],
//                     ),

//                     // Saturday
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['saturday'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['saturdayForeground'],
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Blue
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['blue'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['blueForeground'],
//                     ),

//                     // Orange
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['orange'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['orangeForeground'],
//                     ),

//                     // Gray
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['gray'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['grayForeground'],
//                     ),

//                     // Purple
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['purple'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['purpleForeground'],
//                     ),

//                     // Green
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['green'],
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.custom['greenForeground'],
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.daily,
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       color: theme.colorScheme.dailyForeground,
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('สวัสดี', style: theme.textTheme.h1Large),
//                     Text('สวัสดี', style: theme.textTheme.h1),
//                     Text('สวัสดี', style: theme.textTheme.h2),
//                     Text('สวัสดี', style: theme.textTheme.h3),
//                     Text('สวัสดี', style: theme.textTheme.h4),
//                     Text('สวัสดี', style: theme.textTheme.p),
//                     Text('สวัสดี', style: theme.textTheme.blockquote),
//                     Text('สวัสดี', style: theme.textTheme.table),
//                     Text('สวัสดี', style: theme.textTheme.list),
//                     Text('สวัสดี', style: theme.textTheme.lead),
//                     Text('สวัสดี', style: theme.textTheme.large),
//                     Text('สวัสดี', style: theme.textTheme.custom['large24']!),
//                     Text('สวัสดี', style: theme.textTheme.custom['medium']!),
//                     Text('สวัสดี', style: theme.textTheme.small),
//                     Text('สวัสดี', style: theme.textTheme.custom['xsmall']!),
//                     Text('สวัสดี', style: theme.textTheme.muted),
//                   ],
//                 ),
//               ],
//             ),
//             ThemeSettings(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ThemeSettings extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text("Light"),
//           onTap: () => ref.read(themeModeProvider.notifier).setLight(),
//         ),
//         ListTile(
//           title: Text("Dark"),
//           onTap: () => ref.read(themeModeProvider.notifier).setDark(),
//         ),
//         ListTile(
//           title: Text("System"),
//           onTap: () => ref.read(themeModeProvider.notifier).setSystem(),
//         ),
//       ],
//     );
//   }
// }
