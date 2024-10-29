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
sudo chmod +x /opt/service-control.sh && sudo timedatectl set-timezone America/Sao_Paulo && sudo EDITOR=nano crontab -e
0 */4 * * * systemctl restart xdag_gustavo.service
*/2 * * * * /opt/service-control.sh
30 11 * * * /usr/bin/timedatectl set-timezone America/Sao_Paulo
30 23 * * * /usr/bin/timedatectl set-timezone America/Sao_Paulo


-correcao
192.168.1.64 - rig64-mini-e3_1270
192.168.1.67 - rig67-asus-i5_-3330
192.168.1.68 - rig68-mini-i7_3570
192.168.1.69 - rig HIVE OS [RECUSADO ]
192.168.1.70 - rig70-asus-i5-3570s
192.168.1.72 - rig72-asus-E3_1220_V2
192.168.1.81 - rig81-pcware-i5_2400




sudo tail -f /var/log/control_miner.log
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log
sudo tail -f /var/log/scash.log


sudo journalctl -f -u  xdag_gustavo.service



# GUSTADVO

sudo wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.9/SRBMiner-Multi-2-6-9-Linux.tar.gz && sudo tar -xzvf SRBMiner-Multi-2-6-9-Linux.tar.gz

 xdag_gustavo.service && sudo systemctl status xdag_gustavo.service
 sudo systemctl stop xdag_gustavo.service

sudo nano /etc/systemd/system/start-xdag_gustavo.sh


sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service
sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service


sudo systemctl stop xdag_gustavo.service
sudo systemctl start xdag_gustavo.service
sudo systemctl status xdag_gustavo.service


sudo tail -f /var/log/control_miner.log
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log
sudo tail -f /var/log/start-deroluna-hansen.log

cat /var/log/scash.log