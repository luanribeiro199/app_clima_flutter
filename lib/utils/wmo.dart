import 'package:flutter/material.dart';

/// Traduz os códigos meteorológicos WMO usados pela Open-Meteo.
class Wmo {
  static String descricao(int codigo) {
    switch (codigo) {
      case 0:
        return 'Céu limpo';
      case 1:
        return 'Predomínio de sol';
      case 2:
        return 'Parcialmente nublado';
      case 3:
        return 'Nublado';
      case 45:
      case 48:
        return 'Neblina';
      case 51:
      case 53:
      case 55:
        return 'Garoa';
      case 56:
      case 57:
        return 'Garoa congelante';
      case 61:
      case 63:
      case 65:
        return 'Chuva';
      case 66:
      case 67:
        return 'Chuva congelante';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Neve';
      case 80:
      case 81:
      case 82:
        return 'Pancadas de chuva';
      case 85:
      case 86:
        return 'Pancadas de neve';
      case 95:
        return 'Trovoadas';
      case 96:
      case 99:
        return 'Trovoadas com granizo';
      default:
        return 'Desconhecido';
    }
  }

  static IconData icone(int codigo, {bool dia = true}) {
    if (codigo == 0 || codigo == 1) {
      return dia ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }
    if (codigo == 2) return Icons.wb_cloudy_outlined;
    if (codigo == 3) return Icons.cloud_rounded;
    if (codigo == 45 || codigo == 48) return Icons.foggy;
    if (codigo >= 51 && codigo <= 67) return Icons.water_drop_rounded;
    if (codigo >= 71 && codigo <= 77) return Icons.ac_unit_rounded;
    if (codigo >= 80 && codigo <= 82) return Icons.umbrella_rounded;
    if (codigo >= 85 && codigo <= 86) return Icons.ac_unit_rounded;
    if (codigo >= 95) return Icons.thunderstorm_rounded;
    return Icons.help_outline;
  }
}
