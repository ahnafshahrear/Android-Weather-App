import 'package:ascorp_weather/call_weather_api.dart';
import 'package:ascorp_weather/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ___________________________________________________________________________ Geolocation
  Position? position;
  void getLocation() async {
    var permission = await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }
  // ___________________________________________________________________________ Variables
  TextEditingController controller = TextEditingController();
  WeatherModel? weatherModel;
  var temp;
  int? cel;
  String? tempMsg;
  String? lat;
  String? lon;
  var dateTime = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
  String sunrise = 'assets/sunrise.jpg';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: const Text("Ascorp Weather"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image.asset('assets/as-logo.png', height: 100, width: 100),
            // _____________________________________ First Row
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    // _________________________________________________________ Search
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 4, color: Colors.blue
                              ),
                              borderRadius: BorderRadius.circular(3.0)
                          ),
                          hintText: 'Enter a city name',
                          hintStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black26),
                          prefixIcon: const Icon(Icons.location_pin, size: 32, color: Colors.indigoAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // _________________________________________________________ Location Button
                    child: SizedBox(
                      width: 150,
                      height: 59.0,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue,
                                    Colors.indigoAccent,
                                    //add more colors
                                  ]),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0), //shadow for button
                                    blurRadius: 0) //blur radius of shadow
                              ]
                          ),
                          child: ElevatedButton.icon(icon: const Icon(Icons.my_location_rounded),
                            label: const Text('LOCATION'),
                            onPressed: () async {
                              getLocation();
                              weatherModel = await CallWeatherByLocation().getWeather(position?.latitude.toString(), position?.longitude.toString());
                              temp = weatherModel?.main?.temp;
                              if (weatherModel != null) {
                                cel = temp.round();
                                tempMsg = '$cel°C';
                              }
                              else {
                                tempMsg = 'Invalid City';
                              }
                              lat = (position?.latitude).toString();
                              lon = (position?.longitude).toString();
                              setState(() {});
                            },style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontStyle: FontStyle.normal
                              ),
                            ),
                          ),
                      ),
                      ),
                    ),
                ],
              ),
            ),
            // _________________________________________________________________ Latitude & Longitude
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Latitude      $lat        Longitude      $lon",
                style: TextStyle(height: 1, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
            ),
            // _________________________________________________________________ City & Country
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("${weatherModel?.name}",
                style: TextStyle(height: 1, fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black54),
              ),
            ),
            // _________________________________________________________________ VIEW WEATHER
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                width: 400,
                height: 57.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.indigoAccent,
                            Colors.blue,
                            //add more colors
                          ]),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0), //shadow for button
                            blurRadius: 0) //blur radius of shadow
                      ]
                  ),
                  child: ElevatedButton.icon(icon: const Icon(Icons.search_sharp, size: 30),
                    label: const Text('VIEW WEATHER'),
                    onPressed: () async {
                      weatherModel = await CallWeatherApi().getWeather(controller.text);
                      temp = weatherModel?.main?.temp;
                      if (weatherModel != null) {
                        cel = temp.round();
                        tempMsg = '$cel°C';
                      }
                      else {
                        tempMsg = 'Invalid City';
                      }
                      lat = (weatherModel?.coord?.lat).toString();
                      lon = (weatherModel?.coord?.lon).toString();
                      setState(() {});
                    },style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontStyle: FontStyle.normal
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // _________________________________________________________________ Date Time
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Date & Time: ${dateTime??0}",
                style: TextStyle(height: 1, fontSize: 25, fontWeight: FontWeight.w400, color: Colors.black54),
              ),
            ),
            // _________________________________________________________________ Temperature
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Center(child: Text('$tempMsg',
                style: const TextStyle(height: 1, fontSize: 48, fontWeight: FontWeight.w300, color: Colors.black54),
              ),
              ),
            ),
            // _________________________________________________________________ Humidity
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Humidity              ${weatherModel?.main?.humidity}%",
                style: TextStyle(height: 1, fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black54),
              ),
            ),
            // _________________________________________________________________ Sunset & Sunrise images
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    // _________________________________________________________
                    child: Image.asset(sunrise, height: 75, width: 75),
                  ),
                  const SizedBox(width: 75),
                  Expanded(
                    // _________________________________________________________
                    child: Image.asset('assets/sunset.jpg', height: 100, width: 100),
                  ),
                ],
              ),
            ),
            // _________________________________________________________________ Sunset & Sunrise Data
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Sunrise: ${unixToTime(weatherModel?.sys?.sunrise??0)}              Sunset: ${unixToTime(weatherModel?.sys?.sunset??0)}",
                style: TextStyle(height: 1, fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // __________________________________________
  String unixToTime(timeStamp) {
    final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateFormat('hh:mm a').format(date1);
  }
}
