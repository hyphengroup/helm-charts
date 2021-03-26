.PHONY: build docker/login push

ECR_REPO:=thirdparty/atlantis

ATLANTIS_VERSION=0.16.1
DEFAULT_TERRAGRUNT_VERSION=0.23.40
VERSION:=0.0.6
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg ATLANTIS_VERSION=$(ATLANTIS_VERSION) \
		--build-arg TERRAGRUNT_VERSION=$(DEFAULT_TERRAGRUNT_VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
