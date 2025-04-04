import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:weather_bud/model/weather_model.dart';
import 'package:weather_bud/main.dart' as main;
import 'package:weather_bud/credentials.dart' as creds;
import 'package:geolocator/geolocator.dart';

class WeatherServices {
  String link = "https://api.openweathermap.org/data/2.5/weather?lon=${main.currentPosition?.longitude}&lat=${main.currentPosition?.latitude}&appid=${creds.openWeatherKey}&units=imperial";
  fetchWeather() async {
    print(link);
    final response = await http.get(
      Uri.parse(
        // Mamadou Memo: The tutorial I was following hard coded in the location, had the api key in the link and instead of having the api return in chosen units, converted
        // between units manually. I will not be doing that.
        link,
      ),
    );
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

/// I wanted to be able to get the current position whenever I wanted so I moved it here.
Future<String> getCurrentPosition() async {
  bool locationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationEnabled) {
    return "Location Service Disabled";
  } 

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    log("Permission denied. Requesting Permission");
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return "Permission still denied.";
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () => Geolocator.openAppSettings(),
    );
    return "Permission denied forever";
  }
  final position = await Geolocator.getCurrentPosition();
  main.currentPosition = position;
  return "${position.latitude} / ${position.longitude}";
}
