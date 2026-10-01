# Instalação e uso — Ponto Seguro

## Requisitos

- Flutter SDK e Dart compatíveis com Dart 3.13 ou superior.
- Android Studio com Android SDK e emulador ou aparelho Android.
- Para testar a biometria, aparelho com bloqueio de tela e biometria cadastrada.
- Para carregar o mapa, acesso à internet. Cadastro, login e ponto usam SQLite local.

## Instalar e executar

No diretório do projeto, execute:

```bash
flutter pub get
flutter run
```

Escolha um emulador ou conecte um aparelho Android com depuração USB. O projeto não requer conta de nuvem, arquivo de credenciais nem configuração de serviço externo para autenticação ou banco.

## Primeiro acesso

1. Na tela inicial, escolha **Criar nova conta**.
2. Informe um e-mail válido e uma senha com no mínimo seis caracteres; confirme a senha.
3. Depois do cadastro, a conta fica guardada no banco `ponto_seguro.db` dentro do armazenamento privado do app.
4. Nos próximos acessos, entre com e-mail e senha. O app também oferece autenticação biométrica local após o primeiro login neste aparelho.
5. A autenticação biométrica usa o Android BiometricPrompt. O app não captura nem armazena imagem do rosto ou impressão digital.

Não há recuperação de senha por e-mail porque o sistema é inteiramente local. Os dados não são sincronizados nem recuperáveis em outro aparelho. Remover os dados ou desinstalar o app pode apagar o banco SQLite e as fotos privadas.

## Configurar local de trabalho

Edite `lib/models/workplace.dart` e altere `workplace` (nome, endereço, latitude e longitude). `radiusMeters` define a tolerância, inicialmente 100 m. Use coordenadas verificadas do local.

No emulador Android, abra **Extended controls > Location**, informe as coordenadas do local e envie a localização. Em aparelho físico, conceda permissão de localização e esteja próximo ao ponto cadastrado.

## Registrar e consultar um ponto

1. No painel, atualize a localização para ver a distância aproximada.
2. Toque em **Registrar Entrada** ou **Registrar Saída**.
3. Escreva uma observação se desejar e tire uma foto opcional.
4. Toque em **Confirmar ponto**. O app pede localização e bloqueia a marcação se estiver a mais de 100 m.
5. Selecione um item no histórico para ver hora, distância, observação, coordenadas, foto e mapa.

Os registros incluem tipo, data/hora, latitude, longitude, distância, observação, caminho local da foto e conta proprietária. Cada conta consulta apenas seus próprios registros no SQLite.

## Banco SQLite

O banco é criado automaticamente no primeiro uso do app:

- `accounts`: e-mail único, salt, hash da senha e data de criação.
- `punches`: tipo, data/hora, coordenadas, distância, observação e caminho da foto.

O schema é gerenciado por `lib/database/database_helper.dart` e usa migração de versão. Senhas não são gravadas em texto simples. Para limpar os dados durante o desenvolvimento, limpe o armazenamento do app/emulador ou desinstale e instale novamente.

## Permissões Android

O `AndroidManifest.xml` declara internet para os tiles do mapa, localização aproximada/precisa, câmera opcional e biometria. A localização é solicitada ao verificar ou registrar um ponto; a câmera é aberta somente quando o usuário pede uma foto. Se uma permissão for negada, habilite-a em **Configurações > Aplicativos > Ponto Seguro > Permissões**.

## Validação

```bash
flutter pub get
flutter analyze
flutter run
```

## Limitações

O banco pertence à instalação local: não existe sincronização entre usuários/dispositivos nem backup automático. A senha local usa hash com salt, mas este armazenamento é adequado ao protótipo didático; uma implantação multiusuário deve usar um servidor com autenticação e banco remoto. Coordenadas e horário vêm do dispositivo e podem ser falsificados. A validação por GPS não é antifraude.
