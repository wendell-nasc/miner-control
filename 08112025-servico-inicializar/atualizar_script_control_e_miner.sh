#!/bin/bash
#13052025 12>22
#13052025 12>22

#13052025 12>22

# Caminhos dos arquivos locais e URLs dos arquivos no Git
ARQUIVO_CONTROL_LOCAL="/opt/service-control.sh"
ARQUIVO_CONTROL_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/control/service-control.sh"

ARQUIVO_MINER_LOCAL="/etc/systemd/system/start-xdag_gustavo.sh"
ARQUIVO_MINER_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/cpu/service-control-miner.sh"

ARQUIVO_SCRIPT_LOCAL="/opt/atualizar_script_control_e_miner.sh"
ARQUIVO_SCRIPT_GIT="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/control/atualizar_script_control_e_miner.sh"

ARQUIVO_SCRIPT_NOVO="${ARQUIVO_SCRIPT_LOCAL}.new"

# Variável de controle para saber se houve atualização
HOUVE_ATUALIZACAO=0

# Função para verificar e atualizar arquivo (exceto o próprio script)
verificar_e_atualizar() {
    local arquivo_local="$1"
    local arquivo_git="$2"
    local tmpfile
    tmpfile=$(mktemp)

    echo "Verificando $arquivo_local..."

    sleep 5

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

# Verifica e atualiza os arquivos de controle e miner
verificar_e_atualizar "$ARQUIVO_CONTROL_LOCAL" "$ARQUIVO_CONTROL_GIT"
verificar_e_atualizar "$ARQUIVO_MINER_LOCAL" "$ARQUIVO_MINER_GIT"
verificar_e_atualizar "$ARQUIVO_SCRIPT_LOCAL" "$ARQUIVO_SCRIPT_GIT"



# Verificação especial: não substituir o script enquanto ele roda
echo "Verificando atualização do próprio script..."
tmpfile=$(mktemp)
if curl -A "Mozilla/5.0" -H "Accept: */*" -fsSL "$ARQUIVO_SCRIPT_GIT" -o "$tmpfile"; then
    if [ ! -s "$ARQUIVO_SCRIPT_LOCAL" ] || ! cmp -s "$ARQUIVO_SCRIPT_LOCAL" "$tmpfile"; then
        echo "Nova versão do script detectada. Salvando em $ARQUIVO_SCRIPT_NOVO"
        mv "$tmpfile" "$ARQUIVO_SCRIPT_NOVO"
        chmod +x "$ARQUIVO_SCRIPT_NOVO"
    else
        echo "Script já está atualizado."
        rm -f "$tmpfile"
    fi
else
    echo "Erro ao baixar o script de atualização."
    rm -f "$tmpfile"
fi

# Reiniciar serviço se necessário
SERVICO="xdag_gustavo.service"

if [ "$HOUVE_ATUALIZACAO" -eq 1 ]; then
    echo "$(date): Reiniciando o serviço $SERVICO..."
    systemctl stop "$SERVICO"
    systemctl daemon-reload
    systemctl restart "$SERVICO"
    echo "$(date): Serviço $SERVICO reiniciado com sucesso."
else
    echo "$(date): Nenhuma atualização detectada. Serviço não reiniciado."
fi
