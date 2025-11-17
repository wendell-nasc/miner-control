# geral
sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo nano /etc/systemd/system/xdag_gustavo.service


🔹 Corrigir o arquivo de serviço
sudo systemctl edit --full xdag_gustavo.service

🔹  Aplique e teste
sudo systemctl daemon-reload
sudo systemctl restart xdag_gustavo.service
sudo journalctl -u xdag_gustavo.service -f

