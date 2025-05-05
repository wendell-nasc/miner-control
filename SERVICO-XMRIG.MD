

# USUARIO
usuario root
sudo adduser wendell
sudo usermod -aG sudo wendell

alterar senha do root
sudo -i passwd 
sudo passwd wendell 




# SSH

sudo nano /etc/ssh/ssh_config
sudo ufw allow 22
sudo ufw allow 22/tcp

# HOST
sudo nano /etc/hostname
rig180-generico




# XMRIG XDAG
🔹Ubuntu 18.04
sudo mkdir /home/wendell/xdag && cd /home/wendell/xdag/ && sudo wget https://github.com/FSOL-XDAG/xmrig-4-xdag/releases/download/v6.19.3/x4x-6.19.3-hive-ubuntu_18.04-x64.tar.gz && sudo tar -xvf x4x-6.19.3-hive-ubuntu_18.04-x64.tar.gz

🔹Ubuntu 20.04
mkdir temp_x4x && cd temp_x4x/ && wget https://github.com/FSOL-XDAG/xmrig-4-xdag/releases/download/v.6.20.0/x4x-6.20.0-linux-ubuntu_20.04-x64.tar.gz && tar -xvf x4x-6.20.0-linux-ubuntu_20.04-x64.tar.gz && cp xmrig-4-xdag/xmrig-4-xdag .. && cd .. && rm -r temp_x4x
sudo mkdir /home/wendell/xdag && cd /home/wendell/xdag/ && sudo wget https://github.com/FSOL-XDAG/xmrig-4-xdag/releases/download/v.6.20.0/x4x-6.20.0-linux-ubuntu_20.04-x64.tar.gz && sudo tar -xvf x4x-6.20.0-linux-ubuntu_20.04-x64.tar.gz 


🔹Ubuntu 22.04
sudo mkdir /home/wendell/xdag && cd /home/wendell/xdag/ && sudo wget https://github.com/FSOL-XDAG/xmrig-4-xdag/releases/download/v.6.20.0/x4x-6.20.0-linux-ubuntu_22.04-x64.tar.gz && sudo tar -xvf x4x-6.20.0-linux-ubuntu_22.04-x64.tar.gz 



# Configurar XMRIG COMPLETO

sudo nano start.sh
sudo chmod +x start.sh
sudo sh start.sh


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

# Executa o script start.sh
# cd /home/wendell/hook/xmrig/
# ./start.sh


