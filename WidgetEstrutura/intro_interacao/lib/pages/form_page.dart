// Página de Forumário
// Tela com elementos de formulário para interação do usuário
// textField
// checkBox
// radioButton
// slider
// switch => Botão de alternância
// dropdown => Menu suspenso

// form => Ajuda na validação de dados

import 'package:flutter/material.dart';

// Chama as mudanças de estado
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

// Lógica de construção da tela
class _FormPageState extends State<FormPage> {
  // Atributos
  String _nome = "";
  String _email= "";
  String _senha = "";
  String _confirmarSenha = "";
  bool _aceitarTermos = false; // Switch dos termos
  String _sexo = "Feminino"; // Radio (feminino)
  double _idade = 18; // Slider -> Posição 18
  List<String> _interesses = [];
  String _cidade = "Americana"; // Dropdown

  // Esconder senha
  bool _obscureSenha = true;

  // Chave global de validação do formulário
  final formKey = GlobalKey<FormState>(); // Formulário somente será enviado se a chave estiver validada


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de Cadastro"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        // Adicionar elemento e fazer a erificação
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo texto para nome
                TextFormField(
                  decoration: InputDecoration(labelText: "Digite seu Nome...", border: OutlineInputBorder()),
                  onChanged: (value) => setState(() {_nome = value;}),
                  validator: (value) => value!.isEmpty ? "Campo Obrigatório" : null,
                ),
                // Campo Email
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(labelText: "Digite seu Email...", border: OutlineInputBorder()),
                  onChanged: (value) => setState(() {_email = value;}),
                  validator: (value) => value!.contains("@") ? null : "Formato inválido",
                ),
                // Campo Senha
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Digite sua Senha...", 
                    border: OutlineInputBorder(), 
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        _obscureSenha = !_obscureSenha; // Inverter o valor para a booleana
                      }),
                      icon: Icon(_obscureSenha ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  onChanged: (value) => setState(() {_senha = value;}),
                  validator: (value) => value!.length <=6 ? "Senha deve ser maior que 6 caracteres" : null,
                  obscureText: _obscureSenha, // Esconder senha
                  // Ícone para mostrar ou esconder a senha
                ),
                // Campo confirmar senha
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Confirme sua Senha...",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        _obscureSenha = !_obscureSenha;
                      }), 
                      icon: Icon(_obscureSenha ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  onChanged: (value) => setState(() {_confirmarSenha = value;}),
                  validator: (value) => value! != _senha ? "A confirmação deve ser igual a senha" : null,
                  obscureText: _obscureSenha,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}