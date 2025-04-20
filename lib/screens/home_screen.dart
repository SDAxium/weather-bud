import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
  // potentially pull this into services.dart so that it can just be done automatically
  late WeatherData? weatherInfo;
  bool _isLoading = true;

  currentLocationWeather() async {
    // WeatherServices().fetchWeather().then((value){
    //   setState(() {
    //     weatherInfo = value;
    //   });
    // });

    setState(() {
      _isLoading = true;
      weatherInfo = null;
    });

    String locationResult = await getCurrentPosition();
    if(main.currentPosition != null) {
      final weatherData = await WeatherServices().fetchWeather();

      setState(() {
        _isLoading = false;
        weatherInfo = weatherData;
      });
    }
  }

  @override
  void initState() {
    weatherInfo = WeatherData(name: 'Unknown', temperature: Temperature(current: 0.0), humidity: 0, wind: Wind(speed: 0.0), maxTemperature: 0.0, minTemperature: 0.0, pressure: 0, seaLevel: 0, weather: []);
    currentLocationWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE MMMM dd, yyyy').format(DateTime.now());
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 92, 168, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF0CC),
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading 
        ? const CircularProgressIndicator() 
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            WeatherDetail(weather: weatherInfo, formattedDate: formattedDate)
          ]
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData? weather;
  final String formattedDate;
  const WeatherDetail({super.key,required this.weather, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather!.name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
        Text(
          "${weather!.temperature.current.toStringAsFixed(0)}°${main.unit}",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
        if(weather!.weather.isNotEmpty)
        Text(
          weather!.weather[0].main,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
             fontWeight: FontWeight.bold)
        ),
        // Text(
        //   formattedTime,
        //   style: TextStyle(
        //     fontSize: 10,
        //     color: Colors.white,
        //      fontWeight: FontWeight.bold)
        // ),
      ],
    );
  }
}