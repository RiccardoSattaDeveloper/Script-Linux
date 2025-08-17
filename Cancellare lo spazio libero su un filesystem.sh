# 1) Sicurezza massima (HDD)
# Sovrascrive più volte lo spazio libero.
# Lento ma molto sicuro. Consigliato solo su dischi meccanici.
sudo sfill -v -z /

# 2) Sicurezza standard (HDD)
# Usa meno passaggi (-l), quindi è più veloce.
# Sicurezza discreta, adatta per HDD se non servono livelli militari.
sudo sfill -v -l -z /

# 3) Pulizia veloce (HDD/SSD)
# Minima sicurezza, scrive solo una volta.
# Utile se vuoi solo "ripulire" velocemente senza troppe garanzie.
sudo sfill -v -l /

# 4) Modalità consigliata per SSD
# Sovrascrive con un solo passaggio + azzera alla fine.
# Evita usura inutile dell’SSD, ma garantisce discreta pulizia.
sudo sfill -v -l -z /

