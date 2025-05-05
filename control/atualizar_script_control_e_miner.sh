#!/bin/bash

# Caminhos dos arquivos locais e URLs dos arquivos no Git
ARQUIVO_CONTROL_LOCAL="/opt/service-control.sh"
ARQUIVO_CONTROL_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/cpu/service-control-miner.sh"

ARQUIVO_MINER_LOCAL="/etc/systemd/system/start-xdag_gustavo.sh"
ARQUIVO_MINER_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/control/service-control.sh"

# Função para verificar e atualizar arquivo
verificar_e_atualizar() {
    local arquivo_local="$1"
    local arquivo_git="$2"
    local tmpfile=$(mktemp)

    echo "Verificando $arquivo_local..."

    # Aguarda 5 segundos antes da requisição
    sleep 5

    # Tenta baixar o arquivo remoto com User-Agent customizado
    if curl -A "Mozilla/5.0" -H "Accept: */*" -fsSL "$arquivo_git" -o "$tmpfile"; then
        if [ ! -s "$arquivo_local" ] || ! cmp -s "$arquivo_local" "$tmpfile"; then
            echo "Arquivo diferente ou vazio. Atualizando $arquivo_local..."
            cp "$tmpfile" "$arquivo_local"
            chmod +x "$arquivo_local"
        else
            echo "Arquivo $arquivo_local já está atualizado."
        fi
    else
        echo "Erro ao baixar $arquivo_git"
    fi

    # Remove o arquivo temporário
    rm -f "$tmpfile"
}

# Executa a verificação e atualização com delay entre cada um
verificar_e_atualizar "$ARQUIVO_CONTROL_LOCAL" "$ARQUIVO_CONTROL_GIT"
verificar_e_atualizar "$ARQUIVO_MINER_LOCAL" "$ARQUIVO_MINER_GIT"
