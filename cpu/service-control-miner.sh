#!/bin/bash

# ============================================================
# XMRig - Monero / RandomX / HashVault
# ============================================================

# Caminho dos logs
MOEDA1_LOGFILE="/var/log/SRBMOEDA1.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Caminho do XMRig
XMRIG_PATH="/opt/xmrig/xmrig"

# Wallet Monero
MOEDA1_WALLET="44d4WZVR3vvYBKbvhoPY3Qa7oncbpYPz3M6G1BWp19JW9EjX7yWfJupB32SRaa5deaDey6YjLpGEmQ24gB315RHFS2Echuy"

# Worker / senha
MOEDA1_PASS="$(hostname)"

# Algoritmo Monero
MOEDA1_ALGO="rx/0"

# Pools HashVault
MOEDA1_POOL1="pool.hashvault.pro:443"
MOEDA1_POOL2="pool.hashvault.sh:443"

# TLS
TLS_FINGERPRINT="420c7850e09b7c0bdcf748a7da9eb3647daf8515718f36d9ccfdd6b9ff834b14"

# Número total de threads
TOTAL_THREADS=$(nproc)

# ============================================================
# Criar arquivos de log
# ============================================================

for logfile in "$MOEDA1_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# ============================================================
# PATH
# ============================================================

export PATH="$PATH"

# ============================================================
# Registrar ambiente
# ============================================================

env >> "$ENV_LOGFILE"

# ============================================================
# Informações iniciais
# ============================================================

echo "============================================================" >> "$MOEDA1_LOGFILE"
echo "$(date): Iniciando XMRig" >> "$MOEDA1_LOGFILE"
echo "$(date): Hostname: $(hostname)" >> "$MOEDA1_LOGFILE"
echo "$(date): CPU threads: $TOTAL_THREADS" >> "$MOEDA1_LOGFILE"
echo "$(date): Algoritmo: $MOEDA1_ALGO" >> "$MOEDA1_LOGFILE"
echo "$(date): Pool principal: $MOEDA1_POOL1" >> "$MOEDA1_LOGFILE"
echo "$(date): Pool failover: $MOEDA1_POOL2" >> "$MOEDA1_LOGFILE"
echo "============================================================" >> "$MOEDA1_LOGFILE"

# ============================================================
# Verificar XMRig
# ============================================================

if [ ! -x "$XMRIG_PATH" ]; then
    echo "$(date): ERRO - XMRig não encontrado em $XMRIG_PATH" >> "$ERROR_LOGFILE"
    exit 1
fi

# ============================================================
# Iniciar XMRig
# ============================================================

nice -n -20 "$XMRIG_PATH" \
    --algo="$MOEDA1_ALGO" \
    --url="$MOEDA1_POOL1" \
    --user="$MOEDA1_WALLET" \
    --pass="$MOEDA1_PASS" \
    --tls \
    --tls-fingerprint="$TLS_FINGERPRINT" \
    --url="$MOEDA1_POOL2" \
    --user="$MOEDA1_WALLET" \
    --pass="$MOEDA1_PASS" \
    --tls \
    --tls-fingerprint="$TLS_FINGERPRINT" \
    --threads="$TOTAL_THREADS" \
    --huge-pages \
    --donate-level=1 \
    >> "$MOEDA1_LOGFILE" 2>> "$ERROR_LOGFILE" &

XMRIG_PID=$!

echo "$(date): XMRig iniciado com PID $XMRIG_PID" >> "$MOEDA1_LOGFILE"

# ============================================================
# Aguardar processo
# ============================================================

wait "$XMRIG_PID"

EXIT_CODE=$?

echo "$(date): XMRig finalizado. Código: $EXIT_CODE" >> "$MOEDA1_LOGFILE"

exit "$EXIT_CODE"