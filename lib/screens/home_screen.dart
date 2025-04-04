import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_bud/main.dart' as main;
import 'package:weather_bud/model/weather_model.dart';
import 'package:weather_bud/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = 'No Location Available';

  update() {
    setState(() {});
  }

// potentially pull this into services.dart so that it can just be done automatically
  late WeatherData weatherInfo;
  currentLocationWeather(){
    WeatherServices().fetchWeather().then((value){
      setState(() {
        weatherInfo = value;
        print("Weather info Weather ${weatherInfo.maxTemperature}");
      });
    });
  }

  @override
  void initState() {
    currentLocationWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Your current location is: ${main.longLat.toString()}");
    return Scaffold(
      backgroundColor:Color(0xFF5C7AFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF0CC),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            WeatherDetail(weather: weatherInfo)
          ]
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  const WeatherDetail({super.key,required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
        Text(
          "${weather.temperature.current.toStringAsFixed(0)}°${main.unit}",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
        Text(
          weather.weather[0].main,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}