SHELL := bash
NAME := jruby9k
VERSION := 9.1.10.0
ITERATION := 1
URL := http://jruby.org
DESCRIPTION := Ruby implementation in pure Java
ARCHIVE := jruby-bin-$(VERSION).tar.gz
PACKAGE := $(NAME)_$(VERSION)-$(ITERATION)_amd64.deb
ARCHIVE_URL := https://s3.amazonaws.com/jruby.org/downloads/$(VERSION)/$(ARCHIVE)
DIR_NAME := jruby-$(VERSION)
MAINTAINER := Ryan McKern <ryan@orangefort.com>
VENDOR := Orange Fort
PREFIX := /usr
WORKDIR := build

.DEFAULT_GOAL := all

$(WORKDIR):
	mkdir -p $(WORKDIR)

$(ARCHIVE): $(WORKDIR)
	curl --location --output $(ARCHIVE) $(ARCHIVE_URL)

$(DIR_NAME): $(ARCHIVE)
	mkdir -p $(WORKDIR)/$(DIR_NAME)
	tar xvf $(ARCHIVE) --directory $(WORKDIR)/$(DIR_NAME) --strip-components=1

.PHONY: licensing
licensing: $(DIR_NAME)
	mkdir -p $(WORKDIR)/$(DIR_NAME)/share/doc/$(NAME)
	mv $(WORKDIR)/$(DIR_NAME)/{BSDL,COPYING,LEGAL,LICENSE.RUBY} \
	  $(WORKDIR)/$(DIR_NAME)/share/doc/$(NAME)/

.PHONY: all
all: licensing
	.bundle/bin/fpm \
	  --input-type "dir" \
	  --output-type "deb" \
	  --url "$(URL)" \
	  --license "EPL 1.0, GPL 2, LGPL 2.1" \
	  --maintainer "$(MAINTAINER)" \
	  --vendor "$(VENDOR)" \
	  --description "$(DESCRIPTION)" \
	  --chdir "$(WORKDIR)/$(DIR_NAME)" \
	  --depends "java8-runtime-headless | java7-runtime-headless" \
	  --name "$(NAME)" \
	  --version "$(VERSION)" \
	  --iteration "$(ITERATION)" \
	  --prefix "$(PREFIX)" \
	  ./bin/ast \
	  ./bin/gem \
	  ./bin/irb \
	  ./bin/jgem \
	  ./bin/jirb \
	  ./bin/jirb_swing \
	  ./bin/jruby \
	  ./bin/jrubyc \
	  ./bin/rake \
	  ./bin/rdoc \
	  ./bin/ri \
	  ./bin/testrb \
	  ./lib/jruby.jar \
	  ./lib/jni/$(shell uname -p)-$(shell uname -s) \
	  ./lib/ruby \
	  ./share

clean:
	$(RM) -r $(PACKAGE) $(WORKDIR)

clean-all: clean
	$(RM) -r $(ARCHIVE)
