#!/bin/bash

# Definir arquivos de log
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
NICEHASH_LOGFILE="/var/log/QRL.log"
ENV_LOGFILE="/var/log/start-env.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$NICEHASH_LOGFILE" "$XMRIG_LOGFILE" "$ENV_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exportar o PATH para garantir o ambiente adequado
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"

# Função para calcular o número total de threads da CPU
TOTAL_THREADS=$(nproc)

# Divisão de threads com arredondamento correto para números ímpares
THREADS_SRBMINER=$(( (TOTAL_THREADS * 2 + 2) / 3 ))  # 2/3 das threads
THREADS_XMRIG=$((TOTAL_THREADS - THREADS_SRBMINER))  # 1/3 das threads

echo "Configurando o SRBMiner para usar $THREADS_SRBMINER threads..." >> "$NICEHASH_LOGFILE"
echo "Configurando o XMRig para usar $THREADS_XMRIG threads..." >> "$XMRIG_LOGFILE"

# Variáveis para armazenar os índices das threads
THREADS_XMRIG_INDEXES=""
THREADS_SRBMINER_INDEXES=""

# Preencher os índices das threads para o SRBMiner (2/3 das threads)
for ((i = 1; i <= THREADS_SRBMINER; i++)); do
    THREADS_SRBMINER_INDEXES+="$i"
    if [ $i -lt $THREADS_SRBMINER ]; then
        THREADS_SRBMINER_INDEXES+=";"  # Adiciona ponto e vírgula para separar os valores
    fi
done

# Preencher os índices das threads para o XMRig (1/3 das threads)
for ((i = THREADS_SRBMINER + 1; i <= TOTAL_THREADS; i++)); do
    THREADS_XMRIG_INDEXES+="$i"
    if [ $i -lt $TOTAL_THREADS ]; then
        THREADS_XMRIG_INDEXES+=";"  # Adiciona ponto e vírgula para separar os valores
    fi
done

echo "Índices do SRBMiner: [$THREADS_SRBMINER_INDEXES]" >> "$NICEHASH_LOGFILE"

# Caminho para o minerador SRBMiner
NICEHASH_BINARY="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"
NICEHASH_POOL="stratum+tcp://verushash.auto.nicehash.com:9200"
NICEHASH_WALLET="NHbQdkTWYaaCs85LgLChnktWpG9bxKnMU72s"
NICEHASH_ALGO="verushash"

# Verificar se o minerador existe, caso contrário, baixar e extrair
if [ ! -f "$NICEHASH_BINARY" ]; then
    echo "Minerador não encontrado. Baixando e extraindo..." >> "$NICEHASH_LOGFILE"
    
    # Criar diretório e navegar até ele
    mkdir -p /home/wendell/SRBMiner
    cd /home/wendell/SRBMiner || { echo "Falha ao acessar o diretório"; exit 1; }

    # Baixar e extrair o minerador
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.5/SRBMiner-Multi-2-6-5-Linux.tar.gz || { echo "Falha ao baixar o minerador"; exit 1; }
    tar -xvf SRBMiner-Multi-2-6-5-Linux.tar.gz || { echo "Falha ao extrair o minerador"; exit 1; }
    echo "Minerador baixado e extraído." >> "$NICEHASH_LOGFILE"
else
    echo "Minerador já encontrado. Prosseguindo..." >> "$NICEHASH_LOGFILE"
fi

# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.1.199"

# Se o IP corresponder ao alvo, executa o minerador SRBMiner e depois o XMRig
if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando minerador SRBMiner e XMRig..." >> "$NICEHASH_LOGFILE"
    
    # Iniciar o minerador SRBMiner
    nice -n -20 "$NICEHASH_BINARY" --disable-gpu --algorithm "$NICEHASH_ALGO" --pool "$NICEHASH_POOL" --wallet "$NICEHASH_WALLET.$(hostname)" --keepalive true --randomx-use-1gb-pages --disable-numa-binding --cpu-threads $TOTAL_THREADS & >> "$NICEHASH_LOGFILE" 2>> /var/log/start-deroluna-errors.log
    
    sleep 5  # Esperar um pouco antes de iniciar o minerador XMRig

else
    # Caso o IP não corresponda, só executa o minerador XMRig
    echo "IP não corresponde. IP atual: $CURRENT_IP. Executando apenas o minerador XMRig..." >> "$NICEHASH_LOGFILE"
    
    # Iniciar o minerador SRBMiner
    nice -n -20 "$NICEHASH_BINARY" --disable-gpu --algorithm "$NICEHASH_ALGO" --pool "$NICEHASH_POOL" --wallet "$NICEHASH_WALLET.$(hostname)" --keepalive true --randomx-use-1gb-pages --disable-numa-binding --cpu-threads $TOTAL_THREADS & >> "$NICEHASH_LOGFILE" 2>> /var/log/start-deroluna-errors.log
    
    sleep 5
fi

# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso."
