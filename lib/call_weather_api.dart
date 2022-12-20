import 'package:ascorp_weather/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallWeatherApi {
  getWeather(String? city) async {
    var url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=6eafcaf1ce810d6843fc791fb4509c50&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 ) {
        return WeatherModel.fromJson(json.decode(response.body));
      }
    }
    catch (ex) {
      return null;
    }
  }
}

class CallWeatherByLocation {
  getWeather(String? lat, String? lon) async {
    var url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=6eafcaf1ce810d6843fc791fb4509c50&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 ) {
        return WeatherModel.fromJson(json.decode(response.body));
      }
    }
    catch (ex) {
      return null;
    }
  }
}