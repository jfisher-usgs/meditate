# Prepare package for release

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: docs install check clean
.PHONY: all

docs:
	R -q -e 'pkgload::load_all()'
	R -q -e 'roxygen2::roxygenize()'
	R -q -e 'pkgbuild::clean_dll()'
.PHONY: docs

build:
	cd ..
	R CMD build --no-build-vignettes $(PKGSRC)
.PHONY: build

install: build
	cd ..
	R CMD INSTALL --build $(PKGNAME)_$(PKGVERS).tar.gz
.PHONY: install

check:
	cd ..
	R CMD check --no-build-vignettes $(PKGNAME)_$(PKGVERS).tar.gz
.PHONY: check

datasets:
	cd data-raw
	Rscript build-datasets.R
	[ -f sysdata.rda ] && mv -f sysdata.rda ../R/
.PHONY: datasets

clean:
	cd ..
	rm -f $(PKGSRC).pdf
	rm -f -r $(PKGNAME).Rcheck/
	rm -f $(PKGSRC)/data-raw/*.rda
.PHONY: clean
