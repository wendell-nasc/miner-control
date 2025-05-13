#!/bin/bash

# Caminhos dos arquivos locais e URLs dos arquivos no Git (corretamente associados)
ARQUIVO_CONTROL_LOCAL="/opt/service-control.sh"
ARQUIVO_CONTROL_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/control/service-control.sh"

ARQUIVO_MINER_LOCAL="/etc/systemd/system/start-xdag_gustavo.sh"
ARQUIVO_MINER_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/cpu/service-control-miner.sh"

# Variável de controle para saber se houve atualização
HOUVE_ATUALIZACAO=0

# Função para verificar e atualizar arquivo
verificar_e_atualizar() {
    local arquivo_local="$1"
    local arquivo_git="$2"
    local tmpfile
    tmpfile=$(mktemp)

    echo "Verificando $arquivo_local..."

    # Aguarda 5 segundos antes da requisição
    sleep 5

    # Baixa o arquivo remoto para comparação
    if curl -A "Mozilla/5.0" -H "Accept: */*" -fsSL "$arquivo_git" -o "$tmpfile"; then
        if [ ! -s "$arquivo_local" ] || ! cmp -s "$arquivo_local" "$tmpfile"; then
            echo "Arquivo diferente ou inexistente. Atualizando $arquivo_local..."
            cp "$tmpfile" "$arquivo_local"
            chmod +x "$arquivo_local"
            HOUVE_ATUALIZACAO=1
        else
            echo "Nenhuma mudança detectada em $arquivo_local."
        fi
    else
        echo "Erro ao baixar: $arquivo_git"
    fi

    rm -f "$tmpfile"
}

# Executa a verificação e atualização dos dois arquivos
verificar_e_atualizar "$ARQUIVO_CONTROL_LOCAL" "$ARQUIVO_CONTROL_GIT"
verificar_e_atualizar "$ARQUIVO_MINER_LOCAL" "$ARQUIVO_MINER_GIT"

# Serviço a ser reiniciado
SERVICO="xdag_gustavo.service"

# Reinicia o serviço somente se houve atualização
if [ "$HOUVE_ATUALIZACAO" -eq 1 ]; then
    echo "$(date): Reiniciando o serviço $SERVICO..."
    systemctl stop "$SERVICO"
    systemctl daemon-reload
    systemctl restart "$SERVICO"
    echo "$(date): Serviço $SERVICO reiniciado com sucesso."
else
    echo "$(date): Nenhuma atualização detectada. Serviço não reiniciado."
fi
