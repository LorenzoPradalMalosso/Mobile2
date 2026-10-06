$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$health = Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/health' -TimeoutSec 3
if ($health.status -ne 'ok') {
  throw 'A API não respondeu corretamente em http://127.0.0.1:3000. Inicie-a com: node api/server.js'
}

adb reverse tcp:3000 tcp:3000
if ($LASTEXITCODE -ne 0) { throw 'Não foi possível configurar adb reverse. Confirme que o emulador está iniciado e conectado.' }

flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000/api
