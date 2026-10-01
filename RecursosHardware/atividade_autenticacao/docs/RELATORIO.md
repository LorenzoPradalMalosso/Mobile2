# Relatório de implementação — Ponto Seguro

## 1. Problema e solução

O Ponto Seguro registra entrada e saída de um colaborador quando a localização do dispositivo está no raio de 100 m do estabelecimento configurado. O acesso é feito por conta local (e-mail e senha) ou biometria do aparelho. Os dados são armazenados em SQLite no próprio dispositivo.

## 2. Funcionalidades

1. **Contas locais**: cadastro e login por e-mail e senha. O banco persiste um salt aleatório e hash SHA-256 da senha, nunca o texto puro.
2. **Biometria**: `local_auth` solicita a confirmação do sistema operacional após primeiro acesso com senha no aparelho. Nenhuma imagem biométrica é capturada pelo app.
3. **Geolocalização**: `geolocator` confere serviço e permissão e captura a localização de alta precisão. `Geolocator.distanceBetween` calcula a distância geodésica até o local; marcações além de 100 m são bloqueadas.
4. **Registro de jornada**: as marcações alternam Entrada/Saída. Cada item guarda instante, coordenadas, distância, observação e caminho opcional de foto.
5. **Câmera**: `image_picker` captura uma foto opcional e `path_provider` a copia ao armazenamento privado do app.
6. **Consulta**: o histórico apresenta até 100 registros por conta; a tela de detalhes exibe hora, observação, foto, coordenadas e mapa OpenStreetMap.
7. **Persistência**: `sqflite` cria e migra `ponto_seguro.db`, com tabelas separadas para contas e registros.

## 3. Arquitetura

A estrutura segue o padrão do projeto `senai_checkin`:

- `models`: entidades `PunchRecord` e `Workplace`.
- `controllers`: validação do raio, determinação do tipo de ponto e coordenação do salvamento.
- `database`: conexão SQLite, schema, migração e consultas por conta.
- `services`: autenticação local, localização, permissões e câmera.
- `views`: login/cadastro de conta, painel, formulário de ponto e detalhes.
- `widgets`: cartão reutilizável para cada registro no histórico.

As dependências principais são Flutter Material, `sqflite`, `path`, `crypto`, `shared_preferences`, `geolocator`, `local_auth`, `image_picker`, `path_provider`, `flutter_map` e `latlong2`.

## 4. Modelo de dados

### Tabela `accounts`

| Campo | Tipo | Uso |
| --- | --- | --- |
| `id` | INTEGER | Chave primária |
| `email` | TEXT | E-mail único por conta |
| `password_salt` | TEXT | Salt aleatório exclusivo |
| `password_hash` | TEXT | Hash SHA-256 de salt e senha |
| `created_at` | TEXT | Data e hora do cadastro |

### Tabela `punches`

| Campo | Tipo | Uso |
| --- | --- | --- |
| `id` | INTEGER | Chave primária |
| `account_id` | TEXT | E-mail da conta proprietária |
| `type` | TEXT | Entrada ou Saída |
| `at` | TEXT | Instante ISO 8601 |
| `latitude`, `longitude` | REAL | Coordenadas do aparelho |
| `distance_meters` | REAL | Distância ao local definido |
| `note` | TEXT | Observação opcional |
| `photo_path` | TEXT | Caminho privado local da foto opcional |

## 5. APIs e hardware

- **Geolocator / Android Location Services**: GPS em primeiro plano com permissão solicitada em contexto.
- **Local Auth / Android BiometricPrompt**: autenticação por mecanismo cadastrado no aparelho.
- **Image Picker / câmera Android**: captura de foto opcional como comprovante.
- **SQLite / sqflite**: contas e marcações em banco local com migração de versão.
- **Flutter Map / OpenStreetMap**: mapa dos pontos; acesso à internet é necessário somente para baixar imagens cartográficas.

## 6. Decisões e desafios

- O projeto fica executável sem conta externa ou arquivo de credenciais; o primeiro uso cria o banco SQLite.
- As permissões de localização e câmera são pedidas no momento em que cada recurso é usado.
- A separação por e-mail da conta no banco evita misturar o histórico de usuários do mesmo aparelho.
- A foto é copiada para o diretório privado do app para não depender do cache temporário da câmera.
- O app comunica erro quando o serviço de localização está desligado, a permissão é negada ou o colaborador está fora do raio.

## 7. Escopo e limitações

Este app é local e didático: não sincroniza registros, não recupera senha por e-mail e não transfere dados entre aparelhos. O hash SHA-256 com salt demonstra armazenamento sem texto puro, mas não substitui autenticação profissional baseada em um servidor com algoritmo de derivação de senha de custo adequado. Em produção, use backend, política de backup/retensão e controles de privacidade.

GPS e relógio são fornecidos pelo dispositivo e podem ser simulados ou alterados. A checagem de raio no cliente não é mecanismo antifraude. A biometria confirma localmente o usuário do aparelho e não substitui uma identidade corporativa verificada.

## 8. Critérios da avaliação

| Competência | Evidência |
| --- | --- |
| Técnica (40%) | SQLite, cadastro/login, biometria, GPS, limite de 100 m, câmera, mapa e arquitetura por camadas. |
| Interface e usabilidade (20%) | Fluxo em português, estados de localização, formulários, histórico e detalhes navegáveis. |
| Criatividade e solução de problemas (20%) | Persistência por conta offline, comprovante fotográfico e mapa de conferência. |
| Documentação (20%) | Este relatório, README e guia de instalação/configuração/uso. |
