class Weather {
  final String cidade;
  final double temperatura;
  final String condicao;

  Weather({
    required this.cidade,
    required this.temperatura,
    required this.condicao,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cidade: json['name'], 
      temperatura: json['main']['temp'].toDouble(),
      condicao: json['weather'][0]['main'],
    );
  }
}