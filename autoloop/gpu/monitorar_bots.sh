#!/bin/bash

# sudo nano /home/wendell/monitorar_bots.sh
# sudo chmod +x /home/wendell/monitorar_bots.sh
# ./home/wendell/monitorar_bots.sh
# tail -f /home/wendell/log_monitoramento.log
# screen -r rx580_telestai_monitorar_bots


# crontab -e
# */1 * * * * /home/wendell/monitorar_bots.sh >> /home/wendell/log_monitoramento.log 2>&1
#e algum script sair do ar (a screen fechar), ele será reiniciado automaticamente.
#Você pode acompanhar logs em tempo real com:
#tail -f /home/wendell/log_monitoramento.log


#sudo nano /home/wendell/monitorar_bots.sh
check_and_restart() {
  local session_name=$1
  shift
  local command="$@"

  if screen -list | grep -q "\.${session_name}"; then
    echo "✅ $session_name está rodando."
  else
    echo "❌ $session_name NÃO está rodando. Reiniciando..."
    screen -dmS "$session_name" bash -c "$command; echo 'Script falhou. Reiniciando em 5 segundos...'; sleep 5"
  fi
}

# Monitorar bots SCASH 
#check_and_restart "rx580_telestai_monitorar_bots"          /home/wendell/SRBMiner/SRBMiner-Multi-2-6-5/SRBMiner-MULTI --algorithm progpow_telestai --pool stratum-na.rplant.xyz:7051 --wallet TcafffD4GPcDQLmH4jXNpHmgSytQMwM9A5.rx580 --keepalive true --no-cpu

check_and_restart "rx580_nimar_monitorar_bots"          /home/wendell/SRBMiner/SRBMiner-Multi-2-9-4/SRBMiner-MULTI --disable-cpu --algorithm progpow_zano --pool nir-us.kryptex.network:7023 --wallet Nn2gwAxPVhZFvUDEyRohfVfcTGccKYVzDYdscVqiydNvFeWMZrHLihhXfjfByGcp4CdWEpP9yXuCEc5oQ9ty5kPf1L9CCA2z1/rx580
#/home/wendell/SRBMiner/SRBMiner-Multi-2-9-4/SRBMiner-MULTI --disable-cpu --algorithm progpow_zano --pool nir-us.kryptex.network:7023 --wallet Nn2gwAxPVhZFvUDEyRohfVfcTGccKYVzDYdscVqiydNvFeWMZrHLihhXfjfByGcp4CdWEpP9yXuCEc5oQ9ty5kPf1L9CCA2z1/rx580