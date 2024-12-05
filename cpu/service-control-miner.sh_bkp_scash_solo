#!/bin/bash

# Definir arquivos de log

XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
SCASH_LOGFILE="/var/log/scash.log"
ENV_LOGFILE="/var/log/start-env.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$SCASH_LOGFILE" "$XMRIG_LOGFILE" "$ENV_LOGFILE"; do
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

echo "Configurando o SRBMiner para usar $THREADS_SRBMINER threads..." >> "$SCASH_LOGFILE"
echo "Configurando o XMRig para usar $THREADS_XMRIG threads..." >> "$XMRIG_LOGFILE"

# Variáveis para armazenar os índices das threads
THREADS_XMRIG_INDEXES=""
THREADS_SRBMINER_INDEXES=""

# Preencher os índices das threads para o SRBMiner (2/3 das threads)
for ((i = 1; i <= THREADS_SRBMINER; i++)); do
    if [ $i -gt 1 ]; then
        THREADS_SRBMINER_INDEXES+=";"  # Adiciona ponto e vírgula para separar os valores
    fi
    THREADS_SRBMINER_INDEXES+="$i"  # Adiciona o índice
done

# Preencher os índices das threads para o XMRig (1/3 das threads)
for ((i = THREADS_SRBMINER + 1; i <= TOTAL_THREADS; i++)); do
    if [ $i -gt $((THREADS_SRBMINER + 1)) ]; then
        THREADS_XMRIG_INDEXES+=";"  # Adiciona ponto e vírgula para separar os valores
    fi
    THREADS_XMRIG_INDEXES+="$i"  # Adiciona o índice
done

echo "Índices do SRBMiner: [$THREADS_SRBMINER_INDEXES]" >> "$SCASH_LOGFILE"


# Variáveis para o minerador scash
SCASH_BINARY="/home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI"
SCASH_POOL="stratum-na.rplant.xyz:7019"
SCASH_WALLET="scash1qvv3wfql4lxy36mkpgx3032nm4pvqmlq00lye6u"

# Verificar se o minerador existe, caso contrário, baixar e extrair
if [ ! -f "$SCASH_BINARY" ]; then
    echo "Minerador não encontrado. Baixando e extraindo..." >> "$SCASH_LOGFILE"
    
    # Criar diretório e navegar até ele
    mkdir -p /home/wendell/SRBMiner
    cd /home/wendell/SRBMiner || { echo "Falha ao acessar o diretório"; exit 1; }

    # Baixar e extrair o minerador
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.5/SRBMiner-Multi-2-6-5-Linux.tar.gz || { echo "Falha ao baixar o minerador"; exit 1; }
    tar -xvf SRBMiner-Multi-2-6-5-Linux.tar.gz || { echo "Falha ao extrair o minerador"; exit 1; }
    echo "Minerador baixado e extraído." >> "$SCASH_LOGFILE"
else
    echo "Minerador já encontrado. Prosseguindo..." >> "$SCASH_LOGFILE"
fi


# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.1.199"


# Se o IP corresponder ao alvo, executa o minerador SRBMiner e depois o XMRig
if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando minerador SRBMiner e XMRig..." >> "$SCASH_LOGFILE"
    
    # Iniciar o minerador SRBMiner
    
    sudo systemctl stop "$SERVICO" &    
    sudo systemctl daemon-reload &
    sudo systemctl restart "$SERVICO" &
    echo "$(date): Serviço $SERVICO reiniciado com sucesso!" >> $LOGFILE
    nice -n -20 "$SCASH_BINARY" --disable-gpu --algorithm randomscash --pool "$SCASH_POOL" --wallet "$SCASH_WALLET.$(hostname)" --password m=solo --cpu-threads $TOTAL_THREADS --keepalive true --randomx-use-1gb-pages --cpu-threads-priority 5 >> "$SCASH_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
    sleep 5  # Esperar um pouco antes de iniciar o minerador XMRig

else
    # Caso o IP não corresponda, só executa o minerador XMRig
    echo "IP não corresponde. IP atual: $CURRENT_IP. Executando apenas o minerador XMRig..." >> "$SCASH_LOGFILE"
    
    # Iniciar o minerador SRBMiner
    
    sudo systemctl stop "$SERVICO" &    
    sudo systemctl daemon-reload &
    sudo systemctl restart "$SERVICO" &
    echo "$(date): Serviço $SERVICO reiniciado com sucesso!" >> $LOGFILE
    nice -n -20 "$SCASH_BINARY" --disable-gpu --algorithm randomscash --pool "$SCASH_POOL" --wallet "$SCASH_WALLET.$(hostname)" --password m=solo --cpu-threads $TOTAL_THREADS --keepalive true --randomx-use-1gb-pages --cpu-threads-priority 5 & >> "$SCASH_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
    sleep 5
    

fi


# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso."
