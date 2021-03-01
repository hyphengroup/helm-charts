.PHONY: build docker/login push

ECR_REPO:=thirdparty/atlantis

ATLANTIS_VERSION=v0.17.0-beta
TERRAGRUNT_VERSION=v0.21.11
TERRAFORM_VERSION=0.12.29   # notice no `v` prefix
VERSION:=0.0.4-beta
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg ATLANTIS_VERSION=$(ATLANTIS_VERSION) \
		--build-arg TERRAGRUNT_VERSION=$(TERRAGRUNT_VERSION) \
		--build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
