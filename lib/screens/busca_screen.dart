import 'package:flutter/material.dart';

import '../models/cidade.dart';
import '../services/clima_service.dart';
import 'previsao_screen.dart';

/// Tela inicial: o usuário digita o nome de uma cidade e o app
/// consulta a Geocoding API de forma assíncrona.
class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final _controller = TextEditingController();
  final _service = ClimaService();

  Future<List<Cidade>>? _resultado;

  void _buscar() {
    final termo = _controller.text.trim();
    if (termo.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite ao menos 2 letras')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _resultado = _service.buscarCidades(termo));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Agora'),
        backgroundColor: cores.primary,
        foregroundColor: cores.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                labelText: 'Nome da cidade',
                hintText: 'Ex.: Curitiba',
                prefixIcon: const Icon(Icons.location_city),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildResultado()),
          ],
        ),
      ),
    );
  }

  Widget _buildResultado() {
    if (_resultado == null) {
      return const _Mensagem(
        icone: Icons.travel_explore,
        texto: 'Pesquise uma cidade para ver\no clima atual e a previsão.',
      );
    }
    return FutureBuilder<List<Cidade>>(
      future: _resultado,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _Mensagem(
            icone: Icons.wifi_off,
            texto: 'Não foi possível buscar.\n${snapshot.error}',
          );
        }
        final cidades = snapshot.data ?? [];
        if (cidades.isEmpty) {
          return const _Mensagem(
            icone: Icons.search_off,
            texto: 'Nenhuma cidade encontrada.',
          );
        }
        return ListView.separated(
          itemCount: cidades.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final c = cidades[i];
            return ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(c.nome),
              subtitle: Text(c.descricaoLocal),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrevisaoScreen(cidade: c)),
              ),
            );
          },
        );
      },
    );
  }
}

class _Mensagem extends StatelessWidget {
  final IconData icone;
  final String texto;
  const _Mensagem({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(texto, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
