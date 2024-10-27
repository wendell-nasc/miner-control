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
sudo nano /etc/systemd/system/start-xdag_gustavo.sh



# CONTROL

sudo touch /var/log/control_miner.log && sudo nano /opt/service-control.sh
sudo chmod +x /opt/service-control.sh && sudo EDITOR=nano crontab -e
0 */4 * * * systemctl restart xdag_gustavo.service
*/2 * * * * /opt/service-control.sh

sudo systemctl daemon-reload && sudo systemctl enable xdag_gustavo.service && sudo systemctl restart xdag_gustavo.service && sudo systemctl status xdag_gustavo.service



sudo systemctl daemon-reload && sudo systemctl start xdag_gustavo.service

sudo systemctl stop xdag_gustavo.service


sudo tail -f /var/log/control_miner.log
sudo tail -f /var/log/start-deroluna-xdag_gustavo.log
sudo tail -f /var/log/start-deroluna-hansen.log [ atual ]



# DERO NODE
- instalação
sudo apt install xfsprogs ntpdate

fallocate -l 100G dataFsFile
mkfs.xfs -f  -i maxpct=100 -m crc=0 -i size=256 -b size=512  dataFsFile
mkdir dNodedata ; chmod -R 777 dNodedata
sudo mount dataFsFile dNodedata
cd dNodedata      // Download DERO software and sync in this directory

sudo apt install ntpdate
sudo ntpdate  pool.ntp.org
sudo EDITOR=nano crontab -e
30 * * * * /usr/sbin/ntpdate pool.ntp.org >> /var/log/ntpdate.log 2>&1

wget https://github.com/deroproject/derohe/releases/latest/download/dero_linux_amd64.tar.gz
tar xvzf dero_linux_amd64.tar.gz
cd dero_linux_amd64 

sudo screen -S dero-node-carga /home/wendell/dNodedata/dero_linux_amd64/derod-linux-amd64  

sudo screen -S dero-node /home/wendell/dNodedata/dero_linux_amd64/derod-linux-amd64 --fastsync 
sudo screen -ls ou -r

ser der erro excluir cache maineet
sudo rm -rr mainnet

sudo screen -S dero-node-integrator /home/wendell/dNodedata/dero_linux_amd64/derod-linux-amd64 --integrator-address=dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z --rpc-bind=0.0.0.0:10102 --p2p-bind=0.0.0.0:52672 --add-priority-node=45.82.66.54:8080


https://www.youtube.com/watch?v=zYjtQrsHGvA&t=924s


wget https://github.com/Intergalactic-Mining/Uranus/releases/download/0.0.3.1/uranus-0.0.3.1-linux-amd64.tar.xz

sudo tar xvf uranus-0.0.3.1-linux-amd64.tar.xz

./uranus -o straum+tcp://dero-node-gustavogerman.mysrv.cloud:10100 -u dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -t 4 --force-arch x86_64




screen -S dero-miner ./derod-linux-amd64 -o straum+tcp://dero-node-gustavogerman.mysrv.cloud:10100 -u dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -t $(nproc)


# minerador hansen
https://github.com/Hansen333/Hansen33-s-DERO-Miner
wget https://github.com/Hansen333/Hansen33-s-DERO-Miner/releases/latest/download/hansen33s-dero-miner-linux-amd64.tar.gz
sudo tar xvf hansen33s-dero-miner-linux-amd64.tar.gz

./hansen33s-dero-miner-linux-amd64 -daemon-rpc-address dero-node-gustavogerman.mysrv.cloud:10100 -wallet-address dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -mining-threads $(nproc) -turbo

sudo systemctl daemon-reload && sudo systemctl enable dero_hansen.service && sudo systemctl start dero_hansen.service && sudo systemctl status dero_hansen.service


sudo systemctl disable dero_hansen.service && sudo systemctl stop dero_hansen.service

sudo tail -f /var/log/start-deroluna-hansen.log
dd


screen -S dero-miner /home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64 -daemon-rpc-address dero-node-gustavogerman.mysrv.cloud:10100 -wallet-address dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -mining-threads $(nproc) -turbo

screen -S dero-miner /home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64 -daemon-rpc-address dero-node-gustavogerman.mysrv.cloud:10100 -wallet-address dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -mining-threads $(nproc)


# HANSEN
screen -S dero-miner /home/wendell/dero_linux_amd64/hansen33s-dero-miner-linux-amd64 -daemon-rpc-address 192.168.1.168:10100 -wallet-address dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -mining-threads $(nproc)

# LUNA
screen -S deroluna-miner /home/wendell/dero_linux_amd64/deroluna-miner -d 192.168.1.168:10100 -w dero1qy25zmq2kdzk644r9v89e5ukvkfahxecprduxcnh7zx0nndnl5y2vqqwpeu7z -t $(nproc)