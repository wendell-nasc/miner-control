<!-- markdownlint-disable -->

# sSERVICOS DERO APURAR ...
systemctl list-units --type=service
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log


Caminho dos arquivos locais



sudo nano /opt/service-control.sh


sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service


# NOVO SCRIPT
sudo /opt/atualizar_script_control_e_miner.sh

sudo nano /opt/atualizar_script_control_e_miner.sh

sudo chmod +x /opt/atualizar_script_control_e_miner.sh && sudo /opt/atualizar_script_control_e_miner.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service



sudo EDITOR=nano crontab -e
*/30 * * * * /opt/atualizar_script_control_e_miner.sh

*/5 * * * * /opt/atualizar_script_control_e_miner.sh

sudo /opt/atualizar_script_control_e_miner.sh

- add as duas linhas:
sudo nano /opt/atualizar_script_control_e_miner.sh
sudo EDITOR=nano crontab -e


*/5 * * * * /opt/atualizar_script_control_e_miner.sh
*/5 * * * * [ -f /opt/atualizar_script_control_e_miner.sh.new ] && mv /opt/atualizar_script_control_e_miner.sh.new /opt/atualizar_script_control_e_miner.sh





192.168.1.64
192.168.1.65
192.168.1.68
192.168.1.72
192.168.1.78
192.168.1.83





192.168.1.64
192.168.1.65
192.168.1.71
192.168.1.72
192.168.1.77
192.168.1.78
192.168.1.83





# REDE UBUNTU
sudo apt update
sudo apt install nmap
nmap -sn 192.168.1.0/24

nmap -sn 192.168.1.0/24 | grep "Nmap scan report" | awk '{print $5}' | less


no comando abaixo nao esta aparecendo o ip 192.168.1.77 corrija:

nmap -sn 192.168.1.0/24 | grep "Nmap scan report" | awk '{print $5}' | less


192.168.1.64
192.168.1.65
192.168.1.71
192.168.1.72
192.168.1.77
192.168.1.78
192.168.1.83
192.168.1.144
192.168.1.147
192.168.1.150
192.168.1.152
192.168.1.156
192.168.1.157
192.168.1.158
192.168.1.159
192.168.1.163
192.168.1.164
192.168.1.168



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
sudo nano /etc/systemd/system/xdag_gustavo.service

sudo chmod +x /etc/systemd/system/start-xdag_gustavo.sh

sudo EDITOR=nano crontab -e
systemctl restart xdag_gustavo.service



sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service

# CONTROL

sudo rm -r /opt/service-control.sh && sudo nano /opt/service-control.sh
sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service



sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service


sudo tail -f /var/log/start-deroluna-xdag_gustavo.log



sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service  && sudo systemctl start xdag_gustavo.service 


sudo systemctl status xdag_gustavo.service




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
sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service && sudo systemctl status xdag_gustavo.service


sudo tail -f /var/log/start-astrominer.log


sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo chmod 777 /etc/systemd/system/start-xdag_gustavo.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service && sudo systemctl status xdag_gustavo.service

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


NICEHASH_LOGFILE

sudo journalctl -f -u  xdag_gustavo.service
sudo systemctl stop deroluna.service


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



- HIVE DISABLE

systemctl list-unit-files --type=service | grep enabled
systemctl list-units --type=service --all

sudo nano /etc/systemd/system/xdag_gustavo.service

sudo systemctl disable hive-console.service
sudo systemctl disable hive-netpre.service
sudo systemctl disable hive-ttyd.service 
sudo systemctl disable hive-watchdog.service
sudo systemctl disable hive.service hivex.service


# VERUSCOIN

sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo nano /etc/systemd/system/xdag_gustavo.service

sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service


sudo nano /etc/systemd/system/start-xdag_gustavo.sh
sudo chmod +x /etc/systemd/system/start-xdag_gustavo.sh
sudo chmod +x /etc/systemd/system/xdag_gustavo.service


sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service
sudo tail -f  /var/log/VERUSCOIN.log
sudo journalctl -f -u  xdag_gustavo.service
sudo systemctl status xdag_gustavo.service

sudo chmod +x /opt/service-control.sh && sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl restart xdag_gustavo.service



sudo sh /opt/service-control.sh && sudo systemctl daemon-reload && sudo systemctl stop xdag_gustavo.service  && sudo systemctl start xdag_gustavo.service

sudo EDITOR=nano crontab -e


sudo tail -f /var/log/start-deroluna-errors.log