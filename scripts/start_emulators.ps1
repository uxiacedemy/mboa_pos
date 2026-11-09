$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$env:ComSpec = 'C:\Windows\System32\cmd.exe'
$node = 'C:\Users\EVERMATE\Downloads\node-v20.20.2-win-x64\node-v20.20.2-win-x64\node.exe'
$npmCli = 'C:\Users\EVERMATE\Downloads\node-v20.20.2-win-x64\node-v20.20.2-win-x64\node_modules\npm\bin\npm-cli.js'
$firebaseCli = 'C:\Users\EVERMATE\Downloads\node-v20.20.2-win-x64\node-v20.20.2-win-x64\node_modules\firebase-tools\lib\bin\firebase.js'

if (-not (Test-Path -LiteralPath $node)) {
  throw "Node executable not found at $node"
}
if (-not (Test-Path -LiteralPath $npmCli)) {
  throw "npm CLI not found at $npmCli"
}
if (-not (Test-Path -LiteralPath $firebaseCli)) {
  throw "Firebase CLI not found at $firebaseCli"
}

Push-Location (Join-Path $repositoryRoot 'functions')
try {
  & 'C:\Users\EVERMATE\Downloads\node-v20.20.2-win-x64\node-v20.20.2-win-x64\node.exe' 'C:\Users\EVERMATE\Downloads\node-v20.20.2-win-x64\node-v20.20.2-win-x64\node_modules\npm\bin\npm-cli.js' 'run' 'build'
  if ($LASTEXITCODE -ne 0) {
    throw "Functions build failed with exit code $LASTEXITCODE."
  }
} finally {
  Pop-Location
}

$portsToClean = 4000, 8080, 9099, 4400, 4500, 9150
$connections = Get-NetTCPConnection -LocalPort $portsToClean -State Listen -ErrorAction SilentlyContinue
$seenPids = @()
foreach ($connection in $connections) {
  $connectionPid = $connection.OwningProcess
  if ($seenPids -contains $connectionPid) {
    continue
  }

  Stop-Process -Id $connectionPid -Force
  Write-Host "Cleaned up port $($connection.LocalPort) (PID $connectionPid)"
  $seenPids += $connectionPid
}

Set-Location $repositoryRoot
& $node $firebaseCli emulators:start `
  --import=./emulator-data `
  --export-on-exit=./emulator-data `
  --project mboapos `
  --only auth,firestore,functions
