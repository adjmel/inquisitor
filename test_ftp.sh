#!/bin/bash

# Configurations
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

# # Test 2:
# echo "Test 2: List of files on the FTP server"
# ftp -inv $FTP_SERVER <<EOF
# user $FTP_USER $FTP_PASS
# ls
# quit
# EOF

# if [ $? -eq 0 ]; then
#     echo "List of files on the FTP server"
# else
#     echo "Failed: Unable to list files"
#     exit 1
# fi


# # Test 3: 
# echo "Test 3: File download $TEST_FILE"
# ftp -inv $FTP_SERVER <<EOF
# user $FTP_USER $FTP_PASS
# get $TEST_FILE
# quit
# EOF

# if [ $? -eq 0 ]; then
#     echo "Success: File downloaded"
# else
#     echo "Failed: Unable to download file"
#     exit 1
# fi

# # Test 4: Uploading a file to the FTP server
# UPLOAD_FILE="upload_test.txt"
# echo "Test content" > $UPLOAD_FILE

# echo "Test 4: File upload $UPLOAD_FILE"
# ftp -inv $FTP_SERVER <<EOF
# user $FTP_USER $FTP_PASS
# put $UPLOAD_FILE
# quit
# EOF

# if [ $? -eq 0 ]; then
#     echo "Success: File uploaded"
# else
#     echo "Failed: Unable to upload file"
#     exit 1
# fi

# # Launching FTP Commands
# echo "Test: Full Duplex - Simultaneous Download and Upload"

# ftp -inv $FTP_SERVER <<EOF &
# user $FTP_USER $FTP_PASS
# get $DOWNLOAD_FILE
# quit
# EOF

# ftp -inv $FTP_SERVER <<EOF &
# user $FTP_USER $FTP_PASS
# put $UPLOAD_FILE
# quit
# EOF

# wait

# if [ $? -eq 0 ]; then
#     echo "Success: Download and Upload completed (Full Duplex)"
# else
#     echo "Failure: One of the operations failed."
#     exit 1
# fi
