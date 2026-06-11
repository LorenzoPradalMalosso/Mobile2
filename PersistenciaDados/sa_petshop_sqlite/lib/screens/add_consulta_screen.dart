// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_petshop_sqlite/controllers/consulta_controller.dart';
import 'package:sa_petshop_sqlite/models/consulta_model.dart';
import 'package:sa_petshop_sqlite/models/pet_model.dart';
import 'package:sa_petshop_sqlite/screens/pet_detail_screen.dart';

class AddConsultaScreen extends StatefulWidget {
  final Pet pet; //levar a informação do pet selecionado na tela anterior
  const AddConsultaScreen({super.key, required this.pet});

  @override
  State<AddConsultaScreen> createState() => _AddConsultaScreenState();
}

class _AddConsultaScreenState extends State<AddConsultaScreen> {
  //FORMULÁRIO DE CADASTRO DE SERVIÇO
  final _formKey = GlobalKey<FormState>(); //pemite as validaç~eos do formulário
  final _consultaController = ConsultaController(); // Permite a conexão com o BD

  late String _tipoServico;
  late String _observacao;
  DateTime _selectedDate = DateTime.now(); // Pego o dia atual
  TimeOfDay _selectedTime = TimeOfDay.now(); // Pega a hora atual

  // Método para abrir a seleção de Data
  void _dataSelecionada(BuildContext context) async {
    // Permite abrir um calendário na tela
    final DateTime? picked = await showDatePicker(
      context: context, 
      firstDate: DateTime.now(), //Não permite agendamento de data anterior ao dia atual 
      lastDate: DateTime(2027)
    );
    if(picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked; // Modifica a _selectedDate para a Data selecionada
      });
    }
  }

  // Método para abrir a seleção de Hora
  void _horaSelecionada (BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: _selectedTime
    );
    if(picked != null && picked != _selectedTime){
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Método para salvar a consulta/serviço
  void _salvarConsulta() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save(); //Salva os Valores do Formulário

      //Correção de Data para banco de dados, para o formato ISO8601
      final DateTime dataFinal = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute
      );

      final newConsulta = Consulta(
        petId: widget.pet.id!,
        tipoServico: _tipoServico,
        dataHora: dataFinal.toIso8601String(),
        //ternario para o campo de observação
        observacoes: _observacao.isEmpty ? "Sem Observações" : _observacao
      );
     
      
      try {
        await _consultaController.salvaConsulta(newConsulta);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Agendamento Feito com Sucesso"))
        );
        Navigator.push(context, 
          MaterialPageRoute(builder: (context)=>PetDetailScreen(pet: widget.pet)));
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formatar a data e hora para padrão Brasileiro

    final DateFormat dataFormatada = DateFormat("dd/mm/yyyy");
    final DateFormat horaFormatada = DateFormat("hh:mm");
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Agendamento"),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      // formulário para cadastrar consulta
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "tipo de Serviço"),
              validator: (value) => value!.isEmpty ? "Campo deve Ser Preenchido" : null,
              onSaved: (newValue) => _tipoServico = newValue!,
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: Text("Data: ${dataFormatada.format(_selectedDate)}")),
                TextButton(onPressed: ()=>_dataSelecionada(context), child: Text("Selecionar Data"))
              ],
            ),
            Row(
              children: [
                Expanded(child: Text("Data: ${horaFormatada.format(
                  DateTime(0,0,0,_selectedTime.hour,_selectedTime.minute))}")),
                TextButton(onPressed: ()=>_horaSelecionada(context), child: Text("Selecionar Hora"))
              ],
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(labelText: "Observação"),
              maxLines: 3,
              onSaved: (newValue) => _observacao=newValue!,
            ),
            ElevatedButton(onPressed: _salvarConsulta, child: Text("Agendar Atendimento"))
            
          ],
        )
      ),
      )
    );
  }
}