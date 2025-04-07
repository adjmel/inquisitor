# Inquisitor Project

## Overview

The **Inquisitor** project is a network security tool designed to perform **ARP poisoning** attacks and capture FTP file transfer data in real-time. The program is developed for **Linux** platforms and utilizes **raw sockets** to manipulate ARP tables and sniff network traffic. The entire environment is containerized using **Docker**, enabling easy deployment and testing.

### Key Features:
- **ARP Poisoning** in both directions (full-duplex).
- Automatic restoration of ARP tables upon termination of the attack (via CTRL+C).
- Real-time monitoring and display of file names exchanged between an FTP client and server.
- Uses **libpcap** to capture and inspect packets.
- Fully containerized environment for easy setup using **Docker** and **docker-compose**.

## Prerequisites

Before starting, ensure the following tools are installed on your machine:
- **Docker** and **docker-compose** (for container management).
- A **Linux-based system** to run the containers.

## Project Structure

```
inquisitor/
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Defines multi-container services (FTP server, client, inquisitor)
├── Makefile                # Automation script for environment setup and build
├── inquisitor              # Main program for ARP poisoning and packet sniffing
├── test_ftp.sh             # Bash script to test the program
└── README.md               # Project documentation

```

- `Dockerfile`: Builds the base image required for the inquisitor program and dependencies.
- `docker-compose.yml`: Defines the network and services (FTP server, client, inquisitor).
- `Makefile`: Automates environment setup, clean-up, and program build.
- `inquisitor`: The core program that performs ARP poisoning and monitors FTP traffic.
- `README.md`: Documentation on project setup and usage.

## Setup Instructions

### 1. Environment Setup

Follow the steps below to configure the environment:

#### Clean Up Docker (Optional)
To ensure no conflicting containers or images are present, you can clean up Docker resources:
```bash
docker stop $(docker ps -aq)                 
docker container prune -f
docker-compose down --volumes
docker system prune -af
# Or use Makefile to clean:
make clean
```

#### Pull Docker Image and Build
Download the required Docker images and build the environment:
```bash
docker pull python:3
make
sudo make build
```

### 2. Start the FTP Server and Client Services

1. **Start the necessary services** (FTP server and client) by running:
```bash
make info
make program
```

2. **Access the inquisitor container**:
   - Find the container ID or name using:
   ```bash
   docker image
   ```
   - Then, access the inquisitor container via:
   ```bash
   docker exec -it inquisitor bash
   ```

3. **Verify the program’s presence**:
   ```bash
   docker ls
   ```

4. **Set up FTP service**:
   If the FTP server isn't already set up, you can manually install and start the FTP service:
   ```bash
   apt-get install vsftpd -y
   service vsftpd start
   apt-get install inetutils-ftp
   ```

5. **Create an FTP file**:
   Create a test file to be transferred via FTP:
   ```bash
   touch /srv/ftp/fichier1.txt
   echo "Ceci est un fichier de test FTP" | tee /srv/ftp/fichier1.txt
   echo "Contenu de fichier1" > fichier1.txt
   ```

6. **Test FTP operations**:
   Start an FTP client session:
   ```bash
   ftp <IP-serveur>  # Replace with the actual IP from the 'make info' output
   ```
   - Log in with the provided credentials (`ftpuser` / `ftppass`).
   - Upload and download the file:
   ```bash
   put fichier1.txt
   get fichier1.txt
   ```

   Alternatively, you can run the predefined tests:
   ```bash
   make tests
   ```

### 3. Run the Inquisitor Program

To start **ARP poisoning** and capture FTP traffic, run the inquisitor program in a separate terminal window:

```bash
./inquisitor.py <IP-src> <MAC-src> <IP-target> <MAC-target>
```

Where:
- **`<IP-src>`**: The source IP address (your client or machine initiating the attack).
- **`<MAC-src>`**: The MAC address of the source.
- **`<IP-target>`**: The target IP address (the FTP server or any other target machine in your network).
- **`<MAC-target>`**: The MAC address of the target.

For example, if your network is configured with the following addresses:
- **Source (client)**: `<Source-IP>` with MAC `<Source-MAC>`
- **Target (FTP server)**: `<Target-IP>` with MAC `<Target-MAC>`

You can run the program with the following command:

```bash
./inquisitor.py <Source-IP> <Source-MAC> <Target-IP> <Target-MAC>
```

### 4. Monitor FTP Traffic

Once the inquisitor program is running, it will sniff the FTP traffic and display the names of files exchanged between the FTP client and server in real-time.

### 5. Stop the Attack

To stop the attack and restore the ARP tables, press **Ctrl + C**. The ARP poisoning will stop, and the ARP tables will be automatically restored.

## Final Explanation

### The Inquisitor Network

The **Inquisitor network** is a private Docker network connecting all relevant services (server, client, and inquisitor). This network setup ensures that the services can communicate securely without exposure to the outside world. For instance, the inquisitor container can sniff FTP traffic between the server and client without any external interference.

### Benefits of a Private Docker Network

- **Security**: All services are isolated within the Docker network, ensuring that only authorized containers can communicate with each other.
- **Testing**: The environment is fully isolated from the external network, ensuring a controlled environment for testing ARP poisoning and FTP monitoring.
- **Scalability**: New containers or services can be added easily, maintaining isolation while enabling easy expansion of the environment.

