import 'package:flutter_test/flutter_test.dart';
import 'package:app_clima/main.dart';
import 'package:app_clima/models/previsao.dart';

void main() {
  testWidgets('Tela inicial mostra o campo de busca', (tester) async {
    await tester.pumpWidget(const AppClima());
    expect(find.text('Clima Agora'), findsOneWidget);
    expect(find.text('Nome da cidade'), findsOneWidget);
  });

  test('Previsao.fromJson converte o JSON da API', () {
    final p = Previsao.fromJson({
      'current': {
        'temperature_2m': 21.4, 'apparent_temperature': 20.0,
        'relative_humidity_2m': 70, 'wind_speed_10m': 9.5,
        'weather_code': 2, 'is_day': 1,
      },
      'daily': {
        'time': ['2026-11-05'], 'weather_code': [61],
        'temperature_2m_max': [25.0], 'temperature_2m_min': [15.0],
        'precipitation_probability_max': [80],
      },
    });
    expect(p.atual.temperatura, 21.4);
    expect(p.dias.single.chanceChuva, 80);
  });
}
