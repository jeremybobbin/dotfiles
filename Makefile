include config.mk

deploy: install
	${PREFIX}/bin/deploy

install: submodules
	mkdir -p ${PREFIX}
	cp -a bin etc share src var ${PREFIX}

submodules:
	@echo initializing submodules
	git submodule update --init --recursive


