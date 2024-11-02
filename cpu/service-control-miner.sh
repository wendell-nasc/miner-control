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

# Servico para restartar
SERVICO="xdag_gustavo.service"

# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.15.199"

if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando outro script..." >> "$DEROLUNA_LOGFILE"
    # Executar outro script
    # /path/to/outro_script.sh >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log
    exit 1
else
    echo "IP não corresponde. Atual: $CURRENT_IP." >> "$DEROLUNA_LOGFILE"
fi

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

# Iniciar o minerador XMRig
echo "Iniciando XMRig Miner..." >> "$XMRIG_LOGFILE"
"$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$CONFIG" >> "$XMRIG_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

# Aguardar um pouco
sleep 2

# Variáveis para o Deroluna Miner
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/deroluna-miner"

# Definir a variável DEROLUNA_POOL com base na hora atual
HORA_ATUAL=$(date +%H)
if [ "$HORA_ATUAL" -ge 0 ] && [ "$HORA_ATUAL" -le 12 ]; then
    DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
else
    DEROLUNA_POOL="derosolo.bernacripto.com.br:10100"
    # DEROLUNA_POOL="community-pools.mysrv.cloud:10100"
    # DEROLUNA_POOL="dero-node.mysrv.cloud:10100"
    
    
fi

DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)

# Verificar se o minerador existe, caso contrário, baixar e extrair
if [ ! -f "$DEROLUNA_BINARY" ]; then
    echo "Minerador não encontrado. Baixando e extraindo..." >> "$DEROLUNA_LOGFILE"
    wget https://github.com/Hansen333/Hansen33-s-DERO-Miner/releases/latest/download/hansen33s-dero-miner-linux-amd64.tar.gz -P /home/wendell/dero_linux_amd64
    sudo tar -xvf /home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64.tar.gz -C /home/wendell/dero_linux_amd64
    echo "Minerador baixado e extraído." >> "$DEROLUNA_LOGFILE"
else
    echo "Minerador encontrado. Prosseguindo..." >> "$DEROLUNA_LOGFILE"
fi

# Iniciar o minerador Deroluna
echo "Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
"$DEROLUNA_BINARY" --xmrig -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados."
#testeteststste