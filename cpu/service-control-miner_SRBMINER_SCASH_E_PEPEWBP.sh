#!/bin/bash
#13052025 12>22

# Caminho dos logs
MOEDA1_LOGFILE="/var/log/SRBMOEDA1.log"
MOEDA2_LOGFILE="/var/log/SRBMOEDA2.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Criar arquivos de log
for logfile in "$MOEDA1_LOGFILE" "$MOEDA2_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exporta PATH
export PATH="$PATH"

# Log de variáveis de ambiente
env >> "$ENV_LOGFILE"

# Threads
TOTAL_THREADS=$(nproc)
THREADS1=$((TOTAL_THREADS / 2))
THREADS2=$((TOTAL_THREADS - THREADS1)) # Garante que use todos os núcleos

# Caminho do binário SRBMiner
SRB_PATH="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"

# Verifica existência do SRBMiner
if [ ! -f "$SRB_PATH" ]; then
    echo "SRBMiner não encontrado. Baixando..." >> "$ERROR_LOGFILE"
    mkdir -p /home/wendell/SRBMiner && cd /home/wendell/SRBMiner || exit 1
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.5/SRBMiner-Multi-2-6-5-Linux.tar.gz
    tar -xvf SRBMiner-Multi-2-6-5-Linux.tar.gz
    echo "SRBMiner baixado com sucesso." >> "$ENV_LOGFILE"
fi

# Primeira moeda (ex: SCASH)
MOEDA1_POOL="stratum-na.rplant.xyz:7019"
MOEDA1_WALLET="scash1qvv3wfql4lxy36mkpgx3032nm4pvqmlq00lye6u"
MOEDA1_ALGO="randomscash"

# Segunda moeda (ex: Zephyr)
MOEDA2_POOL="stratum+tcp://br.mining4people.com:4176"
MOEDA2_WALLET="PTMpRyp1qyxqWtqfgbjvof2nK5cAnT47jJ"
MOEDA2_ALGO="xelishashv2_pepew"

# Inicia SRBMiner para moeda 1
echo "$(date): Iniciando mineração da Moeda 1..." >> "$MOEDA1_LOGFILE"
nice -n -20 "$SRB_PATH" --disable-gpu --algorithm "$MOEDA1_ALGO" \
  --pool "$MOEDA1_POOL" --wallet "$MOEDA1_WALLET.$(hostname)" \
  --cpu-threads "$THREADS1" --cpu-threads-priority 5 --keepalive true \
  >> "$MOEDA1_LOGFILE" 2>> "$ERROR_LOGFILE" &

# Inicia SRBMiner para moeda 2
echo "$(date): Iniciando mineração da Moeda 2..." >> "$MOEDA2_LOGFILE"
nice -n -20 "$SRB_PATH" --disable-gpu --algorithm "$MOEDA2_ALGO" \
  --pool "$MOEDA2_POOL" --wallet "$MOEDA2_WALLET.$(hostname)" \
  --cpu-threads "$THREADS2" --cpu-threads-priority 5 --keepalive true \
  >> "$MOEDA2_LOGFILE" 2>> "$ERROR_LOGFILE" &

wait
echo "$(date): Ambos mineradores iniciados com sucesso."
