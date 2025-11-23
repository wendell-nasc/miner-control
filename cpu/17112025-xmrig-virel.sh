#!/bin/bash

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
SRB_PATH="/home/wendell/xmrig-vrl/xmrig-vrl"

# Verifica existência do SRBMiner (ATUALIZADO PARA VERSÃO 2.9.8)
if [ ! -f "$SRB_PATH" ]; then
    echo "Xmrig não encontrado. Baixando ..." >> "$ERROR_LOGFILE"
    mkdir -p /home/wendell/xmrig-vrl && cd /home/wendell/xmrig-vrl || exit 1
    
    # Remove versões antigas se existirem
    rm -rf xmrig-* xmrig*
    
    # Baixa a versão mais recente 2.9.8
    wget https://github.com/rplant8/xmrig-vrl/releases/download/6.0.24-virel/xmrig-vrl-linux.tar.xz
    
    # Extrai o arquivo
    tar -xvf xmrig-vrl-linux.tar.xz
    
    # Verifica se a extração foi bem sucedida
    if [ -f "$SRB_PATH" ]; then
        echo "XMRIG baixado e extraído com sucesso." >> "$ENV_LOGFILE"
        # Torna o executável
        chmod +x "$SRB_PATH"
    else
        echo "ERRO: XMRIG não foi extraído corretamente." >> "$ERROR_LOGFILE"
        echo "Tentando encontrar o binário..." >> "$ERROR_LOGFILE"
        # Tenta encontrar o binário em subdiretórios
        find /home/wendell/SRBMiner -name "srbminer*" -type f -executable >> "$ERROR_LOGFILE" 2>&1
        exit 1
    fi
else
    echo "SRBMiner 2.9.8 já está instalado." >> "$ENV_LOGFILE"
fi

# Primeira moeda (ex: SCASH)
MOEDA1_POOL="stratum-na.rplant.xyz:17155"
MOEDA1_WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
#MOEDA1_WALLET="v71r1cztjuyep18ooyh5zojarziur4mdf22lk8"

MOEDA1_ALGO="rx/vrl"

# Inicia SRBMiner para moeda 1 (ATUALIZADO PARA VERSÃO 2.9.8 - SEM NICE)
echo "$(date): Iniciando mineração da Moeda 1 com SRBMiner 2.9.8..." >> "$MOEDA1_LOGFILE"
"$SRB_PATH" \
    -a "$MOEDA1_ALGO" \
    -o "$MOEDA1_POOL" \
    -u "$MOEDA1_WALLET.$(hostname)" \
    --threads="$TOTAL_THREADS" \
    --keepalive \
    >> "$MOEDA1_LOGFILE" 2>> "$ERROR_LOGFILE" &


wait
echo "$(date): Ambos mineradores iniciados com sucesso com SRBMiner 2.9.8." >> "$ENV_LOGFILE"