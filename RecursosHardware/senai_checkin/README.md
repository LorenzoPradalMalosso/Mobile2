# SENAI Check-in - Registro de ponto e diário de campo com foto e GPS

## 1. Contextualização e Desafio proposto
Em atividades externas, profissionais precisam registrar sua presença e documentar visitas, inspeções e atividades realizadas em diferentes locais. Para tornar esse processo mais confiável e organizado, é necessário utilizar recursos do próprio dispositivo móvel, como GPS e câmera, juntamente com uma forma de armazenamento local dos dados.

## 2. Descrição do Sistema
O **SENAI CheckIn** é um aplicativo mobile desenvolvido em Flutter para realizar registros de presença e atividades em campo. O sistema permite obter a localização atual do usuário por meio do GPS, capturar uma foto utilizando a câmera do dispositivo e adicionar uma observação ao registro.

Os dados, incluindo data e hora, coordenadas geográficas, foto e observação, são armazenados localmente em um banco de dados SQLite. O aplicativo também permite consultar os registros realizados, visualizar suas informações e acessar a localização registrada.

O projeto tem como objetivo demonstrar a integração entre **interface mobile, recursos nativos de hardware, gerenciamento de permissões e persistência de dados local**.

## 3. Tecnologias Utilizadas

- **Flutter** — Framework utilizado para o desenvolvimento do aplicativo mobile.
- **Dart** — Linguagem de programação utilizada no projeto.
- **SQLite** — Banco de dados local para persistência dos registros.
- **sqflite** — Pacote Flutter utilizado para integração com o SQLite.
- **Geolocator** — Pacote utilizado para obtenção da localização por GPS.
- **Image Picker** — Pacote utilizado para captura de imagens pela câmera.
- **Path e Path Provider** — Pacote utilizado para definição de rotas dentro do dispositivo.

## 4. Funcionalidades

- Solicitação e gerenciamento de permissões de câmera e localização.
- Obtenção da localização atual do dispositivo.
- Captura de fotos utilizando a câmera nativa.
- Registro de observações sobre a atividade realizada.
- Registro automático de data e hora.
- Armazenamento dos dados em banco SQLite.
- Listagem dos registros realizados.
- Visualização dos detalhes de cada registro.
- Exibição das fotos associadas aos registros.
- Exibição das coordenadas de latitude e longitude.
- Feedback visual e sonoro após o salvamento de um registro.

## 5. Estrutura do Projeto

```text
lib/
├── main.dart
│
├── models/
│   └── registro.dart
│
├── controllers/
│   ├── registro_controller.dart
│   ├── location_controller.dart
│   └── camera_controller.dart
|
├── views/
│   ├── home_view.dart
│   ├── cadastro_view.dart
│   └── detalhes_view.dart
|
├── database/
│   └── database_helper.dart
│
└── widgets/
    ├── registro_card.dart
    └── ...
```

## 6. Estrutura de Dados

O aplicativo utiliza SQLite para realizar a persistência local dos registros. Dessa forma, os dados permanecem armazenados no dispositivo mesmo após o encerramento do aplicativo.

### Tabela `registros`

| **Campo**     | **Tipo**| **Restrições**                 | **Descrição**                              |
|---------------|---------|--------------------------------|--------------------------------------------|
| `id`          | INTEGER | PRIMARY KEY <br> AUTOINCREMENT | Identificador único do registro            |
| `data_hora`   | TEXT    | NOT NULL                       | Data e hora em que o registro foi realizado|
| `latitude`    | REAL    | NOT NULL                       | Latitude obtida pelo GPS                   |
| `longitude`   | REAL    | NOT NULL                       | Longitude obtida pelo GPS                  |
| `observacao`  | TEXT    | NOT NULL                       | Observação adicionada pelo usuário         |
| `caminho_foto`| TEXT    | NOT NULL                       | Caminho local da foto capturada            |

Cada registro reúne as informações da atividade realizada em campo:

```text
Registro
|
├── Data/Hora│
├── Localização/
│   ├── Latitude
│   ├── Longitude
├── Foto
└── Observação
```

A foto não é armazenada diretamente no banco de dados. O SQLite armazena apenas o **caminho do arquivo**, enquanto a imagem permanece armazenada no armazenamento local do aplicativo.

## 7. Como Executar

### 7.1 Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

- [Flutter](https://docs.flutter.dev/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/)
- Um dispositivo Android físico ou emulador configurado.

### 7.2 Instalação

1. Clone o repositório:

```bash
git clone URL_DO_REPOSITORIO
```

2. Acesse a pasta do projeto:

```bash
cd senai-checkin
```

3. Instale as dependências:

```bash
flutter pub get
```

4. Verifique os dispositivos disponíveis:

```bash
flutter devices
```

5. Exercute o aplicativo:

```bash
flutter run
```

| **Observação:** recomenda-se utilizar um dispositivo físico para testar os recursos de câmera e GPS, pois o comportamento desses recursos pode variar em emuladores.