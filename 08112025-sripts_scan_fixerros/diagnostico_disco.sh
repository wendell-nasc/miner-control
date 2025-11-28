#!/bin/bash

echo "==============================================="
echo "   🔍 DIAGNÓSTICO COMPLETO DO SISTEMA E DISCO  "
echo "==============================================="

echo -e "\n📌 Verificando erros recentes do kernel (I/O, EXT4, falhas de disco)..."
dmesg | grep -Ei "error|fail|I/O|io error|ext4|blk"

echo -e "\n📌 Verificando pacotes quebrados..."
sudo apt --fix-broken install -y

echo -e "\n📌 Atualizando listas de pacotes..."
sudo apt update

echo -e "\n📌 Tentando reparar dependências..."
sudo apt upgrade -y

echo -e "\n📌 Reinstalando bibliotecas críticas..."
sudo apt install --reinstall -y libgnutls30 libcurl4 libjansson4

echo -e "\n==============================================="
echo "   🔍 INFORMANDO SOBRE O DISCO (SMARTCTL)       "
echo "==============================================="

# Detecta automaticamente o disco principal
DISK=$(lsblk -ndo NAME,TYPE | grep disk | head -n 1 | awk '{print $1}')
DISK="/dev/$DISK"

echo "Disco detectado: $DISK"

echo -e "\n📌 Coletando status SMART..."
sudo smartctl -a $DISK

echo -e "\n==============================================="
echo "   🔍 TESTE DE BAD BLOCKS (somente leitura)     "
echo "==============================================="
echo "Este teste é seguro. Pode levar alguns minutos a horas."
echo

sudo badblocks -sv $DISK

echo -e "\n==============================================="
echo "   ✔ DIAGNÓSTICO COMPLETO FINALIZADO           "
echo "==============================================="
echo "Se apareceram I/O errors, bad blocks ou falha SMART:"
echo "➡ Substitua o disco imediatamente."
