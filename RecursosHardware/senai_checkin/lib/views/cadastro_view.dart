import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/registro_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final RegistroController _controller = RegistroController();
  final TextEditingController _observacaoController = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarRegistro() async {
    final observacao = _observacaoController.text.trim();

    if (observacao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha a observação antes de salvar.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final sucesso = await _controller.criarRegistro(observacao);

    if (!mounted) return;

    setState(() => _salvando = false);

    if (sucesso) {
      // Feedback sonoro
      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro salvo com sucesso!'),
          backgroundColor: Color(0xFF0284C7),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar o registro. Verifique as permissões.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Novo Registro',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ícone ilustrativo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFCC0000).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 56,
                    color: Color(0xFFCC0000),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Ao salvar, a câmera será aberta\npara capturar a foto do registro.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Label
            const Text(
              'Observação',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),

            // Campo de observação
            TextField(
              controller: _observacaoController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Descreva a atividade realizada...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFCC0000),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),

            // Informação sobre GPS
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFF0284C7),
                ),
                const SizedBox(width: 6),
                Text(
                  'A localização GPS será capturada automaticamente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Botão salvar
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _salvando ? null : _salvarRegistro,
                icon: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _salvando ? 'Salvando...' : 'Salvar Registro',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC0000),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF990000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
