#!/bin/bash

# Caminho do minerador
MINER="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"

# Parâmetros
PARAMS="--algorithm progpow_telestai --pool stratum-na.rplant.xyz:7051 --wallet TcafffD4GPcDQLmH4jXNpHmgSytQMwM9A5.rx580 --keepalive true --no-cpu"

# Verifica se o minerador já está rodando
if ! pgrep -f "$MINER" > /dev/null; then
    echo "[`date`] Iniciando SRBMiner..."
    cd /home/wendell/SRBMiner/SRBMiner-Multi-2-6-5
    $MINER $PARAMS &
else
    echo "[`date`] SRBMiner já está em execução."
fi


# telestai
screen -s SRBMINER_GPU /home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI --algorithm progpow_telestai --pool stratum-na.rplant.xyz:7051 --wallet TcafffD4GPcDQLmH4jXNpHmgSytQMwM9A5.rx580 --keepalive true --no-cpu