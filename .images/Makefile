include .env
export $(shell sed 's/=.*//' .env)

help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z%/_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# https://github.com/apache/airflow/releases/latest
build/airflow/%: ## Build custom image for airflow
	docker build --rm \
		--build-arg AIRFLOW_VERSION="$*" \
		--build-arg AIRFLOW_DEPS="datadog,kubernetes,s3" \
		-t $(ECR_URL)thirdparty/airflow:$* airflow

push/airflow/%: docker/login ## Push custom image for airflow
	docker push $(ECR_URL)thirdparty/airflow:$*

docker/login:
	awssso --region ${SSO_REGION} login -p ${AWS_PROFILE} -a ${AWS_PROFILE}
	$$(aws ecr get-login --no-include-email --region $(REGION))
