# placa mae
sudo dmidecode -t baseboard
sudo dmidecode | grep -A3 "Base Board"


# geral
sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo nano /etc/systemd/system/xdag_gustavo.service
sudo /opt/atualizar_script_control_e_miner.sh

🔹 Corrigir o arquivo de serviço
sudo systemctl edit --full xdag_gustavo.service

🔹  Aplique e teste
sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service && sudo systemctl status xdag_gustavo.service

sudo journalctl -u xdag_gustavo.service -f

