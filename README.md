# PENDENTES RIGS
161
165

159



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

sudo chmod +x /etc/systemd/system/start-xdag_gustavo.sh



# CONTROL

sudo rm -r /opt/service-control.sh && sudo nano /opt/service-control.sh
sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service



sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service 


-- SCASH
sudo systemctl stop xdag_gustavo.service
sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service
sudo systemctl status xdag_gustavo.service

sudo tail -f /var/log/scash.log


sudo touch /var/log/control_miner.log && sudo nano /opt/service-control.sh
sudo chmod +x /opt/service-control.sh && sudo timedatectl set-timezone America/Sao_Paulo && sudo EDITOR=nano crontab -e
0 */4 * * * systemctl restart xdag_gustavo.service
*/2 * * * * /opt/service-control.sh
30 11 * * * /usr/bin/timedatectl set-timezone America/Sao_Paulo
30 23 * * * /usr/bin/timedatectl set-timezone America/Sao_Paulo



sudo systemctl daemon-reload && sudo systemctl enable xdag_gustavo.service && sudo systemctl start xdag_gustavo.service
sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service


sudo tail -f /var/log/start-astrominer.log


sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo chmod 777 /etc/systemd/system/start-xdag_gustavo.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service

sudo systemctl status xdag_gustavo.service

-correcao
192.168.1.64 - rig64-mini-e3_1270
192.168.1.67 - rig67-asus-i5_-3330
192.168.1.68 - rig68-mini-i7_3570 - falta
192.168.1.69 - rig HIVE OS [RECUSADO ]
192.168.1.70 - rig70-asus-i5-3570s
192.168.1.72 - rig72-asus-E3_1220_V2
192.168.1.81 - rig81-pcware-i5_2400




sudo tail -f /var/log/control_miner.log
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log
sudo tail -f /var/log/scash.log


sudo journalctl -f -u  xdag_gustavo.service


sudo screen -S dero-node-integrator_ok /home/wendell/dero_linux_amd64/derod-linux-amd64 --integrator-address=dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z --rpc-bind=0.0.0.0:10102 --p2p-bind=0.0.0.0:52672 --add-priority-node=45.82.66.54:8080

screen -S dero-miner /home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64 -daemon-rpc-address 192.168.1.168:10102 -wallet-address dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -mining-threads $(nproc)
    

# GUSTADVO

sudo wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.9/SRBMiner-Multi-2-6-9-Linux.tar.gz && sudo tar -xzvf SRBMiner-Multi-2-6-9-Linux.tar.gz

 xdag_gustavo.service && sudo systemctl status xdag_gustavo.service
 sudo systemctl stop xdag_gustavo.service

sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo chmod +X /etc/systemd/system/start-xdag_gustavo.sh


sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service
sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service


sudo systemctl stop xdag_gustavo.service
sudo systemctl start xdag_gustavo.service
sudo systemctl status xdag_gustavo.service


sudo tail -f /var/log/control_miner.log
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log
sudo tail -f /var/log/start-deroluna-hansen.log





sudo journalctl -f -u  xdag_gustavo.service

cat /var/log/scash.log