
PKGNAME	   = $(shell grep "name" META.in | sed -e "s/.*\"\([^\"]*\)\".*/\1/")
PKGVERSION = $(shell grep "@version" ANSITerminal.mli | \
		  sed -e "s/[ *]*@version *\([0-9.]\+\).*/\1/")

SOURCES = ANSITerminal_colors.ml ANSITerminal.ml ANSITerminal.mli

DISTFILES    = LICENSE META.in Makefile Make.bat INSTALL README \
		$(wildcard *.ml) $(wildcard *.mli) $(wildcard examples/)

PKG_TARBALL  = $(PKGNAME)-$(PKGVERSION).tar.bz2

.PHONY: all opt byte mli
all: byte opt
byte: ANSITerminal.cma
opt: ANSITerminal.cmxa

ANSITerminal.ml: ANSITerminal_unix.ml
	cp $< $@
	$(MAKE) .depend.ocaml

ANSITerminal.cma: ANSITerminal_colors.cmo ANSITerminal.cmo
ANSITerminal.cmxa: ANSITerminal_colors.cmx ANSITerminal.cmx

META: META.in
	cp $^ $@
	echo "version = \"$(PKGVERSION)\"" >> $@

# (Un)installation
.PHONY: install uninstall
install: all META
	ocamlfind remove $(PKGNAME); \
	[ -f "$(XARCHIVE)" ] && \
	extra="$(XARCHIVE) $(basename $(XARCHIVE)).a"; \
	ocamlfind install $(PKGNAME) $(MLI_FILES) $(CMI_FILES) $(ARCHIVE) META $$extra $(C_OBJS)

uninstall:
	ocamlfind remove $(PKGNAME)

# Make the examples
.PHONY: ex examples
ex: examples
examples: byte showcolors.exe

# Compile HTML documentation
doc: $(DOCFILES) $(CMI_FILES)
	@if [ -n "$(DOCFILES)" ] ; then \
	    if [ ! -x $(PKGNAME).html ] ; then mkdir $(PKGNAME).html ; fi ; \
	    $(OCAMLDOC) -v -d $(PKGNAME).html -html -stars -colorize-code \
		-I +contrib $(ODOC_OPT) $(DOCFILES) ; \
	fi

# Make a tarball
.PHONY: dist
dist: $(DISTFILES)
	@ if [ -z "$(PKGNAME)" ]; then echo "PKGNAME not defined"; exit 1; fi
	@ if [ -z "$(PKGVERSION)" ]; then \
		echo "PKGVERSION not defined"; exit 1; fi
	mkdir $(PKGNAME)-$(PKGVERSION)
#	mv Make.bat $(PKGNAME)-$(PKGVERSION)
	cp -r $(DISTFILES) $(PKGNAME)-$(PKGVERSION)/
	tar --exclude "*~" --exclude "*.cm{i,x,o,xa}" --exclude "*.o" \
	   --dereference \
	  -jcvf $(PKG_TARBALL) $(PKGNAME)-$(PKGVERSION)
	rm -rf $(PKGNAME)-$(PKGVERSION)

include Makefile.ocaml


.PHONY: clean distclean
clean::
	$(RM) -f META $(PKGNAME)-$(PKGVERSION).tar.bz2
	$(RM) -rf $(PKGNAME).html/
	find . -type f -perm +u=x -exec rm -f {} \;

distclean: clean
	rm -f config.status config.cache config.log .depend