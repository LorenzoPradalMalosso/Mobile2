# Relatório de implementação — Ponto Seguro

## Objetivo e solução

O Ponto Seguro é um app Flutter para registrar entrada e saída de jornada dentro de 100 m do local de trabalho. A autenticação e persistência são feitas por uma API REST configurável; o projeto não usa Firebase nem banco local para contas ou marcações.

## Funcionalidades

- Cadastro e login por NIF/e-mail e senha via endpoints REST.
- Biometria via `local_auth` para liberar a sessão autenticada no próprio aparelho.
- Permissão e leitura de localização pelo `geolocator`; cálculo da distância até as coordenadas configuradas em `workplace.dart`; envio bloqueado fora do raio.
- Histórico remoto e criação de registro com tipo, data/hora, latitude, longitude, distância e observação.
- Foto opcional capturada pela câmera e guardada no diretório privado do app; não é enviada à API nesta versão.
- Tela de detalhes com coordenadas e mapa OpenStreetMap.

## Arquitetura

- `models`: entidades de local de trabalho e registro.
- `services/api_service.dart`: cliente HTTP, token Bearer, autenticação e operações de registro.
- `services/auth_service.dart`: validações do formulário e tradução de erros de autenticação.
- `services/location_service.dart` e `permission_service.dart`: permissões e leitura do GPS.
- `controllers/ponto_controller.dart`: regra de raio, alternância Entrada/Saída e coordenação com API.
- `views`: login/cadastro, painel, formulário e detalhes.
- `widgets`: apresentação de cada registro no histórico.

## Integração REST

A URL base vem de `--dart-define=API_BASE_URL=...`. O cliente espera `POST /auth/register`, `POST /auth/login`, `GET /punches` e `POST /punches`. Cadastro/login retornam `token` (ou `access_token`) e opcionalmente `user` com `id` e `email`. Chamadas protegidas enviam `Authorization: Bearer <token>`. O formato completo de payloads e respostas está em [INSTALACAO.md](INSTALACAO.md).

O servidor precisa persistir contas e registros, verificar credenciais, emitir e validar tokens e derivar a identidade do usuário autenticado no endpoint de marcação. O app não confia no identificador de usuário enviado pelo cliente para definir o proprietário do ponto.

## Decisões e limitações

- A regra de 100 m é conferida no cliente para resposta imediata; o servidor também deve validá-la antes de aceitar um ponto.
- A biometria é uma confirmação local do sistema operacional, não um método enviado ao servidor. A sessão existente é mantida localmente para permitir esse fluxo.
- O token usa `shared_preferences` neste protótipo. Uma implantação real deve usar armazenamento protegido e HTTPS.
- `api/server.js` é um backend didático local, sem dependências externas, que grava os dados em arquivo JSON. Tokens ficam em memória e são invalidados quando o processo reinicia; em produção, substitua por um serviço hospedado com banco durável e gestão segura de sessões.
- Fotos são armazenadas localmente e não sincronizam entre dispositivos.
- Horário e localização são fornecidos pelo aparelho e podem ser adulterados; o aplicativo é didático e não constitui controle antifraude trabalhista.

## Critérios de avaliação

| Competência | Evidência |
| --- | --- |
| Técnica (40%) | API REST para autenticação e registros, biometria local, GPS, raio de 100 m e arquitetura em camadas. |
| Interface e usabilidade (20%) | Fluxo em português, feedback de permissões/localização, histórico e detalhes navegáveis. |
| Criatividade e solução de problemas (20%) | Mapa, comprovante fotográfico opcional e integração com serviço externo. |
| Documentação (20%) | Este relatório, README e guia de configuração da API e execução. |
