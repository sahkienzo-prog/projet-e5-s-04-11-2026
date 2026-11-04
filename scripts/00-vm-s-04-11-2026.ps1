$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
multipass launch 24.04 --name e5-s-04-11-2026 --cpus 6 --memory 10G --disk 35G
if ($LASTEXITCODE -ne 0) { throw 'Creation de la VM impossible' }
multipass transfer --recursive . e5-s-04-11-2026:/home/ubuntu/projet-e5-s-04-11-2026
if ($LASTEXITCODE -ne 0) { throw 'Transfert impossible' }
multipass exec e5-s-04-11-2026 -- bash -lc 'cd /home/ubuntu/projet-e5-s-04-11-2026 && bash scripts/01-installer-s-04-11-2026.sh'
