#!/bin/bash

echo "📅 Avvio pulizia: $(date)"

# Definisce USER_HOME in modo più robusto
if [ -n "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

# Lista di file da rimuovere se esistono
files_to_remove=(
  "/var/log/wtmp"
  "/var/log/btmp"
)

# Lista di file da troncare senza eliminarli
files_to_truncate=(
  "/var/log/syslog"
  "/var/log/auth.log"
  "/var/log/kern.log"
  # aggiungi altri file di log specifici da troncare se vuoi
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
    echo "Rimuovo $file"
    sudo rm -f "$file"
  fi
done

# 2. Tronca i file di log senza eliminarli
for file in "${files_to_truncate[@]}"; do
  if [ -f "$file" ]; then
    echo "Tronco $file"
    sudo truncate -s 0 "$file"
  fi
done

# 3. Pulizia delle directory di log
for dir in "${dirs_to_clear[@]}"; do
  if [ -d "$dir" ]; then
    echo "Pulisco la directory $dir"
    sudo rm -rf "$dir"/*
  fi
done

# 4. Pulizia dmesg (buffer del kernel)
echo "Pulisco buffer kernel (dmesg)"
sudo dmesg --clear

# 5. Rotazione e pulizia journalctl
echo "Rotazione e vacuum journalctl"
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
sudo systemctl restart systemd-journald

# 6. Ricarica daemon systemd
echo "Ricarico daemon systemd"
sudo systemctl daemon-reload 

# 7. Pulizia Snap
echo "Pulizia Snap disabilitati"
sudo snap list --all | awk '/disabled/{print $1, $3}' |
  while read -r snapname revision; do
    echo "Rimuovo snap $snapname, revision $revision"
    sudo snap remove "$snapname" --revision="$revision"
  done

# 8. Pulizia pacchetti inutilizzati
echo "Pulizia pacchetti inutilizzati"
sudo apt autoremove -y 
sudo apt clean
sudo apt autoclean 

# 9. Rimozione di log compressi vecchi
echo "Rimozione di file .gz in /var/log"
sudo find /var/log -type f -name "*.gz" -delete

# 10. Gestione file di log troppo grandi (es. sopra 100MB)
echo "Tronco file di log > 100MB"
sudo find /var/log -type f -size +100M -exec truncate -s 0 {} \; -print

# 11. Cancellare i file temporanei di sistema e la cache utente
echo "Pulizia /tmp"
sudo rm -rf /tmp/*

# 12. Pulizia cache utente
echo "Pulizia cache utente in $USER_HOME/.cache"
sudo rm -rf "$USER_HOME/.cache/"*

# 13. Cancella la cronologia bash utente
echo "Cancellazione cronologia bash in $USER_HOME/.bash_history"
sudo rm -f "$USER_HOME/.bash_history"

# 14. Trim SSD
echo "Esecuzione fstrim su tutte le partizioni"
sudo fstrim -av

echo "✅ Pulizia completata: $(date)"
