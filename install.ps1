# Clone PR - Instalador para Windows PowerShell
# Este script instala as funções clone-pr automaticamente no Windows

param(
    [switch]$Force
)

# Configurar cores para output
$Red = "`e[31m"
$Green = "`e[32m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Reset = "`e[0m"

Write-Host "${Blue}🚀 Instalando Clone PR para Windows...${Reset}"

# Verificar se gh está instalado
try {
    $null = Get-Command gh -ErrorAction Stop
    Write-Host "${Green}✅ GitHub CLI encontrado${Reset}"
} catch {
    Write-Host "${Red}❌ GitHub CLI (gh) não encontrado!${Reset}"
    Write-Host "${Yellow}Por favor, instale o GitHub CLI primeiro:${Reset}"
    Write-Host "https://cli.github.com/"
    Write-Host "${Yellow}Ou execute: winget install GitHub.cli${Reset}"
    exit 1
}

# Definir caminhos
$ProfileDir = Split-Path $PROFILE -Parent
$ClonePrFile = Join-Path $ProfileDir "clone-pr.ps1"
$DownloadUrl = "https://raw.githubusercontent.com/eduardo-nicola/clone-pr/main/clone-pr.ps1"

# Criar diretório do perfil se não existir
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    Write-Host "${Green}✅ Diretório do perfil criado${Reset}"
}

# Baixar o arquivo principal
Write-Host "${Blue}📥 Baixando clone-pr.ps1...${Reset}"
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ClonePrFile -UseBasicParsing
    Write-Host "${Green}✅ Arquivo baixado com sucesso${Reset}"
} catch {
    Write-Host "${Red}❌ Erro ao baixar o arquivo: $($_.Exception.Message)${Reset}"
    exit 1
}

# Função para adicionar ao perfil do PowerShell
function Add-ToProfile {
    param([string]$ProfilePath, [string]$ProfileName)
    
    if (Test-Path $ProfilePath) {
        $ProfileContent = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
        $ImportLine = ". `"$ClonePrFile`""
        
        if ($ProfileContent -notmatch [regex]::Escape($ImportLine)) {
            Add-Content -Path $ProfilePath -Value "`n# Clone PR functions"
            Add-Content -Path $ProfilePath -Value $ImportLine
            Write-Host "${Green}✅ Adicionado ao $ProfileName${Reset}"
        } else {
            Write-Host "${Yellow}⚠️  Já existe no $ProfileName${Reset}"
        }
    } else {
        # Criar perfil se não existir
        New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
        Add-Content -Path $ProfilePath -Value "# Clone PR functions"
        Add-Content -Path $ProfilePath -Value ". `"$ClonePrFile`""
        Write-Host "${Green}✅ Perfil criado e configurado: $ProfileName${Reset}"
    }
}

# Configurar perfis do PowerShell
Write-Host "${Blue}🔧 Configurando perfis do PowerShell...${Reset}"

# Perfil do usuário atual (todos os hosts)
Add-ToProfile $PROFILE.CurrentUserAllHosts "CurrentUserAllHosts"

# Perfil do usuário atual (console específico)
Add-ToProfile $PROFILE.CurrentUserCurrentHost "CurrentUserCurrentHost"

# Carregar as funções na sessão atual
if (Test-Path $ClonePrFile) {
    . $ClonePrFile
    Write-Host "${Green}✅ Funções carregadas na sessão atual${Reset}"
}

Write-Host ""
Write-Host "${Green}🎉 Instalação concluída com sucesso!${Reset}"
Write-Host ""
Write-Host "${Blue}💡 Para usar em uma nova sessão do PowerShell:${Reset}"
Write-Host "  ${Yellow}. `"$ClonePrFile`"${Reset}"
Write-Host ""
Write-Host "${Blue}📖 Documentação completa:${Reset}"
Write-Host "  https://github.com/eduardo-nicola/clone-pr"
