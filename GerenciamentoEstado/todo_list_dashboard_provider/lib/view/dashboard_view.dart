import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_dashboard_provider/controller/tarefa_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard de Tarefas"),centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        // Consumer => Widget do provider que permite a modificação de estado quando recebe as informações do Controller
        child: Consumer<TarefaController>(
          builder: (context, controller, child){
            return Column(
              children: [
                // Aqui teremos uma lista de Card => com as métricas determinadas no Controller
                // totalTarefas
                _cardDashboard(
                  titulo: "Total de Tarefas",
                  value: controller.totalTarefas.toString(),
                  icon: Icons.list_alt,
                  color: Colors.blue
                ),

                // totalTarefasConcluidas
                _cardDashboard(
                  titulo: "Total de Tarefas concluídas",
                  value: controller.totalTarefasConcluidas.toString(),
                  icon: Icons.check_box,
                  color: Colors.green
                ),

                // totalTarefasPendentes
                _cardDashboard(
                  titulo: "Total de Tarefas pendentes",
                  value: controller.totalTarefasPendentes.toString(),
                  icon: Icons.pending_actions,
                  color: Colors.orange
                ),

                // porcentagemTarefasConcluidas
                _cardDashboard(
                  titulo: "Porcentagem de Tarefas concluídas",
                  value: controller.porcentagemTarefasConcluidas.toString(),
                  icon: Icons.percent,
                  color: Colors.purple
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _cardDashboard({
    required String titulo,
    required String value,
    required IconData icon,
    required Color color
  }){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        // Arredondar canto do retangulo
        borderRadius: BorderRadiusGeometry.circular(12)
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color,),
        ),
        title: Text(titulo, style: TextStyle(fontSize: 16,),),
        trailing: Text(value, style: TextStyle(fontSize: 16, color: color),),
      ),
    );
  }