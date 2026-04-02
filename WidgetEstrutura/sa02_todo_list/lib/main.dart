// Situação de aprendizagem 02 - Aplicativo ToDo-List

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TodoListView(),
  ));
}

// A Classe da Janela Stateful
// 1º Classe: Identifica as mudanças de estado e chama o rebuild da tela
class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  // Chama o rebuild
  @override
  State<TodoListView> createState() => _TodoListViewState(); // Arrow function

  // Sem ser Arrow function
  // State<TodoListView> createState(){
  //   return _TodoListViewState();
  // }
}

// 2º Classe: Fica a lógica da tela, atributos/métodos
class _TodoListViewState extends State<TodoListView> {

  // Atributos
  // Obj para controlar os dados do input
  // final => Permite a mudança de valor uma única vez
  // _ o uso de underline, transforma a variável em private
  final TextEditingController _tarefasController = TextEditingController(); // Pegar o valor do input
  final List<Map<String, dynamic>> _tarefas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas"), centerTitle: true,),
      body: Padding(
        // Espaçamento geral de 8px
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Adicionar + de 1 elemento
            // Input da tarefa
            TextField(
              // Controle para o texto inserido
              controller: _tarefasController, // Passar o valor do texto para o controller
              decoration: InputDecoration(
                // Placeholder do input
                labelText: "Digite uma Tarefa..."
              ),
            ),
            // Espaçamento
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _adicionarTarefa, // Método para adicionar Tarefa a Lista
              child: Text("Adicionar Tarefa"),
            ),
            // Listar as tarefas da lista
            // Scroll de parte da tela
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) => 
                  // Para cada elemento faça (FOREACH)
                  ListTile(
                    title: Text(_tarefas[index]["titulo"], 
                      style: TextStyle(
                      // Operador ternário
                        decoration: _tarefas[index]["concluida"]? TextDecoration.lineThrough: null
                      ),
                    ),
                    // Adicionar um checkbox antes do texto
                    leading: Checkbox(
                      value: _tarefas[index]["concluida"], 
                      onChanged: (bool? valor) => setState(() { // Rebuild da janela
                      _tarefas[index]["concluida"] = valor!; // Inverte o valor da booleana
                    })
                    ),
                    // Adicionar ícone para deletar tarefas consluídas (IconButton)
                    trailing: IconButton(
                      onPressed: () => _deletarTarefa(index), 
                      icon: Icon(Icons.delete)),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para adicionar tarefa
  void _adicionarTarefa() {
    //TODO: create Tarefa
    if(_tarefasController.text.trim().isNotEmpty){
      // Ste tarefa não estiver vazia
      // Adiciona a tarefa a lista
      // Mudar o estado da janela
      setState(() {
        // Envia um aviso da mudança de estado
        _tarefas.add({"titulo":_tarefasController.text.trim(), "concluida":false});
        _tarefasController.clear();
      });
    }
  }

  // Método para deletar tarefa
  void _deletarTarefa(int index){
    //TODO: delete Tarefa
  if (_tarefas[index]["concluida"] == true) {
    setState(() {
      _tarefas.remove(_tarefas[index]);
    });
  }
  }
}