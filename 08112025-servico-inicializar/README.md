# placa mae
sudo dmidecode -t baseboard
sudo dmidecode | grep -A3 "Base Board"


# geral
sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo /etc/systemd/system/start-xdag_gustavo.sh

sudo nano /etc/systemd/system/xdag_gustavo.service
sudo /opt/atualizar_script_control_e_miner.sh

🔹 Corrigir o arquivo de serviço
sudo systemctl edit --full xdag_gustavo.service

🔹  Aplique e teste
htop
sudo journalctl -u xdag_gustavo.service -f

