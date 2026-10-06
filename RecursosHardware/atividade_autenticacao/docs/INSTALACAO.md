# Instalação e uso

## Requisitos

- Flutter/Dart compatíveis com `pubspec.yaml`.
- Android Studio, SDK e emulador ou aparelho Android.
- Node.js 18 ou superior para executar a API de exemplo incluída, ou outra API compatível.
- Localização ativa; para biometria, aparelho com bloqueio e biometria cadastrados.

## Iniciar a API incluída

Na raiz do projeto, abra um terminal e mantenha este processo em execução:

```bash
node api/server.js
```

O servidor escuta na porta 3000 em todas as interfaces e grava contas e pontos em `api/data.json`. Confirme que está ativo abrindo `http://localhost:3000/api/health` no computador; deve responder `{"status":"ok"}`. Se o Windows Firewall perguntar, permita acesso na rede privada para testar em um aparelho físico.

## Configurar o endereço no app

Defina a URL base na inicialização. Exemplo de servidor local na porta 3000:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

Para o Android Emulator, encaminhe a porta do computador ao emulador e use `127.0.0.1` dentro do app. Na raiz do projeto, em outro terminal, execute:

```powershell
adb reverse tcp:3000 tcp:3000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000/api
```

Ou use `powershell -ExecutionPolicy Bypass -File scripts/run_android.ps1`, que verifica a API e configura esse encaminhamento antes de iniciar o Flutter. Isso evita bloqueios de firewall no endereço `10.0.2.2`. Em aparelho físico, use o IP local do computador, mantenha ambos na mesma rede e configure esse endereço em `API_BASE_URL`. Para outro servidor, passe a URL base, por exemplo `https://servidor.exemplo.com/api`.

O app espera este contrato JSON (os caminhos são relativos à URL base):

| Método e caminho | Requisição | Resposta esperada |
| --- | --- | --- |
| `POST /auth/register` | `{"identifier":"NIF ou e-mail","email":"... (se for e-mail)","password":"..."}` | `{"token":"...","user":{"id":"...","identifier":"...","email":"..."}}` |
| `POST /auth/login` | Mesmo formato do cadastro | Mesmo formato do cadastro |
| `GET /punches` | Cabeçalho `Authorization: Bearer <token>` | `{"records":[{"id":1,"type":"Entrada","at":"2026-10-06T12:00:00Z","latitude":-23.56,"longitude":-46.65,"distance_meters":25,"note":""}]}` |
| `POST /punches` | Token Bearer e objeto de registro | Registro criado ou `{"record":{...}}` |

Erros HTTP podem retornar `{"message":"descrição"}`. O backend deve associar cada marcação ao usuário do token, validar os dados e persistir os registros. Os formatos de listas também aceitam chaves `punches`/`data`; os itens aceitam `timestamp`, `created_at`, `lat`, `lng`, `lon` e `distance` como nomes equivalentes.

## Instalar e iniciar o app

```bash
flutter pub get
adb reverse tcp:3000 tcp:3000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000/api
```

## Primeiro acesso e ponto

1. Crie uma conta ou entre com NIF/e-mail e senha. A API valida as credenciais e devolve um token.
2. A biometria do sistema pode liberar a sessão já autenticada neste aparelho. Após sair, o token é apagado e é necessário entrar novamente com senha.
3. Edite `lib/models/workplace.dart` para configurar nome e coordenadas do local. A tolerância está definida como 100 m.
4. No painel, atualize a localização e selecione **Registrar Entrada/Saída**. O app bloqueia o envio quando a distância passa de 100 m.
5. O registro contém tipo, instante, coordenadas, distância e observação. A foto é opcional e permanece no armazenamento privado do aparelho.
6. O histórico vem de `GET /punches`; toque em um item para ver detalhes e mapa.

## Permissões Android e rede

O manifesto declara internet, localização aproximada/precisa, câmera e biometria. As permissões de localização e câmera são solicitadas quando os recursos são usados. Para desenvolvimento local por HTTP, o app permite tráfego sem TLS; use HTTPS e remova essa permissão de tráfego claro para distribuição real. A API de produção deve validar token e autorização no servidor.

## Limitações

A API incluída é um servidor didático para desenvolvimento local; tokens ficam em memória e são invalidados quando o servidor reinicia. Para usar uma API externa, implemente o contrato acima e passe a URL dela. O token de sessão fica nas preferências locais para permitir biometria e deve ser protegido com armazenamento seguro em produção. Foto e marcação são enviadas separadamente: a imagem não é carregada para a API neste protótipo. A checagem do raio ocorre no cliente; produção deve repetir a validação no servidor. GPS e horário do aparelho podem ser simulados.
