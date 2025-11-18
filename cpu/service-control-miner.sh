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

env >> "$ENV_LOGFILE"

# ============================================================================
# CONFIGURAÇÃO DO XMRIG-VRL
# ============================================================================

VRL_DIR="/home/wendell/xmrig-vrl"
VRL_VERSION="6.0.24-virel"
VRL_TGZ="xmrig-vrl-linux.tar.xz"
VRL_URL="https://github.com/rplant8/xmrig-vrl/releases/download/${VRL_VERSION}/${VRL_TGZ}"

VRL_TGZ_PATH="$VRL_DIR/$VRL_TGZ"
VRL_PATH="$VRL_DIR/xmrig-vrl"

# Criar diretório
mkdir -p "$VRL_DIR"

# SEMPRE REMOVER VERSÕES ANTERIORES
echo "$(date): Removendo versões anteriores do XMRig-VRL..." >> "$ENV_LOGFILE"
rm -rf "$VRL_DIR"/*
rm -f "$VRL_TGZ_PATH"

# SEMPRE BAIXAR NOVA VERSÃO
echo "$(date): Baixando XMRig-VRL..." >> "$ENV_LOGFILE"
if wget -O "$VRL_TGZ_PATH" "$VRL_URL" 2>> "$ERROR_LOGFILE"; then
    echo "$(date): Download concluído com sucesso" >> "$ENV_LOGFILE"
else
    echo "$(date): ERRO: Falha no download do XMRig-VRL" >> "$ERROR_LOGFILE"
    exit 1
fi

# SEMPRE EXTRAIR NOVA VERSÃO
echo "$(date): Extraindo XMRig-VRL..." >> "$ENV_LOGFILE"
if tar -xf "$VRL_TGZ_PATH" -C "$VRL_DIR" 2>> "$ERROR_LOGFILE"; then
    echo "$(date): Extração concluída com sucesso" >> "$ENV_LOGFILE"
    
    # Encontrar o binário extraído (pode ter nome diferente)
    if [ -f "$VRL_PATH" ]; then
        chmod +x "$VRL_PATH"
        echo "$(date): Binário encontrado e permissões configuradas: $VRL_PATH" >> "$ENV_LOGFILE"
    else
        # Tentar encontrar o binário com nome diferente
        BINARY=$(find "$VRL_DIR" -name "xmrig*" -type f -executable | head -1)
        if [ -n "$BINARY" ]; then
            VRL_PATH="$BINARY"
            echo "$(date): Binário encontrado: $VRL_PATH" >> "$ENV_LOGFILE"
        else
            echo "$(date): ERRO: Não foi possível encontrar o binário do XMRig" >> "$ERROR_LOGFILE"
            exit 1
        fi
    fi
    
    # Limpar arquivo tar após extração
    rm -f "$VRL_TGZ_PATH"
    echo "$(date): Arquivo tar removido" >> "$ENV_LOGFILE"
else
    echo "$(date): ERRO: Falha na extração do XMRig-VRL" >> "$ERROR_LOGFILE"
    exit 1
fi

# ============================================================================
# MINERAÇÃO RANDOMVIREL
# ============================================================================

MOEDA1_POOL="na.rplant.xyz:17155"
MOEDA1_WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
MOEDA1_ALGO="rx/vrl"
TOTAL_THREADS=$(nproc)

echo "$(date): Iniciando mineração..." >> "$MOEDA1_LOGFILE"

# Verificar se o binário existe e é executável
if [ ! -f "$VRL_PATH" ] || [ ! -x "$VRL_PATH" ]; then
    echo "$(date): ERRO: Binário do XMRig não encontrado ou não executável: $VRL_PATH" >> "$ERROR_LOGFILE"
    exit 1
fi

echo "$(date): Executando: $VRL_PATH" >> "$ENV_LOGFILE"

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

echo "$(date): XMRig-VRL iniciado. PID=$PID1" >> "$ENV_LOGFILE"

# Manter o script rodando para o systemd não pensar que terminou
while kill -0 "$PID1" 2>/dev/null; do
    sleep 30
done

echo "$(date): XMRig-VRL finalizou." >> "$ENV_LOGFILE"