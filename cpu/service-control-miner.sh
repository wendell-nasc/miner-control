#!/bin/bash

# ============================================================================
# CONFIGURAÇÕES GERAIS
# ============================================================================

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
        
        # Verificar se o algoritmo randomhscx está disponível
        echo "$(date): Verificando algoritmos disponíveis..." >> "$ENV_LOGFILE"
        "$SRB_PATH" --list-algorithms >> "$ENV_LOGFILE" 2>&1
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
# CONFIGURAÇÕES DOS MINERADORES
# ============================================================================

# Primeira moeda (RandomHSCX)
MOEDA1_POOL="stratum-na.rplant.xyz:7023"
MOEDA1_WALLET="hx1qhhnxud9h3sa7l76a5rp8sk2x9fvsdgmt5e80ss"
MOEDA1_ALGO="randomhscx"

# Segunda moeda (RandomVIREL)
MOEDA2_POOL="stratum-na.rplant.xyz:7155"
MOEDA2_WALLET="v1em8ehwjlda71d98crfii0glji3rtdjboejdqe"
MOEDA2_ALGO="randomvirel"

# ============================================================================
# EXECUÇÃO DOS MINERADORES
# ============================================================================

echo "$(date): Iniciando mineração com SRBMiner 3.0.5..." >> "$ENV_LOGFILE"
echo "$(date): Threads totais: $TOTAL_THREADS" >> "$ENV_LOGFILE"
echo "$(date): Threads Moeda 1: $THREADS1" >> "$ENV_LOGFILE"
echo "$(date): Threads Moeda 2: $THREADS2" >> "$ENV_LOGFILE"

# Inicia SRBMiner para moeda 1 (RandomHSCX)
echo "$(date): Iniciando mineração da Moeda 1 (RandomHSCX)..." >> "$MOEDA1_LOGFILE"
echo "$(date): Comando: $SRB_PATH --disable-gpu --algorithm $MOEDA1_ALGO --cpu-threads $TOTAL_THREADS --pool $MOEDA1_POOL --wallet $MOEDA1_WALLET.$(hostname) --keepalive true" >> "$MOEDA1_LOGFILE"

"$SRB_PATH" --disable-gpu --algorithm "$MOEDA1_ALGO" --cpu-threads $TOTAL_THREADS \
--pool "$MOEDA1_POOL" --wallet "$MOEDA1_WALLET.$(hostname)" \
--keepalive true \
>> "$MOEDA1_LOGFILE" 2>> "$ERROR_LOGFILE" &

PID1=$!
echo "$(date): SRBMiner Moeda 1 iniciado com PID: $PID1" >> "$ENV_LOGFILE"

# Pequena pausa para garantir que o primeiro minerador inicializou
sleep 5

# Inicia SRBMiner para moeda 2 (RandomVIREL)
echo "$(date): Iniciando mineração da Moeda 2 (RandomVIREL)..." >> "$MOEDA2_LOGFILE"
echo "$(date): Comando: $SRB_PATH --disable-gpu --algorithm $MOEDA2_ALGO --cpu-threads $THREADS2 --pool $MOEDA2_POOL --wallet $MOEDA2_WALLET.$(hostname) --keepalive true" >> "$MOEDA2_LOGFILE"

"$SRB_PATH" --disable-gpu --algorithm "$MOEDA2_ALGO" --cpu-threads $TOTAL_THREADS \
--pool "$MOEDA2_POOL" --wallet "$MOEDA2_WALLET.$(hostname)" \
--keepalive true \
>> "$MOEDA2_LOGFILE" 2>> "$ERROR_LOGFILE" &

PID2=$!
echo "$(date): SRBMiner Moeda 2 iniciado com PID: $PID2" >> "$ENV_LOGFILE"

# ============================================================================
# MONITORAMENTO
# ============================================================================

echo "$(date): Ambos mineradores iniciados com sucesso!" >> "$ENV_LOGFILE"
echo "$(date): PID Moeda 1 (RandomHSCX): $PID1" >> "$ENV_LOGFILE"
echo "$(date): PID Moeda 2 (RandomVIREL): $PID2" >> "$ENV_LOGFILE"

# Função para verificar se os processos estão ativos
check_processes() {
    if kill -0 $PID1 2>/dev/null; then
        echo "$(date): ✅ Minerador 1 (PID $PID1) está ativo" >> "$ENV_LOGFILE"
    else
        echo "$(date): ❌ Minerador 1 (PID $PID1) parou" >> "$ERROR_LOGFILE"
    fi
    
    if kill -0 $PID2 2>/dev/null; then
        echo "$(date): ✅ Minerador 2 (PID $PID2) está ativo" >> "$ENV_LOGFILE"
    else
        echo "$(date): ❌ Minerador 2 (PID $PID2) parou" >> "$ERROR_LOGFILE"
    fi
}

# Verificação inicial
check_processes

# Aguardar ambos os processos
wait $PID1 $PID2

echo "$(date): Ambos mineradores finalizaram." >> "$ENV_LOGFILE"