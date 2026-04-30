// widgets/form_atividade.dart
// BottomSheet com formulário para cadastrar nova atividade — RF-004
// Validação obrigatória dos campos conforme RN-008 e RN-009

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/atividade.dart';
import '../providers/fitlife_provider.dart';

class FormAtividade extends StatefulWidget {
  const FormAtividade({super.key});

  @override
  State<FormAtividade> createState() => _FormAtividadeState();
}

class _FormAtividadeState extends State<FormAtividade> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _caloriasController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _duracaoController.dispose();
    _caloriasController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FitLifeProvider>();
    final novaAtividade = Atividade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      duracaoMinutos: int.parse(_duracaoController.text),
      caloriasEstimadas: double.parse(_caloriasController.text),
    );

    provider.adicionarAtividade(novaAtividade);
    Navigator.pop(context);

    // Notificação de sucesso — RF-004
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓  "${novaAtividade.nome}" adicionada às pendentes!'),
        backgroundColor: const Color(0xFF00C853),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // Empurra o formulário acima do teclado
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de arraste
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Nova Atividade',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // ── Campo: Nome da Atividade — RN-008 ───────────────────────────
            TextFormField(
              controller: _nomeController,
              decoration: _inputDecoration(
                label: 'Nome da Atividade',
                hint: 'Ex.: Corrida Matinal',
                icon: Icons.sports_gymnastics,
                colorScheme: colorScheme,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'RN-008: O nome da atividade é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ── Campo: Duração — RN-009 ─────────────────────────────────────
            TextFormField(
              controller: _duracaoController,
              decoration: _inputDecoration(
                label: 'Duração (minutos)',
                hint: 'Ex.: 30',
                icon: Icons.timer_outlined,
                colorScheme: colorScheme,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Campo obrigatório';
                final n = int.tryParse(v);
                if (n == null || n <= 0) return 'RN-009: Deve ser um valor positivo';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ── Campo: Calorias — RN-009 ────────────────────────────────────
            TextFormField(
              controller: _caloriasController,
              decoration: _inputDecoration(
                label: 'Calorias estimadas (kcal)',
                hint: 'Ex.: 250',
                icon: Icons.local_fire_department_outlined,
                colorScheme: colorScheme,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Campo obrigatório';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'RN-009: Deve ser um valor positivo';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ── Botão Salvar ─────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Adicionar Atividade'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: colorScheme.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }
}