#!/bin/bash

# Configurations
# FTP_SERVER="172.18.0.4"       # Adresse IP du serveur FTP
FTP_SERVER=${FTP_SERVER}
FTP_USER="ftpuser"            
FTP_PASS="ftppass"            
TEST_FILE="test_file.txt"    

echo "FTP tests..."

# Test 1:
echo "Test 1: Connecting to the FTP server"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
quit
EOF

if [ $? -eq 0 ]; then
    echo "Success: FTP connection OK"
else
    echo "Failure: Unable to connect to FTP"
    exit 1
fi

# Test 2:
echo "Test 2: List of files on the FTP server"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
ls
quit
EOF

if [ $? -eq 0 ]; then
    echo "List of files on the FTP server"
else
    echo "Failed: Unable to list files"
    exit 1
fi


# Test 3: 
echo "Test 3: File download $TEST_FILE"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
get $TEST_FILE
quit
EOF

if [ $? -eq 0 ]; then
    echo "Success: File downloaded"
else
    echo "Failed: Unable to download file"
    exit 1
fi

# Test 4: Uploading a file to the FTP server
UPLOAD_FILE="upload_test.txt"
echo "Test content" > $UPLOAD_FILE

echo "Test 4: File upload $UPLOAD_FILE"
ftp -inv $FTP_SERVER <<EOF
user $FTP_USER $FTP_PASS
put $UPLOAD_FILE
quit
EOF

if [ $? -eq 0 ]; then
    echo "Success: File uploaded"
else
    echo "Failed: Unable to upload file"
    exit 1
fi

# Launching FTP Commands
echo "Test: Full Duplex - Simultaneous Download and Upload"

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

wait

if [ $? -eq 0 ]; then
    echo "Success: Download and Upload completed (Full Duplex)"
else
    echo "Failure: One of the operations failed."
    exit 1
fi

#Expected result ↓
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