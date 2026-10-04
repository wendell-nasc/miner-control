#!/bin/bash

# ============================================================
# XMRig - Monero / RandomX / HashVault
# Detecção automática de CPU Intel / AMD
# Threads automáticas
# Config.json gerado automaticamente
# ============================================================

set -u

# ============================================================
# CONFIGURAÇÕES
# ============================================================

XMRIG_PATH="/opt/xmrig/xmrig"
XMRIG_CONFIG="/opt/xmrig/config.json"

MOEDA1_LOGFILE="/var/log/SRBMOEDA1.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

MOEDA1_WALLET="44d4WZVR3vvYBKbvhoPY3Qa7oncbpYPz3M6G1BWp19JW9EjX7yWfJupB32SRaa5deaDey6YjLpGEmQ24gB315RHFS2Echuy"

MOEDA1_ALGO="rx/0"

POOL1="pool.hashvault.pro:443"
POOL2="pool.hashvault.sh:443"

TLS_FINGERPRINT="420c7850e09b7c0bdcf748a7da9eb3647daf8515718f36d9ccfdd6b9ff834b14"

WORKER="$(hostname)"
PASSWORD="$WORKER"

# ============================================================
# FUNÇÕES DE LOG
# ============================================================

log()
{
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$MOEDA1_LOGFILE"
}

error()
{
    echo "$(date '+%Y-%m-%d %H:%M:%S'): ERRO: $1" >> "$ERROR_LOGFILE"
}

# ============================================================
# CRIAR LOGS
# ============================================================

for FILE in \
    "$MOEDA1_LOGFILE" \
    "$ENV_LOGFILE" \
    "$ERROR_LOGFILE"
do
    touch "$FILE"
    chmod 644 "$FILE"
done

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

CPU_PHYSICAL="$(lscpu -p=CORE | \
    grep -v '^#' | \
    sort -u | \
    wc -l)"

# proteção
if [ "$CPU_THREADS" -lt 1 ]; then
    CPU_THREADS=1
fi

if [ "$CPU_PHYSICAL" -lt 1 ]; then
    CPU_PHYSICAL=1
fi

# ============================================================
# DETECTAR ASM
# ============================================================

ASM="auto"

if echo "$CPU_VENDOR" | grep -qi "GenuineIntel"; then

    ASM="intel"

elif echo "$CPU_VENDOR" | grep -qi "AuthenticAMD"; then

    if echo "$CPU_MODEL" | grep -Eqi \
        'FX-|Opteron|Bulldozer|Piledriver|Steamroller|Excavator'
    then
        ASM="bulldozer"

    elif echo "$CPU_MODEL" | grep -Eqi \
        'Ryzen|Threadripper|EPYC'
    then
        ASM="ryzen"

    else
        ASM="auto"
    fi

fi

# ============================================================
# OPENCL PLATFORM
# ============================================================

OPENCL_PLATFORM="AMD"

if echo "$CPU_VENDOR" | grep -qi "GenuineIntel"; then
    OPENCL_PLATFORM="Intel"
fi

# ============================================================
# MOSTRAR INFORMAÇÕES
# ============================================================

echo
echo "============================================================"
echo "           XMRig - DETECÇÃO AUTOMÁTICA"
echo "============================================================"
echo "CPU..............: $CPU_MODEL"
echo "Vendor...........: $CPU_VENDOR"
echo "Cores físicos....: $CPU_PHYSICAL"
echo "Threads lógicos..: $CPU_THREADS"
echo "ASM..............: $ASM"
echo "Worker...........: $WORKER"
echo "Pool principal...: $POOL1"
echo "Pool failover....: $POOL2"
echo "============================================================"
echo

log "============================================================"
log "Iniciando XMRig"
log "CPU: $CPU_MODEL"
log "Vendor: $CPU_VENDOR"
log "Cores físicos: $CPU_PHYSICAL"
log "Threads lógicos: $CPU_THREADS"
log "ASM: $ASM"
log "Worker: $WORKER"
log "============================================================"

# ============================================================
# VERIFICAR XMRIG
# ============================================================

if [ ! -x "$XMRIG_PATH" ]; then
    error "XMRig não encontrado em $XMRIG_PATH"
    exit 1
fi

# ============================================================
# GERAR CONFIG.JSON
#
# Python é utilizado apenas para garantir que o JSON seja
# sintaticamente correto.
# ============================================================

export CPU_THREADS
export CPU_PHYSICAL
export ASM
export WORKER
export PASSWORD
export MOEDA1_WALLET
export POOL1
export POOL2
export TLS_FINGERPRINT
export MOEDA1_LOGFILE
export OPENCL_PLATFORM

python3 <<'PY'

import json
import os

threads = int(os.environ["CPU_THREADS"])
physical = int(os.environ["CPU_PHYSICAL"])

asm = os.environ["ASM"]
worker = os.environ["WORKER"]
password = os.environ["PASSWORD"]

wallet = os.environ["MOEDA1_WALLET"]

pool1 = os.environ["POOL1"]
pool2 = os.environ["POOL2"]

fingerprint = os.environ["TLS_FINGERPRINT"]

logfile = os.environ["MOEDA1_LOGFILE"]

opencl_platform = os.environ["OPENCL_PLATFORM"]

# ------------------------------------------------------------
# RandomX: TODOS os threads lógicos
# ------------------------------------------------------------

rx = list(range(threads))

# ------------------------------------------------------------
# CryptoNight: perfil compatível
# ------------------------------------------------------------

cn = [[1, i] for i in range(threads)]

cn_lite = [[1, i] for i in range(threads)]

cn_pico = [[2, i] for i in range(threads)]

cn_upx2 = [[2, i] for i in range(threads)]

ghostrider = [[8, i] for i in range(0, threads, 2)]

# ------------------------------------------------------------
# CN Heavy
#
# Uma thread a cada dois logical CPUs quando possível.
# Não afeta RandomX.
# ------------------------------------------------------------

cn_heavy = []

for i in range(0, threads, 2):

    cn_heavy.append([1, i])

    if len(cn_heavy) >= physical:
        break

# ------------------------------------------------------------
# Argon2
# Deve ser lista de inteiros, NÃO pares.
# ------------------------------------------------------------

argon2 = list(range(threads))

# ------------------------------------------------------------
# CONFIGURAÇÃO XMRIG
# ------------------------------------------------------------

config = {

    "api": {
        "id": None,
        "worker-id": worker
    },

    "http": {
        "enabled": False,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": None,
        "restricted": True
    },

    "autosave": False,

    "background": False,

    "colors": True,

    "title": True,

    "randomx": {
        "init": -1,
        "init-avx2": -1,
        "mode": "auto",
        "1gb-pages": False,
        "rdmsr": True,
        "wrmsr": True,
        "cache_qos": False,
        "numa": True,
        "scratchpad_prefetch_mode": 1
    },

    "cpu": {

        "enabled": True,

        "huge-pages": True,

        "huge-pages-jit": False,

        "hw-aes": None,

        "priority": 2,

        "memory-pool": False,

        "yield": False,

        "max-threads-hint": 100,

        "asm": asm,

        "argon2-impl": None,

        "argon2": argon2,

        "cn": cn,

        "cn-heavy": cn_heavy,

        "cn-lite": cn_lite,

        "cn-pico": cn_pico,

        "cn/upx2": cn_upx2,

        "ghostrider": ghostrider,

        "rx": rx,

        "rx/wow": rx,

        "cn-lite/0": False,

        "cn/0": False,

        "rx/arq": "rx/wow"
    },

    "opencl": {

        "enabled": False,

        "cache": True,

        "loader": None,

        "platform": opencl_platform,

        "adl": True,

        "cn-lite/0": False,

        "cn/0": False
    },

    "cuda": {

        "enabled": False,

        "loader": None,

        "nvml": True,

        "cn-lite/0": False,

        "cn/0": False
    },

    "log-file": logfile,

    "donate-level": 0,

    "donate-over-proxy": 0,

    "pools": [

        {

            "algo": "rx/0",

            "coin": "monero",

            "url": pool1,

            "user": wallet,

            "pass": password,

            "rig-id": worker,

            "nicehash": False,

            "keepalive": True,

            "enabled": True,

            "tls": True,

            "sni": False,

            "tls-fingerprint": fingerprint,

            "daemon": False,

            "socks5": None,

            "self-select": None,

            "submit-to-origin": False
        },

        {

            "algo": "rx/0",

            "coin": "monero",

            "url": pool2,

            "user": wallet,

            "pass": password,

            "rig-id": worker,

            "nicehash": False,

            "keepalive": True,

            "enabled": True,

            "tls": True,

            "sni": False,

            "tls-fingerprint": fingerprint,

            "daemon": False,

            "socks5": None,

            "self-select": None,

            "submit-to-origin": False
        }

    ],

    "retries": 5,

    "retry-pause": 5,

    "print-time": 60,

    "health-print-time": 60,

    "dmi": True,

    "syslog": False,

    "tls": {

        "enabled": False,

        "protocols": None,

        "cert": None,

        "cert_key": None,

        "ciphers": None,

        "ciphersuites": None,

        "dhparam": None
    },

    "dns": {

        "ip_version": 0,

        "ttl": 30
    },

    "user-agent": None,

    "verbose": 0,

    "watch": False,

    "pause-on-battery": False,

    "pause-on-active": False
}

path = "/opt/xmrig/config.json"

with open(path, "w") as f:
    json.dump(config, f, indent=4)

print("Config gerado:", path)
print("Threads RandomX:", threads)
print("ASM:", asm)

PY

# ============================================================
# VALIDAR JSON
# ============================================================

if ! python3 -m json.tool "$XMRIG_CONFIG" > /dev/null 2>&1; then

    error "config.json inválido!"

    python3 -m json.tool "$XMRIG_CONFIG" 2>> "$ERROR_LOGFILE"

    exit 1

fi

log "config.json validado."

# ============================================================
# TESTE DRY-RUN
# ============================================================

echo
echo "============================================================"
echo "VALIDANDO XMRig..."
echo "============================================================"

"$XMRIG_PATH" \
    --config="$XMRIG_CONFIG" \
    --dry-run \
    >> "$MOEDA1_LOGFILE" \
    2>> "$ERROR_LOGFILE"

DRYRUN_RESULT=$?

if [ "$DRYRUN_RESULT" -ne 0 ]; then

    error "XMRig rejeitou o config.json."

    echo
    echo "ERRO: XMRig não aceitou a configuração."
    echo "Veja:"
    echo "$ERROR_LOGFILE"
    echo

    exit 1

fi

log "Dry-run do XMRig concluído com sucesso."

# ============================================================
# INICIAR XMRIG
# ============================================================

echo
echo "============================================================"
echo "INICIANDO MINERAÇÃO"
echo "============================================================"
echo "CPU: $CPU_MODEL"
echo "Threads: $CPU_THREADS"
echo "ASM: $ASM"
echo "Worker: $WORKER"
echo "============================================================"
echo

nice -n -20 "$XMRIG_PATH" \
    --config="$XMRIG_CONFIG" \
    >> "$MOEDA1_LOGFILE" \
    2>> "$ERROR_LOGFILE" &

XMRIG_PID=$!

log "XMRig iniciado. PID=$XMRIG_PID"

# ============================================================
# AGUARDAR
# ============================================================

wait "$XMRIG_PID"

EXIT_CODE=$?

log "XMRig finalizado. Código=$EXIT_CODE"

exit "$EXIT_CODE"