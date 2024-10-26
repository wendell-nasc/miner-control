#!/bin/bash

# Definir arquivos de log
DEROLUNA_LOGFILE="/var/log/start-deroluna-hansen.log"
ENV_LOGFILE="/var/log/start-env.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$DEROLUNA_LOGFILE" "$ENV_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exportar o PATH para garantir o ambiente adequado
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"


# Variáveis para o Deroluna Miner
#DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64"
DEROLUNA_BINARY="/home/wendell/hansen/hansen33s-dero-miner-linux-amd64"
DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)

# Iniciar o minerador Deroluna
echo "Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
"$DEROLUNA_BINARY" -daemon-rpc-address "$DEROLUNA_POOL" -wallet-address "$DEROLUNA_WALLET" -mining-threads "$DEROLUNA_THREADS" -turbo >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados."

# sudo chmod +x /home/wendell/hansen/hansen.sh && sudo nano /etc/systemd/system/dero_hansen.service


