import 'package:flutter/material.dart';

import '../models/cidade.dart';
import '../models/previsao.dart';
import '../services/clima_service.dart';
import '../utils/wmo.dart';

/// Mostra o clima atual e a previsão de 7 dias da cidade escolhida.
class PrevisaoScreen extends StatefulWidget {
  final Cidade cidade;
  const PrevisaoScreen({super.key, required this.cidade});

  @override
  State<PrevisaoScreen> createState() => _PrevisaoScreenState();
}

class _PrevisaoScreenState extends State<PrevisaoScreen> {
  final _service = ClimaService();
  late Future<Previsao> _previsao;

  static const _diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    _previsao = _service.buscarPrevisao(widget.cidade);
  }

  Future<void> _atualizar() async {
    final nova = _service.buscarPrevisao(widget.cidade);
    setState(() => _previsao = nova);
    await nova;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cidade.nome)),
      body: FutureBuilder<Previsao>(
        future: _previsao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 56, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Erro: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                      onPressed: _atualizar, child: const Text('Tentar de novo')),
                ],
              ),
            );
          }
          final p = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _atualizar,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _cardAtual(p.atual),
                const SizedBox(height: 20),
                Text('Próximos 7 dias',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...p.dias.asMap().entries.map((e) => _linhaDia(e.value, e.key)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cardAtual(ClimaAtual a) {
    final gradiente = a.dia
        ? const [Color(0xFF42A5F5), Color(0xFF1565C0)]
        : const [Color(0xFF37474F), Color(0xFF1A237E)];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradiente,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(widget.cidade.descricaoLocal,
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Icon(Wmo.icone(a.codigo, dia: a.dia), size: 72, color: Colors.white),
          Text('${a.temperatura.round()}°C',
              style: const TextStyle(
                  color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold)),
          Text(Wmo.descricao(a.codigo),
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _info(Icons.thermostat, 'Sensação', '${a.sensacao.round()}°C'),
              _info(Icons.water_drop_outlined, 'Umidade', '${a.umidade}%'),
              _info(Icons.air, 'Vento', '${a.vento.round()} km/h'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icone, String rotulo, String valor) {
    return Column(
      children: [
        Icon(icone, color: Colors.white70),
        const SizedBox(height: 4),
        Text(valor,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(rotulo, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _linhaDia(PrevisaoDia d, int indice) {
    final nome = indice == 0 ? 'Hoje' : _diasSemana[d.data.weekday - 1];
    final data = '${d.data.day.toString().padLeft(2, '0')}/'
        '${d.data.month.toString().padLeft(2, '0')}';
    return Card(
      child: ListTile(
        leading: Icon(Wmo.icone(d.codigo),
            color: Theme.of(context).colorScheme.primary, size: 32),
        title: Text('$nome  •  $data'),
        subtitle: Text(
            '${Wmo.descricao(d.codigo)}'
            '${d.chanceChuva != null ? '  •  chuva ${d.chanceChuva}%' : ''}'),
        trailing: Text('${d.maxima.round()}° / ${d.minima.round()}°',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
