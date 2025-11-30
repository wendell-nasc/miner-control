#!/bin/bash

# ============================================================================
# CONFIGURAÇÕES GERAIS
# ============================================================================

# Caminho dos logs
MOEDA_LOGFILE="/var/log/SRB_VIREL.log"
ENV_LOGFILE="/var/log/start-env.log"
ERROR_LOGFILE="/var/log/error.log"

# Criar arquivos de log
for logfile in "$MOEDA_LOGFILE" "$ENV_LOGFILE" "$ERROR_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exporta PATH
export PATH="$PATH"

# Log de variáveis de ambiente
env >> "$ENV_LOGFILE"

# Threads
TOTAL_THREADS=$(nproc)
echo "$(date): Sistema com $TOTAL_THREADS threads" >> "$ENV_LOGFILE"
echo "$(date): Usando TODAS as threads para RandomVIREL" >> "$ENV_LOGFILE"

# ============================================================================
# INSTALAÇÃO DO SRBMINER 3.0.5
# ============================================================================

# Caminho do binário SRBMiner (ATUALIZADO PARA VERSÃO 3.0.5)
SRB_PATH="/home/wendell/SRBMiner/SRBMiner-Multi-3-0-5/SRBMiner-MULTI"

# Verifica existência do SRBMiner (ATUALIZADO PARA VERSÃO 3.0.5)
if [ ! -f "$SRB_PATH" ]; then
    echo "$(date): SRBMiner não encontrado. Baixando versão 3.0.5..." >> "$ERROR_LOGFILE"
    mkdir -p /home/wendell/SRBMiner && cd /home/wendell/SRBMiner || exit 1
    
    # Remove versões antigas se existirem
    rm -rf SRBMiner-Multi-* srbminer_custom-*
    
    # Baixa a versão mais recente 3.0.5
    echo "$(date): Baixando SRBMiner 3.0.5..." >> "$ENV_LOGFILE"
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/3.0.5/SRBMiner-Multi-3-0-5-Linux.tar.gz
    
    # Extrai o arquivo
    echo "$(date): Extraindo SRBMiner 3.0.5..." >> "$ENV_LOGFILE"
    tar -xvf SRBMiner-Multi-3-0-5-Linux.tar.gz
    
    # Verifica se a extração foi bem sucedida
    if [ -f "$SRB_PATH" ]; then
        echo "$(date): SRBMiner 3.0.5 baixado e extraído com sucesso." >> "$ENV_LOGFILE"
        # Torna o executável
        chmod +x "$SRB_PATH"
        
        # Verificar se o algoritmo randomvirel está disponível
        echo "$(date): Verificando algoritmos disponíveis..." >> "$ENV_LOGFILE"
        "$SRB_PATH" --list-algorithms | grep -i virel >> "$ENV_LOGFILE" 2>&1
    else
        echo "$(date): ERRO: SRBMiner não foi extraído corretamente." >> "$ERROR_LOGFILE"
        echo "$(date): Tentando encontrar o binário..." >> "$ERROR_LOGFILE"
        # Tenta encontrar o binário em subdiretórios
        FOUND_BINARY=$(find /home/wendell/SRBMiner -name "SRBMiner-MULTI" -type f | head -1)
        if [ -n "$FOUND_BINARY" ]; then
            SRB_PATH="$FOUND_BINARY"
            chmod +x "$SRB_PATH"
            echo "$(date): Binário encontrado: $SRB_PATH" >> "$ENV_LOGFILE"
        else
            echo "$(date): ERRO: Não foi possível encontrar o binário do SRBMiner" >> "$ERROR_LOGFILE"
            exit 1
        fi
    fi
    
    # Limpa arquivo tar
    rm -f SRBMiner-Multi-3-0-5-Linux.tar.gz
else
    echo "$(date): SRBMiner 3.0.5 já está instalado." >> "$ENV_LOGFILE"
fi

# ============================================================================
# CONFIGURAÇÕES DO MINERADOR - APENAS RANDOMVIREL
# ============================================================================

# Moeda RandomVIREL
POOL="stratum-na.rplant.xyz:7155"
WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
ALGO="randomvirel"
WORKER_NAME="$(hostname)"

# ============================================================================
# EXECUÇÃO DO MINERADOR - APENAS VIREL
# ============================================================================

echo "$(date): Iniciando mineração RandomVIREL com SRBMiner 3.0.5..." >> "$ENV_LOGFILE"
echo "$(date): Pool: $POOL" >> "$ENV_LOGFILE"
echo "$(date): Wallet: $WALLET" >> "$ENV_LOGFILE"
echo "$(date): Algoritmo: $ALGO" >> "$ENV_LOGFILE"
echo "$(date): Threads: $TOTAL_THREADS" >> "$ENV_LOGFILE"

# Inicia SRBMiner para RandomVIREL - USANDO TODAS AS THREADS
echo "$(date): Iniciando mineração RandomVIREL com $TOTAL_THREADS threads..." >> "$MOEDA_LOGFILE"
echo "$(date): Comando: $SRB_PATH --disable-gpu --algorithm $ALGO --cpu-threads $TOTAL_THREADS --pool $POOL --wallet $WALLET.$WORKER_NAME --keepalive true" >> "$MOEDA_LOGFILE"

"$SRB_PATH" --disable-gpu --algorithm "$ALGO" --cpu-threads "$TOTAL_THREADS" \
--pool "$POOL" --wallet "$WALLET.$WORKER_NAME" \
--keepalive true \
>> "$MOEDA_LOGFILE" 2>> "$ERROR_LOGFILE" &

PID=$!
echo "$(date): SRBMiner RandomVIREL iniciado com PID: $PID ($TOTAL_THREADS threads)" >> "$ENV_LOGFILE"

# ============================================================================
# MONITORAMENTO
# ============================================================================

echo "$(date): Minerador RandomVIREL iniciado com sucesso!" >> "$ENV_LOGFILE"

# Verificar uso de CPU após inicialização
sleep 10
echo "$(date): Verificando uso de CPU..." >> "$ENV_LOGFILE"

# Função para verificar uso de CPU
check_cpu_usage() {
    echo "$(date): === STATUS DO SISTEMA ===" >> "$ENV_LOGFILE"
    
    # Uso geral de CPU
    echo "$(date): Uso geral de CPU:" >> "$ENV_LOGFILE"
    top -bn1 | grep -i "cpu(s)" >> "$ENV_LOGFILE"
    
    # Processo do minerador
    echo "$(date): Processo do minerador:" >> "$ENV_LOGFILE"
    ps -p $PID -o pid,ppid,pcpu,pmem,comm --sort=-pcpu 2>/dev/null >> "$ENV_LOGFILE"
    
    # Load average
    echo "$(date): Load average:" >> "$ENV_LOGFILE"
    uptime | grep -o "load average:.*" >> "$ENV_LOGFILE"
}

# Verificação inicial
check_cpu_usage

# Função para verificar se o processo está ativo
check_process() {
    if kill -0 $PID 2>/dev/null; then
        CPU_USAGE=$(ps -p $PID -o %cpu --no-headers 2>/dev/null | xargs)
        echo "$(date): ✅ Minerador RandomVIREL (PID $PID) ativo - CPU: ${CPU_USAGE:-N/A}%" >> "$ENV_LOGFILE"
        return 0
    else
        echo "$(date): ❌ Minerador RandomVIREL (PID $PID) parou" >> "$ERROR_LOGFILE"
        return 1
    fi
}

# Monitoramento contínuo
while true; do
    if check_process; then
        sleep 30
        # Verificar CPU a cada 2 minutos
        if [ $(( $(date +%s) % 120 )) -eq 0 ]; then
            check_cpu_usage
        fi
    else
        echo "$(date): Minerador RandomVIREL parou" >> "$ERROR_LOGFILE"
        break
    fi
done

# Aguardar o processo
echo "$(date): Aguardando finalização do processo..." >> "$ENV_LOGFILE"
wait $PID

echo "$(date): Minerador RandomVIREL finalizou." >> "$ENV_LOGFILE"