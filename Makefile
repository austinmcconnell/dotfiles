.PHONY: docker-build docker-test docker-shell docker-clean

docker-build:
	docker build -t dotfiles-test .

# Extracts the CA chain presented by ghcr.io; the last 28 lines are the final certificate
CA_CERT_EXTRACT = echo | openssl s_client -connect ghcr.io:443 -showcerts 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' | tail -n 28

# Build with custom CA cert (for Cloudflare WARP, corporate proxies, etc.)
docker-build-with-ca:
	@echo "Extracting CA certificate from current connection..."
	@CA_CERT=$$($(CA_CERT_EXTRACT)); \
	docker build --build-arg CUSTOM_CA_CERT="$$CA_CERT" -t dotfiles-test .

# Uses the CA build arg when the extraction returns one, so the image builds behind WARP
docker-test:
	@CA_CERT=$$($(CA_CERT_EXTRACT)); \
	docker build $${CA_CERT:+--build-arg CUSTOM_CA_CERT="$$CA_CERT"} -t dotfiles-test . && \
	docker run --rm -e TERM=xterm dotfiles-test zsh -lc 'eval "$$(fnm env --shell zsh)" && dotfiles test'

docker-shell:
	docker run --rm -it dotfiles-test

docker-clean:
	docker rmi dotfiles-test
	docker system prune -f
