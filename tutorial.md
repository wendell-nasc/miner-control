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


# CONTROL

sudo touch /var/log/control_miner.log
sudo nano /opt/service-control.sh
sudo chmod +x /opt/service-control.sh
sudo EDITOR=nano crontab -e
*/2 * * * * /opt/service-control.sh
tail -f /var/log/control_miner.log


