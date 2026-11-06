import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cidade.dart';
import '../models/previsao.dart';

/// Serviço responsável pelas requisições HTTP à API Open-Meteo.
/// Documentação: https://open-meteo.com/en/docs
class ClimaService {
  static const _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const _forecastUrl = 'https://api.open-meteo.com/v1/forecast';

  final http.Client _client;
  ClimaService({http.Client? client}) : _client = client ?? http.Client();

  /// GET /v1/search?name=... — busca cidades pelo nome.
  Future<List<Cidade>> buscarCidades(String nome) async {
    final uri = Uri.parse(_geocodingUrl).replace(queryParameters: {
      'name': nome,
      'count': '10',
      'language': 'pt',
      'format': 'json',
    });

    final resposta = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (resposta.statusCode != 200) {
      throw Exception('Erro ${resposta.statusCode} ao buscar cidades');
    }

    final json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    final resultados = json['results'] as List<dynamic>?;
    if (resultados == null) return [];
    return resultados
        .map((e) => Cidade.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /v1/forecast — clima atual e previsão de 7 dias para uma coordenada.
  Future<Previsao> buscarPrevisao(Cidade cidade) async {
    final uri = Uri.parse(_forecastUrl).replace(queryParameters: {
      'latitude': cidade.latitude.toString(),
      'longitude': cidade.longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,is_day',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final resposta = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (resposta.statusCode != 200) {
      throw Exception('Erro ${resposta.statusCode} ao buscar previsão');
    }
    return Previsao.fromJson(
        jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>);
  }
}
