// screens/tela_configuracoes.dart
// RF-008: Tela de configurações do usuário
// Toggle modo escuro, campo nome, meta semanal, resetar progresso

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitlife_provider.dart';

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitLifeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Seção: Perfil do Usuário ────────────────────────────────────────
          _SecaoTitulo(titulo: 'Perfil'),
          _CartaoConfig(
            children: [
              // Campo: Nome do usuário — RN-003
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_rounded, color: colorScheme.primary),
                ),
                title: const Text('Nome'),
                subtitle: Text(provider.nomeUsuario),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _editarNome(context, provider),
              ),
            ],
          ),

          // ── Seção: Metas ───────────────────────────────────────────────────
          _SecaoTitulo(titulo: 'Metas'),
          _CartaoConfig(
            children: [
              // Campo: Meta semanal — RN-002
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.flag_rounded, color: Colors.blue),
                ),
                title: const Text('Meta Semanal'),
                subtitle: Text('${provider.metaSemanal} atividades por semana'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _editarMeta(context, provider),
              ),
            ],
          ),

          // ── Seção: Aparência ───────────────────────────────────────────────
          _SecaoTitulo(titulo: 'Aparência'),
          _CartaoConfig(
            children: [
              // Toggle: Modo escuro
              SwitchListTile(
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    provider.modoEscuro
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: Colors.purple,
                  ),
                ),
                title: const Text('Modo Escuro'),
                subtitle: Text(
                  provider.modoEscuro ? 'Ativado' : 'Desativado',
                ),
                value: provider.modoEscuro,
                onChanged: (_) => provider.alternarModoEscuro(),
              ),
            ],
          ),

          // ── Seção: Dados ───────────────────────────────────────────────────
          _SecaoTitulo(titulo: 'Dados'),
          _CartaoConfig(
            children: [
              // Botão: Resetar progresso — RN-007
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restart_alt_rounded, color: Colors.red),
                ),
                title: const Text('Resetar Progresso'),
                subtitle: const Text('Limpar atividades concluídas'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _confirmarReset(context, provider),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Informações do app ─────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Text(
                  'FitLife v1.0.0',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2026 LorenzoPradalMalosso',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Dialog para editar nome — RN-003 ───────────────────────────────────
  void _editarNome(BuildContext context, FitLifeProvider provider) {
    final controller = TextEditingController(text: provider.nomeUsuario);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Nome'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nome do usuário',
            hintText: 'Digite seu nome',
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final nome = controller.text.trim();
              if (nome.isNotEmpty) {
                provider.atualizarNome(nome);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('✓ Nome atualizado!'),
                    backgroundColor: const Color(0xFF00C853),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // ── Dialog para editar meta semanal — RN-002 ────────────────────────────
  void _editarMeta(BuildContext context, FitLifeProvider provider) {
    final controller =
        TextEditingController(text: provider.metaSemanal.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Meta Semanal'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Número de atividades',
            hintText: 'Mínimo: 1',
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final meta = int.tryParse(controller.text);
              if (meta != null && meta >= 1) {
                provider.atualizarMeta(meta);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Meta atualizada para $meta atividades!'),
                    backgroundColor: const Color(0xFF00C853),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚠ RN-002: Meta deve ser ≥ 1'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // ── Dialog de confirmação para resetar progresso — RN-007 ────────────────
  void _confirmarReset(BuildContext context, FitLifeProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resetar Progresso?'),
        content: const Text(
          'Esta ação irá limpar todas as atividades concluídas. '
          'As atividades pendentes serão mantidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              provider.resetarProgresso();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✓ Progresso resetado!'),
                  backgroundColor: const Color(0xFF00C853),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }
}

// ── Widget auxiliar: Seção com título ──────────────────────────────────────
class _SecaoTitulo extends StatelessWidget {
  final String titulo;

  const _SecaoTitulo({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Widget auxiliar: Cartão de configuração ────────────────────────────────
class _CartaoConfig extends StatelessWidget {
  final List<Widget> children;

  const _CartaoConfig({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: children),
    );
  }
}