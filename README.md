# PikaOS
Pós instalação Pika OS Niri

`curl -sSL https://raw.githubusercontent.com/nilsonlinux/pikaos/main/setup.sh | bash`


<img width="1365" height="767" alt="image" src="https://github.com/user-attachments/assets/622adcc3-89bf-42e0-9d7e-55e69990fdbf" />

# 🐧 PikaOS NoctaliaV5 - Setup Automatizado

> Script de configuração automatizada para o PikaOS NoctaliaV5, desenvolvido por NilsonLinux

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Bash](https://img.shields.io/badge/bash-5.0+-orange.svg)
![PikaOS](https://img.shields.io/badge/PikaOS-4.0-purple.svg)

---

## 📋 **Índice**

- [Sobre o Projeto](#-sobre-o-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação Rápida](#-instalação-rápida)
- [O que o Script Faz](#-o-que-o-script-faz)
- [Estrutura do Script](#-estrutura-do-script)
- [Funções Detalhadas](#-funções-detalhadas)
- [Personalização](#-personalização)
- [Solução de Problemas](#-solução-de-problemas)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

---

## 🎯 **Sobre o Projeto**

Este script automatiza a configuração completa do **PikaOS com NoctaliaV5**, instalando pacotes essenciais, ferramentas de desenvolvimento, configurando o ambiente e aplicando personalizações para uma experiência otimizada.

### ✨ **Características Principais**

- ✅ **Comando Único** - Instalação com um simples comando `curl | bash`
- ✅ **Totalmente Automatizado** - Não requer intervenção manual
- ✅ **Baseado em Debian** - Otimizado para PikaOS/Debian
- ✅ **Logs Completos** - Geração automática de logs para debugging
- ✅ **Interface Colorida** - Feedback visual com cores e emojis
- ✅ **Seguro** - Não executa como root e verifica pré-requisitos
- ✅ **Modular** - Funções independentes e organizadas

---

## 📦 **Pré-requisitos**

Antes de executar o script, certifique-se de ter:

| Requisito | Descrição |
|-----------|-----------|
| **Sistema** | PikaOS 4.0 ou Debian 11/12 |
| **Arquitetura** | amd64 (64 bits) |
| **Espaço em Disco** | Mínimo 10GB livres |
| **Internet** | Conexão ativa para download de pacotes |
| **Pacotes** | `pikman`, `wget`, `git`, `curl` |

### 🔍 **Verificação Automática**

O script verifica automaticamente:
- ✅ Compatibilidade do sistema
- ✅ Arquitetura do processador
- ✅ Espaço em disco disponível
- ✅ Conexão com internet
- ✅ Comandos essenciais instalados

---

## 🚀 **Instalação Rápida**

### **Método 1: Comando Único (Recomendado)**

```bash
curl -sSL https://raw.githubusercontent.com/nilsonlinux/pikaos/main/setup.sh | bash
```

### **Método 2: Comando Único (Recomendado)**

# Baixar o script
```bash
wget https://raw.githubusercontent.com/nilsonlinux/pikaos/main/setup.sh
```
# Dar permissão de execução
```chmod +x setup.sh```

# Executar
```./setup.sh```
