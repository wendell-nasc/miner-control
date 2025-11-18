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
VRL_EXTRACT_DIR="$VRL_DIR/xmrig-proxy-vrl-linux"
VRL_PATH="$VRL_EXTRACT_DIR/xmrig-vrl"

# Verifica se existe o binário
if [ ! -f "$VRL_PATH" ]; then
    echo "$(date): XMRig-VRL não encontrado. Baixando versão $VRL_VERSION..." >> "$ERROR_LOGFILE"

    mkdir -p "$VRL_DIR" || exit 1
    cd "$VRL_DIR" || exit 1

    # Remove versões antigas
    rm -rf xmrig-* xmrig-vrl* xmrig-proxy-vrl-linux*

    # Baixar nova versão
    wget "$VRL_URL" -O "$VRL_TGZ" >> "$ENV_LOGFILE" 2>> "$ERROR_LOGFILE"

    # Extrair arquivos
    tar -xvf "$VRL_TGZ" >> "$ENV_LOGFILE" 2>> "$ERROR_LOGFILE"

    # Conferir extração
    if [ -f "$VRL_PATH" ]; then
        chmod +x "$VRL_PATH"
        echo "$(date): XMRig-VRL $VRL_VERSION baixado e configurado." >> "$ENV_LOGFILE"
    else
        echo "$(date): ERRO: XMRig-VRL não foi extraído corretamente." >> "$ERROR_LOGFILE"
        find "$VRL_DIR" -type f -executable >> "$ERROR_LOGFILE"
        exit 1
    fi
else
    echo "$(date): XMRig-VRL $VRL_VERSION já está instalado." >> "$ENV_LOGFILE"
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
