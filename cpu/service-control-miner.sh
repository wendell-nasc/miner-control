#!/bin/bash

# Definir arquivos de log
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
DEROLUNA_LOGFILE="/var/log/start-deroluna-xdag_gustavo.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/start-miner-errors.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$XMRIG_LOGFILE" "$DEROLUNA_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    if [ ! -f "$logfile" ]; then
        touch "$logfile"
    fi
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
XMRIG_HTTP_PORT="37329"
XMRIG_HTTP_TOKEN="auth"
XMRIG_DONATE_LEVEL="1"
XMRIG_CONFIG="/opt/xmrig/config.json"
THREADS_XMRIG=$(nproc)




# Variáveis para o Deroluna Miner
DEROLUNA_BINARY="/home/wendell/dero_linux_amd64/deroluna-miner"
DEROLUNA_POOL="dero-node-gustavogerman.mysrv.cloud:10100"
DEROLUNA_WALLET="dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z"
DEROLUNA_THREADS=$(nproc)






# Criar ou atualizar o arquivo de configuração do XMRig
cat > "$XMRIG_CONFIG" <<EOL


{
    "autosave": true,
    "cpu": {
        "enabled": true,
        "huge-pages": true,                // Ativa o uso de páginas grandes para melhor desempenho
        "hw-aes": true,                    // Ativa HW AES, se suportado pelo seu processador (melhora o desempenho em algoritmos que o utilizam)
        "priority": 5,                     // Aumenta a prioridade do minerador (0 a 10, onde 10 é a mais alta)
        "memory-pool": true,               // Ativa o pool de memória para melhorar a eficiência
        "max-threads-hint": 100,           // Ajuste baseado no número de threads disponíveis
        "asm": true,                       // Ativa as instruções ASM para melhor desempenho
        "argon2-impl": null,               // Deixe como null a menos que você tenha uma implementação específica
        "astrobwt-max-size": 550,          // Tamanho máximo do Astrobwt, mantenha ou ajuste conforme necessário
        "astrobwt-avx2": true,             // Habilite AVX2 se seu CPU suportar, para melhorar o desempenho no Astrobwt
        "cn/0": false,                     // Normalmente não é necessário ativar
        "cn-lite/0": false,                // Normalmente não é necessário ativar
        "1gb-pages": true                   // Ativa suporte a 1GB de páginas, se suportado pelo seu sistema
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

# Garantir que o arquivo de configuração tenha permissões adequadas
chmod 644 "$XMRIG_CONFIG"








# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.1.199"


# Se o IP corresponder ao alvo, executa o minerador SRBMiner e depois o XMRig
if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando minerador SRBMiner e XMRig..." >> "$SCASH_LOGFILE"
    

    # Validar a existência do binário XMRig
    if [ -x "$XMRIG_BINARY" ]; then
        echo "$(date): Iniciando XMRig Miner..." >> "$XMRIG_LOGFILE"
        nice -n -20 "$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t $THREADS_XMRIG --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$XMRIG_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
    else
        echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $XMRIG_BINARY" >> "$ERROR_LOGFILE"
    fi


    # Aguardar um pouco
    sleep 10



    # Validar a existência do binário Deroluna
    if [ -x "$DEROLUNA_BINARY" ]; then
        echo "$(date): Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
        nice -n -20 "$DEROLUNA_BINARY" --xmrig -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> "$ERROR_LOGFILE" &
    else
        echo "$(date): ERRO: Binário Deroluna não encontrado ou sem permissões em $DEROLUNA_BINARY" >> "$ERROR_LOGFILE"
    fi

    
    

else
    # Caso o IP não corresponda, só executa o minerador XMRig
    echo "IP não corresponde. IP atual: $CURRENT_IP. Executando apenas o minerador XMRig..." >> "$SCASH_LOGFILE"
    
        # Validar a existência do binário XMRig
    if [ -x "$XMRIG_BINARY" ]; then
        echo "$(date): Iniciando XMRig Miner..." >> "$XMRIG_LOGFILE"
        nice -n -20 "$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t $THREADS_XMRIG --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$XMRIG_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
    else
        echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $XMRIG_BINARY" >> "$ERROR_LOGFILE"
    fi


    # Aguardar um pouco
    sleep 10

    # Validar a existência do binário Deroluna
    if [ -x "$DEROLUNA_BINARY" ]; then
        echo "$(date): Iniciando Deroluna Miner..." >> "$DEROLUNA_LOGFILE"
        nice -n -20 "$DEROLUNA_BINARY" --xmrig -d "$DEROLUNA_POOL" -w "$DEROLUNA_WALLET" -t "$DEROLUNA_THREADS" >> "$DEROLUNA_LOGFILE" 2>> "$ERROR_LOGFILE" &
    else
        echo "$(date): ERRO: Binário Deroluna não encontrado ou sem permissões em $DEROLUNA_BINARY" >> "$ERROR_LOGFILE"
    fi

    

    

fi






# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso." | tee -a "$XMRIG_LOGFILE" "$DEROLUNA_LOGFILE"
