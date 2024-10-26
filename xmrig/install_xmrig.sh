#!/bin/bash

# Diretório onde o repositório será clonado
DIR="/home/wendell/xmrig/deploy-automatic/xmrig"
DIR2="/opt/xmrig"

# Verifica se o diretório xmrig existe
if [ ! -d "$DIR" || ! -d "$DIR2" ]; then
    echo "O diretório xmrig não existe. Iniciando a instalação..."

    # Atualiza a lista de pacotes
    apt update

    # Instala pacotes necessários
    apt install -y \
        build-essential \
        curl \
        git \
        vim \
        htop \
        tmux \
        wget

    # Instala dependências adicionais
    apt install -y \
        cmake \
        libuv1-dev \
        libssl-dev \
        libhwloc-dev

    # Cria a pasta de destino
    mkdir -p /home/wendell/xmrig/deploy-automatic

    # Clona o repositório
    cd /home/wendell/xmrig/deploy-automatic
    git clone https://github.com/xmrig/xmrig.git

    # Muda para o diretório do repositório clonado
    cd xmrig

    # Cria o diretório build e muda para ele
    mkdir -p build
    cd build

    # Configura o projeto com cmake
    cmake ..

    # Compila o projeto
    make -j4

    # Cria o diretório para instalação
    mkdir -p /opt/xmrig
    chown wendell:wendell /opt/xmrig

    # Copia o executável para o diretório de instalação
    cp ./xmrig /opt/xmrig/xmrig

else
    echo "O diretório xmrig já existe. Nada foi feito."
fi


