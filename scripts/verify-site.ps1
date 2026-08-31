$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$pages = @(
  [pscustomobject]@{ Path = 'index.html'; En = 'CodeAI Workbench Legal Documents' },
  [pscustomobject]@{ Path = 'privacy-policy.html'; En = 'CodeAI Workbench Privacy Policy' },
  [pscustomobject]@{ Path = 'user-agreement.html'; En = 'CodeAI Workbench User Agreement' }
)

foreach ($page in $pages) {
  $file = Join-Path $root $page.Path
  if (-not (Test-Path $file)) {
    throw "Missing page: $($page.Path)"
  }

  $html = Get-Content -Raw -Encoding UTF8 $file
  if ($html -notmatch [Regex]::Escape($page.En)) {
    throw "Missing English title in $($page.Path)"
  }

  if ($html -notmatch 'data-lang-toggle="zh"' -or $html -notmatch 'data-lang-toggle="en"') {
    throw "Missing language toggle buttons in $($page.Path)"
  }

  if ($html -notmatch 'class="lang lang-zh"' -or $html -notmatch 'class="lang lang-en"') {
    throw "Missing bilingual content blocks in $($page.Path)"
  }

  if ($html -notmatch 'assets/lang\.js' -or $html -notmatch 'assets/site\.css') {
    throw "Missing shared assets in $($page.Path)"
  }
}

$script = Join-Path $root 'assets/lang.js'
$style = Join-Path $root 'assets/site.css'

if (-not (Test-Path $script)) {
  throw 'Missing shared language script: assets/lang.js'
}

if (-not (Test-Path $style)) {
  throw 'Missing shared stylesheet: assets/site.css'
}

$scriptText = Get-Content -Raw -Encoding UTF8 $script
if ($scriptText -notmatch 'localStorage' -or $scriptText -notmatch 'navigator.language') {
  throw 'Language script must remember the selected language and detect browser language'
}

$readme = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'README.md')
if ($readme -notmatch 'English' -or $readme -notmatch 'lang\.js') {
  throw 'README must mention bilingual support'
}

'Site verification passed.'
