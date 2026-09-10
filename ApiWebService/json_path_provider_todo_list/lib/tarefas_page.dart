import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_path_provider_todo_list/json_helper.dart';

class TarefasPage extends StatefulWidget {
  // Vai trazer informações da página anterior
  final String nomeUsuario;
  final Map<String,dynamic> db;
  // Adicionar os atributos no construtor
  const TarefasPage({super.key, required this.nomeUsuario, required this.db});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  List<Map<String,dynamic>> _tarefas = [];

  // Métodos CRUD
  void _carregarTarefas() async {
    List<dynamic> tarefasDinamicas = widget.db[widget.nomeUsuario] ?? []; // Tratamento de nulidade
    setState(() {
      _tarefas = List<Map<String,dynamic>>.from(tarefasDinamicas);
    });
  }

  void _salvarTarefa() async {
    setState(() {
      _tarefas.add(
        {
          "titulo":"Nova Tarefa ${_tarefas.length+1}",
          "concluida":false
        }
      );
    });
    _salvarAlteracoesJson();
  }

  void _atualizarTarefa(int index) async {
    setState(() {
      _tarefas[index]["concluida"] = !_tarefas[index]["concluida"];
    });
    _salvarAlteracoesJson();
  }

  void _removerTarefa(int index) async {
    setState(() {
      _tarefas.removeAt(index);
    });
    _salvarAlteracoesJson();
  }

  // Atuar no Json
  void _salvarAlteracoesJson() async {
    // Atualizando a lista de tarefas do usuário específico no arquivo Json
    widget.db[widget.nomeUsuario] = _tarefas;
    JsonHelper.salvarDados(widget.db);
  }

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarefas de ${widget.nomeUsuario}"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Expanded(
          child: ListView.builder(
            itemCount: _tarefas.length,
            itemBuilder: (_, index) {
              final tarefa = _tarefas[index];
              return CheckboxListTile(
                title: Text(tarefa["titulo"], style: TextStyle(decoration: tarefa["concluida"] ? TextDecoration.lineThrough: null),),
                value: tarefa["concluida"],
                onChanged: (bool ? valor) => _atualizarTarefa(index),
                secondary: IconButton(
                  onPressed: () => _removerTarefa(index), 
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarTarefa,
        child: Icon(Icons.add),
      ),
    );
  }
}