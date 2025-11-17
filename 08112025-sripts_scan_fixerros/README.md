# fping
sudo nano scan_netbios.sh
sudo chmod +x scan_netbios.sh
./scan_netbios.sh



# corrigir erros
# Criar o script de correcao
sudo nano /usr/local/bin/fix_disk.sh
sudo chmod +x /usr/local/bin/fix_disk.sh

# Criar o serviço systemd para rodar no boot
sudo nano /etc/systemd/system/fix-disk.service
sudo chmod +x /etc/systemd/system/fix-disk.service


# inicializar servico

sudo systemctl daemon-reload
sudo systemctl enable fix-disk.service

sudo systemctl start fix-disk.service
sudo systemctl status fix-disk.service

cat /var/log/fix_disk.log


# ubuntu modo texto
sudo systemctl disable gdm
sudo systemctl stop gdm
sudo systemctl set-default multi-user.target
voltar
sudo systemctl set-default graphical.target

