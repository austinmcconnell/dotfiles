.PHONY: docker-build docker-image docker-test docker-idempotency docker-shell docker-clean docker-prune

# Cap on BuildKit's cache, which every project on this Docker host shares
BUILD_CACHE_MAX = 4GB

docker-build:
	docker build -t dotfiles-test .

# Extracts the CA chain presented by ghcr.io; the last 28 lines are the final certificate
CA_CERT_EXTRACT = echo | openssl s_client -connect ghcr.io:443 -showcerts 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' | tail -n 28

# Build with custom CA cert (for Cloudflare WARP, corporate proxies, etc.)
docker-build-with-ca:
	@echo "Extracting CA certificate from current connection..."
	@CA_CERT=$$($(CA_CERT_EXTRACT)); \
	docker build --build-arg CUSTOM_CA_CERT="$$CA_CERT" -t dotfiles-test .

# Rebuilds the image from the current tree, using the CA build arg when the extraction returns
# one so the image builds behind WARP
docker-image:
	@CA_CERT=$$($(CA_CERT_EXTRACT)); \
	docker build $${CA_CERT:+--build-arg CUSTOM_CA_CERT="$$CA_CERT"} -t dotfiles-test . && \
	$(MAKE) --no-print-directory docker-prune

docker-test: docker-image
	@docker run --rm -e TERM=xterm dotfiles-test zsh -lc 'eval "$$(fnm env --shell zsh)" && dotfiles test'

# Runs install.sh twice in a fresh container and fails if the second run changes anything;
# CHECK_ARGS=--self-test confirms the check catches an injected change
docker-idempotency: docker-image
	@docker run --rm -e TERM=xterm -e GIT_TERMINAL_PROMPT=0 -e HOMEBREW_NO_AUTO_UPDATE=1 \
		dotfiles-test /home/testuser/.dotfiles/scripts/check-idempotency.sh $(CHECK_ARGS)

# Removes earlier builds of this image (untagged once a rebuild takes the tag), leaving other
# projects' images alone, then trims the shared build cache to BUILD_CACHE_MAX
docker-prune:
	docker image prune -f --filter label=dotfiles-test=true
	docker builder prune -f --max-used-space $(BUILD_CACHE_MAX)

docker-shell:
	docker run --rm -it dotfiles-test

docker-clean:
	docker rmi dotfiles-test
	docker system prune -f
