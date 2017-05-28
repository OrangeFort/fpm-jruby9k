INSTANCE_NAME := docker-jruby9k
CONTAINER_NAME := xenial-builder

.DEFAULT_GOAL := run

.PHONY: build
build:
	docker build \
	  --rm \
	  --tag \
	  $(CONTAINER_NAME) \
	  $(PWD)

.PHONY: run
run: build
	docker run \
	  --rm \
	  --name $(INSTANCE_NAME) \
	  --interactive \
	  --tty \
	  --volume $(PWD):/build \
	  $(CONTAINER_NAME)
