#!/bin/bash

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
SRB_PATH="/home/wendell/SRBMiner/srbminer_custom/srbminer_custom_bin"

# Verifica existência do SRBMiner
if [ ! -f "$SRB_PATH" ]; then
    echo "SRBMiner não encontrado. Baixando..." >> "$ERROR_LOGFILE"
    mkdir -p /home/wendell/SRBMiner && cd /home/wendell/SRBMiner || exit 1
    wget -O srbminer_custom-3.2.8.tar.gz \
      https://github.com/doktor83/SRBMiner-Multi/releases/download/3.2.8/srbminer_custom-3.2.8.tar.gz
    tar -xvf srbminer_custom-3.2.8.tar.gz
    chmod +x "$SRB_PATH"
    echo "SRBMiner baixado com sucesso." >> "$ENV_LOGFILE"
fi

# Primeira moeda (SCASH)
MOEDA1_POOL="eu.rplant.xyz:17019"
MOEDA1_WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
MOEDA1_ALGO="randomscash"

# Inicia SRBMiner para moeda 1
echo "$(date): Iniciando mineração da Moeda 1..." >> "$MOEDA1_LOGFILE"
nice -n -20 "$SRB_PATH" \
  --algorithm "$MOEDA1_ALGO" \
  --pool "$MOEDA1_POOL" \
  --tls true \
  --wallet "$MOEDA1_WALLET" \
  --keepalive true \
  >> "$MOEDA1_LOGFILE" 2>> "$ERROR_LOGFILE"

echo "$(date): Minerador encerrado." >> "$MOEDA1_LOGFILE"