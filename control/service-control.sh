#!/bin/bash

# URL do arquivo no GitHub
URL="https://raw.githubusercontent.com/wendell-nasc/miner-control/refs/heads/main/cpu/service-control-miner.sh"

# Caminho do arquivo local
ARQUIVO_LOCAL="/etc/systemd/system/start-xdag_gustavo.sh"


# Definir arquivos de log
LOGFILE="/var/log/control_miner.log"

#Servico para restartar
SERVICO="xdag_gustavo.service"


# Garantir que os arquivos de log existam e tenham permissões adequadas
for logfile in "$LOGFILE"; do
    touch "$logfile"
    chmod 644 "$logfile"
done



# Comparar e atualizar automaticamente
if ! curl -s $URL | diff -q --strip-trailing-cr $ARQUIVO_LOCAL - > /dev/null; then
    echo "$(date): Arquivo diferente. Atualizando..." >> $LOGFILE
    # Baixar e substituir o arquivo local
    sudo rm -r $ARQUIVO_LOCAL
    sudo curl -s $URL -o $ARQUIVO_LOCAL
    sudo chmod +x $ARQUIVO_LOCAL
    echo "$(date): Arquivo atualizado !!!" >> $LOGFILE
    # Reiniciar o serviço
    echo "$(date): Reiniciando o servico ..." >> $LOGFILE
    sudo systemctl daemon-reload && sudo systemctl restart $SERVICO
    echo "$(date): Servico reiniciado !!!" >> $LOGFILE
else
    echo "$(date): O arquivo já está atualizado." >> $LOGFILE
fi
