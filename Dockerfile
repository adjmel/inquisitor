FROM python:3

# Met à jour les dépôts et installe les dépendances nécessaires
RUN apt-get -y update \
    && apt-get -y install vsftpd inetutils-ftp \
    && apt-get -y install libpcap0.8 \
    && pip install scapy

# Définit le répertoire de travail
WORKDIR /usr/src/app

# Copie les fichiers nécessaires dans l'image
COPY . .

# Commande par défaut pour garder le conteneur actif
# CMD ["tail", "-f", "/dev/null"]
CMD service vsftpd start && tail -f /dev/null
