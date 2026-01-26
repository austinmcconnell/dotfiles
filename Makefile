.PHONY: docker-build docker-test docker-shell docker-clean

docker-build:
	docker build -t dotfiles-test .

docker-test:
	docker run --rm dotfiles-test zsh -c "dotfiles test"

docker-shell:
	docker run --rm -it dotfiles-test

docker-clean:
	docker rmi dotfiles-test
	docker system prune -f
