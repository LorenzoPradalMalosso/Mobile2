// screens/tela_inicial.dart
// RF-001: Tela de apresentação do FitLife
// Exibe nome, slogan, ilustração e botão "Começar" → navega para TelaPrivincipal

import 'package:flutter/material.dart';
import 'tela_principal.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Fundo gradiente verde → fundo do tema
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // ── Ilustração fitness ────────────────────────────────────────
                Container(
                  width: size.width * 0.55,
                  height: size.width * 0.55,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    size: size.width * 0.28,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 40),

                // ── Nome do aplicativo ────────────────────────────────────────
                Text(
                  'FitLife',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Slogan ────────────────────────────────────────────────────
                Text(
                  'Sua jornada fitness começa aqui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withOpacity(0.65),
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Mensagem de boas-vindas ───────────────────────────────────
                Text(
                  'Olá, usuário!\nPreparado para começar essa jornada?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.5),
                    height: 1.6,
                  ),
                ),

                const Spacer(flex: 2),

                // ── Botão Começar ─────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega para TelaPrivincipal substituindo a pilha (sem voltar)
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const TelaPrincipal()),
                      );
                    },
                    child: const Text('Começar!'),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}