## Makefile

.DEFAULT_GOAL := build

GOOS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
GOARCH ?= amd64

SOURCES = $(wildcard */main.go)
PROJECTS = $(foreach p, $(dir $(SOURCES)), $(p:/=))
BINARIES = $(foreach p, $(PROJECTS), $(p)/$(p))

build: $(BINARIES)

$(BINARIES):
	export PROJECT=$(firstword $(subst /, ,$(@))) && \
		docker run --rm -t -v "$(shell pwd)/$${PROJECT}":/src -w /src \
		golang:latest sh -c "\
			CGO_ENABLED=0 \
			GOOS=$(GOOS) \
			GOARCH=$(GOARCH) \
			go build -a --installsuffix cgo --ldflags="-s" -o $${PROJECT}/$${PROJECT}"

clean:
	@rm -rvf $(BINARIES)

.PHONY: build clean $(BINARIES)
