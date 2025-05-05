#sudo nano /etc/systemd/system/start-xdag_gustavo.sh sudo chmod +x /etc/systemd/system/start-xdag_gustavo.sh


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
XMRIG_BINARY="/home/wendell/xdag/xmrig-4-xdag/xmrig-4-xdag"
XMRIG_POOL="stratum.xdag.org:23656"
XMRIG_USER="Dzdbr5d8PVafQwvEkEwfNde7mFKNDaDSv.$(hostname)"
XMRIG_ALGO="rx/xdag"
XMRIG_THREADS=$(nproc)
XMRIG_HTTP_PORT="37329"
XMRIG_HTTP_TOKEN="auth"
XMRIG_DONATE_LEVEL="1"
CONFIG="/opt/xmrig/config.json"



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
# DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
DEROLUNA_POOL="192.168.1.168:10100"
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
"$DEROLUNA_BINARY" -daemon-rpc-address "$DEROLUNA_POOL" -wallet-address "$DEROLUNA_WALLET" -mining-threads "$DEROLUNA_THREADS" -turbo >> "$DEROLUNA_LOGFILE" 2>> /var/log/start-deroluna-errors.log &

# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados."




sudo chmod +x /etc/systemd/system/start-xdag_gustavo.sh && sudo nano /etc/systemd/system/xdag_gustavo.service



[Unit]
Description=Start XMRig and Deroluna Miners
After=network.target

[Service]
ExecStart=/etc/systemd/system/start-xdag_gustavo.sh
Restart=always
#User=wendell  # Descomente e ajuste conforme necessárioz
StandardOutput=journal
StandardError=journal
SyslogIdentifier=miners
Nice=10
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target





sudo systemctl daemon-reload && sudo systemctl enable xdag_gustavo.service &&  sudo systemctl stop xdag_gustavo.service && sudo systemctl start xdag_gustavo.service && sudo systemctl status xdag_gustavo.service 
