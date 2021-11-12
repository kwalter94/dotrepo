install: build
	mv dotrepo ~/bin
	
build: test
	crystal build src/dotrepo.cr
	
test:
	crystal spec
