import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/constance/style.dart';
import 'provider_setup.dart';
import 'ui/shared/navigation/navigation.dart';
import 'ui/shared/navigation/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Red Cat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primaryColor,
          textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          iconTheme: const IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: primaryColor,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
          ),
        ),
        initialRoute: Navigation.instance.initialRoute,
        navigatorKey: Navigation.instance.navigatorKey,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

