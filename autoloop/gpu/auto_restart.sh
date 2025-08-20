#!/bin/bash

# sudo nano /home/wendell/auto_restart.sh
# sudo chmod +x /home/wendell/auto_restart.sh
# ./home/wendell/auto_restart.sh
# tail -f /home/wendell/log_auto_restart.log
# screen -r rx580_telestai_auto_restart

# crontab -e
# */120 * * * * /home/wendell/auto_restart.sh >> /home/wendell/log_auto_restart.log 2>&1
#e algum script sair do ar (a screen fechar), ele será reiniciado automaticamente.
#Você pode acompanhar logs em tempo real com:
#tail -f /home/wendell/log_auto_restart.log


#sudo nano /home/wendell/auto_restart.sh

start_session() {
  local session_name=$1
  shift
  local command="$@"

  while true; do
    echo "Iniciando sessão $session_name..."
    
    # Mata a sessão anterior, se existir
    screen -S "$session_name" -X quit 2>/dev/null

    # Cria nova sessão screen com o comando desejado
    screen -dmS "$session_name" bash -c "$command; echo 'Script falhou. Reiniciando em 5 segundos...'; sleep 5"
    
    # Aguarda 10 segundos para verificar se o screen ainda está vivo (opcional)
    sleep 10
    if ! screen -list | grep -q "$session_name"; then
      echo "Sessão $session_name caiu, reiniciando..."
    else
      break
    fi
  done
}

# SCASH
#start_session "rx580_telestai_auto_restart"         /home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI --algorithm progpow_telestai --pool stratum-na.rplant.xyz:7051 --wallet TcafffD4GPcDQLmH4jXNpHmgSytQMwM9A5.rx580 --keepalive true --no-cpu
start_session "rx580_nimar_auto_restart"          /home/wendell/SRBMiner/SRBMiner-Multi-2-9-4/SRBMiner-MULTI --disable-cpu --algorithm progpow_zano --pool nir-us.kryptex.network:7023 --wallet Nn2gwAxPVhZFvUDEyRohfVfcTGccKYVzDYdscVqiydNvFeWMZrHLihhXfjfByGcp4CdWEpP9yXuCEc5oQ9ty5kPf1L9CCA2z1/rx580


#/home/wendell/SRBMiner/SRBMiner-Multi-2-9-4/SRBMiner-MULTI --disable-cpu --algorithm progpow_zano --pool nir-us.kryptex.network:7023 --wallet Nn2gwAxPVhZFvUDEyRohfVfcTGccKYVzDYdscVqiydNvFeWMZrHLihhXfjfByGcp4CdWEpP9yXuCEc5oQ9ty5kPf1L9CCA2z1/rx580