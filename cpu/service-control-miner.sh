#!/bin/bash

# Definir arquivos de log
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
DEROLUNA_LOGFILE="/var/log/start-deroluna-xdag_gustavo.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/start-miner-errors.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$XMRIG_LOGFILE" "$DEROLUNA_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    if [ ! -f "$logfile" ]; then
        touch "$logfile"
    fi
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
XMRIG_THREADS=$(nproc) # Número de threads baseado nas CPUs disponíveis
XMRIG_HTTP_PORT="37329"
XMRIG_HTTP_TOKEN="auth"
XMRIG_DONATE_LEVEL="1" # Nível de doação
XMRIG_CONFIG="/opt/xmrig/config.json"

# Criar ou atualizar o arquivo de configuração do XMRig
cat > "$XMRIG_CONFIG" <<EOL
{
    "api": {
        "id": null,
        "worker-id": "$(hostname)"
    },
    "autosave": true,
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "hw-aes": null,
        "asm": true
    },
    "pools": [
        {
            "url": "$XMRIG_POOL",
            "user": "$XMRIG_USER",
            "pass": "x",
            "keepalive": true,
            "tls": false
        }
    ],
    "http": {
        "enabled": true,
        "host": "127.0.0.1",
        "port": $XMRIG_HTTP_PORT,
        "access-token": "$XMRIG_HTTP_TOKEN",
        "restricted": false
    },
    "donate-level": $XMRIG_DONATE_LEVEL
}
EOL

# Garantir que o arquivo de configuração tenha permissões adequadas
chmod 644 "$XMRIG_CONFIG"

# Validar a existência do binário XMRig
if [ -x "$XMRIG_BINARY" ]; then
    echo "$(date): Iniciando XMRig Miner..." >> "$XMRIG_LOGFILE"
    "$XMRIG_BINARY" --config="$XMRIG_CONFIG" >> "$XMRIG_LOGFILE" 2>> "$ERROR_LOGFILE" &
else
    echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $XMRIG_BINARY" >> "$ERROR_LOGFILE"
fi

# Variáveis para o Deroluna Miner
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/deroluna-miner"
HORA_ATUAL=$(date +%H)

# Definir a variável DEROLUNA_POOL com base na hora atual
DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"

DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)

# Validar a existência do binário Deroluna
if [ -x "$DEROLUNA_BINARY" ]; then
    echo "$(date): Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
    "$DEROLUNA_BINARY" --xmrig \
        -d "$DEROLUNA_POOL" \
        -w "$DEROLUNA_WALLET" \
        -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> "$ERROR_LOGFILE" &
else
    echo "$(date): ERRO: Binário Deroluna não encontrado ou sem permissões em $DEROLUNA_BINARY" >> "$ERROR_LOGFILE"
fi

# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso." | tee -a "$XMRIG_LOGFILE" "$DEROLUNA_LOGFILE"
