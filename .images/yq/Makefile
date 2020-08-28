.PHONY: build docker/login push

ECR_REPO:=thirdparty/yq
VERSION:=3.3.2
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg YQ_BIN_VERSION=$(VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
