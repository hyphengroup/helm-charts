.PHONY: build docker/login push

ECR_REPO:=thirdparty/airflow
# https://github.com/apache/airflow/releases/latest
AIRFLOW_VERSION:=1.10.7
TAG:=$(ECR_URL)/$(ECR_REPO):$(AIRFLOW_VERSION)

build: Dockerfile
	docker build --rm \
		--build-arg AIRFLOW_VERSION=$(AIRFLOW_VERSION) \
		--build-arg AIRFLOW_DEPS="datadog,kubernetes,s3" \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
