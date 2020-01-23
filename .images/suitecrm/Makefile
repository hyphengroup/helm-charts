.PHONY: build docker/login push

ECR_REPO:=thirdparty/suitecrm
# https://suitecrm.com/download/
SUITECRM_VERSION:=7.11.10
TAG:=$(ECR_URL)/$(ECR_REPO):$(SUITECRM_VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg SUITECRM_VERSION=$(SUITECRM_VERSION) \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
