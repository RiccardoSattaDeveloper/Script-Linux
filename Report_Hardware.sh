#!/bin/bash

OUTPUT="report_hardware.txt"
> "$OUTPUT"

echo "Report generato il: $(date)" >> "$OUTPUT"

echo "=== INFORMAZIONI CPU ===" >> "$OUTPUT"
lscpu >> "$OUTPUT"

echo -e "\n=== INFORMAZIONI RAM (free -h) ===" >> "$OUTPUT"
free -h >> "$OUTPUT"

echo -e "\n=== INFORMAZIONI RAM DETTAGLIATE (dmidecode) ===" >> "$OUTPUT"
sudo dmidecode -t memory >> "$OUTPUT"

echo -e "\n=== INFORMAZIONI DISCHI (lsblk) ===" >> "$OUTPUT"
lsblk >> "$OUTPUT"

echo -e "\n=== INFORMAZIONI DISCHI DETTAGLIATE (fdisk) ===" >> "$OUTPUT"
sudo fdisk -l >> "$OUTPUT"

echo -e "\n=== GPU (scheda video) ===" >> "$OUTPUT"
lspci | grep -i vga >> "$OUTPUT"

echo -e "\n=== GPU Dettagliata ===" >> "$OUTPUT"
sudo lshw -C display >> "$OUTPUT"

echo -e "\n=== SCHEDA DI RETE DETTAGLIATA ===" >> "$OUTPUT"
sudo lshw -C network >> "$OUTPUT"

echo -e "\n=== INFORMAZIONI INTERFACCIA DI RETE ATTIVA (ip addr) ===" >> "$OUTPUT"
ip addr show >> "$OUTPUT"

echo -e "\n=== SERVIZI ATTIVI (systemctl) ===" >> "$OUTPUT"
systemctl list-units --type=service --state=running >> "$OUTPUT"

echo -e "\n=== STATO SMART DEI DISCHI ===" >> "$OUTPUT"
for disk in /dev/sd?; do
    echo "---- $disk ----" >> "$OUTPUT"
    sudo smartctl --all "$disk" >> "$OUTPUT" 2>/dev/null
done

echo -e "\n=== SENSORI HARDWARE (temperatura, voltaggi) ===" >> "$OUTPUT"
sensors >> "$OUTPUT"

echo -e "\n=== DISPOSITIVI USB ===" >> "$OUTPUT"
lsusb >> "$OUTPUT"

echo -e "\n=== UTENTI LOGGATI ===" >> "$OUTPUT"
who >> "$OUTPUT"

echo -e "\n=== HARDWARE COMPLETO ===" >> "$OUTPUT"
sudo lshw >> "$OUTPUT"

echo -e "\n=== BIOS / UEFI ===" >> "$OUTPUT"
sudo dmidecode -t bios >> "$OUTPUT"

echo -e "\n✅ Report completato in: $OUTPUT"
