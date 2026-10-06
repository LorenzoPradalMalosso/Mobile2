# Ponto Seguro

Aplicativo Flutter para registro de jornada com autenticação por NIF/e-mail e senha, opção de biometria do aparelho e validação de geolocalização em um raio de 100 metros. Autenticação e registros são enviados a uma API REST; não há Firebase.

## Executar

1. Em um terminal, inicie a API local: `node api/server.js`.
2. Inicie o app Android pelo script, que valida a API e configura o redirecionamento de porta do emulador:

```bash
powershell -ExecutionPolicy Bypass -File scripts/run_android.ps1
```

O script executa `flutter run`; as dependências são resolvidas automaticamente. Para iniciar manualmente, rode `adb reverse tcp:3000 tcp:3000` e depois `flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000/api`.

A API de exemplo incluída usa apenas Node.js, sem pacotes adicionais. Seus dados são gravados em `api/data.json`.

## Funcionalidades

- Cadastro/login remoto por NIF ou e-mail em `/auth/register` e `/auth/login`.
- Biometria local do sistema para liberar o uso da sessão já autenticada no aparelho.
- Consulta e envio de registros autenticados em `/punches`.
- Captura de GPS e bloqueio a mais de 100 m do local definido em `lib/models/workplace.dart`.
- Histórico, detalhes, mapa OpenStreetMap, observação e foto opcional local.

Veja [relatório técnico](docs/RELATORIO.md) e [instalação, contrato da API e uso](docs/INSTALACAO.md).
