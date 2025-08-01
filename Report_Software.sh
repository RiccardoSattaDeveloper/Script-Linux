#!/bin/bash

OUTFILE="report_software.txt"
echo "Generazione report software in $OUTFILE..."
echo "Raccolta informazioni: $(date)" > "$OUTFILE"
echo "----------------------------------------" >> "$OUTFILE"

# Informazioni sul sistema operativo
{
  echo -e "\n=== Sistema Operativo ==="
  lsb_release -a 2>/dev/null
  cat /etc/os-release
  hostnamectl
} >> "$OUTFILE"

# Kernel
{
  echo -e "\n=== Kernel ==="
  uname -a
  cat /proc/version
} >> "$OUTFILE"

# Pacchetti installati
{
  echo -e "\n=== Pacchetti APT Installati ==="
  apt list --installed 2>/dev/null | head -n 100

  echo -e "\n=== Pacchetti Snap Installati ==="
  snap list 2>/dev/null

  echo -e "\n=== Pacchetti Flatpak Installati ==="
  flatpak list 2>/dev/null
} >> "$OUTFILE"

# Filesystem
{
  echo -e "\n=== File System e Mount ==="
  mount | grep "^/dev"
  df -h
  lsblk
} >> "$OUTFILE"

# Utenti
{
  echo -e "\n=== Utenti ==="
  whoami
  id
  getent passwd | cut -d: -f1,3,7
} >> "$OUTFILE"

# Servizi e processi
{
  echo -e "\n=== Servizi Attivi ==="
  systemctl list-units --type=service --state=running

  echo -e "\n=== Processi Attivi ==="
  ps aux --sort=-%mem | head -n 20
} >> "$OUTFILE"

# Sicurezza
{
  echo -e "\n=== Sicurezza ==="
  ufw status 2>/dev/null
  sudo apparmor_status 2>/dev/null
} >> "$OUTFILE"

# Rete
{
  echo -e "\n=== Rete ==="
  ip a
  nmcli 2>/dev/null
  systemd-resolve --status
} >> "$OUTFILE"

# Moduli e parametri
{
  echo -e "\n=== Moduli del Kernel ==="
  lsmod | head -n 20

  echo -e "\n=== Parametri sysctl ==="
  sysctl -a | grep -E 'net|vm|fs|kernel' | head -n 50
} >> "$OUTFILE"

# Log di sistema
{
  echo -e "\n=== Log di Sistema ==="
  journalctl -n 50 --no-pager
  dmesg | tail -n 30
} >> "$OUTFILE"

# Versioni software
{
  echo -e "\n=== Versioni Software ==="
  command -v python3 && python3 --version
  command -v gcc && gcc --version | head -n 1
  command -v node && node --version
  command -v java && java -version 2>&1 | head -n 1
} >> "$OUTFILE"

echo "✅ Report completato. Controlla il file: $OUTFILE"
