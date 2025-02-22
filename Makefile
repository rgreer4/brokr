TEST?=$(shell go list ./... | grep -v /vendor/)

# Get git commit information
BROKR_VERSION?=$(shell git describe --abbrev=0 --tags 2> /dev/null || echo "0.0.0")
GIT_COMMIT=$(shell git rev-parse --short HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_DATE=$(shell date)

default: test

test:
	@echo " ==> Running tests..."
	@go list $(TEST) \
		| grep -v "/vendor/" \
		| xargs -n1 go test -v -timeout=60s $(TESTARGS)
.PHONY: test



clean:
	@echo " ==> Cleaning up old directory..."
	@rm -rf bin && mkdir -p bin
.PHONY: clean
	
build: clean
	@echo " ==> Building..."
	@go build -ldflags " \
		-X github.com/calvn/brokr/buildtime.Version=${BROKR_VERSION} \
		-X github.com/calvn/brokr/buildtime.GitCommit=${GIT_COMMIT}${GIT_DIRTY} \
		-X 'github.com/calvn/brokr/buildtime.BuildDate=${BUILD_DATE}' \
		" -o bin/brokr .
.PHONY: build

build-windows: clean
	@echo " ==> Building..."
	@GOOS=windows GOARCH=amd64 go build -ldflags " \
		-X github.com/calvn/brokr/buildtime.Version=${BROKR_VERSION} \
		-X github.com/calvn/brokr/buildtime.GitCommit=${GIT_COMMIT}${GIT_DIRTY} \
		-X 'github.com/calvn/brokr/buildtime.BuildDate=${BUILD_DATE}' \
		" -o bin/brokr.exe .
.PHONY: build-windows

build-linux: create-build-image remove-dangling build-native
.PHONY: build-linux

install: clean build
	@echo " ==> Installing..."
	@cp bin/brokr $(GOPATH)/bin
.PHONY: install

generate-gif:
	@echo "To generate the GIF from asciicast file, get https://github.com/pettarin/asciicast2gif and then run:"
	@echo "$$ ./asciicast2gif brokr_demo.json brokr_demo.gif --fps=20 --theme=monokai --size=medium --speed=0.5"
