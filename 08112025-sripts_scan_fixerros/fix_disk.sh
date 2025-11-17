#!/bin/bash
# Script: fix_disk.sh
# Função: Verifica e corrige erros no disco, isolando blocos defeituosos no boot

# Configurações
LOG_FILE="/var/log/fix_disk.log"
DISK="/dev/sda1"   # ajuste para sua partição principal

echo "[$(date)] Iniciando verificação automática de disco..." | tee -a "$LOG_FILE"

# Verifica se o disco existe
if [ ! -b "$DISK" ]; then
  echo "[$(date)] ERRO: Disco $DISK não encontrado." | tee -a "$LOG_FILE"
  exit 1
fi

# Etapa 1: Forçar sincronização
sync
echo "[$(date)] Sincronização de cache concluída." | tee -a "$LOG_FILE"

# Etapa 2: Executar fsck automaticamente
echo "[$(date)] Executando fsck em $DISK..." | tee -a "$LOG_FILE"
fsck -y "$DISK" >> "$LOG_FILE" 2>&1
echo "[$(date)] fsck finalizado." | tee -a "$LOG_FILE"

# Etapa 3: Procurar blocos defeituosos
echo "[$(date)] Verificando blocos defeituosos..." | tee -a "$LOG_FILE"
badblocks -sv "$DISK" >> "$LOG_FILE" 2>&1
echo "[$(date)] Verificação de blocos concluída." | tee -a "$LOG_FILE"

echo "[$(date)] Processo de verificação e reparo finalizado." | tee -a "$LOG_FILE"
exit 0
