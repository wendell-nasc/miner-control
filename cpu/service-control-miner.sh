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
XMRIG_BINARY="/home/wendell/xdag/xmrig-4-xdag/xmrig-4-xdag"
XMRIG_POOL="stratum.xdag.org:23656"
XMRIG_USER="Dzdbr5d8PVafQwvEkEwfNde7mFKNDaDSv.$(hostname)"
XMRIG_ALGO="rx/xdag"
XMRIG_THREADS=$(nproc)
XMRIG_HTTP_PORT="37329"
XMRIG_HTTP_TOKEN="auth"
XMRIG_DONATE_LEVEL="1"
CONFIG="/opt/xmrig/config.json"

# Criar ou atualizar o arquivo de configuração do XMRig
cat > "$CONFIG" <<EOL
{
    "autosave": true,
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "hw-aes": true,
        "priority": 5,
        "memory-pool": true,
        "max-threads-hint": 100,
        "asm": true,
        "argon2-impl": null,
        "astrobwt-max-size": 550,
        "astrobwt-avx2": true,
        "1gb-pages": true
    },
    "http": {
        "enabled": true,
        "host": "127.0.0.1",
        "port": 37329,
        "access-token": "auth",
        "restricted": false
    }
}
EOL

# Garantir que o arquivo de configuração tenha permissões adequadas
chmod 644 "$CONFIG"

# Validar a existência do binário XMRig
if [ -x "$XMRIG_BINARY" ]; then
    echo "$(date): Iniciando XMRig Miner..." >> "$XMRIG_LOGFILE"
    "$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$CONFIG" >> "$XMRIG_LOGFILE" 2>> "$ERROR_LOGFILE" &
else
    echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $XMRIG_BINARY" >> "$ERROR_LOGFILE"
fi

# Aguardar um pouco
sleep 2

# Variáveis para o Deroluna Miner
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/deroluna-miner"

# Definir a variável DEROLUNA_POOL com base na hora atual
HORA_ATUAL=$(date +%H)
if [ "$HORA_ATUAL" -ge 0 ] && [ "$HORA_ATUAL" -le 12 ]; then
    DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
else
    DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
fi

DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)

# Validar a existência do binário Deroluna
if [ -x "$DEROLUNA_BINARY" ]; then
    echo "$(date): Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
    "$DEROLUNA_BINARY" --xmrig -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> "$ERROR_LOGFILE" &
else
    echo "$(date): ERRO: Binário Deroluna não encontrado ou sem permissões em $DEROLUNA_BINARY" >> "$ERROR_LOGFILE"
fi

# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso." | tee -a "$XMRIG_LOGFILE" "$DEROLUNA_LOGFILE"
