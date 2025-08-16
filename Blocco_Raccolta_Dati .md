# Accedere a: 'sudo nano /etc/hosts'

127.0.0.1       localhost
127.0.1.1       # Inserire il nome del proprio PC

# IPv6 settings
::1             ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

# --- Blocchi Google Analytics e tracciamento ---
127.0.0.1       www.google-analytics.com
127.0.0.1       analytics.google.com
127.0.0.1       ssl.google-analytics.com
127.0.0.1       pagead2.googlesyndication.com
127.0.0.1       ad.doubleclick.net
127.0.0.1       www.googletagservices.com
127.0.0.1       www.googletagmanager.com

# --- Blocchi Facebook tracking ---
127.0.0.1       connect.facebook.net
127.0.0.1       graph.facebook.com
127.0.0.1       pixel.facebook.com

# --- Blocchi altri traccianti comuni ---
127.0.0.1       cdn.optimizely.com
127.0.0.1       stats.g.doubleclick.net
127.0.0.1       tags.tiqcdn.com
127.0.0.1       js-agent.newrelic.com
127.0.0.1       bam.nr-data.net
