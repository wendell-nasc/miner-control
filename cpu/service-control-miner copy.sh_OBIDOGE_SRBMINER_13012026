#!/bin/bash

# Caminho dos logs
# Caminho dos logs
MOEDA1_LOGFILE="/var/log/SRBMOEDA1.log"
MOEDA2_LOGFILE="/var/log/SRBMOEDA2.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Criar arquivos de log
for logfile in "$MOEDA1_LOGFILE" "$MOEDA2_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exporta PATH
export PATH="$PATH"

# Log de variáveis de ambiente
env >> "$ENV_LOGFILE"

# Threads
TOTAL_THREADS=$(nproc)
THREADS1=$((TOTAL_THREADS / 2))
THREADS2=$((TOTAL_THREADS - THREADS1)) # Garante que use todos os núcleos

# Caminho do binário SRBMiner (ATUALIZADO PARA VERSÃO 2.9.8)
SRB_PATH="/home/wendell/SRBMiner/SRBMiner-Multi-2-9-8/SRBMiner-MULTI"

# Verifica existência do SRBMiner (ATUALIZADO PARA VERSÃO 2.9.8)
if [ ! -f "$SRB_PATH" ]; then
    echo "SRBMiner não encontrado. Baixando versão 2.9.8..." >> "$ERROR_LOGFILE"
    mkdir -p /home/wendell/SRBMiner && cd /home/wendell/SRBMiner || exit 1
    
    # Remove versões antigas se existirem
    rm -rf SRBMiner-Multi-* srbminer_custom-*
    
    # Baixa a versão mais recente 2.9.8
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.9.8/SRBMiner-Multi-2-9-8-Linux.tar.gz
    
    # Extrai o arquivo
    tar -xvf SRBMiner-Multi-2-9-8-Linux.tar.gz
    
    # Verifica se a extração foi bem sucedida
    if [ -f "$SRB_PATH" ]; then
        echo "SRBMiner 2.9.8 baixado e extraído com sucesso." >> "$ENV_LOGFILE"
        # Torna o executável
        chmod +x "$SRB_PATH"
    else
        echo "ERRO: SRBMiner não foi extraído corretamente." >> "$ERROR_LOGFILE"
        echo "Tentando encontrar o binário..." >> "$ERROR_LOGFILE"
        # Tenta encontrar o binário em subdiretórios
        find /home/wendell/SRBMiner -name "srbminer*" -type f -executable >> "$ERROR_LOGFILE" 2>&1
        exit 1
    fi
else
    echo "SRBMiner 2.9.8 já está instalado." >> "$ENV_LOGFILE"
fi

# Primeira moeda (ex: SCASH)
MOEDA1_POOL="stratum-na.rplant.xyz:7063"
MOEDA1_WALLET="MUbsRrDWW1cmri3BbZCWaw84RENCD8i58R"
#MOEDA1_WALLET="v71r1cztjuyep18ooyh5zojarziur4mdf22lk8"

MOEDA1_ALGO="minotaurx"

# Inicia SRBMiner para moeda 1 (ATUALIZADO PARA VERSÃO 2.9.8 - SEM NICE)
echo "$(date): Iniciando mineração da Moeda 1 com SRBMiner 2.9.8..." >> "$MOEDA1_LOGFILE"
"$SRB_PATH" --disable-gpu --algorithm "$MOEDA1_ALGO" --cpu-threads "$TOTAL_THREADS" \
--pool "$MOEDA1_POOL" --wallet "$MOEDA1_WALLET.$(hostname)" \
--keepalive true \
>> "$MOEDA1_LOGFILE" 2>> "$ERROR_LOGFILE" &

wait
echo "$(date): Ambos mineradores iniciados com sucesso com SRBMiner 2.9.8." >> "$ENV_LOGFILE"