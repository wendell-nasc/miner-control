#!/bin/bash

# Definir arquivos de log

SCASH_LOGFILE="/var/log/scash.log"
ENV_LOGFILE="/var/log/start-env.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$SCASH_LOGFILE" "$ENV_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exportar o PATH para garantir o ambiente adequado
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"

# Variáveis para o minerador scash
SCASH_BINARY="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"
SCASH_POOL="stratum-na.rplant.xyz:7019"
# SCASH_POOL="192.168.1.168:10100"
SCASH_WALLET="scash1qvv3wfql4lxy36mkpgx3032nm4pvqmlq00lye6u"
SCASH_THREADS=$(nproc)


# Serviço para reiniciar
SERVICO="xdag_gustavo.service"

# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.1.167"

if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando outro script..." >> "$SCASH_LOGFILE"
    # Executar outro script
    # /path/to/outro_script.sh >> "$SCASH_LOGFILE" 2>> /var/log/start-scash-errors.log
    "$SCASH_BINARY" --disable-gpu --algorithm randomscash --pool "$SCASH_POOL" --wallet "$SCASH_WALLET.$(hostname)" --donate-level 1 --cpu-threads "$SCASH_THREADS" --keepalive true &
    
    wait

    echo "Minerador ( $TARGET_IP )iniciados."
    #exit 1
else
    echo "IP não corresponde. Atual: $CURRENT_IP." >> "$SCASH_LOGFILE"
fi

# Verificar se o minerador existe, caso contrário, baixar e extrair
if [ ! -f "$SCASH_BINARY" ]; then
    echo "Minerador não encontrado. Baixando e extraindo..." >> "$SCASH_LOGFILE"
    sudo mkdir /home/wendell/SRBMiner    
    cd /home/wendell/SRBMiner
    sudo sudo wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.5/SRBMiner-Multi-2-6-5-Linux.tar.gz
    # Aguardar um pouco
    sleep 20
    sudo tar -xvf /home/wendell/SRBMiner/SRBMiner-Multi-2-6-5-Linux.tar.gz    
    sleep 20
    echo "Minerador baixado e extraído." >> "$SCASH_LOGFILE"
else
    echo "Minerador encontrado. Prosseguindo..." >> "$SCASH_LOGFILE"
fi

# Iniciar o minerador scash
echo "Iniciando scash Miner..." >> "$SCASH_LOGFILE"
#"$SCASH_BINARY" --disable-gpu --algorithm randomscash --pool "$SCASH_POOL" --wallet "$SCASH_WALLET.$(hostname)" --donate-level 1 --cpu-threads "$SCASH_THREADS" --keepalive true --cpu-threads-intensity 4 --disable-huge-pages false --cpu-threads-priority 5 
nice -n -20 "$SCASH_BINARY" --disable-gpu --algorithm randomscash --pool "$SCASH_POOL" --wallet "$SCASH_WALLET.$(hostname)" --donate-level 1 --keepalive true --cpu-threads "$SCASH_THREADS" --randomx-use-1gb-pages --disable-numa-binding --cpu-threads-priority 5 &


#"$SCASH_BINARY" --disable-gpu --algorithm randomscash --pool "$SCASH_POOL" --wallet "$SCASH_WALLET.$(hostname)" --donate-level 1 --cpu-threads "$SCASH_THREADS" --password m=solo --keepalive true &
#./SRBMiner-MULTI --disable-gpu --algorithm randomscash --pool eu.rplant.xyz:7019 --wallet "scash1qvv3wfql4lxy36mkpgx3032nm4pvqmlq00lye6u.$(hostname)"  --donate-level 1 --cpu-threads


# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados."

# sudo chmod +x /home/wendell/hansen/hansen.sh && sudo nano /etc/systemd/system/dero_hansen.service
# testeetstets
# 29/10/2024










