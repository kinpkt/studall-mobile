import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'text_theme.dart';
import 'material_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Sarabun", "Google Sans");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MyHomePage(),
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
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('สวัสดี', style: Theme.of(context).textTheme.displayLarge),
                Text('สวัสดี', style: Theme.of(context).textTheme.displayMedium),
                Text('สวัสดี', style: Theme.of(context).textTheme.displaySmall),
                Text('สวัสดี', style: Theme.of(context).textTheme.headlineLarge),
                Text('สวัสดี', style: Theme.of(context).textTheme.headlineMedium),
                Text('สวัสดี', style: Theme.of(context).textTheme.headlineSmall),
                Text('สวัสดี', style: Theme.of(context).textTheme.titleLarge),
                Text('สวัสดี', style: Theme.of(context).textTheme.titleMedium),
                Text('สวัสดี', style: Theme.of(context).textTheme.titleSmall),
                Text('สวัสดี', style: Theme.of(context).textTheme.bodyLarge),
                Text('สวัสดี', style: Theme.of(context).textTheme.bodyMedium),
                Text('สวัสดี', style: Theme.of(context).textTheme.bodySmall),
                Text('สวัสดี', style: Theme.of(context).textTheme.labelLarge),
                Text('สวัสดี', style: Theme.of(context).textTheme.labelMedium),
                Text('สวัสดี', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
