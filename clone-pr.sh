#!/bin/bash

# Clone PR - Funções para duplicação de Pull Requests
# Autor: Eduardo Possani
# Versão: 1.0

# Função para duplicar um PR para a branch staging
# Uso: pr-dup-stg <repo> <numero_pr>
# Exemplo: pr-dup-stg microsoft/vscode 123
pr-dup-stg() {
  local repo=$1   # Repositório no formato owner/repo (ex: org-x/projeto-y)
  local old=$2    # Número do PR original

  # Validação de parâmetros
  if [[ -z "$repo" || -z "$old" ]]; then
    echo "❌ Uso: pr-dup-stg <repo> <numero_pr>"
    echo "📖 Exemplo: pr-dup-stg microsoft/vscode 123"
    return 1
  fi

  echo "🔄 Duplicando PR #$old de $repo para staging..."

  # Verificar se o PR existe
  if ! gh pr view $old --repo $repo > /dev/null 2>&1; then
    echo "❌ PR #$old não encontrado no repositório $repo"
    return 1
  fi

  gh pr create \
    --repo $repo \
    --base staging \
    --head $(gh pr view $old --repo $repo --json headRefName -q .headRefName) \
    --title "$(gh pr view $old --repo $repo --json title -q .title)" \
    --body "$(gh pr view $old --repo $repo --json body -q .body)"
    
  if [[ $? -eq 0 ]]; then
    echo "✅ PR duplicado com sucesso para staging!"
  else
    echo "❌ Erro ao criar o PR"
    return 1
  fi
}

# Função para duplicar um PR para uma branch específica
# Uso: pr-dup <repo> <numero_pr> <branch_destino>
# Exemplo: pr-dup microsoft/vscode 123 develop
pr-dup() {
  local repo=$1      # Repositório no formato owner/repo (ex: org-x/projeto-y)
  local old=$2       # Número do PR original
  local newbase=$3   # Branch de destino

  # Validação de parâmetros
  if [[ -z "$repo" || -z "$old" || -z "$newbase" ]]; then
    echo "❌ Uso: pr-dup <repo> <numero_pr> <branch_destino>"
    echo "📖 Exemplo: pr-dup microsoft/vscode 123 develop"
    return 1
  fi

  echo "🔄 Duplicando PR #$old de $repo para $newbase..."

  # Verificar se o PR existe
  if ! gh pr view $old --repo $repo > /dev/null 2>&1; then
    echo "❌ PR #$old não encontrado no repositório $repo"
    return 1
  fi

  gh pr create \
    --repo $repo \
    --base $newbase \
    --head $(gh pr view $old --repo $repo --json headRefName -q .headRefName) \
    --title "$(gh pr view $old --repo $repo --json title -q .title)" \
    --body "$(gh pr view $old --repo $repo --json body -q .body)"
    
  if [[ $? -eq 0 ]]; then
    echo "✅ PR duplicado com sucesso para $newbase!"
  else
    echo "❌ Erro ao criar o PR"
    return 1
  fi
}
