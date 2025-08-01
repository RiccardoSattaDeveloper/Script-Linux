#!/bin/bash

# 🧹 Script avanzato per la pulizia dei log e file temporanei. Creato per migliorare la manutenzione del sistema

# 🔐 Verifica dei permessi di root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Questo script deve essere eseguito come root (usa sudo)."
  exit 1
fi

# 🎨 Colori ANSI per output leggibile
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Nessun colore

echo -e "${YELLOW}📅 Avvio pulizia: $(date)${NC}"

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
    rm -f "$file" && echo -e "${GREEN}🗑️ Rimosso: $file${NC}"
  fi
}

truncate_file() {
  local file="$1"
  if [ -f "$file" ]; then
    truncate -s 0 "$file" && echo -e "${GREEN}✂️  Troncato: $file${NC}"
  fi
}

clear_directory() {
  local dir="$1"
  if [ -d "$dir" ]; then
    rm -rf "$dir"/* && echo -e "${GREEN}🧹 Pulita directory: $dir${NC}"
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
dmesg --clear && echo -e "${GREEN}🧽 Pulito buffer kernel (dmesg)${NC}"

# 📓 Pulizia e rotazione dei log di sistema
journalctl --rotate && echo -e "${GREEN}🔄 Ruotato journal${NC}"
journalctl --vacuum-time=1s && echo -e "${GREEN}🧺 Pulito journalctl (1s)${NC}"
systemctl restart systemd-journald && echo -e "${GREEN}🔁 Riavviato journald${NC}"

# ♻️ Reload daemon di sistema
systemctl daemon-reexec && echo -e "${GREEN}♻️  Ricaricato systemd${NC}"

# 🧹 Pulizia pacchetti APT
apt autoremove -y && echo -e "${GREEN}📦 Autoremove completato${NC}"
apt clean && echo -e "${GREEN}🧽 Pulizia cache apt completata${NC}"
apt autoclean && echo -e "${GREEN}🧼 Autoclean apt completato${NC}"

# 💾 SSD TRIM (per dispositivi compatibili)
fstrim -av && echo -e "${GREEN}💾 Fstrim completato${NC}"

# 🧑‍💻 Pulizia cronologia della shell
shred -u ~/.bash_history 2>/dev/null
history -c
history -w
echo -e "${GREEN}🗑️ Cronologia bash eliminata${NC}"

# 📆 Fine script
echo -e "${YELLOW}✅ Pulizia completata: $(date)${NC}"
