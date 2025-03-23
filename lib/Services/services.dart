import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_bud/main.dart' as main;
import 'package:weather_bud/credentials.dart' as creds;

class WeatherServices{
  fetchWeather() async {
    final response = await http.get(
      Uri.parse(
        // Mamadou Memo: The tutorial I was following hard coded in the location, had the api key in the link and instead of having the api return in chosen units, converted
        // between units manually. I will not be doing that. 
        "https://api.openweathermap.org/data/2.5/weather?${main.currentPosition?.longitude}&${main.currentPosition?.latitude}&appid=${creds.openWeatherKey}a&units=imperial")
      );
      try{
        if(response.statusCode == 200) {
          var json = jsonDecode(response.body);
        }
      } catch (e) {
        print(e.toString());
      }
  }
}