install: build
	mv dotrepo ~/bin
	
install-fish-completions:
	cp share/dotrepo.fish ~/.config/fish/completions/dotrepo.fish
	
build: test
	crystal build src/dotrepo.cr --release

test: lint
	crystal spec

lint:
	crystal tool format --check
	
