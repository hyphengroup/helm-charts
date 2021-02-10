.PHONY: build docker/login push

ECR_REPO:=thirdparty/argocd-helmfile
ARGO_VERSION:=1.8.3
SOPS_VERSION:=3.5.0
HELMFILE_VERSION:=0.98.1

VERSION:=${ARGO_VERSION}
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg ARGO_VERSION=$(ARGO_VERSION) \
		--build-arg SOPS_VERSION=$(SOPS_VERSION) \
		--build-arg HELMFILE_VERSION=$(HELMFILE_VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
