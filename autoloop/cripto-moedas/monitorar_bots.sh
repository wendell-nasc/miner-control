#!/bin/bash

#sudo nano monitorar_bots.sh
#sudo chmod +x monitorar_bots.sh
#./monitorar_bots.sh


# crontab -e
# */1 * * * * /home/wendell/trader-nonky/monitorar_bots.sh >> /home/wendell/trader-nonky/log_monitoramento.log 2>&1
#e algum script sair do ar (a screen fechar), ele será reiniciado automaticamente.
#Você pode acompanhar logs em tempo real com:
#tail -f /home/wendell/trader-nonky/log_monitoramento.log


#sudo nano /home/wendell/trader-nonky/monitorar_bots.sh
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
check_and_restart "nonky_SCASH"         python3 /home/wendell/trader-nonky/main3.py SCASH/USDT SCASH 0.0091
check_and_restart "nonky_SCASH_compra"  python3 /home/wendell/trader-nonky/bid_main3.py SCASH/USDT USDT 0.0074

# PEPOW
check_and_restart "nonky_PEPOW"         python3 /home/wendell/trader-nonky/main3.py PEPEW/USDT PEPEW 0.0000030
# check_and_restart "nonky_PEPOW_compra"  python3 /home/wendell/trader-nonky/bid_main3.py PEPEW/USDT USDT 0.0000026

# TARI
check_and_restart "nonky_TARI_XTM"         python3 /home/wendell/trader-nonky/main3.py XTM/USDT XTM 0.030
#check_and_restart "nonky_TARI_XTM_compra"         python3 /home/wendell/trader-nonky/bid_main3.py XTM/USDT XTM 0.01


# Monitorar bots DERO 
check_and_restart "nonky_DERO"         python3 /home/wendell/trader-nonky/main3.py DERO/USDT DERO 0.45
check_and_restart "nonky_DERO_compra"  python3 /home/wendell/trader-nonky/bid_main3.py DERO/USDT USDT 0.41


# Monitorar bots RAVECOIN 
check_and_restart "nonky_RVN"         python3 /home/wendell/trader-nonky/main3.py RVN/USDT RVN 0.0185
check_and_restart "nonky_RVN_compra"  python3 /home/wendell/trader-nonky/bid_main3.py RVN/USDT USDT 0.0135

# Monitorar bots DOGE 
check_and_restart "nonky_DOGE"         python3 /home/wendell/trader-nonky/main3.py DOGE/USDT DOGE 0.23
check_and_restart "nonky_DOGE_compra"  python3 /home/wendell/trader-nonky/bid_main3.py DOGE/USDT USDT 0.17

# Monitorar bots SPECTRA 
check_and_restart "nonky_SPR"         python3 /home/wendell/trader-nonky/main3.py SPR/USDT SPR 0.000800
check_and_restart "nonky_SPR_compra"  python3 /home/wendell/trader-nonky/bid_main3.py SPR/USDT USDT 0.000530

# Monitorar bots XDAG 
check_and_restart "nonky_XDAG"         python3 /home/wendell/trader-nonky/main3.py XDAG/USDT XDAG 0.0049
check_and_restart "nonky_XDAG_compra"  python3 /home/wendell/trader-nonky/bid_main3.py XDAG/USDT USDT 0.0026

# Monitorar bots Salvium 
check_and_restart "nonky_SAL"         python3 /home/wendell/trader-nonky/main3.py SAL/USDT SAL 0.10
check_and_restart "nonky_SAL_compra"  python3 /home/wendell/trader-nonky/bid_main3.py SAL/USDT USDT 0.067


# Monitorar bots ZEPH 
check_and_restart "nonky_ZEPH"         python3 /home/wendell/trader-nonky/main3.py ZEPH/USDT ZEPH 0.85
check_and_restart "nonky_ZEPH_compra"  python3 /home/wendell/trader-nonky/bid_main3.py ZEPH/USDT USDT 0.73

