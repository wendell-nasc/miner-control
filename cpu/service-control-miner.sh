#!/bin/bash

# Definir arquivos de log
SCASH_LOGFILE="/var/log/scash.log"
ENV_LOGFILE="/var/log/start-env.log"
SCASH_ERRO="/var/log/start-scash-errors.log" # Corrigido espaço incorreto

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$SCASH_LOGFILE" "$ENV_LOGFILE" "$SCASH_ERRO"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exportar o PATH para garantir o ambiente adequado
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"

# Variáveis para o minerador scash
SCASH_BINARY="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"
SCASH_POOL="51pool.online:3416"
# SCASH_POOL="192.168.1.168:10100" # Outra opção de pool comentada
SCASH_WALLET="wendell"
SCASH_THREADS=$(nproc)
SCASH_ALGORITIMO="randomepic"

# Verificar se o minerador existe, caso contrário, baixar e extrair
if [ ! -f "$SCASH_BINARY" ]; then
    echo "Minerador não encontrado. Baixando e extraindo..." >> "$SCASH_LOGFILE"
    sudo mkdir -p /home/wendell/SRBMiner
    cd /home/wendell/SRBMiner || exit
    sudo wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.5/SRBMiner-Multi-2-6-5-Linux.tar.gz
    sleep 20
    sudo tar -xvf SRBMiner-Multi-2-6-5-Linux.tar.gz
    sleep 20
    echo "Minerador baixado e extraído." >> "$SCASH_LOGFILE"
else
    echo "Minerador encontrado. Prosseguindo..." >> "$SCASH_LOGFILE"
fi

# Iniciar o minerador scash
echo "Iniciando scash Miner..." >> "$SCASH_LOGFILE" 
"$SCASH_BINARY" --disable-gpu --algorithm "$SCASH_ALGORITIMO" --pool "$SCASH_POOL" --wallet "$SCASH_WALLET#$(hostname)" --password "1234" --donate-level 1 --cpu-threads "$SCASH_THREADS" --keepalive true >> "$SCASH_LOGFILE" 2>> "$SCASH_ERRO" &

# Esperar os processos em segundo plano
wait

echo "Mineradores iniciados com sucesso."
