import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Paleta de cores frias – azul escuro como principal
    const Color primaryDarkBlue = Color(0xFF0D47A1);
    const Color bgColor = Color(0xFFE3F2FD); // azul muito claro
    const Color cardColor = Color(0xFFBBDEFB); // azul claro para cartões
    const Color darkText = Color(0xFF0D47A1); // texto escuro em azul

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          backgroundColor: bgColor,
        ).copyWith(primary: primaryDarkBlue, secondary: Color(0xFF81D4FA)),
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryDarkBlue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Meu Perfil",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: _buildCircularIconButton(
              Icons.arrow_back_ios_new,
              size: 20,
              iconColor: Colors.white,
              borderColor: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: _buildCircularIconButton(
                Icons.edit_document,
                iconColor: Colors.white,
                borderColor: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- SEÇÃO DE PERFIL ---
              const CircleAvatar(
                radius: 65,
                backgroundColor: primaryDarkBlue, // azul escuro primário
                child: Icon(
                  Icons.person,
                  size: 90,
                  color: Color(0xFFBBDEFB), // azul claro para o ícone
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Lorenzo Pradal Malosso",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const Text(
                "lpmalosso@gmail.com",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 15),
              const Divider(color: Colors.black38, thickness: 1),
              const SizedBox(height: 15),

              // --- SEÇÃO DE ESTATÍSTICAS (XXX) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard("582", "Seguidores", cardColor),
                    _buildStatCard("276", "Seguindo", cardColor),
                    _buildStatCard("23", "Projetos", cardColor),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- SEÇÃO DE DETALHES (Habilidade, Empresa, etc) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Habilidade: Desenvolvedor Web"),
                      _buildDetailRow("Experiência: 7 anos"),
                      _buildDetailRow("Empresa: Teksana Tecidos"),
                      _buildDetailRow("Localização: São Paulo, Brasil"),
                      _buildDetailRow("Contato: lpmalosso@gmail.com"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- SEÇÃO "SOBRE LORENZO" ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height:
                      200, // Altura fixa para simular a área de texto com scroll
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sobre Lorenzo:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: darkText,
                                    height: 1.4,
                                    fontFamily:
                                        'Poppins', // Mantendo a fonte base
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "Sou um estudante e entusiasta da área de tecnologia, com interesse em desenvolvimento de software, robótica e análise de dados. Tenho experiência com linguagens como ",
                                    ),
                                    TextSpan(
                                      text: "JavaScript, Java e Python",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ", além do desenvolvimento de aplicações com ",
                                    ),
                                    TextSpan(
                                      text: "Flutter",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ".\n\nParticipei de projetos e competições tecnológicas como ",
                                    ),
                                    TextSpan(
                                      text: "RoboCup",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: " e "),
                                    TextSpan(
                                      text: "FLL",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " (First Lego League), onde desenvolvi habilidades em programação, resolução de problemas e trabalho em equipe. Também desenvolvo projetos práticos durante minha formação no SENAI, buscando aplicar conhecimento técnico em soluções reais.",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- SEÇÃO DE REDES SOCIAIS ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: cardColor, // Faixa cinza mais escura
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Usando ícones genéricos padrão do Flutter
                    Icon(
                      Icons.work_outline,
                      size: 28,
                      color: primaryDarkBlue,
                    ), // LinkedIn equiv.
                    Icon(
                      Icons.code,
                      size: 28,
                      color: primaryDarkBlue,
                    ), // GitHub equiv.
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 28,
                      color: primaryDarkBlue,
                    ), // Instagram equiv.
                    Icon(
                      Icons.mail_outline,
                      size: 28,
                      color: primaryDarkBlue,
                    ), // Email
                    Icon(
                      Icons.phone_outlined,
                      size: 28,
                      color: primaryDarkBlue,
                    ), // Telefone
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 28,
                      color: primaryDarkBlue,
                    ), // Twitch equiv.
                  ],
                ),
              ),

              const SizedBox(
                height: 40,
              ), // Espaçamento extra para a barra inferior flutuante
            ],
          ),
        ),

        // --- BARRA DE NAVEGAÇÃO INFERIOR ---
        bottomNavigationBar: BottomAppBar(
          color: primaryDarkBlue,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularIconButton(
                  Icons.search,
                  isBottomNav: true,
                  iconColor: cardColor,
                  borderColor: cardColor,
                ),
                _buildCircularIconButton(
                  Icons.favorite_border,
                  isBottomNav: true,
                  iconColor: cardColor,
                  borderColor: cardColor,
                ),
                const SizedBox(width: 48), // Espaço para o botão Home
                _buildCircularIconButton(
                  Icons.notifications_none,
                  isBottomNav: true,
                  iconColor: cardColor,
                  borderColor: cardColor,
                ),
                _buildCircularIconButton(
                  Icons.settings_outlined,
                  isBottomNav: true,
                  iconColor: cardColor,
                  borderColor: cardColor,
                ),
              ],
            ),
          ),
        ),

        // Botão Home Centralizado
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryDarkBlue, // Fundo cinza
              border: Border.all(color: cardColor, width: 1.5), // Borda fina
            ),
            child: const Icon(Icons.home_outlined, color: cardColor, size: 32),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // ===========================================================================
  // MÉTODOS AUXILIARES
  // ===========================================================================

  // Botões circulares com borda usados na AppBar e na BottomBar
  Widget _buildCircularIconButton(
    IconData icon, {
    double size = 24,
    bool isBottomNav = false,
    Color iconColor = Colors.black87,
    Color borderColor = Colors.black87,
  }) {
    return Container(
      margin: isBottomNav ? const EdgeInsets.only(top: 8) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: size, color: iconColor),
        onPressed: () {},
        padding: const EdgeInsets.all(8),
        constraints:
            const BoxConstraints(), // Reduz o padding padrão do IconButton
      ),
    );
  }

  // Cards da seção Seguidores / Seguindo / Projetos
  Widget _buildStatCard(String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Linhas da seção de detalhes (Habilidade, Empresa, etc)
  Widget _buildDetailRow(String title, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.black87, thickness: 1, height: 1),
          ),
      ],
    );
  }
}
