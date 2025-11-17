#!/usr/bin/env bash
set -euo pipefail

# Uso: sudo ./scan_netbios.sh [REDE]
# Ex.: sudo ./scan_netbios.sh 192.168.1.0/24
# Se nenhum argumento for passado, usa 192.168.1.0/24 por padrão.

NET="${1:-192.168.1.0/24}"
OUTFILE="hosts_netbios.csv"

# Função para instalar via apt se o comando não existir
ensure_installed() {
  local cmd="$1"
  local pkg="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "-> '$cmd' não encontrado. Instalando pacote '$pkg'..."
    sudo apt-get update -qq
    sudo apt-get install -y "$pkg"
  else
    echo "-> '$cmd' já instalado."
  fi
}

# Verifica/instala fping
ensure_installed fping fping

# Verifica/instala nmblookup (vem no pacote samba-common-bin)
# nmblookup é usado para consulta NetBIOS
ensure_installed nmblookup samba-common-bin

echo "Iniciando scan na rede: $NET"
echo "Saída será gravada em: $OUTFILE"
echo "ip,hostname" > "$OUTFILE"

# Executa fping para listar IPs ativos e para cada IP tenta nmblookup
# Usamos -a -g para obter apenas IPs vivos na faixa
fping -a -g "$NET" 2>/dev/null | while read -r ip; do
  # Tenta obter nome NetBIOS (<00> entrada)
  name=$(nmblookup -A "$ip" 2>/dev/null | awk -F'<' '/<00>/{print $1; exit}' | sed 's/ //g' || true)
  # Remove possible trailing dots and whitespace
  name=$(echo "$name" | sed 's/\.$//' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
  echo "$ip,${name:-}" >> "$OUTFILE"
done

echo "Scan finalizado. Resultado salvo em: $OUTFILE"
