import 'package:flutter/material.dart';

import '../controllers/registro_controller.dart';
import '../models/registro_model.dart';
import '../widgets/registro_card.dart';
import 'cadastro_view.dart';
import 'detalhes_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final RegistroController _controller = RegistroController();
  List<Registro> _registros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  Future<void> _carregarRegistros() async {
    setState(() => _carregando = true);
    final registros = await _controller.listarRegistros();
    setState(() {
      _registros = registros;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'SENAI Check-in',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCC0000),
              ),
            )
          : _registros.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 72,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum registro encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toque no botão + para criar um novo registro',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFCC0000),
                  onRefresh: _carregarRegistros,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _registros.length,
                    itemBuilder: (context, index) {
                      final registro = _registros[index];
                      return RegistroCard(
                        registro: registro,
                        onTap: () async {
                          final resultado = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetalhesView(registro: registro),
                            ),
                          );

                          if (resultado == true) {
                            _carregarRegistros();
                          }
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CadastroView()),
          );
          if (resultado == true) {
            _carregarRegistros();
          }
        },
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}