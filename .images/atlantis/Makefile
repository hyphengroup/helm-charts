.PHONY: build docker/login push

ECR_REPO:=thirdparty/atlantis

ATLANTIS_VERSION=0.17.3
TERRAGRUNT_VERSION=0.23.40
TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.7.2
TELEPORT_VERSION=7.3.0
VERSION:=0.0.13
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg ATLANTIS_VERSION=$(ATLANTIS_VERSION) \
		--build-arg DEFAULT_TERRAGRUNT_VERSION=$(TERRAGRUNT_VERSION) \
		--build-arg TERRAGRUNT_ATLANTIS_CONFIG_VERSION=$(TERRAGRUNT_ATLANTIS_CONFIG_VERSION) \
		--build-arg TELEPORT_VERSION=$(TELEPORT_VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
