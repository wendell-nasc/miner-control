#!/bin/bash

# Script para compilar e executar cpuminer-opt
set -e

# Configurações
CPUMINER_DIR="/home/wendell/cpuminer-opt"
CPUMINER_PATH="$CPUMINER_DIR/cpuminer"
POOL="stratum+tcp://na.rplant.xyz:7022"
WALLET="Bqd2qXoeBNsnfhMPDxXVKc9UzoqD7B5EqK"
ALGO="power2b"
WORKER_NAME="$(hostname)"

# Diretório de log no home do usuário
LOG_DIR="/home/wendell/logs"
mkdir -p "$LOG_DIR"

# Log inicial
echo "$(date): Iniciando processo do cpuminer..." >> "$LOG_DIR/cpuminer.log"

# Verificar e instalar/compilar cpuminer se necessário
if [ ! -f "$CPUMINER_PATH" ]; then
    echo "CPUMiner não encontrado. Instalando dependências e compilando..." >> "$LOG_DIR/cpuminer.log"
    
    # Atualizar e instalar dependências
    echo "Instalando dependências..." >> "$LOG_DIR/cpuminer.log"
    sudo apt-get update >> "$LOG_DIR/cpuminer.log" 2>&1
    sudo apt-get install -y build-essential automake libssl-dev libcurl4-openssl-dev libjansson-dev libgmp-dev zlib1g-dev git >> "$LOG_DIR/cpuminer.log" 2>&1
    
    # Clonar e compilar cpuminer
    echo "Clonando repositório do cpuminer..." >> "$LOG_DIR/cpuminer.log"
    cd /home/wendell/
    
    # Remove diretório existente se houver
    rm -rf cpuminer-opt
    
    git clone https://github.com/JayDDee/cpuminer-opt.git >> "$LOG_DIR/cpuminer.log" 2>&1
    cd cpuminer-opt
    
    echo "Compilando cpuminer..." >> "$LOG_DIR/cpuminer.log"
    ./build.sh >> "$LOG_DIR/cpuminer.log" 2>&1
    
    # Verificar se a compilação foi bem sucedida
    if [ ! -f "cpuminer" ]; then
        echo "ERRO: Falha ao compilar cpuminer" >> "$LOG_DIR/cpuminer.log"
        exit 1
    fi
    
    echo "CPUMiner compilado com sucesso!" >> "$LOG_DIR/cpuminer.log"
else
    echo "CPUMiner já está instalado." >> "$LOG_DIR/cpuminer.log"
fi

# Verificar se é executável
chmod +x "$CPUMINER_PATH"

# Executar cpuminer
echo "$(date): Executando cpuminer..." >> "$LOG_DIR/cpuminer.log"
echo "Comando: $CPUMINER_PATH -a $ALGO -o $POOL -u $WALLET.$WORKER_NAME" >> "$LOG_DIR/cpuminer.log"

# Executar o minerador (mantém em foreground)
exec "$CPUMINER_PATH" -a "$ALGO" -o "$POOL" -u "$WALLET.$WORKER_NAME"