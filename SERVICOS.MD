
sudo nano /etc/systemd/system/xdag_gustavo.service

[Unit]
Description=Start XMRig and Deroluna Miners
After=network.target

[Service]
ExecStart=/etc/systemd/system/start-xdag_gustavo.sh
Restart=always
#User=wendell  # Descomente e ajuste conforme necessário
StandardOutput=journal
StandardError=journal
SyslogIdentifier=miners
Nice=10
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
