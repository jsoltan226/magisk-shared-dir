all:
	rm -f test.zip
	zip -x ./.git/\* ./Makefile -r test.zip .
	sudo magisk --install-module test.zip

clean:
	rm -f test.zip
