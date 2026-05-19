// Página de exibição das notas

import 'package:exemplo_sqflite/nota_dbhelper.dart';
import 'package:exemplo_sqflite/nota_model.dart';
import 'package:flutter/material.dart';

class NotaPage extends StatefulWidget{
  const NotaPage({super.key});

  @override
  State<NotaPage> createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {

  // Instanciar DBHelper
  final NotaDbhelper _dbhelper = NotaDbhelper();
  // Toda vez que precisar de conexão com o banco, usar o dbhelper

  // Atributos
  List<Nota> _notas = [];
  bool _isLoading = true; // Usar como indicador de conexão com o DB

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  // Carregar as notas para o vetor
  void _carregarNotas() async {
    setState(() {
      _isLoading = true;
    });
    // Chamar o método read
    _notas = [];
    _notas = await _dbhelper.getNotas(); // Carregar as notas para a Lista
    setState(() {
      _isLoading = false;
    });
  }

  // Criar nota no DB
  void _addNota() async {
    Nota novaNota = Nota(titulo: "Nota ${DateTime.now()}", conteudo: "Conteúdo da Nota");
    _dbhelper.create(novaNota);
    _carregarNotas();
  }

  // Delete Nota
  void _deleteNota(int id) async {
    _dbhelper.deleteNota(id);
    _carregarNotas();
  }

  // Update Nota
  void _updateNota (Nota nota) async {
    Nota notaAtualizada = Nota(
      id: nota.id,
      titulo: "${nota.titulo} (editado)",
      conteudo: nota.conteudo);
    _updateNota(notaAtualizada);
    // Criar um alertDialog para atualizar conta
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Atualizar Nota"),
          content: TextField(
            controller: TextEditingController(text: nota.conteudo),
            onChanged: (value){
              notaAtualizada = Nota(id: nota.id, titulo: nota.titulo, conteudo: value);
            },
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                _dbhelper.updateNota(notaAtualizada);
                _carregarNotas();
              }, 
              child: Text("Atualizar"))
          ],
        );
      }
    );
  }



  // Criar o build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Notas"),),
      body: _isLoading ? Center(
        child: CircularProgressIndicator()
      ) : ListView.builder(
        itemCount: _notas.length,
        itemBuilder: (context,index){
          final nota = _notas[index];
          return ListTile(
            title: Text(nota.titulo),
            subtitle: Text(nota.conteudo),
            trailing: IconButton(
              onPressed: () => _deleteNota(nota.id!), 
              icon: Icon(Icons.delete, color: Colors.red,)
            ),
            onLongPress: () => _updateNota(nota),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNota,
        tooltip: "Adicionar Nota",
        child: Icon(Icons.add, color: Colors.green,),
      ),
    );
  }
}