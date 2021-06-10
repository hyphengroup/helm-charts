.PHONY: build docker/login push

ECR_REPO:=thirdparty/airflow
# https://github.com/apache/airflow/releases/latest
AIRFLOW_VERSION:=1.10.15
TAG:=$(ECR_REGISTRY_URL)/$(ECR_REPO):$(AIRFLOW_VERSION)-authlib

build: Dockerfile
	docker build --rm \
		--build-arg AIRFLOW_VERSION=$(AIRFLOW_VERSION) \
		--build-arg AIRFLOW_DEPS="datadog,kubernetes,s3,statsd" \
		--build-arg PYTHON_DEPS="authlib==0.15.3" \
		-t $(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))

push: docker/login
	docker push $(TAG)
