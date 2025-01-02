#!/bin/bash

# Verificar se o 'screen' está instalado. Se não, instalar sem interação
if ! command -v screen &> /dev/null; then
    echo "O 'screen' não está instalado. Instalando agora..."
    sudo apt-get update -y && sudo apt-get install -y screen
else
    echo "O 'screen' já está instalado."
fi

# Definir arquivos de log
XMRIG_LOGFILE="/var/log/start-xmrig-xdag_gustavo.log"
VERUSCOIN_LOGFILE="/var/log/VERUSCOIN.log"
ENV_LOGFILE="/var/log/start-env.log"

# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$VERUSCOIN_LOGFILE" "$XMRIG_LOGFILE" "$ENV_LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done

# Exportar o PATH para garantir o ambiente adequado
export PATH="$PATH"

# Log das variáveis de ambiente
env >> "$ENV_LOGFILE"

# Função para calcular o número total de threads da CPU
TOTAL_THREADS=$(nproc)

# Variáveis para o minerador VERUSCOIN
VERUSCOIN_BINARY="/home/wendell/hellminer/hellminer"
VERUSCOIN_POOL="stratum+tcp://eu.luckpool.net:3956#xnsub"
VERUSCOIN_WALLET="RAECnH4f6LFXcPYjcNT6dcgwHSvTxM44pW"

# Verificar se o minerador existe, caso contrário, baixar e extrair
if [ ! -f "$VERUSCOIN_BINARY" ]; then
    echo "Minerador não encontrado. Baixando e extraindo..." >> "$VERUSCOIN_LOGFILE"
    
    # Criar diretório e navegar até ele
    cd /home/wendell || { echo "Falha ao acessar o diretório"; exit 1; }

    # Baixar e extrair o minerador
    git clone https://github.com/vrscms/hellminer.git
    sudo chmod -R 777 hellminer     
    cd /home/wendell/hellminer

    # Rodar o script de instalação, se necessário
    if [ -f "./install.sh" ]; then
        ./install.sh
    else
        echo "O script de instalação não foi encontrado. Verifique a instalação manualmente." >> "$VERUSCOIN_LOGFILE"
    fi

    echo "Minerador baixado e extraído." >> "$VERUSCOIN_LOGFILE"
else
    cd /home/wendell/hellminer
    echo "Minerador já encontrado. Prosseguindo..." >> "$VERUSCOIN_LOGFILE"
fi

# Verificar o IP atual
CURRENT_IP=$(hostname -I | awk '{print $1}')
TARGET_IP="192.168.1.199"

# Verificar se o minerador já está rodando no screen
SCREEN_NAME="hellminer"
SCREEN_CHECK=$(screen -list | grep "$SCREEN_NAME")

# Se o IP corresponder ao alvo, executa o minerador VERUSCOIN
if [ "$CURRENT_IP" == "$TARGET_IP" ]; then
    echo "IP corresponde a $TARGET_IP. Executando minerador VERUSCOIN..." >> "$VERUSCOIN_LOGFILE"

    # Verificar se o minerador já está em execução no screen
    if [ -z "$SCREEN_CHECK" ]; then
        # Iniciar o minerador VERUSCOIN dentro de uma sessão screen
        screen -S "$SCREEN_NAME" -d -m "$VERUSCOIN_BINARY" -c "$VERUSCOIN_POOL" -u "$VERUSCOIN_WALLET.$(hostname)" -p x --cpu "$TOTAL_THREADS" >> "$VERUSCOIN_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
        echo "Minerador VERUSCOIN iniciado dentro de uma sessão screen." >> "$VERUSCOIN_LOGFILE"
    else
        echo "O minerador já está rodando na sessão screen." >> "$VERUSCOIN_LOGFILE"
    fi

    sleep 5  # Esperar um pouco antes de iniciar o minerador XMRig

else
    echo "IP não corresponde. IP atual: $CURRENT_IP. Executando apenas o minerador VERUSCOIN..." >> "$VERUSCOIN_LOGFILE"

    # Verificar se o minerador já está em execução no screen
    if [ -z "$SCREEN_CHECK" ]; then
        # Iniciar o minerador VERUSCOIN dentro de uma sessão screen
        screen -S "$SCREEN_NAME" -d -m "$VERUSCOIN_BINARY" -c "$VERUSCOIN_POOL" -u "$VERUSCOIN_WALLET.$(hostname)" -p x --cpu "$TOTAL_THREADS" >> "$VERUSCOIN_LOGFILE" 2>> /var/log/start-deroluna-errors.log &
        echo "Minerador VERUSCOIN iniciado dentro de uma sessão screen." >> "$VERUSCOIN_LOGFILE"
    else
        echo "O minerador já está rodando na sessão screen." >> "$VERUSCOIN_LOGFILE"
    fi

    sleep 5
fi

# Esperar os processos em segundo plano
wait

# Mensagem final
echo "$(date): Mineradores iniciados com sucesso."

# Esperar indefinidamente (loop infinito)
echo "O script está em execução indefinidamente..."
while true; do
    sleep 3600  # Dormir por uma hora antes de verificar novamente
done
