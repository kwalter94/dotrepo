install: build
	mv dotrepo ~/bin
	
install-fish-completions:
	cp share/dotrepo.fish ~/.config/fish/completions/dotrepo.fish
	
build: test
	crystal build src/dotrepo.cr --release

build-static: test
	docker run --rm -it -v $(shell pwd):/workspace -w /workspace crystallang/crystal:latest-alpine crystal build src/dotrepo.cr --static --release

test: lint
	crystal spec

lint:
	crystal tool format --check
	
