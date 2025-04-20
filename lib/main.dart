import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'services/services.dart' as services;
import 'package:window_manager/window_manager.dart';
import 'screens/home_screen.dart' as home;

/// The current position of the device. 
Position? currentPosition;
String? longLat;

/// Units for temperature
String unit = "F";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(300, 300),
    center: true,
    title: 'Weather Bud',
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
    alwaysOnTop: true,
  );
  
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
 
 
 
    await windowManager.setAlignment(
      Alignment.bottomRight,
      animate: true,
    );
    windowManager.setResizable(false);
  });
  
  longLat = await services.getCurrentPosition();
  //home.HomeScreenState().currentLocationWeather();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Bud',
      home: const home.HomeScreen(title: 'Weather Bud Home'),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // r - hot reload
        // R - hot restart
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}