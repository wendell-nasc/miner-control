#!/bin/bash

# Definir arquivos de log
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
DEROLUNA_LOGFILE="/var/log/start-deroluna-xdag_gustavo.log"
ENV_LOGFILE="/var/log/start-env.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$XMRIG_LOGFILE" "$DEROLUNA_LOGFILE" "$ENV_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exportar o PATH para garantir o ambiente adequado
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"


# Variáveis para o XMRig
XMRIG_BINARY="/opt/xmrig/xmrig"
XMRIG_POOL="randomx.rplant.xyz:7020"
XMRIG_USER="XM3AyS2F9ya65NQunXYTdFfqMu7kAd2ay7sqJV7UUaSFG4WvWgUE6QgQw6N3zqZc7GcqY9JSPDMgP2J1WcEtcwhA37RYNZhxA.$(hostname)"
XMRIG_ALGO="randomx"
XMRIG_THREADS=$(nproc) # Define o número de threads baseado no número de CPUs disponíveis
XMRIG_HTTP_PORT="37329"
XMRIG_HTTP_TOKEN="auth"
XMRIG_DONATE_LEVEL="1" # Definir nível de doação para 1%
CONFIG="/opt/xmrig/config.json"

# Iniciar o minerador XMRig com as configurações específicas
echo "Iniciando XMRig Miner..." >> $XMRIG_LOGFILE
"$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --http-port $HTTP_PORT --http-no-restricted --http-access-token $XMRIG_HTTP_TOKEN  >> "$XMRIG_LOGFILE" 2>> /var/log/start-deroluna-errors.log 