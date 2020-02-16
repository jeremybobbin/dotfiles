include config.mk

deploy: install
	${PREFIX}/bin/deploy

install: submodules
	mkdir -p ${PREFIX}
	cp -r bin etc share src ${PREFIX}

submodules:
	@echo initializing submodules
	git submodule update --init --recursive


