# Clone PR - Ferramentas para Duplicação de Pull Requests

Este repositório fornece funções úteis para duplicar Pull Requests no GitHub usando a CLI do GitHub (`gh`).

## 🚀 Instalação Rápida

Execute o comando abaixo no seu terminal:

```bash
curl -sSL https://raw.githubusercontent.com/eduardo-nicola/clone-pr/main/install.sh | bash
```

Ou instale manualmente:

```bash
curl -o ~/.clone-pr.sh https://raw.githubusercontent.com/eduardo-nicola/clone-pr/main/clone-pr.sh
echo "source ~/.clone-pr.sh" >> ~/.bashrc
echo "source ~/.clone-pr.sh" >> ~/.zshrc
source ~/.clone-pr.sh
```

## 📋 Pré-requisitos

- [GitHub CLI (gh)](https://cli.github.com/) instalado e configurado
- Acesso aos repositórios onde você deseja duplicar PRs

## 📖 Uso

### `pr-dup-stg`

Duplica um PR existente para a branch `staging`.

**Sintaxe:**
```bash
pr-dup-stg <repositorio> <numero_do_pr>
```

**Parâmetros:**
- `repositorio`: Nome do repositório no formato `owner/repo` (ex: `microsoft/vscode`)
- `numero_do_pr`: Número do PR original que você deseja duplicar

**Exemplo:**
```bash
pr-dup-stg org-x/projeto-y 123
```

Este comando irá:
1. Buscar as informações do PR #123 no repositório `org-x/projeto-y`
2. Criar um novo PR com:
   - Base: `staging`
   - Head: mesma branch do PR original
   - Título: mesmo título do PR original
   - Descrição: mesma descrição do PR original

### `pr-dup`

Duplica um PR existente para uma branch específica.

**Sintaxe:**
```bash
pr-dup <repositorio> <numero_do_pr> <branch_destino>
```

**Parâmetros:**
- `repositorio`: Nome do repositório no formato `owner/repo` (ex: `microsoft/vscode`)
- `numero_do_pr`: Número do PR original que você deseja duplicar
- `branch_destino`: Nome da branch de destino para o novo PR

**Exemplo:**
```bash
pr-dup org-x/projeto-y 123 develop
```

Este comando irá:
1. Buscar as informações do PR #123 no repositório `org-x/projeto-y`
2. Criar um novo PR com:
   - Base: `develop`
   - Head: mesma branch do PR original
   - Título: mesmo título do PR original
   - Descrição: mesma descrição do PR original

## 💡 Casos de Uso Comuns

### Promover um PR de desenvolvimento para staging
```bash
pr-dup-stg minha-org/meu-projeto 456
```

### Criar backport para uma branch de release
```bash
pr-dup minha-org/meu-projeto 789 release/v2.1
```

### Duplicar para múltiplas branches
```bash
# Para staging
pr-dup-stg minha-org/meu-projeto 101

# Para produção
pr-dup minha-org/meu-projeto 101 main
```

## ⚠️ Notas Importantes

- Certifique-se de ter permissões adequadas no repositório de destino
- A branch source do PR original deve existir e estar acessível
- O comando não faz merge automaticamente, apenas cria o novo PR
- Revise sempre os PRs criados antes de fazer merge


