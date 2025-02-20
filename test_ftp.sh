#!/bin/bash

# Configurations
# FTP_SERVER="172.18.0.4"       # Adresse IP du serveur FTP
FTP_SERVER=${FTP_SERVER}
FTP_USER="ftpuser"            # Nom d'utilisateur FTP
FTP_PASS="ftppass"            # Mot de passe FTP
TEST_FILE="test_file.txt"     # Nom du fichier pour les tests

echo "Début des tests FTP..."

# Test 1: Connexion au serveur FTP
echo "Test 1: Connexion au serveur FTP"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
quit
EOF

if [ $? -eq 0 ]; then
    echo "Succès : Connexion FTP OK"
else
    echo "Échec : Connexion FTP impossible"
    exit 1
fi

# Test 2: Liste des fichiers sur le serveur FTP
echo "Test 2: Liste des fichiers sur le serveur FTP"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
ls
quit
EOF

if [ $? -eq 0 ]; then
    echo "Succès : Liste des fichiers récupérée"
else
    echo "Échec : Impossible de lister les fichiers"
    exit 1
fi


# Test 3: Téléchargement de fichier depuis le serveur FTP
echo "Test 3: Téléchargement de fichier $TEST_FILE"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
get $TEST_FILE
quit
EOF

if [ $? -eq 0 ]; then
    echo "Succès : Fichier téléchargé"
else
    echo "Échec : Téléchargement du fichier impossible"
    exit 1
fi

# Test 4: Upload d'un fichier vers le serveur FTP
UPLOAD_FILE="upload_test.txt"
echo "Contenu de test" > $UPLOAD_FILE

echo "Test 4: Upload de fichier $UPLOAD_FILE"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
put $UPLOAD_FILE
quit
EOF

if [ $? -eq 0 ]; then
    echo "Succès : Fichier uploadé"
else
    echo "Échec : Upload du fichier impossible"
    exit 1
fi

# Lancement en parallèle des commandes FTP
echo "Test: Full Duplex - Téléchargement et Upload simultanés"

ftp -inv $FTP_SERVER <<EOF &
user $FTP_USER $FTP_PASS
get $DOWNLOAD_FILE
quit
EOF

ftp -inv $FTP_SERVER <<EOF &
user $FTP_USER $FTP_PASS
put $UPLOAD_FILE
quit
EOF

# Attendre la fin des processus
wait

# Vérification des résultats
if [ $? -eq 0 ]; then
    echo "Succès : Téléchargement et Upload terminés (Full Duplex)"
else
    echo "Échec : Une des opérations a échoué"
    exit 1
fi

# inquisitor git:(main) ✗ make test
# Lancement des tests FTP...
# Début des tests FTP...
# Test 1: Connexion au serveur FTP
# Connected to 172.26.0.4.
# 220 (vsFTPd 3.0.3)
# 331 Please specify the password.
# 230 Login successful.
# 221 Goodbye.
# Succès : Connexion FTP OK
# Test 2: Liste des fichiers sur le serveur FTP
# Connected to 172.26.0.4.
# 220 (vsFTPd 3.0.3)
# 331 Please specify the password.
# 230 Login successful.
# 200 PORT command successful. Consider using PASV.
# 150 Here comes the directory listing.
# -rw-r--r--    1 ftp      ftp             0 Dec 02 15:09 coucou.txt
# -rw-r--r--    1 ftp      ftp            20 Dec 02 14:44 fichier1.txt
# 226 Directory send OK.
# 221 Goodbye.
# Succès : Liste des fichiers récupérée
# Test 3: Téléchargement de fichier test_file.txt
# Connected to 172.26.0.4.
# 220 (vsFTPd 3.0.3)
# 331 Please specify the password.
# 230 Login successful.
# 200 PORT command successful. Consider using PASV.
# 550 Failed to open file.
# 221 Goodbye.
# Succès : Fichier téléchargé
# Tests FTP terminés avec succès.