#!/bin/bash

# Definir arquivos de log
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
SALVIUM_LOGFILE="/var/log/SALVIUM.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$SALVIUM_LOGFILE" "$XMRIG_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
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

echo "Configurando o SRBMiner para usar $THREADS_SRBMINER threads..." >> "$SALVIUM_LOGFILE"
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

echo "Índices do SRBMiner: [$THREADS_SRBMINER_INDEXES]" >> "$SALVIUM_LOGFILE"

# Variáveis para o XMRig
XMRIG_BINARY="/opt/xmrig/xmrig"
XMRIG_POOL="br.salvium.herominers.com:1230"
XMRIG_USER="SaLvdWbthy1hjCMh6SnV6z2trwaNq87gKJ3g2nuGXTiGMv6VAFzvSNzTeV6ncF5nfTMjWTeDNrKY8a5FnFeYResjTymWAFQpnfv.$(hostname)"
XMRIG_ALGO="randomx"
# XMRIG_THREADS="$THREADS_XMRIG"  # Número de threads baseado no cálculo acima
XMRIG_THREADS=$(nproc)  # Número de threads baseado no cálculo acima
XMRIG_HTTP_PORT="37329"
XMRIG_HTTP_TOKEN="auth"
XMRIG_DONATE_LEVEL="1" # Nível de doação
XMRIG_CONFIG="/opt/xmrig/config.json"

# # Criar ou atualizar o arquivo de configuração do XMRig
# cat > "$XMRIG_CONFIG" <<EOL
# {
#     "http": {
#     "enabled": true,
#     "host": "127.0.0.1",
#     "port": 37329,
#     "access-token": "auth",
#     "restricted": false
# }
# }
# EOL


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



# # Validar a existência do binário XMRig
# if [ -x "$XMRIG_BINARY" ]; then
#     echo "$(date): Iniciando XMRig Miner..." >> "$XMRIG_LOGFILE"
#     "$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$XMRIG_LOGFILE" 2>> "$ERROR_LOGFILE" &
# else
#     echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $XMRIG_BINARY" >> "$ERROR_LOGFILE"
# fi


# Variáveis para o minerador SALVIUM
SALVIUM_BINARY="/opt/xmrig/xmrig"
SALVIUM_POOL="br.salvium.herominers.com:1230"
SALVIUM_WALLET="solo:SaLvdWbthy1hjCMh6SnV6z2trwaNq87gKJ3g2nuGXTiGMv6VAFzvSNzTeV6ncF5nfTMjWTeDNrKY8a5FnFeYResjTymWAFQpnfv"
SALVIUM_ALGO="randomx"
SALVIUM_DONATE_LEVEL="1" # Nível de doação



# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.1.199"

# Se o IP corresponder ao alvo, executa o minerador SRBMiner e depois o XMRig
if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando minerador SRBMiner e XMRig..." >> "$SALVIUM_LOGFILE"
    
    # Validar a existência do binário XMRig
    if [ -x "$SALVIUM_BINARY" ]; then
        echo "$(date): Iniciando XMRig Miner..." >> "$SALVIUM_LOGFILE"
        nice -n -20 "$SALVIUM_BINARY" -o "$SALVIUM_POOL" -u "$SALVIUM_WALLET.$(hostname)" -t "$TOTAL_THREADS" --algo="$SALVIUM_ALGO" --donate-level="$SALVIUM_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$SALVIUM_LOGFILE" 2>> "$ERROR_LOGFILE" &
        # nice -n -20 "$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$XMRIG_LOGFILE" 2>> "$ERROR_LOGFILE" &

    else
        echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $SALVIUM_BINARY" >> "$ERROR_LOGFILE"
    fi

    sleep 5  # Esperar um pouco antes de iniciar o minerador XMRig

else
    # Caso o IP não corresponda, só executa o minerador XMRig
    echo "IP não corresponde. IP atual: $CURRENT_IP. Executando apenas o minerador XMRig..." >> "$SALVIUM_LOGFILE"
    
    # Validar a existência do binário XMRig
    if [ -x "$SALVIUM_BINARY" ]; then
        echo "$(date): Iniciando XMRig Miner..." >> "$SALVIUM_LOGFILE"
        nice -n -20 "$SALVIUM_BINARY" -o "$SALVIUM_POOL" -u "$SALVIUM_WALLET.$(hostname)" -t "$TOTAL_THREADS" --algo="$SALVIUM_ALGO" --donate-level="$SALVIUM_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$SALVIUM_LOGFILE" 2>> "$ERROR_LOGFILE" &
        # nice -n -20 "$XMRIG_BINARY" -o "$XMRIG_POOL" -u "$XMRIG_USER" -t "$XMRIG_THREADS" --algo="$XMRIG_ALGO" --donate-level="$XMRIG_DONATE_LEVEL" --config="$XMRIG_CONFIG" >> "$XMRIG_LOGFILE" 2>> "$ERROR_LOGFILE" &
    else
        echo "$(date): ERRO: Binário XMRig não encontrado ou sem permissões em $SALVIUM_BINARY" >> "$ERROR_LOGFILE"
    fi

    sleep 5 # Esperar um pouco antes de iniciar o minerador XMRig
fi









# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso."
