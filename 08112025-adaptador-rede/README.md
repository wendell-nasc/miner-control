
sudo nano /etc/netplan/01-network-manager-all.yaml 
sudo netplan try

sudo netplan apply 

sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager
sudo netplan apply

sudo netplan try




