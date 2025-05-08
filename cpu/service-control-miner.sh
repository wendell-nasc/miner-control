#!/bin/bash

# Caminho dos logs
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
ZEPH_LOGFILE="/var/log/SALVIUM.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Criar os arquivos de log e definir permissões
for logfile in "$ZEPH_LOGFILE" "$XMRIG_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exporta PATH
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"

# Threads totais e divisão entre os mineradores
TOTAL_THREADS=$(nproc)
THREADS_SRBMINER=$(( (TOTAL_THREADS * 2 + 2) / 3 ))
THREADS_XMRIG=$((TOTAL_THREADS - THREADS_SRBMINER))

# Caminho e variáveis do SRBMiner
ZEPH_BINARY1="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"
ZEPH_POOL="br.zephyr.herominers.com:1123"
ZEPH_WALLET1="ZEPHYR2Gz72Xzthz6gY3d7hSRWryxyhmEJK6RZhebDjqfYb34c3rHiSH2zZKTkgWdd4osMTcX6EGHZkpBDPbS8nrL4gq8DsefM72c"
ZEPH_ALGO1="randomx"

# Verifica e baixa o SRBMiner se não existir
if [ ! -f "$ZEPH_BINARY1" ]; then
    echo "Minerador SRBMiner não encontrado. Baixando..." >> "$ZEPH_LOGFILE"
    mkdir -p /home/wendell/SRBMiner && cd /home/wendell/SRBMiner || exit 1
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.5/SRBMiner-Multi-2-6-5-Linux.tar.gz
    tar -xvf SRBMiner-Multi-2-6-5-Linux.tar.gz
    echo "SRBMiner baixado e extraído." >> "$ZEPH_LOGFILE"
else
    echo "SRBMiner encontrado." >> "$ZEPH_LOGFILE"
fi

# # Executa SRBMiner
# if [ -x "$ZEPH_BINARY1" ]; then
#     echo "$(date): Iniciando SRBMiner..." >> "$ZEPH_LOGFILE"
#     # nice -n -20 "$ZEPH_BINARY1" --disable-gpu --algorithm "$ZEPH_ALGO1" \
#     #     --pool "$ZEPH_POOL" --wallet "$ZEPH_WALLET1.$(hostname)" \
#     #     --cpu-threads "$THREADS_SRBMINER" --keepalive true \
#     #     --cpu-threads-priority 5 >> "$ZEPH_LOGFILE" 2>> "$ERROR_LOGFILE" &

#     nice -n -20 "$ZEPH_BINARY1" --disable-gpu --algorithm "$ZEPH_ALGO1" --pool "$ZEPH_POOL" --wallet "$ZEPH_WALLET1.$(hostname)"  --cpu-threads $TOTAL_THREADS --keepalive true --randomx-use-1gb-pages --cpu-threads-priority 5 >> "$ZEPH_LOGFILE" 2>> "$ERROR_LOGFILE" &
# else
#     echo "ERRO: Binário SRBMiner não encontrado." >> "$ERROR_LOGFILE"
# fi

# sleep 5

# Configuração do XMRig
XMRIG_BINARY="/opt/xmrig/xmrig"
XMRIG_CONFIG="/opt/xmrig/config.json"
ZEPH_WALLET="ZEPHYR2Gz72Xzthz6gY3d7hSRWryxyhmEJK6RZhebDjqfYb34c3rHiSH2zZKTkgWdd4osMTcX6EGHZkpBDPbS8nrL4gq8DsefM72c"
ZEPH_ALGO="rx/0"

# Gera config do XMRig
cat > "$XMRIG_CONFIG" <<EOL
{
  "autosave": true,
  "cpu": {
    "enabled": true,
    "huge-pages": true,
    "hw-aes": true,
    "priority": 5,
    "memory-pool": true,
    "max-threads-hint": 100,
    "asm": true,
    "argon2-impl": null,
    "astrobwt-max-size": 550,
    "astrobwt-avx2": true,
    "1gb-pages": true
  },
  "http": {
    "enabled": true,
    "host": "127.0.0.1",
    "port": 37329,
    "access-token": "auth",
    "restricted": false
  }
}
EOL

chmod 644 "$XMRIG_CONFIG"

# Executa XMRig
if [ -x "$XMRIG_BINARY" ]; then
    echo "$(date): Iniciando XMRig..." >> "$XMRIG_LOGFILE"
    nice -n -20 "$XMRIG_BINARY" -o "$ZEPH_POOL" -u "$ZEPH_WALLET.$(hostname)" \
        --algo="$ZEPH_ALGO" --donate-level=1 --config="$XMRIG_CONFIG" \
        >> "$XMRIG_LOGFILE" 2>> "$ERROR_LOGFILE" &
else
    echo "ERRO: Binário XMRig não encontrado." >> "$ERROR_LOGFILE"
fi

wait

echo "$(date): Mineradores iniciados com sucesso."