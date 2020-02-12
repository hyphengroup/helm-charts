.PHONY: build docker/login push

ECR_REPO:=thirdparty/argocd-helmfile
VERSION:=1.3.6
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
