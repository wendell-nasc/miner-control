# …or create a new repository on the command line
echo "# miner-control" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:wendell-nasc/miner-control.git
git push -u origin main

# …or push an existing repository from the command line
git remote add origin git@github.com:wendell-nasc/miner-control.git
git branch -M main
git push -u origin main



# geral
sudo nano /etc/systemd/system/start-xdag_gustavo.sh


# CONTROL

sudo touch /var/log/control_miner.log && sudo nano /opt/service-control.sh
sudo chmod +x /opt/service-control.sh && sudo EDITOR=nano crontab -e
0 */4 * * * systemctl restart xdag_gustavo.service
*/2 * * * * /opt/service-control.sh

sudo systemctl daemon-reload && sudo systemctl enable xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service && sudo systemctl status xdag_gustavo.service


sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service
sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service

sudo systemctl stop xdag_gustavo.service
sudo systemctl start xdag_gustavo.service


sudo tail -f /var/log/control_miner.log
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log
sudo tail -f /var/log/start-deroluna-hansen.log