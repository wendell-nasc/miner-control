


# auto_restart
sudo nano /home/wendell/auto_restart.sh
sudo chmod +x /home/wendell/auto_restart.sh
./home/wendell/auto_restart.sh
tail -f /home/wendell/log_auto_restart.log
screen -r rx580_telestai_auto_restart

# monitorar_bots
sudo nano /home/wendell/monitorar_bots.sh
sudo chmod +x /home/wendell/monitorar_bots.sh
./home/wendell/monitorar_bots.sh
tail -f /home/wendell/log_monitoramento.log
screen -r rx580_telestai_monitorar_bots