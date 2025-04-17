build :
	#docker-compose up --build
	docker compose up --build

clean:
	#docker-compose down
	docker compose down
	docker system prune -f -a || true


# How run the program with container IPs and MACs
program:
	@echo "Execute in Inquisitor bash (docker exec -it inquisitor bash) ./inquisitor" \
		$$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' server) \
		$$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' server) \
		$$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' client) \
		$$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' client)

# Run FTP tests
tests:
	@echo "Running FTP tests..."
	@FTP_SERVER=$$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' server) && \
	docker exec -e FTP_SERVER=$$FTP_SERVER -it inquisitor ./test_ftp.sh
