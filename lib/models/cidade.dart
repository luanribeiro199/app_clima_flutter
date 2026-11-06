/// Representa uma cidade retornada pela Geocoding API do Open-Meteo.
class Cidade {
  final String nome;
  final String? estado;
  final String? pais;
  final double latitude;
  final double longitude;

  Cidade({
    required this.nome,
    this.estado,
    this.pais,
    required this.latitude,
    required this.longitude,
  });

  /// Converte um objeto JSON (Map) em uma instância de [Cidade].
  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      nome: json['name'] as String,
      estado: json['admin1'] as String?,
      pais: json['country'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String get descricaoLocal =>
      [estado, pais].where((e) => e != null && e.isNotEmpty).join(', ');
}
