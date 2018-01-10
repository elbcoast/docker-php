NAME = elbcoast/php
VERSIONS = 7.0.27 7.1.13 7.2.1

.PHONY: all build tag_latest release tag_version

all: build

build:
	$(foreach VERSION,$(VERSIONS),$(call build_docker,$(VERSION)))


tag_latest:
	$(foreach VERSION,$(VERSIONS),$(call tag_docker,$(VERSION)))

release: tag_latest
	docker push $(NAME)

# Builds the docker images
define build_docker
	docker build -f $(shell echo ${1} | cut -f1,2 -d.)/Dockerfile -t $(NAME):${1} --build-arg PHP_VERSION=${1} .
	docker build -f $(shell echo ${1} | cut -f1,2 -d.)/Dockerfile-xdebug -t $(NAME):${1}-xdebug --build-arg PHP_VERSION=${1} .
	docker build -f $(shell echo ${1} | cut -f1,2 -d.)/Dockerfile-blackfire -t $(NAME):${1}-blackfire --build-arg PHP_VERSION=${1} .

endef

# Tags the docker images as minor version
define tag_docker
	docker tag $(NAME):${1} $(NAME):$(shell echo ${1} | cut -f1,2 -d.)
	docker tag $(NAME):${1}-xdebug $(NAME):$(shell echo ${1} | cut -f1,2 -d.)-xdebug
	docker tag $(NAME):${1}-blackfire $(NAME):$(shell echo ${1} | cut -f1,2 -d.)-blackfire

endef
