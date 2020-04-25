PREFIX = ${HOME}/.local
MANPREFIX = ${PREFIX}/share/man

deploy: submodules install
	${PREFIX}/bin/deploy

test: install
	${PREFIX}/bin/deploy

install:
	mkdir -p ${PREFIX}
	cp -af bin etc share src var ${PREFIX}

submodules:
	@echo initializing submodules
	git submodule update --init --recursive


