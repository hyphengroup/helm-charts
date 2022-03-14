.PHONY: build docker/login push

ECR_REPO:=thirdparty/atlantis

ATLANTIS_VERSION=0.19.2
DEFAULT_TERRAGRUNT_VERSION=0.28.24
TELEPORT_VERSION=8.2.0
TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.13.0
VERSION:=0.2.0
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg ATLANTIS_VERSION=$(ATLANTIS_VERSION) \
		--build-arg DEFAULT_TERRAGRUNT_VERSION=$(DEFAULT_TERRAGRUNT_VERSION) \
		--build-arg TELEPORT_VERSION=$(TELEPORT_VERSION) \
		--build-arg TERRAGRUNT_ATLANTIS_CONFIG_VERSION=$(TERRAGRUNT_ATLANTIS_CONFIG_VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
