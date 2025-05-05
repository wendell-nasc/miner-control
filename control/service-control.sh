#!/bin/bash

# URL dos arquivos no GitHub
URL="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/cpu/service-control-miner.sh"
URL_CONTROL="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/control/service-control.sh"

# Caminho dos arquivos locais
ARQUIVO_LOCAL="/etc/systemd/system/start-xdag_gustavo.sh"
ARQUIVO_LOCAL_CONTROL="/opt/service-control.sh"

# Definir arquivo de log
LOGFILE="/var/log/control_miner.log"

# Serviço para reiniciar
SERVICO="xdag_gustavo.service"

# Garantir que o arquivo de log exista e tenha permissões adequadas
touch "$LOGFILE"
chmod 644 "$LOGFILE"

# Atualizar data e hora para o horário do Brasil
echo "$(date): Atualizando a data e hora para o horário do Brasil..." >> "$LOGFILE"
timedatectl set-timezone America/Sao_Paulo

# Função para atualizar um arquivo se necessário
atualizar_arquivo() {
    local url="$1"
    local arquivo_local="$2"
    local atualizado=0

    local temp_file
    temp_file=$(mktemp)

    if curl -s "$url" -o "$temp_file"; then
        if [ ! -f "$arquivo_local" ] || ! diff -q --strip-trailing-cr "$temp_file" "$arquivo_local" > /dev/null; then
            echo "$(date): Arquivo diferente. Atualizando $arquivo_local..." >> "$LOGFILE"
            mv "$temp_file" "$arquivo_local"
            chmod +x "$arquivo_local"
            echo "$(date): Arquivo atualizado: $arquivo_local" >> "$LOGFILE"
            atualizado=1
        else
            echo "$(date): O arquivo $arquivo_local já está atualizado." >> "$LOGFILE"
            rm "$temp_file"
        fi
    else
        echo "$(date): Falha ao baixar $url." >> "$LOGFILE"
        rm -f "$temp_file"
    fi

    return $atualizado
}

# Inicializa a variável de controle de atualização
arquivos_atualizados=0

# Atualiza os arquivos e verifica se houve atualização
atualizar_arquivo "$URL" "$ARQUIVO_LOCAL" && arquivos_atualizados=1
atualizar_arquivo "$URL_CONTROL" "$ARQUIVO_LOCAL_CONTROL" && arquivos_atualizados=1

# Reiniciar o serviço somente se algum arquivo foi atualizado
if [ $arquivos_atualizados -eq 1 ]; then
    echo "$(date): Reiniciando o serviço $SERVICO..." >> "$LOGFILE"
    systemctl stop "$SERVICO"
    systemctl daemon-reexec
    systemctl restart "$SERVICO"
    echo "$(date): Serviço $SERVICO reiniciado com sucesso!" >> "$LOGFILE"
else
    echo "$(date): Nenhuma atualização foi feita. Serviço não reiniciado." >> "$LOGFILE"
fi
