import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixbook_wallpapers/screens/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixbook',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          toolbarTextStyle: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme).bodyText2, titleTextStyle: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme).headline6,
        ),
      ),
      home: Homepage(),
    );
  }
}
