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
import 'package:intro_interacao/widgets/bnb.dart';

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
  List<String> _interesses = []; // Checkbox
  String _cidade = "Americana"; // Dropdown -> Escolha da cidade

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
                  // Operador ternário => Validação se o campo não está vazio
                  validator: (value) => value!.isEmpty ? "Campo Obrigatório" : null,
                ),

                // Campo Email
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(labelText: "Digite seu Email...", border: OutlineInputBorder()),
                  onChanged: (value) => setState(() {_email = value;}),
                  // Verificar se o campo contém o "@"
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
                      // Ícone para visibilidade da senha
                      icon: Icon(_obscureSenha ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  onChanged: (value) => setState(() {_senha = value;}),
                  // Senha > que 6 caracteres
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

                // Radio Button => Sexo
                SizedBox(height: 20,),
                // Forma antiga
                // Row(
                //   children: [
                //     Text("Sexo:"),
                //     SizedBox(width: 5,),
                //     Radio(
                //       value: "Feminino",
                //       groupValue: _sexo,
                //       onChanged: (value) => setState(() =>_sexo = value!),
                //       ),
                //     Text("Feminino"),
                //     SizedBox(width: 5,),
                //     Radio(
                //       value: "Masculino",
                //       groupValue: _sexo,
                //       onChanged: (value) => setState(() =>_sexo = value!),
                //       ),
                //     Text("Masculino"),
                //     SizedBox(width: 5,),
                //     Radio(
                //       value: "Outro",
                //       groupValue: _sexo,
                //       onChanged: (value) => setState(() =>_sexo = value!),
                //       ),
                //     Text("Outro"),
                //   ],
                // ),
                // Radio Versão Nova
                // RadioGroup
                RadioGroup<String>(
                  groupValue: _sexo,
                  onChanged: (String? value)=> setState(()=> _sexo = value!), 
                  child: Row(
                    children: [
                      Text("Sexo:"),
                      SizedBox(width: 5,),
                      Radio(value: "Feminino"),
                      Text("Feminino"),
                      SizedBox(width: 5,),
                      Radio(value: "Masculino"),
                      Text("Masculino"),
                      SizedBox(width: 5,),
                      Radio(value: "Outro"),
                      Text("Outro"),
                    ],
                  ),
                ),

                // Slider para seleção da idade
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text("Idade: ${_idade.toInt()}"), // Exibir a idade selecionada
                    Expanded(
                      child: Slider(
                        value: _idade, 
                        onChanged: (value)=> setState(() => _idade = value,),
                        min: 0, // Valor mínimo do slider
                        max: 100, // Valor máximo do slider
                        divisions: 100, // Nº de divisões do slider
                        label: _idade.toInt().toString(),
                      ),
                    ),
                  ],
                ),

                // CheckBox para selecionar interesses
                SizedBox(height: 20,),
                Column(
                  children: [
                    Text("Interesses Pessoais:"),
                    // 1º linha de interesses
                    Row(
                      children: [
                        // 1º CheckBox
                        Checkbox(
                          value: _interesses.contains("Cinema"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Cinema") : _interesses.remove("Cinema");
                          }),
                        ),
                        Text("Cinema"),
                        SizedBox(width: 5,),
                        //2º CheckBox
                        Checkbox(
                          value: _interesses.contains("Esporte"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Esporte") : _interesses.remove("Esporte");
                          }),
                        ),
                        Text("Esporte"),
                        SizedBox(width: 5,),
                        // 3° CheckBox
                        Checkbox(
                          value: _interesses.contains("Teatro"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Teatro") : _interesses.remove("Teatro");
                          }),
                        ),
                        Text("Teatro"),
                      ],
                    ),
                    // 2º linha de interesses
                    Row(
                      children: [
                        // 1º CheckBox
                        Checkbox(
                          value: _interesses.contains("Música"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Música") : _interesses.remove("Música");
                          }),
                        ),
                        Text("Música"),
                        SizedBox(width: 5,),
                        //2º CheckBox
                        Checkbox(
                          value: _interesses.contains("Viagens"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Viagens") : _interesses.remove("Viagens");
                          }),
                        ),
                        Text("Viagens"),
                        SizedBox(width: 5,),
                        // 3° CheckBox
                        Checkbox(
                          value: _interesses.contains("VideoGame"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("VideoGame") : _interesses.remove("VideoGame");
                          }),
                        ),
                        Text("VideoGame"),
                      ],
                    ),
                  ],
                ),

                // Dropdown cidades
                SizedBox(height: 20,),
                Text("Cidade"),
                DropdownButtonFormField(
                  // Criar uma borda na caixa de dropdown
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  // items: [
                  //   DropdownMenuItem(child: Text("Americana"), value: "Americana",),
                  //   DropdownMenuItem(child: Text("Campinas"), value: "Campinas",),
                  //   DropdownMenuItem(child: Text("Nova Odessa"), value: "Nova Odessa",),
                  //   DropdownMenuItem(child: Text("Santa Bárbara d'Oeste"), value: "Santa Bárbara d'Oeste",),
                  //   DropdownMenuItem(child: Text("Sumaré"), value: "Sumaré",),
                  //   DropdownMenuItem(child: Text("Piracicaba"), value: "Piracicaba",),
                  //   DropdownMenuItem(child: Text("Outra"), value: "Outra",),
                  // ],

                  // Usando map
                  items: [
                    "Americana", 
                    "Campinas", 
                    "Nova Odessa", 
                    "Santa Bárbara d'Oeste", 
                    "Sumaré", 
                    "Piracicaba",
                    "Outra"
                  ]
                  .map(
                    (cidade) => DropdownMenuItem(
                      value: cidade, 
                      child: Text(cidade),
                    )
                  ).toList(),
                  onChanged: (value) => setState(() => _cidade = value!),
                ),

                // Switch para aceitar os termos de uso
                Row(
                  children: [
                    Switch(
                      value: _aceitarTermos, 
                      onChanged: (bool value) => setState(() => _aceitarTermos = value,),
                    ),
                    Text("Aceitar Termos de Uso"),
                  ],
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () => _enviarFormulario(), 
                  child: Text("Enviar Formulário"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bnb(context),
    );
  }

  void _enviarFormulario() {
    // Verificar os termos do formulário (validação)
    // Mostrar um AlertDialog (modal de alerta)
    if(formKey.currentState!.validate() && _aceitarTermos){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: Text("Dados do Formulário"),
          content: SingleChildScrollView(
            // Permite a rolagem do modal
            child: ListBody(
              children: [
                Text("Nome: $_nome"),
                Text("Email: $_email"),
                Text("Senha: $_senha"),
                Text("Sexo: $_senha"),
                Text("Idade: ${_idade.toInt()}"),
                Text("Interesses: ${_interesses.join(", ")}"),
                Text("Cidade: $_cidade"),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                
                // Sem arrow function para fazer várias ações
                // Limpar as respostas
                setState(() {
                  _nome = "";
                  _email = "";
                  _senha = "";
                  _confirmarSenha = "";
                  _sexo = "Feminino";
                  _idade = 18;
                  _interesses = [];
                  _cidade = "Americana";
                  _aceitarTermos = false; // Reseta a validação do formulário
                });
                Navigator.popAndPushNamed(context, "/");
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    }
  }
}