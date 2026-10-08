#!/bin/bash

# ============================================================
# XMRig - MONERO / RANDOMX / C3POOL
# ============================================================
#
# Características:
# - Instala XMRig automaticamente se não existir
# - Utiliza instalador oficial do C3Pool
# - Worker automático pelo hostname
# - RandomX rx/0
# - Huge Pages
# - RDMSR / WRMSR
# - 4 cores físicos para i7-3770
# - TLS desativado / porta 80
# - Configuração independente do config.json original
# - Validação JSON
# - Dry-run antes da mineração
#
# ============================================================

set -u

# ============================================================
# CONFIGURAÇÕES
# ============================================================

XMRIG_DIR="/home/wendell/c3pool"
XMRIG_PATH="$XMRIG_DIR/xmrig"
XMRIG_CONFIG="$XMRIG_DIR/config_custom.json"

INSTALLER="/tmp/setup_c3pool_miner.sh"

LOGFILE="/var/log/XMRIG_C3POOL.log"
ERROR_LOG="/var/log/XMRIG_C3POOL_error.log"

# ============================================================
# CARTEIRA MONERO
# ============================================================

WALLET="44d4WZVR3vvYBKbvhoPY3Qa7oncbpYPz3M6G1BWp19JW9EjX7yWfJupB32SRaa5deaDey6YjLpGEmQ24gB315RHFS2Echuy"

# ============================================================
# C3POOL
# ============================================================

POOL="auto.c3pool.org:80"

# ============================================================
# WORKER
# ============================================================

WORKER="$(hostname)"

# ============================================================
# LOGS
# ============================================================

mkdir -p "$XMRIG_DIR"

touch "$LOGFILE" "$ERROR_LOG" 2>/dev/null || true

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERRO: $1" >> "$ERROR_LOG"
}

# ============================================================
# CABEÇALHO
# ============================================================

echo
echo "============================================================"
echo "              XMRIG - C3POOL / MONERO"
echo "============================================================"
echo
echo "Worker : $WORKER"
echo "Pool   : $POOL"
echo
echo "============================================================"
echo

log "Script iniciado."
log "Worker: $WORKER"
log "Pool: $POOL"

# ============================================================
# VERIFICAR CURL
# ============================================================

if ! command -v curl >/dev/null 2>&1; then

    echo "ERRO: curl não está instalado."
    echo
    echo "Instale com:"
    echo
    echo "sudo apt update && sudo apt install -y curl"
    echo

    error "curl não encontrado."

    exit 1
fi

# ============================================================
# VERIFICAR PYTHON
# ============================================================

if ! command -v python3 >/dev/null 2>&1; then

    echo "ERRO: python3 não está instalado."
    echo
    echo "Instale com:"
    echo
    echo "sudo apt update && sudo apt install -y python3"
    echo

    error "python3 não encontrado."

    exit 1
fi

# ============================================================
# INSTALAR XMRIG C3POOL SE NÃO EXISTIR
# ============================================================

echo
echo "============================================================"
echo "             VERIFICANDO XMRIG C3POOL"
echo "============================================================"
echo

if [ ! -f "$XMRIG_PATH" ] || [ ! -x "$XMRIG_PATH" ]; then

    echo "XMRig C3Pool NÃO encontrado."
    echo
    echo "Esperado:"
    echo "$XMRIG_PATH"
    echo
    echo "Iniciando download do instalador oficial C3Pool..."
    echo

    log "XMRig não encontrado."
    log "Iniciando instalação C3Pool."

    # --------------------------------------------------------
    # DOWNLOAD DO INSTALADOR
    # --------------------------------------------------------

    rm -f "$INSTALLER"

    curl -fL \
        --retry 3 \
        --retry-delay 3 \
        --connect-timeout 15 \
        --max-time 120 \
        "https://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh" \
        -o "$INSTALLER"

    RESULT=$?

    if [ "$RESULT" -ne 0 ]; then

        echo
        echo "============================================================"
        echo "ERRO AO BAIXAR INSTALADOR C3POOL"
        echo "============================================================"
        echo
        echo "Código: $RESULT"
        echo

        error "Falha no download do instalador. Código: $RESULT"

        rm -f "$INSTALLER"

        exit 1
    fi

    # --------------------------------------------------------
    # VALIDAR INSTALADOR
    # --------------------------------------------------------

    if [ ! -s "$INSTALLER" ]; then

        echo
        echo "ERRO: instalador baixado está vazio."
        echo

        error "Instalador C3Pool vazio."

        rm -f "$INSTALLER"

        exit 1
    fi

    chmod +x "$INSTALLER"

    echo "Instalador baixado:"
    ls -lh "$INSTALLER"

    echo
    echo "Executando instalador oficial C3Pool..."
    echo

    log "Instalador C3Pool baixado."
    log "Executando instalador C3Pool."

    # --------------------------------------------------------
    # EXECUTAR INSTALADOR
    # --------------------------------------------------------

    LC_ALL=en_US.UTF-8 \
        bash "$INSTALLER" "$WALLET"

    RESULT=$?

    if [ "$RESULT" -ne 0 ]; then

        echo
        echo "============================================================"
        echo "ERRO NA INSTALAÇÃO DO C3POOL"
        echo "============================================================"
        echo
        echo "Código de saída: $RESULT"
        echo

        error "Instalação C3Pool falhou. Código: $RESULT"

        exit 1
    fi

    echo
    echo "Instalador C3Pool finalizado."
    echo

    log "Instalador C3Pool finalizado."

else

    echo "XMRig C3Pool já existe:"
    echo "$XMRIG_PATH"
    echo

    log "XMRig já instalado: $XMRIG_PATH"

fi

# ============================================================
# CONFIRMAR XMRIG
# ============================================================

echo
echo "============================================================"
echo "             VERIFICANDO EXECUTÁVEL XMRIG"
echo "============================================================"
echo

if [ ! -f "$XMRIG_PATH" ]; then

    echo "ERRO: o instalador terminou, mas o XMRig não foi encontrado."
    echo
    echo "Arquivo esperado:"
    echo "$XMRIG_PATH"
    echo
    echo "Procurando outros XMRig existentes:"
    echo

    find /home/wendell \
        -maxdepth 4 \
        -type f \
        -name "xmrig" \
        -ls 2>/dev/null

    error "XMRig não encontrado após instalação."

    exit 1
fi

chmod +x "$XMRIG_PATH"

if [ ! -x "$XMRIG_PATH" ]; then

    echo "ERRO: XMRig existe, mas não é executável:"
    echo "$XMRIG_PATH"

    error "XMRig não executável."

    exit 1
fi

echo "XMRig encontrado:"
echo "$XMRIG_PATH"

echo
echo "Versão:"
"$XMRIG_PATH" --version

echo

log "XMRig confirmado: $XMRIG_PATH"

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
# DEFINIR THREADS RANDOMX
# ============================================================

# Para i7-3770:
#
# 4 cores físicos
# 8 threads lógicos
#
# Benchmark observado no C3Pool:
#
# rx/0 ≈ 2441 H/s
# com 4 threads
#
# Portanto usamos 1 thread por core físico.

if [ "$CPU_PHYSICAL" -ge 4 ]; then

    RX_THREADS=4

elif [ "$CPU_PHYSICAL" -gt 0 ]; then

    RX_THREADS="$CPU_PHYSICAL"

else

    RX_THREADS=1

fi

# ============================================================
# MOSTRAR CPU
# ============================================================

echo
echo "============================================================"
echo "                    CPU DETECTADA"
echo "============================================================"
echo
echo "Modelo..............: $CPU_MODEL"
echo "Fabricante..........: $CPU_VENDOR"
echo "Cores físicos.......: $CPU_PHYSICAL"
echo "Threads lógicos.....: $CPU_THREADS"
echo "Threads RandomX.....: $RX_THREADS"
echo
echo "============================================================"
echo

log "CPU: $CPU_MODEL"
log "Vendor: $CPU_VENDOR"
log "Cores físicos: $CPU_PHYSICAL"
log "Threads lógicos: $CPU_THREADS"
log "Threads RandomX: $RX_THREADS"

# ============================================================
# GERAR CONFIGURAÇÃO
# ============================================================

echo "Gerando:"
echo "$XMRIG_CONFIG"
echo

export WALLET
export POOL
export WORKER
export LOGFILE
export XMRIG_CONFIG
export RX_THREADS

python3 <<'PY'

import json
import os

wallet = os.environ["WALLET"]
pool = os.environ["POOL"]
worker = os.environ["WORKER"]
logfile = os.environ["LOGFILE"]
config_path = os.environ["XMRIG_CONFIG"]
rx_threads = int(os.environ["RX_THREADS"])

# ============================================================
# THREAD AFFINITY
# ============================================================

rx = list(range(rx_threads))

config = {

    "api": {
        "id": None,
        "worker-id": None
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

        "init-avx2": 0,

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

        "memory-pool": True,

        "yield": True,

        "asm": True,

        "rx": rx
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

            "url": pool,

            "user": wallet,

            "pass": worker,

            "rig-id": None,

            "nicehash": False,

            "keepalive": True,

            "enabled": True,

            "tls": False,

            "sni": False,

            "tls-fingerprint": None,

            "daemon": False,

            "socks5": None,

            "self-select": None,

            "submit-to-origin": False
        }
    ],

    "retries": 5,

    "retry-pause": 5,

    "print-time": 60,

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

    "watch": True,

    "donate-level": 0,

    "donate-over-proxy": 1,

    "log-file": logfile
}

with open(config_path, "w") as f:

    json.dump(
        config,
        f,
        indent=4
    )

print("Configuração criada com sucesso.")

PY

RESULT=$?

if [ "$RESULT" -ne 0 ]; then

    echo
    echo "ERRO ao gerar configuração."
    echo

    error "Falha ao gerar configuração."

    exit 1
fi

# ============================================================
# VALIDAR JSON
# ============================================================

echo
echo "============================================================"
echo "               VALIDANDO CONFIG.JSON"
echo "============================================================"
echo

if ! python3 -m json.tool "$XMRIG_CONFIG" > /dev/null 2>&1; then

    echo "ERRO: JSON inválido."
    echo

    error "JSON inválido."

    exit 1
fi

echo "JSON válido."
echo

log "JSON validado."

# ============================================================
# MOSTRAR CONFIGURAÇÃO IMPORTANTE
# ============================================================

echo "Configuração:"
echo
echo "Pool       : $POOL"
echo "Worker     : $WORKER"
echo "Algoritmo  : rx/0"
echo "Threads    : $RX_THREADS"
echo "TLS        : false"
echo "Huge Pages : true"
echo

# ============================================================
# DRY RUN
# ============================================================

echo
echo "============================================================"
echo "             TESTANDO XMRIG - DRY RUN"
echo "============================================================"
echo

"$XMRIG_PATH" \
    --config="$XMRIG_CONFIG" \
    --dry-run \
    >> "$LOGFILE" \
    2>> "$ERROR_LOG"

RESULT=$?

if [ "$RESULT" -ne 0 ]; then

    echo
    echo "============================================================"
    echo "       ERRO: XMRIG REJEITOU A CONFIGURAÇÃO"
    echo "============================================================"
    echo
    echo "Últimos erros:"
    echo

    tail -30 "$ERROR_LOG"

    error "XMRig rejeitou a configuração. Código: $RESULT"

    exit 1
fi

echo "Dry-run concluído com sucesso."
echo

log "Dry-run concluído com sucesso."

# ============================================================
# INICIAR MINERAÇÃO
# ============================================================

echo
echo "============================================================"
echo "                  MINERAÇÃO INICIADA"
echo "============================================================"
echo
echo "XMRig..............: $XMRIG_PATH"
echo "Pool...............: $POOL"
echo "Worker.............: $WORKER"
echo "Algoritmo..........: rx/0"
echo "Threads RandomX....: $RX_THREADS"
echo "Huge Pages.........: Ativado"
echo "TLS................: Desativado"
echo
echo "Log:"
echo "$LOGFILE"
echo
echo "Erros:"
echo "$ERROR_LOG"
echo
echo "============================================================"
echo

log "Mineração iniciada."

# ============================================================
# EXECUTAR XMRIG
# ============================================================

exec "$XMRIG_PATH" \
    --config="$XMRIG_CONFIG" \
    >> "$LOGFILE" \
    2>> "$ERROR_LOG"
```
