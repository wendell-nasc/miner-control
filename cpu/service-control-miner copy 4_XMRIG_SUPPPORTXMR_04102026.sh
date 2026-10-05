#!/bin/sh

# ============================================================
# XMRig - MONERO / RANDOMX / SUPPORTXMR
# Compatível com SH e BASH
# Intel / AMD
# Worker automático pelo hostname
# ============================================================

set -u

# ============================================================
# CONFIGURAÇÕES
# ============================================================

XMRIG_PATH="/opt/xmrig/xmrig"
XMRIG_CONFIG="/opt/xmrig/config.json"

LOGFILE="/var/log/SRBMOEDA1.log"
ERROR_LOG="/var/log/error.log"

# Dificuldade fixa 1000 anexada ao endereço da carteira
WALLET="44d4WZVR3vvYBKbvhoPY3Qa7oncbpYPz3M6G1BWp19JW9EjX7yWfJupB32SRaa5deaDey6YjLpGEmQ24gB315RHFS2Echuy+1000"

# Porta 3333 = baixa dificuldade inicial + suporta dificuldade fixa via +N
# NÃO usar TLS nesta porta (o sufixo +1000 só funciona sem TLS)
POOL="pool.supportxmr.com:3333"

WORKER="$(hostname)"
ASM="auto"

# ============================================================
# LOGS
# ============================================================

mkdir -p /opt/xmrig
touch "$LOGFILE" "$ERROR_LOG"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERRO: $1" >> "$ERROR_LOG"
}

# ============================================================
# VERIFICAR XMRIG
# ============================================================

if [ ! -x "$XMRIG_PATH" ]; then
    error "XMRig não encontrado: $XMRIG_PATH"
    exit 1
fi

# ============================================================
# DETECTAR CPU
# ============================================================

CPU_VENDOR="$(lscpu | awk -F: '/Vendor ID:/ {
    gsub(/^[ \t]+|[ \t]+$/, "", $2);
    print $2
}')"

CPU_MODEL="$(lscpu | awk -F: '/Model name:/ {
    gsub(/^[ \t]+|[ \t]+$/, "", $2);
    print $2
}')"

CPU_THREADS="$(nproc)"

CPU_PHYSICAL="$(lscpu -p=CORE |
    grep -v '^#' |
    sort -u |
    wc -l | tr -d ' ')"

[ "$CPU_THREADS" -lt 1 ] && CPU_THREADS=1
[ "$CPU_PHYSICAL" -lt 1 ] && CPU_PHYSICAL=1

# ============================================================
# DETECTAR ASM - SH COMPATÍVEL
# ============================================================

case "$CPU_VENDOR" in
    GenuineIntel)
        ASM="intel"
        ;;
    AuthenticAMD)
        case "$CPU_MODEL" in
            *FX-*|*Opteron*|*Bulldozer*|*Piledriver*|*Steamroller*|*Excavator*)
                ASM="bulldozer"
                ;;
            *Ryzen*|*Threadripper*|*EPYC*)
                ASM="ryzen"
                ;;
            *)
                ASM="auto"
                ;;
        esac
        ;;
    *)
        ASM="auto"
        ;;
esac

# ============================================================
# MOSTRAR CONFIGURAÇÃO
# ============================================================

echo
echo "=================================================="
echo "             XMRIG - SUPPORTXMR"
echo "=================================================="
echo "CPU.............: $CPU_MODEL"
echo "Vendor..........: $CPU_VENDOR"
echo "Cores físicos...: $CPU_PHYSICAL"
echo "Threads.........: $CPU_THREADS"
echo "ASM.............: $ASM"
echo "Worker..........: $WORKER"
echo "Carteira........: $(printf '%s' "$WALLET" | cut -c1-12)...+1000"
echo "Pool............: $POOL"
echo "Algoritmo.......: rx/0"
echo "TLS.............: Desativado (porta 3333)"
echo "Dificuldade.....: 1000 (fixa)"
echo "=================================================="
echo

log "Iniciando XMRig - SupportXMR"
log "CPU: $CPU_MODEL"
log "Vendor: $CPU_VENDOR"
log "Threads: $CPU_THREADS"
log "ASM: $ASM"
log "Worker: $WORKER"
log "Pool: $POOL"
log "Dificuldade: 1000"

# ============================================================
# GERAR CONFIG.JSON
# ============================================================

export WALLET POOL WORKER ASM LOGFILE

python3 <<'PY'

import json
import os

config = {
    "autosave": False,
    "background": False,
    "colors": True,
    "title": True,

    "randomx": {
        "mode": "auto",
        "1gb-pages": False,
        "rdmsr": True,
        "wrmsr": True,
        "numa": True
    },

    "cpu": {
        "enabled": True,
        "huge-pages": True,
        "priority": 2,
        "yield": False,
        "max-threads-hint": 100,
        "asm": os.environ["ASM"]
    },

    "opencl": {
        "enabled": False
    },

    "cuda": {
        "enabled": False
    },

    "pools": [
        {
            "algo": "rx/0",
            "coin": "monero",
            "url": os.environ["POOL"],
            "user": os.environ["WALLET"],
            "pass": os.environ["WORKER"],
            "keepalive": True,
            "enabled": True,
            "tls": False
        }
    ],

    "retries": 10,
    "retry-pause": 5,
    "print-time": 60,
    "health-print-time": 60,
    "log-file": os.environ["LOGFILE"],
    "donate-level": 0
}

path = "/opt/xmrig/config.json"

with open(path, "w") as f:
    json.dump(config, f, indent=4)

print("Config gerado:", path)

PY

if [ "$?" -ne 0 ]; then
    error "Falha ao gerar config.json"
    exit 1
fi

# ============================================================
# VALIDAR JSON
# ============================================================

if ! python3 -m json.tool "$XMRIG_CONFIG" > /dev/null 2>&1; then
    error "Configuração JSON inválida"
    exit 1
fi

log "Configuração JSON validada."

# ============================================================
# VALIDAR XMRIG
# ============================================================

echo
echo "VALIDANDO CONFIGURAÇÃO XMRIG..."
echo

"$XMRIG_PATH" \
    --config="$XMRIG_CONFIG" \
    --dry-run \
    >> "$LOGFILE" 2>> "$ERROR_LOG"

RESULT=$?

if [ "$RESULT" -ne 0 ]; then
    error "XMRig rejeitou a configuração."
    exit 1
fi

log "Dry-run concluído com sucesso."

# ============================================================
# INICIAR MINERAÇÃO
# ============================================================

echo
echo "=================================================="
echo "             MINERAÇÃO INICIADA"
echo "=================================================="
echo "Pool: $POOL"
echo "Worker: $WORKER"
echo "Threads: $CPU_THREADS"
echo "ASM: $ASM"
echo "Dificuldade: 1000"
echo "=================================================="
echo

exec "$XMRIG_PATH" \
    --config="$XMRIG_CONFIG" \
    >> "$LOGFILE" 2>> "$ERROR_LOG"