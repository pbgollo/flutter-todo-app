// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:trabalho_1/model/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  // Busca os dados do tempo na API
  Future<Weather> getWeather(String cidade) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cidade&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erro ao carregar os dados do tempo!");
    }
  }

  // Busca a cidade de acordo com a localização atual
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? cidade = placemarks[0].subAdministrativeArea;

    return cidade ?? "";
  }
  
}