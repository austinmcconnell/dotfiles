.PHONY: docker-build docker-test docker-shell docker-clean

docker-build:
	docker build -t dotfiles-test .

# Build with custom CA cert (for Cloudflare WARP, corporate proxies, etc.)
# Extract your CA cert: echo | openssl s_client -connect ghcr.io:443 -showcerts 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' | tail -n +$(echo | openssl s_client -connect ghcr.io:443 -showcerts 2>/dev/null | grep -n "BEGIN CERTIFICATE" | tail -1 | cut -d: -f1)
docker-build-with-ca:
	@echo "Extracting CA certificate from current connection..."
	@CA_CERT=$$(echo | openssl s_client -connect ghcr.io:443 -showcerts 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' | tail -n 28); \
	docker build --build-arg CUSTOM_CA_CERT="$$CA_CERT" -t dotfiles-test .

docker-test:
	docker run --rm dotfiles-test zsh -c "dotfiles test"

docker-shell:
	docker run --rm -it dotfiles-test

docker-clean:
	docker rmi dotfiles-test
	docker system prune -f
