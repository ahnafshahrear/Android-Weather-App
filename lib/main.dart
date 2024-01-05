import 'package:ascorp_weather/call_weather_api.dart';
import 'package:ascorp_weather/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

//... Ahnaf Shahrear Khan
//... Computer Science & Engineering, University of Rajshahi
//... ahnafshahrearkhan@gmail.com

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ___________________________________________________________________________ Geolocation v1
  Position? position;
  void getLocation() async {
    var permission = await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }
  // ___________________________________________________________________________ Variables v1
  TextEditingController controller = TextEditingController();
  WeatherModel? weatherModel;
  var temp;
  int? cel;
  String? tempMsg;
  String? lat;
  String? lon;
  var dateTime = DateFormat('EEEE, dd MMMM yyyy | hh:mm a', 'en_US').format(DateTime.now());
  String sunrise = 'assets/sunrise.jpg';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.indigoAccent,
        //   title: const Text("Ascorp Weather"),
        // ),
        backgroundColor: Color(0xFF1A1A1A),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // .... Buttons v2 .................................................v2 Buttons <Search, Location>
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //... Search Field ........................................... Search Text Field v2
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 50, // Set the desired height
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white, fontSize: 20,), // Set the text color
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 4), // Adjust vertical padding
                          hintText: 'Search',
                          hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                          prefixIcon: const Icon(Icons.location_pin, size: 32, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  //... VIEW WEATHER ........................................... VIEW WEATHER v2
                  Expanded(
                    // padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  // Colors.indigoAccent,
                                  // Colors.blue,
                                  Colors.transparent,
                                  Colors.transparent,
                                  //add more colors
                                ]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0), //shadow for button
                                  blurRadius: 0) //blur radius of shadow
                            ]
                        ),
                        child: ElevatedButton.icon(icon: const Icon(Icons.search_sharp, size: 36),
                          label: const Text(''),
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
                            alignment: Alignment.center, // Center the icon
                            padding: EdgeInsets.zero,
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
                  const SizedBox(width: 5),
                  // __________________________________________________________ Location Button
                  Expanded(
                    // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  // Colors.indigoAccent,
                                  // Colors.blue,
                                  Colors.transparent,
                                  Colors.transparent,
                                  //add more colors
                                ]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0), //shadow for button
                                  blurRadius: 0) //blur radius of shadow
                            ]
                        ),
                        child: ElevatedButton.icon(icon: const Icon(Icons.my_location_rounded, size: 30),
                          label: const Text(''),
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
                            alignment: Alignment.center, // Center the icon
                            padding: EdgeInsets.zero,
                            primary: Colors.transparent,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 0,
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
            //..................................................................v2 City, Temp & Date-Time
            SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //... City Name ..........................................v2 City
                      Text('${weatherModel?.name}', style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                      Stack(
                        children: [
                          //... Temperature ....................................v2 Temp °C
                          Text('${tempMsg??'0°C'}', style: TextStyle(
                              fontSize: 150,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                          Opacity(opacity: 0.85,
                            child: Padding(
                              padding: const EdgeInsets.only(left:70, right: 30, top:100, bottom: 20),
                              child: Image(
                                height: 150,
                                image: AssetImage(
                                  'assets/showers.png',
                                ),
                              ),
                            ),),
                        ],
                      ),
                      //... Date & Time ........................................v2 Date & Time
                      Text('${dateTime??0}', style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                )),
            //... MaxTemp, MinTemp & Feels Like ................................v2 MaxTemp, MinTemp & Feels Like
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 135,
                width: 350,
                decoration: BoxDecoration(
                  color: Color(0xFF151515),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Column(
                        children: [
                          Image(
                              height: 50,
                              image: AssetImage('assets/sleet.png')),
                          SizedBox(height: 10,),
                          Text('Min Temp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          Text('${weatherModel?.main?.tempMin}°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 8),
                      child: Column(
                        children: [
                          Image(
                              height: 50,
                              image: AssetImage('assets/max-temp.png')),
                          SizedBox(height: 10,),
                          Text('Max Temp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          Text('${weatherModel?.main?.tempMax}°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, right: 8),
                      child: Column(
                        children: [
                          Image(
                              height: 50,
                              image: AssetImage('assets/mainimg.png')),
                          SizedBox(height: 10,),
                          Text('Feels Like', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          Text('${weatherModel?.main?.feelsLike}°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //... Humidity, Sunrise & Sunset ...................................v2 Humidity, Sunrise & Sunset
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 135,
                width: 350,
                decoration: BoxDecoration(
                  color: Color(0xFF151515),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 8),
                      child: Column(
                        children: [
                          Image(
                              height: 50,
                              image: AssetImage('assets/humidity2.png')),
                          SizedBox(height: 10,),
                          Text('Humidity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          Text('${weatherModel?.main?.humidity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Column(
                        children: [
                          Image(
                              height: 50,
                              image: AssetImage('assets/sunrise.png')),
                          SizedBox(height: 10,),
                          Text('Sunrise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          Text('${unixToTime(weatherModel?.sys?.sunrise??0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, right: 8),
                      child: Column(
                        children: [
                          Image(
                              height: 50,
                              image: AssetImage('assets/sunset.png')),
                          SizedBox(height: 10,),
                          const Text('Sunset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          Text('${unixToTime(weatherModel?.sys?.sunset??0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            //... Ahnaf Shahrear Khan ..........................................v2 Ahnaf Shahrear Khan, RuCse27 © 2k24
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text('Ahnaf Shahrear Khan, RuCse27 © 2k24', style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),),
              ),
            )

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
