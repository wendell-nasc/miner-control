https://github.com/vrscms/hellminer

git clone https://github.com/vrscms/hellminer.git && chmod -R 777 hellminer && cd hellminer && ./install.sh

Config
Edit mine.sh with nano and add your wallet's address and your worker ID.

nano mine.sh

Launch Miner
screen -d -m bash -c "cd hellminer ; ./mine.sh"