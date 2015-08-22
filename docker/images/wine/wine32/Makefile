.PHONY: build

IMAGE_TAG:=puppet.tvbs:5000/wine32
ifneq ($(DOCKER_BRANCH), master)
	IMAGE_TAG:=$(IMAGE_TAG)-$(DOCKER_BRANCH)
endif

build:
	docker build --no-cache -t $(IMAGE_TAG) .
	docker push $(IMAGE_TAG)
