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
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64"
#DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
DEROLUNA_POOL="192.168.1.168:10100"
DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)



#Servico para restartar
SERVICO="xdag_gustavo.service"

# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.15.161"

if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando outro script..." >> "$DEROLUNA_LOGFILE"
    # Executar outro script
    # /path/to/outro_script.sh >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log

    exit 1
else
    echo "IP não corresponde. Atual: $CURRENT_IP." >> "$DEROLUNA_LOGFILE"
    
fi


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
"$DEROLUNA_BINARY" -daemon-rpc-address "$DEROLUNA_POOL" -wallet-address "$DEROLUNA_WALLET" -mining-threads "$DEROLUNA_THREADS" -turbo >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados."


# sudo chmod +x /home/wendell/hansen/hansen.sh && sudo nano /etc/systemd/system/dero_hansen.service


