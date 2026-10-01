# Ponto Seguro

Aplicativo Flutter de registro de jornada com contas locais, autenticação biométrica do aparelho, verificação de GPS em um raio de 100 m, observação, foto opcional e histórico com mapa. Os dados de conta e ponto são persistidos no banco SQLite local (`sqflite`). O app funciona sem internet para cadastro, login e registros; o mapa precisa de conexão para carregar as imagens cartográficas.

## Executar

```bash
flutter pub get
flutter run
```

Crie uma conta com e-mail e senha no primeiro acesso. Senhas precisam ter pelo menos 6 caracteres. Para testar uma marcação, edite as coordenadas em `lib/models/workplace.dart` e configure o emulador Android para essa posição ou aproxime um aparelho do local cadastrado.

## Estrutura

```text
lib/
├── main.dart
├── models/       # conta e registro de ponto
├── controllers/  # regra de distância e alternância Entrada/Saída
├── database/     # schema e operações SQLite
├── services/     # autenticação local, GPS, permissões e câmera
├── views/        # login, painel, cadastro e detalhes
└── widgets/      # cartão reutilizável do histórico
docs/             # relatório e guia de uso/configuração
```

## Recursos

- Cadastro e login locais por e-mail e senha; senha armazenada como hash com salt aleatório.
- Login biométrico local após o primeiro acesso por senha.
- GPS com solicitação de permissão e bloqueio quando a distância supera 100 m.
- Entrada/saída alternadas, observação e comprovante fotográfico opcional.
- SQLite para contas e registros, isolados por conta; até 100 registros no histórico.
- Tela de detalhes com data, coordenadas e mapa OpenStreetMap.

Veja [o relatório técnico](docs/RELATORIO.md) e [o guia de instalação e uso](docs/INSTALACAO.md).

## Escopo de segurança

SQLite mantém os dados neste aparelho; contas não são compartilhadas entre dispositivos e não existe recuperação de senha por e-mail. A biometria é verificada pelo sistema operacional. O GPS e o relógio são fornecidos pelo dispositivo e podem ser simulados ou alterados; este app é um protótipo didático, não um sistema antifraude para uso trabalhista real.
