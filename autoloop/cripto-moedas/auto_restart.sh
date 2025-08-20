#!/bin/bash

#sudo nano auto_restart.sh
#sudo chmod +x auto_restart.sh
#./auto_restart.sh



# crontab -e
# */120 * * * * /home/wendell/trader-nonky/auto_restart.sh >> /home/wendell/trader-nonky/log_auto_restart.log 2>&1
#e algum script sair do ar (a screen fechar), ele será reiniciado automaticamente.
#Você pode acompanhar logs em tempo real com:
#tail -f /home/wendell/trader-nonky/log_auto_restart.log


#sudo nano /home/wendell/trader-nonky/auto_restart.sh

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
start_session "nonky_SCASH"         python3 /home/wendell/trader-nonky/main3.py SCASH/USDT SCASH 0.0091
start_session "nonky_SCASH_compra"  python3 /home/wendell/trader-nonky/bid_main3.py SCASH/USDT USDT 0.0074

# PEPOW
start_session "nonky_PEPOW"         python3 /home/wendell/trader-nonky/main3.py PEPEW/USDT PEPEW 0.0000030
#start_session "nonky_PEPOW_compra"  python3 /home/wendell/trader-nonky/bid_main3.py PEPEW/USDT USDT 0.0000026

# TARI
start_session "nonky_TARI_XTM"         python3 /home/wendell/trader-nonky/main3.py XTM/USDT XTM 0.030
#start_session "nonky_TARI_XTM_compra"         python3 /home/wendell/trader-nonky/bid_main3.py XTM/USDT XTM 0.01


# DERO
start_session "nonky_DERO"         python3 /home/wendell/trader-nonky/main3.py DERO/USDT DERO 0.46
start_session "nonky_DERO_compra"  python3 /home/wendell/trader-nonky/bid_main3.py DERO/USDT USDT 0.41

# RAVECOIN
start_session "nonky_RVN"         python3 /home/wendell/trader-nonky/main3.py RVN/USDT RVN 0.0185
start_session "nonky_RVN_compra"  python3 /home/wendell/trader-nonky/bid_main3.py RVN/USDT USDT 0.0135

# DOGE
start_session "nonky_DOGE"         python3 /home/wendell/trader-nonky/main3.py DOGE/USDT DOGE 0.23
start_session "nonky_DOGE_compra"  python3 /home/wendell/trader-nonky/bid_main3.py DOGE/USDT USDT 0.17


# SPECTRA
start_session "nonky_SPR"         python3 /home/wendell/trader-nonky/main3.py SPR/USDT SPR 0.000800
start_session "nonky_SPR_compra"  python3 /home/wendell/trader-nonky/bid_main3.py SPR/USDT USDT 0.000530



# XDAG
start_session "nonky_XDAG"         python3 /home/wendell/trader-nonky/main3.py XDAG/USDT XDAG 0.0049
start_session "nonky_XDAG_compra"  python3 /home/wendell/trader-nonky/bid_main3.py XDAG/USDT USDT 0.0026

# SALVIUM
start_session "nonky_SAL"         python3 /home/wendell/trader-nonky/main3.py SAL/USDT SAL 0.10
start_session "nonky_SAL_compra"  python3 /home/wendell/trader-nonky/bid_main3.py SAL/USDT USDT 0.067


# Monitorar bots ZEPH 
start_session "nonky_ZEPH"         python3 /home/wendell/trader-nonky/main3.py ZEPH/USDT ZEPH 0.85
start_session "nonky_ZEPH_compra"  python3 /home/wendell/trader-nonky/bid_main3.py ZEPH/USDT USDT 0.73


