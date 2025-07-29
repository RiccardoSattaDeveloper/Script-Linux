#!/bin/bash

echo "📌 Script dimostrativo dei comandi Linux più comuni"

# 👤 Utente e sistema
whoami             # Mostra l'utente corrente
uname -ar          # Info complete sul sistema
pwd                # Percorso directory corrente

# 📂 File e directory
ls                 # Elenca file e cartelle
ls -l              # Elenco dettagliato
ls -a              # Includi file nascosti
touch file.txt     # Crea file vuoto
mkdir cartella     # Crea una cartella
cd cartella        # Entra nella cartella
touch file3.txt    # Crea un file nella cartella
cd ..              # Torna alla directory precedente
rmdir cartella     # Rimuove cartella (vuota)
rm -rf cartella    # Rimuove cartella e contenuto
mv cartella /tmp   # Sposta la cartella in /tmp
cp file.txt file2.txt   # Copia file
mv archivio.zip archivio2.zip  # Rinomina file
rm file2.txt       # Elimina un file

# ✏️ Scrittura, lettura e modifiche file
echo testo > file.txt       # Scrive testo (sovrascrive)
echo testo2 >> file.txt     # Aggiunge testo (append)
cat file.txt                # Visualizza contenuto
nano file.txt               # Modifica con editor nano
vim file.txt                # Modifica con editor vim
less robots.txt             # Visualizza con scorrimento
head robots.txt             # Prime 10 righe
head -n 5 robots.txt        # Prime 5 righe
tail -n 5 robots.txt        # Ultime 5 righe

# 🔍 Ricerca e link simbolici
ln -rs file.txt collegamento    # Link simbolico relativo
find / -name file.txt 2> /dev/null  # Cerca file (ignora errori)
which libreoffice               # Percorso eseguibile
man apt                         # Manuale del comando
history                         # Storico comandi

# 💾 Utilizzo risorse e spazio disco
free              # Stato memoria RAM
free -h           # Stato RAM in forma leggibile
du /opt           # Spazio usato da /opt
du -h /opt        # Spazio leggibile
du -hs /opt       # Totale compatto
ps -ef            # Tutti i processi
pstree            # Processi in forma ad albero
top               # Monitoraggio in tempo reale
kill 37140        # Termina processo con PID 37140

# 📦 Pacchetti e applicazioni
sudo apt update                          # Aggiorna elenco pacchetti
sudo apt search libreoffice             # Cerca pacchetto libreoffice
libreoffice                              # Avvia LibreOffice
libreoffice &                            # Avvia LibreOffice in background
/usr/bin/libreoffice                     # Avvia LibreOffice via percorso
zip archivio.zip file.txt                # Crea archivio ZIP
unzip archivio2.zip                      # Estrae archivio ZIP
tar cvf archivio3.tar file.txt           # Crea archivio TAR
tar xvf archivio3.tar                    # Estrae archivio TAR

# 🌐 Rete e connessioni
ifconfig                  # Info rete (deprecato)
ip address                # Interfacce e IP
ip a                      # Alias di sopra
ip a | grep parola        # Cerca stringa nell'output IP
netstat                   # Mostra connessioni di rete
watch -n 1 netstat -antp  # Aggiorna ogni secondo

# 🔐 Privilegi di amministrazione
sudo ls -l /root       # Elenca contenuto della home di root
sudo adduser test      # Aggiunge utente "test"
su                     # Passa a root o altro utente
passwd                 # Cambia password dell’utente
chmod +x file.sh       # Rende il file eseguibile

# 🌍 Download da Internet
wget https://en.wikipedia.org/robots.txt   # Scarica file da URL

# 🔒 Sicurezza: Sovrascrittura dello spazio libero
sudo sfill -v /home && echo "🔒 Sfill eseguito su /home"	# Sovrascrive lo spazio libero in /home in modo sicuro
