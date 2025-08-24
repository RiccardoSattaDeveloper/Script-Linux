#!/bin/bash
set -euo pipefail

echo "📅 Avvio pulizia: $(date)"

# Definisce USER_HOME in modo più robusto
if [ -n "${SUDO_USER:-}" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

# Lista di file da rimuovere se esistono
files_to_remove=(
  "/var/log/wtmp"
  "/var/log/btmp"
)

# Directory da svuotare
dirs_to_clear=(
  "/var/log/apache2"
  "/var/log/mysql"
  "/var/log/nginx"
  "/var/log/apt"
  "/var/log/journal"
)

# 1. Rimozione file specifici
for file in "${files_to_remove[@]}"; do
  if [ -f "$file" ]; then
    sudo rm -f "$file"
  fi
done

# 2. Tronco dinamicamente file .log grandi (>10MB) in /var/log
found_logs=$(sudo find /var/log -type f -name "*.log" -size +10M)
if [ -n "$found_logs" ]; then
  while IFS= read -r logfile; do
    sudo truncate -s 0 "$logfile"
  done <<< "$found_logs"
fi

# 3. Pulizia delle directory di log
for dir in "${dirs_to_clear[@]}"; do
  if [ -d "$dir" ]; then
    sudo rm -rf "$dir"/*
  fi
done

# 4. Pulizia dmesg (buffer del kernel)
sudo dmesg --clear

# 5. Rotazione e pulizia journalctl
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
sudo systemctl restart systemd-journald

# 6. Ricarica daemon systemd
sudo systemctl daemon-reload 

# 7. Pulizia Snap disabilitati
sudo snap list --all | awk '/disabled/{print $1, $3}' |
  while read -r snapname revision; do
    sudo snap remove "$snapname" --revision="$revision"
  done

# 8. Pulizia pacchetti inutilizzati
sudo apt autoremove -y 
sudo apt clean
sudo apt autoclean 

# 9. Rimozione di log compressi vecchi
sudo find /var/log -type f -name "*.gz" -delete

# 10. Gestione file di log troppo grandi (es. sopra 100MB) diversi da .log
sudo find /var/log -type f ! -name "*.log" -size +100M -exec truncate -s 0 {} \;

# 11. Cancellare i file temporanei di sistema e la cache utente
sudo rm -rf /tmp/*

# 12. Pulizia cache utente
if [ -d "$USER_HOME/.cache" ]; then
  sudo rm -rf "$USER_HOME/.cache/"*
fi

# 13. Trim SSD
sudo fstrim -av

# 14. Cancella cronologie bash e zsh utente
for histfile in ".bash_history" ".zsh_history"; do
  target="$USER_HOME/$histfile"
  if [ -f "$target" ]; then
    sudo rm -f "$target"
  fi
done

echo "✅ Pulizia completata: $(date)"
