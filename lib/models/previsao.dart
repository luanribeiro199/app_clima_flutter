/// Condições climáticas atuais.
class ClimaAtual {
  final double temperatura;
  final double sensacao;
  final int umidade;
  final double vento;
  final int codigo;
  final bool dia;

  ClimaAtual({
    required this.temperatura,
    required this.sensacao,
    required this.umidade,
    required this.vento,
    required this.codigo,
    required this.dia,
  });

  factory ClimaAtual.fromJson(Map<String, dynamic> json) {
    return ClimaAtual(
      temperatura: (json['temperature_2m'] as num).toDouble(),
      sensacao: (json['apparent_temperature'] as num).toDouble(),
      umidade: (json['relative_humidity_2m'] as num).toInt(),
      vento: (json['wind_speed_10m'] as num).toDouble(),
      codigo: (json['weather_code'] as num).toInt(),
      dia: json['is_day'] == 1,
    );
  }
}

/// Previsão de um dia.
class PrevisaoDia {
  final DateTime data;
  final int codigo;
  final double maxima;
  final double minima;
  final int? chanceChuva;

  PrevisaoDia({
    required this.data,
    required this.codigo,
    required this.maxima,
    required this.minima,
    this.chanceChuva,
  });
}

/// Resposta completa da Forecast API: clima atual + próximos dias.
class Previsao {
  final ClimaAtual atual;
  final List<PrevisaoDia> dias;

  Previsao({required this.atual, required this.dias});

  factory Previsao.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>;
    final datas = List<String>.from(daily['time']);
    final dias = <PrevisaoDia>[];
    for (var i = 0; i < datas.length; i++) {
      dias.add(PrevisaoDia(
        data: DateTime.parse(datas[i]),
        codigo: (daily['weather_code'][i] as num).toInt(),
        maxima: (daily['temperature_2m_max'][i] as num).toDouble(),
        minima: (daily['temperature_2m_min'][i] as num).toDouble(),
        chanceChuva: (daily['precipitation_probability_max'][i] as num?)?.toInt(),
      ));
    }
    return Previsao(
      atual: ClimaAtual.fromJson(json['current'] as Map<String, dynamic>),
      dias: dias,
    );
  }
}
