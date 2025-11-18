#!/bin/bash

# ============================================================================
# CONFIGURAÇÃO DE LOGS
# ============================================================================

MOEDA1_LOGFILE="/var/log/XMRIG_VRL_MOEDA1.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Criar arquivos de log
for logfile in "$MOEDA1_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Log de variáveis de ambiente
env >> "$ENV_LOGFILE"


# ============================================================================
# CONFIGURAÇÃO DO XMRIG-VRL
# ============================================================================

VRL_DIR="/home/wendell/xmrig-vrl"
VRL_VERSION="6.0.24-virel"
VRL_TGZ="xmrig-vrl-linux.tar.xz"
VRL_URL="https://github.com/rplant8/xmrig-vrl/releases/download/${VRL_VERSION}/${VRL_TGZ}"
VRL_EXTRACT_DIR="$VRL_DIR"
VRL_PATH="$VRL_EXTRACT_DIR/xmrig-vrl"

# Baixa somente se NÃO existir
if [ ! -f "$VRL_DIR" ]; then
    wget -O "$VRL_DIR" "$VRL_URL"
fi

# Extrai somente se o binário NÃO existir
if [ ! -f "$BIN" ]; then
    tar -xf "$VRL_DIR" -C "$VRL_DIR"
fi


# ============================================================================
# CONFIGURAÇÃO DA MOEDA 1 — RANDOMVIREL (SCASH)
# ============================================================================

MOEDA1_POOL="na.rplant.xyz:17155"
MOEDA1_WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
MOEDA1_ALGO="rx/vrl"

TOTAL_THREADS=$(nproc)

echo "$(date): Iniciando mineração Moeda 1 com XMRig-VRL $VRL_VERSION..." >> "$MOEDA1_LOGFILE"

"$VRL_PATH" \
    -a "$MOEDA1_ALGO" \
    -o "$MOEDA1_POOL" \
    -u "$MOEDA1_WALLET.$(hostname)" \
    --threads="$TOTAL_THREADS" \
    --keepalive \
    --no-color \
    >> "$MOEDA1_LOGFILE" \
    2>> "$ERROR_LOGFILE" &

PID1=$!

echo "$(date): Minerador XMRig-VRL iniciado. PID=$PID1" >> "$ENV_LOGFILE"

wait "$PID1"
echo "$(date): XMRig-VRL finalizou." >> "$ENV_LOGFILE"
