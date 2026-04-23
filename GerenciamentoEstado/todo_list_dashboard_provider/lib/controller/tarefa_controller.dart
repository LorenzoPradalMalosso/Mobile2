// Controller vai ter a função de provider

import 'package:flutter/material.dart';
import 'package:todo_list_dashboard_provider/model/tarefa.dart';

class TarefaController extends ChangeNotifier{
  // Transformo a classe controller em herdeira da changeNotifier (Provider)
  // Classe que vai armazenar tarefas
  List<Tarefa> _tarefas =[]; // Array que vai armazenas as tarefas criadas (obj da classe model)
  // obs: _ => Atributo privado

  //Liberar o Acesso (getter)
  List<Tarefa> get tarefas => _tarefas;

  // Métodos (CRUD)
  // CREATE
  void createTarefa(String titulo){

    if(titulo.trim().isEmpty)return; // Se o título estiver vazio, interrompe os métodos

    _tarefas.add(Tarefa(titulo: titulo)); //Adicionar um obj de Tarefa ao Vetor

    notifyListeners(); // Avisar os listeners que foi adicionado uma tarefa no vetor
  }

  // UPDATE
  void updateTarefa(int index){
    _tarefas[index].concluida = !_tarefas[index].concluida;
    // "!" inverte o valor da booleana
    notifyListeners();
  }

  // DELETE
  void deleteTarefa(int index){
    _tarefas.removeAt(index);
    notifyListeners();
  }

  // Criar métodos para definição das métricas
  // totalTarefas => calcula no nº total de Tarefas
  int get totalTarefas => _tarefas.length;

  // totalTarefasConcluidas
  int get totalTarefasConcluidas => _tarefas.where((tarefa)=>tarefa.concluida).length;

  // totalTarefasPendentes
  int get totalTarefasPendentes => _tarefas.where((tarefa)=>!tarefa.concluida).length;

  // porcentagemTarefasConcluidas
  double get porcentagemTarefasConcluidas {
    if(totalTarefas==0) return 0;
    return num.parse(((totalTarefasConcluidas/totalTarefas) * 100).toStringAsFixed(2)).toDouble();
  }
}