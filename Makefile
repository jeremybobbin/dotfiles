#!/bin/make -f
#
# Assumptions:
# 	- POSIX
# 	- git
# 	- this makefile is not moved elsewhere relative to the repo dir
# ----------
#
# Why not just use a package manager?
# I don't want to use makepkg because of its use of Bash.
#
# ----------
#
# Why not reimplement makepkg in POSIX sh?
# Arguments to 'make' are not handled elegantly.
# For example:
# make_pkg() {
# 	. $pkg/PKGBUILD
# 	make "CC=$CC" "CFLAGS=$CFLAGS" "LDFLAGS=$LDFLAGS" $MAKE_OPTS
# }
#
# Though CC & (C|LD)FLAGS are easy to manage, if PKGBUILD sets MAKE_OPTS like this:
# MAKE_OPTS="LOCAL_LIBS=-lterminfo -ltre OTHER_MAKE_OPT=foo bar"
#
# I'm not sure how to manage the splitting of MAKE_OPTS
# 
# And though getting the dependency tree order right is easy with coreutils' tsort,
# this functionality is baked into Makefile.
# 
# ----------
#
# Nitpicks
#
# If one of the src dirs' entries is added, renamed or removed during compilation,
# make will re-make, (and optionally re-run 'configure')
#
# The makefile syntax should be restricted to its dependency macros,
# $@, $^, $< (etc) and its "target0[ target1[ ...]]: [dep0[ dep1[ ..]]]\n\tshell".
# m4 should do the rest(why cpp isn't just c.m4 doesn't make much sense to me either)
# Why not apply UNIX universally?
#
# git doesn't have a clone --force option
#
# ----------
#
# I don't really like phony targets.
# The following has too much indirection:
#
# ```
# musl: musl-src
# 	...
# musl-src: $(SRC)/musl
# $(SRC)/musl:
# 	git clone ...
# $(BIN)/bash: musl curses tre
# 	...
# ```
#
# Compared to example:
# ```
# $(LIB)/libc.so: $(SRC)/musl 
# 	...
# $(SRC)/musl:
# 	git clone ...
# $(BIN)/bash: $(LIB)/libc.so $(LIB)/libcurses.so $(LIB)/libtre.so
# 	...
# ```
#
# The latter is:
# 1. a bit of an eye-sore
# 2. makes the interface a somewhat painful
# 	- ./deploy $HOME/.local/bin/bash PREFIX=$HOME/.local
# 	- though this can be addressed later with "bash: $(BIN)/bash" or a
# 	wrapper script
#
# I could use phony targets like "bash.git" and make ".git" a generic SUFFIX:
# .SUFFIXES: .git
# $(SRC)/bash: https://github.com/user/bash.git
# .git:
# 	cd $(SRC); git clone $@ 
# However:
# 	- bmake and GNU/make can't apply the inference rule when the dep isn't a dir entry
#
# ----------
#
# I don't really like too many interdepencies
# At what point are their too many assumptions? 
#  - POSIX is the only reasonable assumption
#  	- But GIT is not POSIX
#  		- Ok, POSIX + GIT
#
# ----------
#
# Shouldn't there be a single source of truth for a package's (provided|dependcy) (bin|libr)aries?
# 	- Yeah, that's what package managers do. This is the package manager
# 
# ---------
#
PREFIX = $(HOME)/.local
SRC = $(PREFIX)/src
BIN = $(PREFIX)/bin
LIB = $(PREFIX)/lib
INC = $(PREFIX)/include
ETC = $(PREFIX)/etc
VAR = $(PREFIX)/var
SHARE = $(PREFIX)/share
CC = musl-gcc
MAKE = make
LN = ln -sf
CP = cp -fa
RM = rm -rf
DEPLOY_CFLAGS = -I$(PREFIX)/include -I. -fPIC -O3 $(CFLAGS)
DEPLOY_LDFLAGS = -L$(PREFIX)/lib -Wl,-rpath=$(LIB) $(LDFLAGS)
FLAGS = "CC=$(CC)" "CFLAGS=$(DEPLOY_CFLAGS)" "LDFLAGS=$(DEPLOY_LDFLAGS)" 

CURSES = $(BIN)/infocmp $(BIN)/tabs $(BIN)/tput  $(BIN)/tset $(BIN)/tic \
	$(LIB)/libcurses.so  $(LIB)/libform.so  $(LIB)/libmenu.so $(LIB)/libpanel.so \
	$(INC)/curses.h
LUA = $(BIN)/lua $(LIB)/liblua.so $(INC)/lua.h
MENUTILS = $(BIN)/menu $(BIN)/menu-fb $(BIN)/menu-cache
MUSL = $(BIN)/musl-gcc $(LIB)/libc.so $(LIB)/libdl.a
READLINE = $(LIB)/libhistory.so $(LIB)/libreadline.so
SUPPORT = $(BIN)/orders $(BIN)/network-bug-report.sh
TERMKEY = $(LIB)/libtermkey.so $(INC)/termkey.h
VIM=etc/vim/pack/$(USER)/start/
VIM_PLUGINS = $(VIM)/csv.vim $(VIM)/haskell-vim $(VIM)/rust.vim $(VIM)/vim-javascript \
	$(VIM)/vim-json $(VIM)/vim-jsx $(VIM)/vim-repeat $(VIM)/vim-surround \
	$(VIM)/vim-unimpaired $(VIM)/vim-vinegar
VIS_PLUGIN_DIR=$(ETC)/vis/plugins
VIS_PLUGINS = $(VIS_PLUGIN_DIR)/vis-ctags $(VIS_PLUGIN_DIR)/vis-surround \
	$(VIS_PLUGIN_DIR)/vis-cursors $(VIS_PLUGIN_DIR)/vis-toggler \
	$(VIS_PLUGIN_DIR)/vis-commentary

# C Stack
C=$(MUSL) # $(BIN)/$(CC)

.PHONY: all base options xorg 

all: base xorg

install: base

base: $(SUPPORT) dotfiles $(BIN)/abduco $(BIN)/bash $(BIN)/dvtm $(BIN)/vis $(SHARE)/regex $(MENUTILS)
	# TODO: if cron isn't installed, this doesn't work
	crontab $(PREFIX)/etc/crontab

xorg: $(BIN)/dwm $(BIN)/dmenu $(BIN)/st $(BIN)/surf

clean:
	cd $(PREFIX) && for src in $(PREFIX)/src/*; do \
		cd "$$src" && $(MAKE) clean ||:; \
		touch "$$src"; \
	done

options:
	@echo CC=$(CC)
	@echo CFLAGS=$(DEPLOY_CFLAGS)
	@echo LDFLAGS=$(DEPLOY_LDFLAGS)
	@echo PREFIX=$(PREFIX)

# Vim plugins need to be cloned before we can copy them over 
# TODO: PATH !~ *$HOME/.local/bin* by default -
# another argument for shell script wrapper around this
dotfiles $(HOME)/.profile $(HOME)/.bashrc $(HOME)/.inputrc $(HOME)/.config:\
	$(VIS_PLUGINS) $(VIM_PLUGINS) etc/profile etc/bash.bashrc etc/inputrc etc/crontab
	mkdir -p $(PREFIX)
	cp -af bin etc share $(PREFIX)
	[ "$(PREFIX)" = "$$HOME/.local" ] &&  \
		$(LN) "$(ETC)/profile"               "$(HOME)/.profile"    && \
		$(LN) "$(ETC)/profile.d"             "$(HOME)/.profile.d"  && \
		$(LN) "$(ETC)/bash.bashrc"           "$(HOME)/.bashrc"     && \
		$(LN) "$(ETC)/X11/xinit/xinitrc"     "$(HOME)/.xinitrc"    && \
		$(LN) "$(ETC)/inputrc"               "$(HOME)/.inputrc"    && \
		$(LN) "$(ETC)/vimrc"                 "$(HOME)/.vimrc"      && \
		$(LN) "$(ETC)/vim"                   "$(HOME)/.vim"        && \
		$(LN) "$(ETC)/"                      "$(HOME)/.config"    ||:

	cp -af $(ETC)/skel/. $(HOME)

$(VIM_PLUGINS):
	git submodule update --init --recursive

$(VIS_PLUGIN_DIR)/vis-commentary:
	git clone https://github.com/jeremybobbin/vis-commentary $@

$(VIS_PLUGIN_DIR)/vis-ctags:
	git clone https://github.com/jeremybobbin/vis-ctags $@

$(VIS_PLUGIN_DIR)/vis-cursors:
	git clone https://github.com/erf/vis-cursors $@

$(VIS_PLUGIN_DIR)/vis-surround:
	git clone https://repo.or.cz/vis-surround.git $@

$(VIS_PLUGIN_DIR)/vis-toggler:
	git clone https://repo.or.cz/vis-toggler.git $@

$(MUSL): $(SRC)/musl
	cd $(SRC)/musl && \
	./configure --prefix=$(PREFIX) CC=cc && \
	$(MAKE) install syslibdir=$(LIB);

$(BIN)/tcc: $(SRC)/tcc $(MUSL)
	cd $(SRC)/tcc && \
	./configure --cc=musl-gcc --prefix=$(PREFIX) --config-musl --sysroot=$(PREFIX) \
		--extra-cflags="$(DEPLOY_CFLAGS)" --extra-ldflags="$(DEPLOY_LDFLAGS)" && \
	make && make install

$(CURSES): $(SRC)/ncurses $(C)
	cd $(SRC)/ncurses && \
	./configure --prefix=$(PREFIX) --enable-overwrite --without-cxx --without-ada --with-shared --enable-widec $(FLAGS) && \
	$(MAKE) install && \
	$(LN) -sf $(LIB)/libncursesw.so $(LIB)/libcurses.so && \
	$(LN) -sf $(LIB)/libpanelw.so $(LIB)/libpanel.so && \
	$(LN) -sf $(LIB)/libformw.so $(LIB)/libform.so && \
	$(LN) -sf $(LIB)/libmenuw.so $(LIB)/libmenu.so

$(READLINE): $(SRC)/readline $(C) $(CURSES)
	cd $(SRC)/readline && \
	./configure --prefix=$(PREFIX) --with-curses --enable-shared \
		"CC=$(CC)" "CFLAGS=$(DEPLOY_CFLAGS)" "LDFLAGS=$(DEPLOY_LDFLAGS)" && \
	$(MAKE) install SHLIB_LIBS=-lcurses;

$(BIN)/abduco: $(SRC)/abduco $(C)
	cd $(SRC)/abduco && \
	./configure --prefix=$(PREFIX) $(FLAGS) && \
	$(MAKE) install CC=$(CC) || test -e $(PREFIX)/bin/abduco;

$(BIN)/bash: $(SRC)/bash $(C) $(READLINE) $(LIB)/libtre.so
	cd $(SRC)/bash && \
	./configure --prefix=$(PREFIX) --with-curses --enable-readline --with-installed-readline --without-bash-malloc \
		$(FLAGS) && \
	$(MAKE) install;

$(LIB)/libtre.so: $(SRC)/tre $(C)
	cd $(SRC)/tre && \
	./configure --prefix=$(PREFIX) && \
	$(MAKE) install PREFIX=$(PREFIX) CC=$(CC) LDFLAGS="$(DEPLOY_LDFLAGS)" \
		CFLAGS="-shared $(DEPLOY_CFLAGS) -DHAVE_WCHAR_H -DHAVE_WCTYPE_H -DHAVE_MBRTOWC";

$(MENUTILS): $(SRC)/menutils
	cd $(SRC)/menutils && \
	$(MAKE) install PREFIX=$(PREFIX)

$(BIN)/dmenu: $(SRC)/dmenu
	cd $(SRC)/dmenu && \
	$(MAKE) install "PREFIX=$(PREFIX)";

$(BIN)/st: $(SRC)/st
	cd $(SRC)/st && \
	$(MAKE) install "PREFIX=$(PREFIX)";

$(BIN)/surf: $(SRC)/surf $(BIN)/dmenu
	cd $(SRC)/surf && \
	$(MAKE) install "PREFIX=$(PREFIX)";

$(BIN)/dwm: $(SRC)/dwm
	cd $(SRC)/dwm && \
	$(MAKE) install "PREFIX=$(PREFIX)";

$(LUA): $(SRC)/lua $(C) $(READLINE)
	cd $(SRC)/lua && \
	./configure "--prefix=$(PREFIX)"; \
	$(MAKE) install "CFLAGS=$(DEPLOY_CFLAGS) -DLUA_USE_LINUX -DLUA_COMPAT_5_2 -DLUA_COMPAT_5_1" \
		"LDFLAGS=$(LD_FLAGS)" CC=$(CC)

$(LIB)/liblpeg.so $(LIB)/liblpeg.a: $(SRC)/lpeg $(C) $(LUA)
	cd $(SRC)/lpeg && \
	./configure; \
	$(MAKE) install "CFLAGS=$(DEPLOY_CFLAGS) -shared" \
		"LDFLAGS=$(LD_FLAGS)" CC=$(CC) PREFIX=$(PREFIX)

$(BIN)/vis $(BIN)/vis-clipboard $(BIN)/vis-complete $(BIN)/vis-open: $(SRC)/vis $(C) $(LIB)/libcurses.so \
	$(LIB)/libtermkey.so $(INC)/termkey.h $(LIB)/libtre.so $(LUA) $(LIB)/liblpeg.so
	cd $(SRC)/vis && \
	./configure --prefix=$(PREFIX) --enable-curses --enable-lua --enable-tre \
		CC=$(CC) "CFLAGS=$(DEPLOY_CFLAGS)" CFLAGS_CURSES= \
		"LDFLAGS=$(DEPLOY_LDFLAGS) -ltre -lcurses -llpeg -llua -ltermkey" && \
	$(MAKE) install

$(TERMKEY): $(SRC)/libtermkey $(C) $(CURSES)
	cd $(SRC)/libtermkey && \
	./configure --prefix=$(PREFIX) --enable-curses $(FLAGS) && \
	$(MAKE) install PREFIX=$(PREFIX);

$(BIN)/dvtm: $(SRC)/dvtm $(C) $(CURSES)
	cd $(SRC)/dvtm && \
	$(MAKE) install $(FLAGS) PREFIX=$(PREFIX) && \
	$(BIN)/tic $(SRC)/dvtm/dvtm.info

$(SUPPORT): $(SRC)/support
	cd $(SRC)/support && $(MAKE) install PREFIX=$(PREFIX)

$(SHARE)/regex: $(SRC)/regex
	cd $(SRC)/support && $(MAKE) install PREFIX=$(PREFIX)

# I'm not aware of any other POSIX complient way of doing this that doesn't suck
# https://pubs.opengroup.org/onlinepubs/009695399/utilities/make.html#tag_04_84_13_05
# 
# I could write a makefile-gen script and then makefile-gen | make - 
# But maintaining that'd be a bitch
$(SRC)/abduco:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/abduco "$@"

$(SRC)/bash:
	$(RM) "$@"
	git clone http://git.savannah.gnu.org/git/bash -b bash-5.0 "$@"

$(SRC)/dmenu:
	$(RM) "$@"
	git clone https://www.github.com/jeremybobbin/dmenu "$@"

$(SRC)/dvtm:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/dvtm "$@"

$(SRC)/dwm:
	$(RM) "$@"
	git clone https://www.github.com/jeremybobbin/dwm "$@"

$(SRC)/libtermkey:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/libtermkey "$@"

$(SRC)/lpeg:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/lpeg "$@"

$(SRC)/lua:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/lua "$@"

$(SRC)/menutils:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/menutils "$@"

$(SRC)/musl:
	$(RM) "$@"
	git clone https://github.com/bminor/musl "$@"

$(SRC)/ncurses:
	$(RM) "$@"
	git clone https://github.com/mirror/ncurses "$@"

$(SRC)/nnn:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/nnn "$@"

$(SRC)/readline:
	$(RM) "$@"
	git clone -b readline-8.0 https://git.savannah.gnu.org/git/readline.git "$@"

$(SRC)/regex:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/regexes "$@"

$(SRC)/sbase:
	$(RM) "$@"
	git clone https://github.com/michaelforney/sbase "$@"

$(SRC)/st:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/st "$@"

$(SRC)/support:
	$(RM) "$@"
	git clone https://github.com/LambdaLabs/support "$@"

$(SRC)/surf:
	$(RM) "$@"
	git clone -b master https://www.github.com/jeremybobbin/surf "$@" 

$(SRC)/tcc:
	$(RM) "$@"
	git clone https://github.com/TinyCC/tinycc "$@"

$(SRC)/tre:
	$(RM) "$@"
	git clone https://github.com/jeremybobbin/tre "$@"

$(SRC)/vis:
	$(RM) "$@"
	git clone https://github.com/martanne/vis "$@"
