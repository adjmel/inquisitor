#!/bin/bash

set -e

# === Configurations ===
FTP_SERVER="server"
FTP_USER="ftpuser"
FTP_PASS="ftppass"
TEST_FILE="test_file.txt"
UPLOAD_FILE="upload_test.txt"
SERVER_DIR="./server"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

function success() {
  echo -e "${GREEN}Success:${NC} $1"
}

function failure() {
  echo -e "${RED}Failure:${NC} $1"
  exit 1
}

echo "Checking and adjusting permissions on $SERVER_DIR..."
chmod -R 777 $SERVER_DIR

echo "Running FTP tests..."

echo "Test 1: Connecting to the FTP server"
ftp -inv $FTP_SERVER <<EOF > ftp_test1.log 2>&1
user $FTP_USER $FTP_PASS
quit
EOF

if grep -q "230" ftp_test1.log; then
    success "FTP connection OK"
else
    failure "Unable to connect to FTP"
fi

echo "Test 2: List of files on the FTP server"
ftp -inv $FTP_SERVER <<EOF > ftp_test2.log 2>&1
user $FTP_USER $FTP_PASS
ls
quit
EOF

if grep -q "226" ftp_test2.log; then
    success "List of files retrieved"
else
    failure "Unable to list files"
fi

echo "Test 3: File download $TEST_FILE"
ftp -inv $FTP_SERVER <<EOF > ftp_test3.log 2>&1
user $FTP_USER $FTP_PASS
get $TEST_FILE
quit
EOF

if grep -q "550" ftp_test3.log; then
    failure "Unable to download file $TEST_FILE (not found)"
elif grep -q "226" ftp_test3.log; then
    success "File $TEST_FILE downloaded"
else
    failure "Unknown error during file download"
fi

echo "Test content for upload" > $UPLOAD_FILE

echo "Test 4: File upload $UPLOAD_FILE"
ftp -inv $FTP_SERVER <<EOF > ftp_test4.log 2>&1
user $FTP_USER $FTP_PASS
put $UPLOAD_FILE
quit
EOF

if grep -q "553" ftp_test4.log; then
    failure "Unable to upload file $UPLOAD_FILE (permission denied?)"
elif grep -q "226" ftp_test4.log; then
    success "File $UPLOAD_FILE uploaded"
else
    failure "Unknown error during file upload"
fi

echo "Test: Full Duplex - Simultaneous Download and Upload"

UPLOAD_FILE_2="upload_test2.txt"
echo "Another test content" > $UPLOAD_FILE_2

ftp -inv $FTP_SERVER <<EOF > ftp_duplex_download.log 2>&1 &
user $FTP_USER $FTP_PASS
get $TEST_FILE
quit
EOF

ftp -inv $FTP_SERVER <<EOF > ftp_duplex_upload.log 2>&1 &
user $FTP_USER $FTP_PASS
put $UPLOAD_FILE_2
quit
EOF

wait

if grep -q "550" ftp_duplex_download.log || grep -q "553" ftp_duplex_upload.log; then
    failure "Full Duplex test failed (either download or upload)"
else
    success "Full Duplex Download and Upload completed"
fi

echo "All FTP tests completed!"
