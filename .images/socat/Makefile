.PHONY: build docker/login push

ECR_REPO:=thirdparty/socat
# https://suitecrm.com/download/
VERSION:=1.0.0
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(VERSION)

build: Dockerfile
	docker build --rm \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
