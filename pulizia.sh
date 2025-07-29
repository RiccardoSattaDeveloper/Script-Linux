#!/bin/bash

echo "📅 Avvio pulizia: $(date)"

# Lista di file da rimuovere se esistono
files_to_remove=(
  "/var/log/syslog"
  "/var/log/kern.log"
  "/var/log/auth.log"
  "/var/log/dpkg.log"
)

# Lista di file da troncare
files_to_truncate=(
  "/var/log/faillog"
  "/var/log/lastlog"
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

# 1. Rimozione file
for file in "${files_to_remove[@]}"; do
  if [ -f "$file" ]; then
    sudo rm -f "$file" && echo "🗑️ Rimosso: $file"
  fi
done

# 2. Tronca i file di log senza eliminarli
for file in "${files_to_truncate[@]}"; do
  if [ -f "$file" ]; then
    sudo truncate -s 0 "$file" && echo "✂️  Troncato: $file"
  fi
done

# 3. Pulizia delle directory di log
for dir in "${dirs_to_clear[@]}"; do
  if [ -d "$dir" ]; then
    sudo rm -rf "$dir"/* && echo "🧹 Pulita directory: $dir"
  fi
done

# 4. Pulizia dmesg (buffer del kernel)
sudo dmesg --clear && echo "🧽 Pulito dmesg"

# 5. Rotazione e pulizia journalctl
sudo journalctl --rotate && echo "🔄 Ruotato journal"
sudo journalctl --vacuum-time=1s && echo "🧺 Pulito journal (vacuum)"
sudo systemctl restart systemd-journald && echo "🔁 Riavviato systemd-journald"

# 6. Ricarica daemon
sudo systemctl daemon-reload && echo "♻️  Ricaricato systemd"

# 7. Pulizia pacchetti inutilizzati
sudo apt autoremove -y && echo "📦 Autoremove completato"
sudo apt clean && echo "🧽 Pulizia cache apt completata"
sudo apt autoclean && echo "🧼 Autoclean apt completato"

# 8. Trim SSD
sudo fstrim -av && echo "💾 Fstrim completato"

echo "✅ Pulizia completata: $(date)"
