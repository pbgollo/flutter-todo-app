// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/model/weather.dart';
import 'package:trabalho_1/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trabalho_1/view/login_gui.dart';
import 'package:trabalho_1/view/principal_gui.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService("f6d38f90bca9d14759b32495ab42c99b");
  Weather? _weather;

  _fetchWeather() async {
    String cidade = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cidade);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
  }

  bool isDaytime() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    int sunriseHour = 6; 
    int sunsetHour = 18; 

    return currentHour >= sunriseHour && currentHour < sunsetHour;
  }

  String getWeatherAnimationDay(String? condicao) {
    if(condicao == null) return "assets/animation/sol-loading.json";

    switch(condicao.toLowerCase()){
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/animation/nuvem.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/animation/sol-chuva.json";
      case "thunderstorm":
        return "assets/animation/tempestade.json";
      case "clear":
        return "assets/animation/sol.json";
      default:
        return "assets/animation/sol.json";
    }
  }

  String getWeatherAnimationNight(String? condicao) {
    if(condicao == null) return "assets/animation/lua-loading.json";

    switch(condicao.toLowerCase()){
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/animation/nuvem.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/animation/lua-chuva.json";
      case "thunderstorm":
        return "assets/animation/tempestade.json";
      case "clear":
        return "assets/animation/lua.json";
      default:
        return "assets/animation/lua.json";
    }
  }

  String getWeatherText(String? condicao) {
    if(condicao == null) return "Buscando informações...";

    switch(condicao.toLowerCase()){
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "Nublado";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "Chuva";
      case "thunderstorm":
        return "Tempestade";
      case "clear":
        return "Limpo";
      default:
        return "Limpo";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0), 
        child: AppBar(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrincipalPage(usuario: widget.usuario),
                        ),
                      );
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            const SizedBox(height: 20),

            Icon(Icons.location_on,
              color: Colors.grey[500], 
              size: 25,
            ),

            const SizedBox(height: 5),

            Text(
              (_weather?.cidade ?? "Carregando a cidade...").toUpperCase(),
              style: GoogleFonts.bebasNeue(
                fontSize: 25,
                fontWeight: FontWeight.w400, 
                color: Colors.grey[500], 
              ),
            ),

            const SizedBox(height: 90),

            Lottie.asset(isDaytime() ? getWeatherAnimationDay(_weather?.condicao) : getWeatherAnimationNight(_weather?.condicao)),

            const SizedBox(height: 110),
            
            Text(
              ("${_weather?.temperatura.round()}°C").toUpperCase(),
              style: GoogleFonts.bebasNeue(
                fontSize: 55,
                fontWeight: FontWeight.bold, 
                color: Colors.grey[700], 
              ),
            ),

            Text(
              (getWeatherText(_weather?.condicao)).toUpperCase(),
              style: GoogleFonts.bebasNeue(
                fontSize: 25,
                fontWeight: FontWeight.w400, 
                color: Colors.grey[500], 
              ),

            ),
          ],
        ),
      ),  
    );
  }
}