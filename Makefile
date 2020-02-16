include config.mk

deploy: install
	${PREFIX}/bin/deploy

install:
	mkdir -p ${PREFIX}
	cp -r bin etc share src ${PREFIX}
