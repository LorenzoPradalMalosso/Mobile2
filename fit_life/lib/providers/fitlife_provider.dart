// providers/fitlife_provider.dart
// Provider principal — gerencia todo o estado global da aplicação FitLife
// Seguindo RF-002 ao RF-009 e as Regras de Negócio RN-001 ao RN-009

import 'package:flutter/material.dart';
import '../models/atividade.dart';

class FitLifeProvider extends ChangeNotifier {
  // ── Estado interno ──────────────────────────────────────────────────────────
  final List<Atividade> _pendentes = [];
  final List<Atividade> _concluidas = [];
  int _metaSemanal = 10; // RN-002: inteiro positivo, mínimo 1
  String _nomeUsuario = 'Lorenzo Malosso'; // RN-003: obrigatório
  bool _modoEscuro = false;
  int _indexNavegacao = 0; // RF-009: controle da aba ativa

  // ── Getters públicos ────────────────────────────────────────────────────────
  List<Atividade> get pendentes => List.unmodifiable(_pendentes);
  List<Atividade> get concluidas => List.unmodifiable(_concluidas);
  int get metaSemanal => _metaSemanal;
  String get nomeUsuario => _nomeUsuario;
  bool get modoEscuro => _modoEscuro;
  int get indexNavegacao => _indexNavegacao;

  /// Total de calorias somadas das atividades concluídas — RN-006
  double get totalCalorias =>
      _concluidas.fold(0, (soma, a) => soma + a.caloriasEstimadas);

  /// Tempo total em minutos das atividades concluídas — RN-006
  int get tempoTotalMinutos =>
      _concluidas.fold(0, (soma, a) => soma + a.duracaoMinutos);

  /// Progresso semanal limitado a 100% — RN-005
  double get progressoSemanal {
    if (_metaSemanal <= 0) return 0;
    final progresso = _concluidas.length / _metaSemanal;
    return progresso > 1.0 ? 1.0 : progresso;
  }

  /// Percentual de progresso formatado (0–100)
  int get progressoPercentual => (progressoSemanal * 100).round();

  // ── Ações ───────────────────────────────────────────────────────────────────

  /// RF-004 — Adiciona nova atividade à lista de pendentes
  /// RN-008: nome obrigatório | RN-009: duração e calorias positivos
  void adicionarAtividade(Atividade atividade) {
    assert(atividade.nome.isNotEmpty, 'RN-008: Nome da atividade é obrigatório');
    assert(atividade.duracaoMinutos > 0, 'RN-009: Duração deve ser positiva');
    assert(atividade.caloriasEstimadas > 0, 'RN-009: Calorias devem ser positivas');
    _pendentes.add(atividade);
    notifyListeners();
  }

  /// RF-005 — Exclui atividade de pendentes ou concluídas
  void excluirAtividade(String id, {required bool concluida}) {
    if (concluida) {
      _concluidas.removeWhere((a) => a.id == id);
    } else {
      _pendentes.removeWhere((a) => a.id == id);
    }
    notifyListeners(); // RN-006: métricas recalculadas automaticamente
  }

  /// RF-006 — Move atividade de pendentes para concluídas
  /// RN-004: só pode concluir se estiver em pendentes
  void concluirAtividade(String id) {
    final index = _pendentes.indexWhere((a) => a.id == id);
    if (index == -1) return; // RN-004: atividade não está em pendentes
    final atividade = _pendentes.removeAt(index);
    _concluidas.add(atividade.copyWith(concluida: true));
    notifyListeners(); // RF-007: dashboard atualizado automaticamente
  }

  /// RF-008 — Reseta progresso limpando apenas as concluídas — RN-007
  void resetarProgresso() {
    _concluidas.clear();
    notifyListeners();
  }

  /// RF-008 — Atualiza meta semanal — RN-002
  void atualizarMeta(int meta) {
    if (meta < 1) return; // RN-002: mínimo 1
    _metaSemanal = meta;
    notifyListeners();
  }

  /// RF-008 — Atualiza nome do usuário — RN-003
  void atualizarNome(String nome) {
    if (nome.trim().isEmpty) return; // RN-003: nome obrigatório
    _nomeUsuario = nome.trim();
    notifyListeners();
  }

  /// RF-008 — Alterna modo escuro
  void alternarModoEscuro() {
    _modoEscuro = !_modoEscuro;
    notifyListeners();
  }

  /// RF-009 — Atualiza aba ativa na BottomNavigationBar
  void setIndexNavegacao(int index) {
    _indexNavegacao = index;
    notifyListeners();
  }

  // ── Dados de exemplo para demonstração ─────────────────────────────────────
  void carregarDadosExemplo() {
    _pendentes.addAll([
      Atividade(id: '1', nome: 'Corrida Leve', duracaoMinutos: 30, caloriasEstimadas: 280),
      Atividade(id: '2', nome: 'Musculação', duracaoMinutos: 60, caloriasEstimadas: 350),
      Atividade(id: '3', nome: 'Natação', duracaoMinutos: 45, caloriasEstimadas: 400),
      Atividade(id: '4', nome: 'Yoga', duracaoMinutos: 40, caloriasEstimadas: 150),
      Atividade(id: '5', nome: 'Ciclismo', duracaoMinutos: 50, caloriasEstimadas: 420),
    ]);
    // Simula 7 atividades já concluídas (conforme protótipo: 70% de 10)
    final concluidas = [
      Atividade(id: '6', nome: 'Caminhada', duracaoMinutos: 35, caloriasEstimadas: 200, concluida: true),
      Atividade(id: '7', nome: 'Alongamento', duracaoMinutos: 20, caloriasEstimadas: 80, concluida: true),
      Atividade(id: '8', nome: 'HIIT', duracaoMinutos: 25, caloriasEstimadas: 310, concluida: true),
      Atividade(id: '9', nome: 'Pilates', duracaoMinutos: 50, caloriasEstimadas: 230, concluida: true),
      Atividade(id: '10', nome: 'Jump Rope', duracaoMinutos: 15, caloriasEstimadas: 180, concluida: true),
      Atividade(id: '11', nome: 'Funcional', duracaoMinutos: 40, caloriasEstimadas: 130, concluida: true),
      Atividade(id: '12', nome: 'Bike Indoor', duracaoMinutos: 45, caloriasEstimadas: 110, concluida: true),
    ];
    _concluidas.addAll(concluidas);
    notifyListeners();
  }
}