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
CONFIG='"http": { "enabled": true, "host": "127.0.0.1", "port": 37329, "access-token": "auth", "restricted": false }"'

# Iniciar o minerador XMRig com as configurações específicas
echo "Iniciando XMRig Miner..." >> $XMRIG_LOGFILE
"$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --http-port $HTTP_PORT --http-no-restricted --http-access-token $XMRIG_HTTP_TOKEN  >> "$XMRIG_LOGFILE" 2>> /var/log/start-deroluna-errors.log &



# Aguardar um pouco
sleep 2

# Variáveis para o Deroluna Miner
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/deroluna-miner"

# Definir a variável DEROLUNA_POOL com base na hora atual
HORA_ATUAL=$(date +%H)
if [ "$HORA_ATUAL" -ge 0 ] && [ "$HORA_ATUAL" -le 12 ]; then
    DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
else
    # DEROLUNA_POOL="derosolo.bernacripto.com.br:10100"
    #DEROLUNA_POOL="community-pools.mysrv.cloud:10100"
    DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
    
    
fi

DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)


# Iniciar o minerador Deroluna
echo "Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
"$DEROLUNA_BINARY" --xmrig -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados."
#testeteststste