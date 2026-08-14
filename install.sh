#!/bin/bash

# Interrompe o script caso algum comando falhe
set -e

echo "=========================================================="
echo "🚀 Iniciando a configuração do PikaOS NoctaliaV5 (NilsonLinux)"
echo "=========================================================="

# 1. Instalação e remoção de pacotes via pikman
echo ""
echo "📦 Instalando pacotes necessários via repositório..."
pikman install noctalia gnome-text-editor fish fastfetch firefox telegram-desktop -y

echo ""
echo "🗑️ Removendo pacotes não utilizados..."
pikman remove vim-gui-common nemo pikabar xterm -y

# 2. Instalação do Visual Studio Code (.deb)
echo ""
echo "💻 Baixando e instalando o Visual Studio Code..."
# Baixa o pacote deb para a pasta temporária do sistema
wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
# O uso de sudo é necessário aqui. O apt vai resolver qualquer dependência que o VS Code exija.
sudo apt install -y /tmp/vscode.deb
# Limpa o instalador
rm /tmp/vscode.deb

# 3. Verificação e criação dos diretórios de configuração
echo ""
echo "🔍 Verificando diretórios de configuração..."

if [ ! -d "$HOME/.config/niri" ]; then
    echo "📂 Criando diretório ~/.config/niri..."
    mkdir -p "$HOME/.config/niri"
else
    echo "✅ Diretório ~/.config/niri já existe. Pulando..."
fi

if [ ! -d "$HOME/.config/kitty" ]; then
    echo "📂 Criando diretório ~/.config/kitty..."
    mkdir -p "$HOME/.config/kitty"
else
    echo "✅ Diretório ~/.config/kitty já existe. Pulando..."
fi

# 4. Download e cópia dos arquivos do GitHub
echo ""
echo "⬇️ Baixando configurações do repositório..."
TMP_DIR=$(mktemp -d)
git clone https://github.com/nilsonlinux/pikaos.git "$TMP_DIR"

echo "📝 Aplicando configurações do Niri e Kitty..."
cp "$TMP_DIR/niri/niri.kdl" "$HOME/.config/niri/"
cp "$TMP_DIR/kitty/kitty.conf" "$HOME/.config/kitty/"

echo ""
echo "🧹 Limpando arquivos temporários do repositório..."
rm -rf "$TMP_DIR"

# 5. Configurando o Fish Shell
echo ""
echo "🐟 Definindo o fish como shell padrão..."
echo "⚠️ Você pode ser solicitado a digitar sua senha para mudar o shell."
chsh -s $(which fish)

echo ""
echo "✅ Configuração concluída com sucesso! Aproveite o PikaOS."
echo "=================================================="
