# Clone PR - Funções para duplicação de Pull Requests (PowerShell)
# Autor: Eduardo Possani
# Versão: 1.0

# Função para duplicar um PR para a branch staging
# Uso: pr-dup-stg <repo> <numero_pr>
# Exemplo: pr-dup-stg microsoft/vscode 123
function pr-dup-stg {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Repo,
        
        [Parameter(Mandatory=$true, Position=1)]
        [int]$PrNumber
    )
    
    if ([string]::IsNullOrWhiteSpace($Repo) -or $PrNumber -le 0) {
        Write-Host "❌ Uso: pr-dup-stg <repo> <numero_pr>" -ForegroundColor Red
        Write-Host "📖 Exemplo: pr-dup-stg microsoft/vscode 123" -ForegroundColor Yellow
        return
    }
    
    Write-Host "🔄 Duplicando PR #$PrNumber de $Repo para staging..." -ForegroundColor Cyan
    
    # Verificar se o PR existe
    try {
        $null = gh pr view $PrNumber --repo $Repo --json title 2>$null
    } catch {
        Write-Host "❌ PR #$PrNumber não encontrado no repositório $Repo" -ForegroundColor Red
        return
    }
    
    # Obter informações do PR
    try {
        $headRef = gh pr view $PrNumber --repo $Repo --json headRefName -q .headRefName
        $title = gh pr view $PrNumber --repo $Repo --json title -q .title
        $body = gh pr view $PrNumber --repo $Repo --json body -q .body
        
        # Criar novo PR
        gh pr create --repo $Repo --base staging --head $headRef --title $title --body $body
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ PR duplicado com sucesso para staging!" -ForegroundColor Green
        } else {
            Write-Host "❌ Erro ao criar o PR" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Erro ao processar o PR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Função para duplicar um PR para uma branch específica
# Uso: pr-dup <repo> <numero_pr> <branch_destino>
# Exemplo: pr-dup microsoft/vscode 123 develop
function pr-dup {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Repo,
        
        [Parameter(Mandatory=$true, Position=1)]
        [int]$PrNumber,
        
        [Parameter(Mandatory=$true, Position=2)]
        [string]$TargetBranch
    )
    
    if ([string]::IsNullOrWhiteSpace($Repo) -or $PrNumber -le 0 -or [string]::IsNullOrWhiteSpace($TargetBranch)) {
        Write-Host "❌ Uso: pr-dup <repo> <numero_pr> <branch_destino>" -ForegroundColor Red
        Write-Host "📖 Exemplo: pr-dup microsoft/vscode 123 develop" -ForegroundColor Yellow
        return
    }
    
    Write-Host "🔄 Duplicando PR #$PrNumber de $Repo para $TargetBranch..." -ForegroundColor Cyan
    
    # Verificar se o PR existe
    try {
        $null = gh pr view $PrNumber --repo $Repo --json title 2>$null
    } catch {
        Write-Host "❌ PR #$PrNumber não encontrado no repositório $Repo" -ForegroundColor Red
        return
    }
    
    # Obter informações do PR
    try {
        $headRef = gh pr view $PrNumber --repo $Repo --json headRefName -q .headRefName
        $title = gh pr view $PrNumber --repo $Repo --json title -q .title
        $body = gh pr view $PrNumber --repo $Repo --json body -q .body
        
        # Criar novo PR
        gh pr create --repo $Repo --base $TargetBranch --head $headRef --title $title --body $body
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ PR duplicado com sucesso para $TargetBranch!" -ForegroundColor Green
        } else {
            Write-Host "❌ Erro ao criar o PR" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Erro ao processar o PR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Exportar funções
Export-ModuleMember -Function pr-dup-stg, pr-dup
