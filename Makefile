# Prepare package for release

PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: docs install check clean

docs:
	R -q -e 'pkgload::load_all()';\
	R -q -e 'roxygen2::roxygenize()';\
	R -q -e 'pkgbuild::clean_dll()';\

build:
	cd ..;\
	R CMD build --no-build-vignettes $(PKGSRC);\

install: build
	cd ..;\
	R CMD INSTALL --build $(PKGNAME)_$(PKGVERS).tar.gz;\

check:
	cd ..;\
	R CMD check --no-build-vignettes $(PKGNAME)_$(PKGVERS).tar.gz;\

datasets:
	cd data-raw;\
	Rscript build-datasets.R;\
	[ -f sysdata.rda ] && mv -f sysdata.rda ../R/;\

clean:
	cd ..;\
	rm -f $(PKGSRC).pdf;\
	rm -f -r $(PKGNAME).Rcheck/;\
	rm -f $(PKGSRC)/data-raw/*.rda;\

.PHONY: all docs build install check datasets clean
