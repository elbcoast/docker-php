NAME = elbcoast/php
VERSIONS = 7.0.30 7.1.17 7.2.5

.PHONY: all build tag_latest release tag_version

all: build

build:
	$(foreach VERSION,$(VERSIONS),$(call build_docker,$(VERSION)))


tag_latest:
	$(foreach VERSION,$(VERSIONS),$(call tag_docker,$(VERSION)))

release: tag_latest
	$(foreach VERSION,$(VERSIONS),$(call push_docker,$(VERSION)))

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

# Pushes the created docker images
define push_docker
	docker push $(NAME):${1}
	docker push $(NAME):${1}-xdebug
	docker push $(NAME):${1}-blackfire
	docker push $(NAME):$(shell echo ${1} | cut -f1,2 -d.)
	docker push $(NAME):$(shell echo ${1} | cut -f1,2 -d.)-xdebug
	docker push $(NAME):$(shell echo ${1} | cut -f1,2 -d.)-blackfire

endef
