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

# Variáveis para o Deroluna Miner
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/deroluna-miner"
DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)



# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')

TARGET_IPS=("192.168.15.161" "192.168.1.148" "192.168.1.151" "192.168.1.154" "192.168.1.158" "192.168.1.162")

# Variável para controlar se o IP foi encontrado
IP_FOUND=false

for TARGET_IP in "${TARGET_IPS[@]}"; do
    if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
        # echo "IP corresponde a $TARGET_IP. Executando outro script..." >> "$DEROLUNA_LOGFILE"
        # Executar outro script
        # /path/to/outro_script.sh >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log
        IP_FOUND=true
        DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"

        # Iniciar o minerador Deroluna
        echo "Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
        #"$DEROLUNA_BINARY" -daemon-rpc-address "$DEROLUNA_POOL" -wallet-address "$DEROLUNA_WALLET" -mining-threads "$DEROLUNA_THREADS" -turbo >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
        "$DEROLUNA_BINARY" -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

        # Esperar os processos em segundo plano
        wait

        echo "Mineradores iniciados."

        break
    fi
done

if [ "$IP_FOUND" == false ]; then
    # echo "IP não corresponde. Atual: $CURRENT_IP." >> "$DEROLUNA_LOGFILE"
    
    

    # Iniciar o minerador Deroluna
    echo "Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
    #"$DEROLUNA_BINARY" -daemon-rpc-address "$DEROLUNA_POOL" -wallet-address "$DEROLUNA_WALLET" -mining-threads "$DEROLUNA_THREADS" -turbo >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
    "$DEROLUNA_BINARY" -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

    # Esperar os processos em segundo plano
    wait

    echo "Mineradores iniciados."


fi