#!/bin/bash

# Interrompe o script caso algum comando falhe
set -e

echo "=================================================="
echo "🚀 Iniciando a configuração do PikaOS (NilsonLinux)"
echo "=================================================="

# 1. Instalação e remoção de pacotes
echo ""
echo "📦 Instalando pacotes necessários..."
pikman install noctalia gnome-text-editor fish fastfetch firefox telegram-desktop -y

echo ""
echo "🗑️ Removendo pacotes não utilizados..."
# O uso do -y garante que não haverá interrupção pedindo confirmação
pikman remove vim-gui-common nemo pikabar xterm -y

# 2. Criação dos diretórios de configuração
echo ""
echo "📂 Criando diretórios ~/.config/niri e ~/.config/kitty..."
mkdir -p ~/.config/niri
mkdir -p ~/.config/kitty

# 3. Download e cópia dos arquivos do GitHub
echo ""
echo "⬇️ Baixando configurações do repositório..."
# Cria um diretório temporário para clonar o repositório sem sujar sua pasta Home
TMP_DIR=$(mktemp -d)
git clone https://github.com/nilsonlinux/pikaos.git "$TMP_DIR"

echo "📝 Aplicando configurações do Niri e Kitty..."
cp "$TMP_DIR/niri/niri.kdl" ~/.config/niri/
cp "$TMP_DIR/kitty/kitty.conf" ~/.config/kitty/

# 4. Limpeza do diretório temporário
echo ""
echo "🧹 Limpando arquivos temporários..."
rm -rf "$TMP_DIR"

# (Opcional) Define o fish como shell padrão. 
chsh -s $(which fish)

echo ""
echo "✅ Configuração concluída com sucesso! Aproveite o PikaOS com Niri e Noctalia V5."
echo "=================================================="
