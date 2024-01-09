PKGVERSION = $(shell git describe --always --dirty)

build:
	dune build @install

all: build
	dune build @runtest --force

test: all
	_build/default/tests/test.exe

install-windows:
	rsync -av _build/install/default/. $(shell cygpath --unix $(OPAM_SWITCH_PREFIX))/.

install-unix:
	rsync -av _build/install/default/. $(OPAM_SWITCH_PREFIX)/.

clean:
	dune clean

.PHONY: all build test clean
