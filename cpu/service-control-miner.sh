#!/bin/bash

# ============================================================================
# CONFIGURAÇÕES GERAIS
# ============================================================================

MOEDA_LOGFILE="/var/log/SRB_VIREL.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

for logfile in "$MOEDA_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

export PATH="$PATH"
env >> "$ENV_LOGFILE"

TOTAL_THREADS=$(nproc)
echo "$(date): Sistema com $TOTAL_THREADS threads detectadas." >> "$ENV_LOGFILE"

# ============================================================================
# INSTALAÇÃO DO SRBMINER 3.0.5
# ============================================================================

SRB_DIR="/home/wendell/SRBMiner"
SRB_PATH="$SRB_DIR/SRBMiner-Multi-3-0-5/SRBMiner-MULTI"

if [ ! -f "$SRB_PATH" ]; then
    echo "$(date): SRBMiner não encontrado. Baixando..." >> "$ERROR_LOGFILE"
    mkdir -p "$SRB_DIR" && cd "$SRB_DIR" || exit 1
    rm -rf SRBMiner-Multi-* *.tar.gz

    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/3.0.5/SRBMiner-Multi-3-0-5-Linux.tar.gz
    tar -xvf SRBMiner-Multi-3-0-5-Linux.tar.gz

    if [ ! -f "$SRB_PATH" ]; then
        SRB_PATH=$(find "$SRB_DIR" -name "SRBMiner-MULTI" | head -1)
        if [ -z "$SRB_PATH" ]; then
            echo "$(date): FALHA FATAL: SRBMiner não encontrado." >> "$ERROR_LOGFILE"
            exit 1
        fi
    fi

    chmod +x "$SRB_PATH"
    rm -f SRBMiner-Multi-3-0-5-Linux.tar.gz
else
    echo "$(date): SRBMiner encontrado." >> "$ENV_LOGFILE"
fi

# ============================================================================
# DETECÇÃO AVANÇADA DE CPU
# ============================================================================

CPU_MODEL=$(grep -i "model name" /proc/cpuinfo | head -1)

echo "$(date): CPU detectado: $CPU_MODEL" >> "$ENV_LOGFILE"

# AES
if grep -qi "aes" /proc/cpuinfo; then
    AES_OPT="--cpu-aes"
else
    AES_OPT=""
fi

# AVX (somente Intel / alguns FX)
if grep -qi "avx" /proc/cpuinfo; then
    AVX_OPT="--avx --no-avx2"
else
    AVX_OPT=""
fi

# ============================================================================
# REGRAS ESPECIAIS PARA AMD FX-6000 e FX-8000
# ============================================================================

LIMIT_THREADS=$TOTAL_THREADS

if echo "$CPU_MODEL" | grep -qiE "FX-6|FX-8"; then
    echo "$(date): CPU AMD FX detectado → ativando proteções térmicas." >> "$ENV_LOGFILE"

    # Limitar AVX (FX tem AVX defeituoso → desativado)
    AVX_OPT=""
    AES_OPT=""

    # Diminuir threads para evitar 80–95°C
    LIMIT_THREADS=$(( TOTAL_THREADS * 75 / 100 ))
    if [ $LIMIT_THREADS -lt 2 ]; then
        LIMIT_THREADS=2
    fi

    echo "$(date): Threads reduzidas para segurança: $LIMIT_THREADS" >> "$ENV_LOGFILE"
else
    LIMIT_THREADS=$TOTAL_THREADS
fi

# ============================================================================
# MELHORIA PARA INTEL 2ª E 3ª GERAÇÃO (Sandy/Ivy Bridge)
# ============================================================================

if echo "$CPU_MODEL" | grep -qiE "i7-3|i5-3|i7-2|i5-2"; then
    echo "$(date): Intel Sandy/Ivy Bridge detectado → AVX ativo, AVX2 desativado." >> "$ENV_LOGFILE"
fi

# ============================================================================
# GERAR cpu_threads.conf
# ============================================================================

THREADS_FILE="$SRB_DIR/cpu_threads.conf"

echo "[" > "$THREADS_FILE"

for ((i=0; i<LIMIT_THREADS; i++)); do
cat <<EOF >> "$THREADS_FILE"
  { "low_power_mode" : false, "no_prefetch" : false, "affine_to_cpu" : $i },
EOF
done

sed -i '$ s/,$//' "$THREADS_FILE"
echo "]" >> "$THREADS_FILE"

echo "$(date): cpu_threads.conf gerado com $LIMIT_THREADS threads" >> "$ENV_LOGFILE"

# ============================================================================
# CONFIGURAÇÃO RANDOMVIREL
# ============================================================================

POOL="stratum-na.rplant.xyz:7155"
WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
ALGO="randomvirel"
WORKER_NAME="$(hostname)"

echo "$(date): Iniciando minerador..." >> "$ENV_LOGFILE"

# ============================================================================
# EXECUÇÃO DO SRBMINER
# ============================================================================

COMMAND="$SRB_PATH --disable-gpu \
--algorithm $ALGO \
--pool $POOL \
--wallet $WALLET.$WORKER_NAME \
--cpu-threads $LIMIT_THREADS \
--cpu-threads-conf $THREADS_FILE \
--cpu-max-usage 100 \
--cpu-priority 5 \
--keepalive true \
--max-no-share-sent 600 \
$AES_OPT \
$AVX_OPT"

echo "$(date): Comando final: $COMMAND" >> "$MOEDA_LOGFILE"

$COMMAND >> "$MOEDA_LOGFILE" 2>> "$ERROR_LOGFILE" &
PID=$!

echo "$(date): SRBMiner iniciado com PID $PID" >> "$ENV_LOGFILE"

# ============================================================================
# MONITORAMENTO
# ============================================================================

sleep 8

check_cpu_usage() {
    echo "$(date): === STATUS DO SISTEMA ===" >> "$ENV_LOGFILE"
    top -bn1 | grep "Cpu(s)" >> "$ENV_LOGFILE"
    ps -p $PID -o pid,pcpu,pmem,comm >> "$ENV_LOGFILE"
    uptime | grep "load average" >> "$ENV_LOGFILE"
}

check_process() {
    if kill -0 $PID 2>/dev/null; then
        CPU_USAGE=$(ps -p $PID -o %cpu --no-headers | xargs)
        echo "$(date): Minerando OK - CPU ${CPU_USAGE}%" >> "$ENV_LOGFILE"
        return 0
    else
        echo "$(date): ❌ Minerador caiu" >> "$ERROR_LOGFILE"
        return 1
    fi
}

check_cpu_usage

while true; do
    if check_process; then
        sleep 30
    else
        break
    fi
done

wait $PID
echo "$(date): Minerador finalizou." >> "$ENV_LOGFILE"
