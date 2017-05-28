SHELL := bash
NAME := jruby9k
VERSION := 9.1.10.0
ARCHIVE := jruby-bin-$(VERSION).tar.gz
PACKAGE := $(NAME)_$(VERSION)_amd64.deb
URL := https://s3.amazonaws.com/jruby.org/downloads/$(VERSION)/$(ARCHIVE)
DIR_NAME := jruby-$(VERSION)
PREFIX := /usr
WORKDIR := $(shell mktemp -d)

.DEFAULT_GOAL := deb

$(ARCHIVE):
	curl --location --output $(ARCHIVE) $(URL)

$(DIR_NAME): $(ARCHIVE)
	mkdir -p $(DIR_NAME)
	tar xvf $(ARCHIVE) --directory $(DIR_NAME) --strip-components=1

.PHONY: licensing
licensing: $(DIR_NAME)
	mkdir -p $(DIR_NAME)/share/doc/$(NAME)
	mv $(DIR_NAME)/{BSDL,COPYING,LEGAL,LICENSE.RUBY} $(DIR_NAME)/share/doc/$(NAME)/

.PHONY: deb
deb: licensing
	bin/fpm \
	  --input-type dir \
	  --output-type deb \
	  --license "EPL 1.0, GPL 2, LGPL 2.1" \
	  --chdir $(DIR_NAME) \
	  --depends java8-runtime-headless \
	  --name $(NAME) \
	  --version $(VERSION) \
	  --prefix $(PREFIX) \
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
	$(RM) -r $(PACKAGE) $(DIR_NAME)

clean-all: clean
	$(RM) -r $(ARCHIVE)
