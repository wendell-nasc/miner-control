# systemctl list-unit-files --type=service | grep enabled
systemctl list-units --type=service --all

sudo nano /etc/systemd/system/xdag_gustavo.service

sudo systemctl disable hive-console.service
sudo systemctl disable hive-netpre.service
sudo systemctl disable hive-ttyd.service 
sudo systemctl disable hive-watchdog.service
sudo systemctl disable hive.service hivex.service



sudo systemctl disable hive-console.service && sudo systemctl disable hive-netpre.service  && sudo systemctl disable hive-ttyd.service && sudo systemctl disable hive-watchdog.service  && sudo systemctl disable hive.service hivex.service


sudo systemctl stop hive-console.service  && sudo systemctl stop hive-netpre.service  && sudo systemctl stop hive-ttyd.service  && sudo systemctl stop hive-watchdog.service  &&  sudo systemctl stop hive.service hivex.service



sudo nano /etc/netplan/01-network-manager-all.yaml 
sudo netplan try


sudo netplan apply 

sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager
sudo netplan apply

sudo netplan try




