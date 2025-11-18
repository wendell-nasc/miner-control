#!/bin/bash

# ============================================================================
# CONFIGURAÇÃO DE LOGS
# ============================================================================

MOEDA1_LOGFILE="/var/log/SRBMOEDA1.log"
MOEDA2_LOGFILE="/var/log/SRBMOEDA2.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Criar arquivos de log
for logfile in "$MOEDA1_LOGFILE" "$MOEDA2_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Log de variáveis de ambiente
env >> "$ENV_LOGFILE"


# ============================================================================
# CONFIGURAÇÃO DO SRBMINER
# ============================================================================

SRB_DIR="/home/wendell/SRBMiner"
SRB_VERSION="2-9-8"
SRB_PATH="$SRB_DIR/SRBMiner-Multi-$SRB_VERSION/SRBMiner-MULTI"
SRB_TGZ="SRBMiner-Multi-$SRB_VERSION-Linux.tar.gz"
SRB_URL="https://github.com/doktor83/SRBMiner-Multi/releases/download/2.9.8/$SRB_TGZ"

# Verificação do executável
if [ ! -f "$SRB_PATH" ]; then
    echo "$(date): SRBMiner não encontrado. Baixando versão $SRB_VERSION..." >> "$ERROR_LOGFILE"
    
    mkdir -p "$SRB_DIR" || exit 1
    cd "$SRB_DIR" || exit 1

    # Remove versões antigas
    rm -rf SRBMiner-Multi-* srbminer_custom-*

    # Baixar versão nova
    wget "$SRB_URL" -O "$SRB_TGZ" >> "$ENV_LOGFILE" 2>> "$ERROR_LOGFILE"

    # Extrair
    tar -xvf "$SRB_TGZ" >> "$ENV_LOGFILE" 2>> "$ERROR_LOGFILE"

    # Conferir extração
    if [ -f "$SRB_PATH" ]; then
        chmod +x "$SRB_PATH"
        echo "$(date): SRBMiner $SRB_VERSION baixado e configurado." >> "$ENV_LOGFILE"
    else
        echo "$(date): ERRO: SRBMiner não foi extraído corretamente." >> "$ERROR_LOGFILE"
        find "$SRB_DIR" -type f -executable >> "$ERROR_LOGFILE"
        exit 1
    fi
else
    echo "$(date): SRBMiner $SRB_VERSION já está instalado." >> "$ENV_LOGFILE"
fi


# ============================================================================
# CONFIGURAÇÃO DA MOEDA 1
# ============================================================================

MOEDA1_POOL="stratum-na.rplant.xyz:7155"
MOEDA1_WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
MOEDA1_ALGO="randomvirel"

TOTAL_THREADS=$(nproc)

echo "$(date): Iniciando mineração Moeda 1 com SRBMiner $SRB_VERSION..." >> "$MOEDA1_LOGFILE"

"$SRB_PATH" \
    --disable-gpu \
    --algorithm "$MOEDA1_ALGO" \
    --pool "$MOEDA1_POOL" \
    --wallet "$MOEDA1_WALLET.$(hostname)" \
    --cpu-threads "$TOTAL_THREADS" \
    --password m=solo \
    --keepalive true \
    >> "$MOEDA1_LOGFILE" \
    2>> "$ERROR_LOGFILE" &

PID1=$!

echo "$(date): Minerador iniciado. PID=$PID1" >> "$ENV_LOGFILE"

wait "$PID1"
echo "$(date): SRBMiner finalizou." >> "$ENV_LOGFILE"
