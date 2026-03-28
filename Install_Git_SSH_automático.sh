#!/bin/bash

echo "🔧 Atualizando sistema..."
sudo apt update

echo "📦 Instalando Git..."
sudo apt install git -y

echo ""
echo "✅ Git instalado: $(git --version)"
echo ""

# =========================
# CONFIGURAÇÃO DO GIT
# =========================

echo "⚙️ Configuração do Git"

read -p "👤 Digite seu nome: " GIT_NAME
read -p "📧 Digite seu email: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Configs úteis extras
git config --global init.defaultBranch main
git config --global core.editor nano
git config --global pull.rebase false

echo ""
echo "✅ Git configurado com sucesso!"
echo ""

# =========================
# CONFIGURAÇÃO SSH
# =========================

echo "🔐 Configuração da chave SSH"

read -p "🔑 Nome da chave SSH (padrão: id_ed25519): " SSH_NAME
SSH_NAME=${SSH_NAME:-id_ed25519}

# Criar pasta .ssh se não existir
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Gerar chave
echo ""
echo "🔑 Gerando chave SSH..."
ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f ~/.ssh/$SSH_NAME -N ""

# Iniciar ssh-agent
echo ""
echo "🚀 Iniciando ssh-agent..."
eval "$(ssh-agent -s)"

# Adicionar chave
ssh-add ~/.ssh/$SSH_NAME

# Instalar xclip para copiar automaticamente (opcional)
if ! command -v xclip &> /dev/null
then
    echo "📋 Instalando xclip para copiar chave automaticamente..."
    sudo apt install xclip -y
fi

# Copiar chave para clipboard
xclip -selection clipboard < ~/.ssh/$SSH_NAME.pub

echo ""
echo "📋 Chave SSH copiada automaticamente!"
echo ""

echo "👉 Agora vá em:"
echo "👉 https://github.com/settings/keys"
echo "👉 Clique em 'New SSH key' e cole (CTRL+V)"
echo ""

read -p "Pressione ENTER depois de adicionar a chave no GitHub..."

# Testar conexão
echo ""
echo "🔎 Testando conexão com GitHub..."
ssh -T git@github.com

echo ""
echo "🎉 Tudo pronto!"
echo "✔️ Git instalado e configurado"
echo "✔️ SSH conectado ao GitHub"
echo ""
