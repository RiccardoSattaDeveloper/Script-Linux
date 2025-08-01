#!/bin/bash

# 🧹 Script avanzato per la pulizia dei log e file temporanei

# 🔐 Verifica dei permessi di root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Questo script deve essere eseguito come root (usa sudo)."
  exit 1
fi

echo "📅 Avvio pulizia: $(date)"

# 📦 Liste di elementi da gestire
files_to_remove=(
  "/var/log/syslog"
  "/var/log/kern.log"
  "/var/log/auth.log"
  "/var/log/dpkg.log"
)

files_to_truncate=(
  "/var/log/faillog"
  "/var/log/lastlog"
  "/var/log/wtmp"
  "/var/log/btmp"
)

dirs_to_clear=(
  "/var/log/apache2"
  "/var/log/mysql"
  "/var/log/nginx"
  "/var/log/apt"
  "/var/log/journal"
)

# ⚙️ Funzioni modulari
cleanup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    rm -f "$file" && echo "🗑️ Rimosso: $file"
  fi
}

truncate_file() {
  local file="$1"
  if [ -f "$file" ]; then
    truncate -s 0 "$file" && echo "✂️  Troncato: $file"
  fi
}

clear_directory() {
  local dir="$1"
  if [ -d "$dir" ]; then
    rm -rf "$dir"/* && echo "🧹 Pulita directory: $dir"
  fi
}

# ✅ Pulizia file di log
for file in "${files_to_remove[@]}"; do
  cleanup_file "$file"
done

for file in "${files_to_truncate[@]}"; do
  truncate_file "$file"
done

for dir in "${dirs_to_clear[@]}"; do
  clear_directory "$dir"
done

# 🧽 Pulizia buffer kernel
dmesg --clear && echo "🧽 Pulito buffer kernel (dmesg)"

# 📓 Pulizia e rotazione dei log di sistema
journalctl --rotate && echo "🔄 Ruotato journal"
journalctl --vacuum-time=1s && echo "🧺 Pulito journalctl (1s)"
systemctl restart systemd-journald && echo "🔁 Riavviato journald"

# ♻️ Reload daemon di sistema
systemctl daemon-reexec && echo "♻️  Ricaricato systemd"

# 🧹 Pulizia pacchetti APT
apt autoremove -y && echo "📦 Autoremove completato"
apt clean && echo "🧽 Pulizia cache apt completata"
apt autoclean && echo "🧼 Autoclean apt completato"

# 💾 SSD TRIM (per dispositivi compatibili)
fstrim -av && echo "💾 Fstrim completato"

# 🧑‍💻 Pulizia cronologia della shell
shred -u ~/.bash_history 2>/dev/null
history -c
history -w
echo "🗑️ Cronologia bash eliminata"

# 📆 Fine script
echo "✅ Pulizia completata: $(date)"
