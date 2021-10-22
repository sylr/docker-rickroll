GIT_UPDATE_INDEX  := $(shell git update-index --refresh)
GIT_REVISION      ?= $(shell git rev-parse HEAD)
GIT_DESCRIBE      ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)

DOCKER_BUILD_IMAGE      ?= ghcr.io/sylr/rickroll
DOCKER_BUILD_VERSION    ?= $(GIT_DESCRIBE)
DOCKER_BUILD_LABELS      = --label org.opencontainers.image.title=rickrool
DOCKER_BUILD_LABELS     += --label org.opencontainers.image.description="RickRolls as a Services"
DOCKER_BUILD_LABELS     += --label org.opencontainers.image.url="https://github.com/sylr/docker-rickroll"
DOCKER_BUILD_LABELS     += --label org.opencontainers.image.source="https://github.com/sylr/docker-rickroll"
DOCKER_BUILD_LABELS     += --label org.opencontainers.image.revision=$(GIT_REVISION)
DOCKER_BUILD_LABELS     += --label org.opencontainers.image.version=$(GIT_VERSION)
DOCKER_BUILD_LABELS     += --label org.opencontainers.image.created=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
DOCKER_BUILD_BUILD_ARGS ?=
DOCKER_BUILDX_PLATFORMS ?= linux/amd64,linux/arm64
DOCKER_BUILDX_CACHE     ?= /tmp/.buildx-cache

# -- docker --------------------------------------------------------------------

docker-build:
	@docker buildx build . -f Dockerfile \
		-t $(DOCKER_BUILD_IMAGE):$(DOCKER_BUILD_VERSION) \
		--cache-to=type=local,dest=$(DOCKER_BUILDX_CACHE) \
		--platform=$(DOCKER_BUILDX_PLATFORMS) \
		$(DOCKER_BUILD_BUILD_ARGS) \
		$(DOCKER_BUILD_LABELS)

docker-push:
	@docker buildx build . -f Dockerfile \
		-t $(DOCKER_BUILD_IMAGE):$(DOCKER_BUILD_VERSION) \
		--cache-from=type=local,src=$(DOCKER_BUILDX_CACHE) \
		--platform=$(DOCKER_BUILDX_PLATFORMS) \
		$(DOCKER_BUILD_BUILD_ARGS) \
		$(DOCKER_BUILD_LABELS) \
		--push

docker-run:
	docker build . -t $(DOCKER_BUILD_IMAGE):dev --platform=linux/amd64
	docker run -p 8080:8080 $(DOCKER_BUILD_IMAGE):dev
