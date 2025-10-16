<#
Build-Autopsy-TestImage.ps1  (v3.1)
- Crée un VHD NTFS (DiskPart), le peuple avec artefacts DFIR, puis le détache.
- Compatible Windows PowerShell 5.1 (pas de -AsByteStream).
#>

[CmdletBinding()]
param(
  [Parameter()][string]$OutDir = "$PWD\output",
  [Parameter()][int]$VhdSizeMB = 200,
  [Parameter()][string]$VhdName = "TRAINING.vhd",
  [Parameter()][string]$VolLabel = "TRAINING",
  [Parameter()][char]$DriveLetter = 'Z'
)

try { [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false) } catch {}
$ProgressPreference = 'SilentlyContinue'
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Admin {
  $id = [Security.Principal.WindowsIdentity]::GetCurrent()
  $p  = New-Object Security.Principal.WindowsPrincipal($id)
  if (-not $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Exécute ce script en Administrateur.'
  }
}

function Run-DiskPartScript {
  param([string[]]$Lines)
  $tmp = [System.IO.Path]::GetTempFileName()
  try {
    [System.IO.File]::WriteAllLines($tmp, $Lines, [System.Text.Encoding]::ASCII) # CRLF ASCII pour DiskPart
    $res = & diskpart /s $tmp 2>&1
    if ($LASTEXITCODE -ne 0) {
      Write-Host $res
      throw "DiskPart a échoué (code $LASTEXITCODE)."
    }
    return $res
  } finally {
    try { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue } catch {}
  }
}

function New-VhdNtfs {
  param(
    [string]$FilePath,
    [int]$SizeMB,
    [string]$Label,
    [char]$Letter
  )
  if ([string]::IsNullOrWhiteSpace($FilePath)) { throw 'FilePath vide.' }
  if (Test-Path -LiteralPath $FilePath) { Remove-Item -LiteralPath $FilePath -Force }

  $script = @(
    "create vdisk file=""$FilePath"" maximum=$SizeMB type=fixed",
    "attach vdisk",
    "create partition primary",
    "format fs=ntfs quick label=""$Label""",
    "assign letter=$Letter",
    "exit"
  )
  $out = Run-DiskPartScript -Lines $script
  $root = "$Letter`:"
  if (-not (Test-Path -LiteralPath $root)) {
    throw "Le lecteur $root n'est pas monté. Sortie DiskPart:`n$out"
  }
  return $root
}

function Dismount-Vhd {
  param([string]$FilePath)
  if (Test-Path -LiteralPath $FilePath) {
    Run-DiskPartScript -Lines @(
      "select vdisk file=""$FilePath""",
      "detach vdisk",
      "exit"
    ) | Out-Null
  }
}

function New-FakeLnk {
  param(
    [string]$LnkPath,
    [string]$TargetPath,
    [string]$Arguments = '',
    [string]$WorkingDir = ''
  )
  $shell = New-Object -ComObject WScript.Shell
  $lnk = $shell.CreateShortcut($LnkPath)
  $lnk.TargetPath = $TargetPath
  if ($Arguments) { $lnk.Arguments = $Arguments }
  if ($WorkingDir) { $lnk.WorkingDirectory = $WorkingDir }
  $lnk.IconLocation = "$env:SystemRoot\System32\SHELL32.dll,0"
  $lnk.Save()
}

function Send-ToRecycleBin {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return }
  $shell = New-Object -ComObject Shell.Application
  $ns = $shell.Namespace(10)  # Recycle Bin
  if ($null -ne $ns) { $ns.MoveHere($Path) }
  Start-Sleep -Milliseconds 300
}

# --- MAIN ---
Assert-Admin

# 0) Préparation
$null = New-Item -ItemType Directory -Path $OutDir -Force
$vhdPath = Join-Path $OutDir $VhdName

Write-Host ("[*] Création du VHD {0} ({1} MB)..." -f $vhdPath, $VhdSizeMB)
$drive = $null
$attached = $false
try {
  $drive = New-VhdNtfs -FilePath $vhdPath -SizeMB $VhdSizeMB -Label $VolLabel -Letter $DriveLetter
  $attached = $true

  # 1) Arborescence
  $Base     = Join-Path $drive 'Users\student'
  $Desktop  = Join-Path $Base  'Desktop'
  $Docs     = Join-Path $Base  'Documents'
  $Down     = Join-Path $Base  'Downloads'
  $Pics     = Join-Path $Base  'Pictures'
  $Recent   = Join-Path $Base  'Recent'
  $Secrets  = Join-Path $Base  'Secrets'
  $BinTest  = Join-Path $Base  'BinTest'
  foreach ($d in @($Base,$Desktop,$Docs,$Down,$Pics,$Recent,$Secrets,$BinTest)) {
    if ([string]::IsNullOrWhiteSpace($d)) { throw 'Chemin de dossier vide.' }
    New-Item -ItemType Directory -Path $d -Force | Out-Null
  }

  # 2) Fichiers "sensibles"
  $clients = ("# Clients & mots de passe (faux)","alice: Password123!","bob:   P@ssw0rd!") -join "`r`n"
  Set-Content -Path (Join-Path $Docs 'clients.txt') -Value $clients -Encoding UTF8
  Set-Content -Path (Join-Path $Secrets 'vpn.txt') -Value 'vpn.example.com; user=training; pass=Winter2025!' -Encoding UTF8

  # ADS sur secrets.txt
  $visible = Join-Path $Secrets 'secrets.txt'
  Set-Content -Path $visible -Value 'Note visible.' -Encoding UTF8
  Set-Content -Path ($visible + ':password') -Value 'SuperSecret-Hunter2' -Encoding UTF8

  # 3) Timestomping
  $old = Get-Date '2017-01-15T10:30:00'
  $fileTS = Join-Path $Docs 'old_project_plan.txt'
  Set-Content -Path $fileTS -Value 'Ancien plan de projet (factice).' -Encoding UTF8
  (Get-Item $fileTS).CreationTime   = $old
  (Get-Item $fileTS).LastWriteTime  = $old
  (Get-Item $fileTS).LastAccessTime = $old

  # 4) Binaires factices / ZIP
  $exe = Join-Path $Down 'setup.exe'
  $zip = Join-Path $Down 'report.zip'
  [System.IO.File]::WriteAllBytes($exe, [byte[]](1..200))
  Compress-Archive -Path $Docs -DestinationPath $zip -Force

  # 5) Image JPEG minimaliste
  $jpg = Join-Path $Pics 'holiday.jpg'
  [byte[]]$jpegBytes = 0xFF,0xD8,0xFF,0xDB,0xFF,0xD9
  [System.IO.File]::WriteAllBytes($jpg, $jpegBytes)

  # 6) LNK
  New-FakeLnk -LnkPath (Join-Path $Recent 'clients.lnk') -TargetPath (Join-Path $Docs 'clients.txt') -WorkingDir $Docs
  New-FakeLnk -LnkPath (Join-Path $Recent 'vpn.lnk')     -TargetPath (Join-Path $Secrets 'vpn.txt')  -WorkingDir $Secrets

  # 7) Fichier supprimé (hard delete)
  $toDelete = Join-Path $Docs 'delete_me.txt'
  Set-Content -Path $toDelete -Value 'Je dois être supprimé (hard delete).' -Encoding UTF8
  Remove-Item -LiteralPath $toDelete -Force

  # 8) Vers la Corbeille
  $toRecycle = Join-Path $BinTest 'throw_me_away.txt'
  Set-Content -Path $toRecycle -Value 'Je vais à la Corbeille.' -Encoding UTF8
  Send-ToRecycleBin -Path $toRecycle

  # 9) ADS multiple + extension trompeuse
  $pdfFake = Join-Path $Down 'invoice_2025.pdf'
  Set-Content -Path $pdfFake -Value "Ce n'est pas un vrai PDF." -Encoding UTF8
  Set-Content -Path ($pdfFake + ':comment') -Value 'Pièce jointe suspecte' -Encoding UTF8

  # 10) README
  $readme = @(
    "Bienvenue sur l'image d'entraînement DFIR.",
    "Points à chercher dans Autopsy :",
    "- Fichiers .lnk dans Users\student\Recent",
    "- ADS sur Secrets\secrets.txt (:password) et Downloads\invoice_2025.pdf (:comment)",
    "- Fichiers supprimés (hard delete) et Corbeille (BinTest)",
    "- Timestamps anormaux (old_project_plan.txt)",
    "- Contenu sensible: Documents\clients.txt, Secrets\vpn.txt"
  ) -join "`r`n"
  Set-Content -Path (Join-Path $Base 'README-FIRST.txt') -Value $readme -Encoding UTF8

  Write-Host '[+] Population terminee.'
}
catch {
  Write-Warning ("[!] Erreur: {0}" -f $_.Exception.Message)
  throw
}
finally {
  if ($attached) {
    Write-Host '[*] Detachement du VHD...'
    try { Dismount-Vhd -FilePath $vhdPath } catch { Write-Warning $_.Exception.Message }
    Write-Host '[OK] Detache.'
  }
}

Write-Host ''
Write-Host '=== Resultat ==='
Write-Host ('VHD pret : ' + $vhdPath)
Write-Host ('Ouvre-le dans Autopsy : Add Data Source -> Disk Image or VM File -> ' + $VhdName)
