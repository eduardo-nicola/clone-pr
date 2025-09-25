#!/bin/bash

# Clone PR - Instalador
# Este script instala as funções clone-pr automaticamente

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Instalando Clone PR...${NC}"

# Verificar se gh está instalado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) não encontrado!${NC}"
    echo -e "${YELLOW}Por favor, instale o GitHub CLI primeiro:${NC}"
    echo "https://cli.github.com/"
    exit 1
fi

echo -e "${GREEN}✅ GitHub CLI encontrado${NC}"

# Baixar o arquivo principal
CLONE_PR_FILE="$HOME/.clone-pr.sh"
DOWNLOAD_URL="https://raw.githubusercontent.com/eduardo-nicola/clone-pr/main/clone-pr.sh"

echo -e "${BLUE}📥 Baixando clone-pr.sh...${NC}"
if curl -sSL "$DOWNLOAD_URL" -o "$CLONE_PR_FILE"; then
    echo -e "${GREEN}✅ Arquivo baixado com sucesso${NC}"
else
    echo -e "${RED}❌ Erro ao baixar o arquivo${NC}"
    exit 1
fi

# Função para adicionar source ao arquivo de configuração do shell
add_to_shell_config() {
    local config_file=$1
    local shell_name=$2
    
    if [ -f "$config_file" ]; then
        # Verificar se já existe a linha
        if ! grep -q "source ~/.clone-pr.sh" "$config_file" 2>/dev/null; then
            echo "" >> "$config_file"
            echo "# Clone PR functions" >> "$config_file"
            echo "source ~/.clone-pr.sh" >> "$config_file"
            echo -e "${GREEN}✅ Adicionado ao $shell_name${NC}"
        else
            echo -e "${YELLOW}⚠️  Já existe no $shell_name${NC}"
        fi
    fi
}

# Adicionar aos arquivos de configuração dos shells
echo -e "${BLUE}🔧 Configurando shells...${NC}"

add_to_shell_config "$HOME/.bashrc" "bashrc"
add_to_shell_config "$HOME/.zshrc" "zshrc"
add_to_shell_config "$HOME/.profile" "profile"

# Carregar as funções na sessão atual
source "$CLONE_PR_FILE"

echo ""
echo -e "${GREEN}🎉 Instalação concluída com sucesso!${NC}"
echo ""
echo -e "${BLUE}📖 Uso:${NC}"
echo -e "  ${YELLOW}pr-dup-stg <repo> <numero_pr>${NC}     # Duplica para staging"
echo -e "  ${YELLOW}pr-dup <repo> <numero_pr> <branch>${NC} # Duplica para branch específica"
echo ""
echo -e "${BLUE}📚 Exemplos:${NC}"
echo -e "  ${YELLOW}pr-dup-stg microsoft/vscode 123${NC}"
echo -e "  ${YELLOW}pr-dup microsoft/vscode 123 develop${NC}"
echo ""
echo -e "${BLUE}💡 Para usar em uma nova sessão de terminal, execute:${NC}"
echo -e "  ${YELLOW}source ~/.clone-pr.sh${NC}"
echo ""
echo -e "${BLUE}📖 Documentação completa:${NC}"
echo -e "  https://github.com/eduardo-nicola/clone-pr"
