# DOCKER TASKS #
# Build and run all containers
build :
	#docker-compose up --build
	docker compose up --build

# Clean up containers and remove unused Docker resources
clean:
	#docker-compose down
	docker compose down
	docker system prune -f -a || true



# UTILS & TESTS #
# Display information about containers
info:
	@for container in server client inquisitor; do \
	  echo "$$container Info:"; \
	  echo " - IPAddress: $$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $$container)"; \
	  echo " - MacAddress: $$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $$container)"; \
	done

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
	FTP_SERVER=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' server) && \
	docker exec -e FTP_SERVER=$$FTP_SERVER -it inquisitor ./test_ftp.sh
