#!/bin/bash

###############################################
# PikaOS NoctaliaV5 - Setup Script
# Autor: NilsonLinux
# Descrição: Configuração automatizada do PikaOS
# Uso: curl -sSL https://raw.githubusercontent.com/nilsonlinux/pikaos/main/setup.sh | bash
###############################################

# Configurações
set -euo pipefail
readonly SCRIPT_VERSION="1.0.0"
readonly LOG_FILE="/tmp/pikaos-setup-$(date +%Y%m%d-%H%M%S).log"
readonly CONFIG_REPO="https://github.com/nilsonlinux/pikaos.git"
readonly VSCODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

# Cores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m'

###############################################
# Funções de Log
###############################################

log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $*${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $*${NC}" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${CYAN}ℹ️  $*${NC}" | tee -a "$LOG_FILE"
}

log_step() {
    echo ""
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🚀 $*${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

###############################################
# Funções de Sistema
###############################################

check_system() {
    log_step "Verificando Sistema"
    
    # Verifica se é Debian/PikaOS
    if ! grep -qi "debian\|pikaos" /etc/os-release 2>/dev/null; then
        log_warning "Sistema não identificado como Debian/PikaOS"
        log_info "Distro: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo 'Desconhecida')"
    else
        log_success "Sistema compatível: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    fi
    
    # Verifica arquitetura
    local arch=$(dpkg --print-architecture)
    log_info "Arquitetura: $arch"
    
    # Verifica espaço em disco
    local free_space=$(df -h / | awk 'NR==2 {print $4}')
    log_info "Espaço disponível: $free_space"
}

check_prerequisites() {
    log_step "Verificando Pré-requisitos"
    
    local missing=()
    local required_cmds=(pikman wget git chsh curl)
    
    for cmd in "${required_cmds[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Comandos necessários não encontrados:"
        printf "  ${RED}✗${NC} %s\n" "${missing[@]}"
        log_info "Instale com: sudo apt install -y ${missing[*]}"
        exit 1
    fi
    
    log_success "Todos os pré-requisitos estão instalados"
}

check_internet() {
    log_step "Verificando Conexão com Internet"
    
    if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
        log_success "Conexão com internet ativa"
    else
        log_error "Sem conexão com internet"
        exit 1
    fi
}

###############################################
# Funções de Instalação
###############################################

update_system() {
    log_step "Atualizando Sistema"
    
    log_info "Atualizando lista de pacotes..."
    if sudo apt update -y 2>/dev/null; then
        log_success "Lista de pacotes atualizada"
    else
        log_warning "Falha ao atualizar lista de pacotes"
    fi
    
    log_info "Atualizando pacotes do sistema..."
    if sudo apt upgrade -y 2>/dev/null; then
        log_success "Sistema atualizado"
    else
        log_warning "Falha ao atualizar alguns pacotes"
    fi
}

install_packages() {
    log_step "Instalando Pacotes Essenciais"
    
    local packages=(
        "noctalia"
        "gnome-text-editor"
        "fish"
        "fastfetch"
        "firefox-esr"
        "telegram-desktop"
        "curl"
        "wget"
        "git"
        "build-essential"
        "unzip"
        "zip"
        "htop"
    )
    
    log_info "Pacotes a instalar: ${packages[*]}"
    
    if sudo pikman install -y "${packages[@]}" 2>/dev/null; then
        log_success "Pacotes instalados com sucesso"
    else
        log_error "Falha ao instalar alguns pacotes"
        return 1
    fi
}

remove_packages() {
    log_step "Removendo Pacotes Não Utilizados"
    
    local packages=(
        "vim-gui-common"
        "nemo"
        "pikabar"
        "xterm"
        "leafpad"
    )
    
    log_info "Pacotes a remover: ${packages[*]}"
    
    if sudo pikman remove -y "${packages[@]}" 2>/dev/null; then
        log_success "Pacotes removidos com sucesso"
    else
        log_warning "Alguns pacotes não puderam ser removidos"
    fi
}

install_vscode() {
    log_step "Instalando Visual Studio Code"
    
    if command -v code &> /dev/null; then
        log_warning "VS Code já está instalado"
        local version=$(code --version | head -1)
        log_info "Versão: $version"
        return 0
    fi
    
    log_info "Baixando VS Code..."
    if wget -q --show-progress -O /tmp/vscode.deb "$VSCODE_URL"; then
        log_success "Download concluído"
    else
        log_error "Falha ao baixar VS Code"
        return 1
    fi
    
    log_info "Instalando VS Code..."
    if sudo apt install -y /tmp/vscode.deb 2>/dev/null; then
        log_success "VS Code instalado com sucesso"
    else
        log_error "Falha ao instalar VS Code"
        rm -f /tmp/vscode.deb
        return 1
    fi
    
    rm -f /tmp/vscode.deb
}

###############################################
# Funções de Configuração
###############################################

create_directories() {
    log_step "Criando Diretórios"
    
    local dirs=(
        "$HOME/.config/niri"
        "$HOME/.config/kitty"
        "$HOME/.config/fish"
        "$HOME/.local/bin"
        "$HOME/Projects"
        "$HOME/Downloads/Apps"
        "$HOME/.vim"
        "$HOME/.ssh"
    )
    
    local created=0
    local existed=0
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir" 2>/dev/null
            ((created++))
            log_info "Criado: $dir"
        else
            ((existed++))
        fi
    done
    
    log_success "Diretórios criados: $created (existentes: $existed)"
}

download_configs() {
    log_step "Baixando Configurações Personalizadas"
    
    local tmp_dir
    tmp_dir=$(mktemp -d)
    
    log_info "Clonando repositório: $CONFIG_REPO"
    if git clone --depth 1 "$CONFIG_REPO" "$tmp_dir" 2>/dev/null; then
        log_success "Repositório clonado"
    else
        log_warning "Falha ao clonar repositório, pulando configurações"
        rm -rf "$tmp_dir"
        return 0
    fi
    
    # Niri
    if [[ -f "$tmp_dir/niri/niri.kdl" ]]; then
        cp "$tmp_dir/niri/niri.kdl" "$HOME/.config/niri/"
        log_success "Configuração do Niri aplicada"
    else
        log_warning "Arquivo niri.kdl não encontrado"
    fi
    
    # Kitty
    if [[ -f "$tmp_dir/kitty/kitty.conf" ]]; then
        cp "$tmp_dir/kitty/kitty.conf" "$HOME/.config/kitty/"
        log_success "Configuração do Kitty aplicada"
    else
        log_warning "Arquivo kitty.conf não encontrado"
    fi
    
    # Fish
    if [[ -d "$tmp_dir/fish" ]]; then
        cp -r "$tmp_dir/fish/"* "$HOME/.config/fish/" 2>/dev/null
        log_success "Configurações do Fish aplicadas"
    fi
    
    rm -rf "$tmp_dir"
}

setup_fish() {
    log_step "Configurando Fish Shell"
    
    local fish_path
    fish_path=$(which fish 2>/dev/null || echo "")
    
    if [[ -z "$fish_path" ]]; then
        log_error "Fish não está instalado"
        return 1
    fi
    
    # Instala Fisher (gerenciador de plugins)
    if ! fish -c "type fisher &> /dev/null" 2>/dev/null; then
        log_info "Instalando Fisher (gerenciador de plugins)..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>/dev/null
        log_success "Fisher instalado"
    fi
    
    # Instala plugins populares
    local plugins=(
        "jethrokuan/z"
        "PatrickF1/fzf.fish"
        "oh-my-fish/theme-bobthefish"
        "edc/bass"
    )
    
    for plugin in "${plugins[@]}"; do
        if ! fish -c "fisher list | grep -q '$plugin'" 2>/dev/null; then
            fish -c "fisher install $plugin" 2>/dev/null && log_info "Plugin instalado: $plugin"
        fi
    done
    
    if [[ "$SHELL" == "$fish_path" ]]; then
        log_info "Fish já é o shell padrão"
        return 0
    fi
    
    log_info "Definindo Fish como shell padrão..."
    if sudo chsh -s "$fish_path" "$USER" 2>/dev/null; then
        log_success "Shell padrão alterado para Fish"
        log_warning "Reinicie a sessão para aplicar as mudanças"
    else
        log_warning "Execute manualmente: sudo chsh -s $(which fish) $USER"
    fi
}

setup_git() {
    log_step "Configurando Git"
    
    # Verifica se já tem configurações
    if git config --global user.name &> /dev/null; then
        log_info "Git já configurado"
        return 0
    fi
    
    git config --global user.name "NilsonLinux"
    git config --global user.email "nilsonlinux@gmail.com"
    git config --global init.defaultBranch "main"
    git config --global pull.rebase true
    git config --global core.editor "code --wait"
    
    # Configurações de alias úteis
    git config --global alias.co "checkout"
    git config --global alias.br "branch"
    git config --global alias.st "status"
    git config --global alias.lg "log --oneline --graph --all"
    
    log_success "Git configurado com sucesso"
}

setup_aliases() {
    log_step "Configurando Aliases do Sistema"
    
    local bashrc="$HOME/.bashrc"
    local alias_file="$HOME/.aliases"
    
    # Cria arquivo de aliases
    cat > "$alias_file" << 'EOF'
# Aliases PikaOS
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias clean='sudo apt autoremove -y && sudo apt autoclean'
alias py='python3'
alias vi='vim'
alias ports='sudo netstat -tulpn'
alias myip='curl -s ifconfig.me'
EOF
    
    # Adiciona ao bashrc se não existir
    if ! grep -q "source ~/.aliases" "$bashrc" 2>/dev/null; then
        echo "" >> "$bashrc"
        echo "# Aliases personalizados" >> "$bashrc"
        echo "if [ -f ~/.aliases ]; then" >> "$bashrc"
        echo "    source ~/.aliases" >> "$bashrc"
        echo "fi" >> "$bashrc"
    fi
    
    log_success "Aliases configurados"
}

###############################################
# Finalização
###############################################

cleanup() {
    log_step "Limpando Cache"
    
    sudo apt autoremove -y 2>/dev/null || true
    sudo apt autoclean -y 2>/dev/null || true
    sudo apt clean 2>/dev/null || true
    
    log_success "Cache limpo"
}

show_summary() {
    log_step "✅ Setup Concluído!"
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              PIKAOS NOCTALIAV5 - INSTALADO             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📦 Pacotes Instalados:${NC}"
    echo "   • noctalia • gnome-text-editor • fish • fastfetch"
    echo "   • firefox-esr • telegram-desktop • htop"
    echo ""
    echo -e "${CYAN}🛠️  Ferramentas:${NC}"
    echo "   • Visual Studio Code"
    echo "   • Git configurado"
    echo "   • Fish com plugins"
    echo ""
    echo -e "${CYAN}🎨 Configurações:${NC}"
    echo "   • Niri (WM) • Kitty (terminal)"
    echo "   • Aliases do sistema"
    echo ""
    echo -e "${YELLOW}📝 Log: $LOG_FILE${NC}"
    echo ""
    echo -e "${GREEN}✨ RECOMENDAÇÕES FINAIS:${NC}"
    echo -e "${YELLOW}1.${NC} Reinicie a sessão para aplicar o Fish como shell padrão"
    echo -e "${YELLOW}2.${NC} Execute 'fastfetch' para ver as informações do sistema"
    echo -e "${YELLOW}3.${NC} Verifique as configurações em ~/.config/"
    echo -e "${YELLOW}4.${NC} Configure suas chaves SSH em ~/.ssh/"
    echo ""
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}🚀 Aproveite seu PikaOS NoctaliaV5!${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════${NC}"
}

###############################################
# Main
###############################################

main() {
    # Banner
    echo -e "${CYAN}"
    echo "   ╔═══════════════════════════════════════════════╗"
    echo "   ║  🐧 PIKAOS NOCTALIAV5 - SETUP AUTOMATIZADO   ║"
    echo "   ║         by NilsonLinux v${SCRIPT_VERSION}            ║"
    echo "   ╚═══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Verifica se é root
    if [[ "$EUID" -eq 0 ]]; then
        log_error "Não execute este script como root"
        exit 1
    fi
    
    # Início do log
    log_info "Iniciando setup do PikaOS NoctaliaV5"
    log_info "Log salvo em: $LOG_FILE"
    
    # Execução principal
    {
        check_system
        check_internet
        check_prerequisites
        update_system
        install_packages
        remove_packages
        install_vscode
        create_directories
        download_configs
        setup_fish
        setup_git
        setup_aliases
        cleanup
        show_summary
    } 2>&1 | tee -a "$LOG_FILE"
    
    # Verifica resultado
    if [[ $? -eq 0 ]]; then
        echo ""
        log_success "Setup finalizado com sucesso!"
    else
        echo ""
        log_error "Setup finalizou com erros. Verifique o log: $LOG_FILE"
        exit 1
    fi
}

# Executa
main "$@"
