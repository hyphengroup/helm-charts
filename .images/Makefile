include .env
export $(shell sed 's/=.*//' .env)

help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z%/_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# https://github.com/apache/airflow/releases/latest
build/airflow/%: ## Build custom image for airflow
	docker build --rm \
		--build-arg AIRFLOW_VERSION="$*" \
		--build-arg AIRFLOW_DEPS="datadog,kubernetes,s3" \
		-t $(ECR_URL)/thirdparty/airflow:$* airflow

push/airflow/%: docker/login ## Push custom image for airflow
	docker push $(ECR_URL)/thirdparty/airflow:$*

build/socat: ## Build custom image for socat
	docker build --rm \
		-t $(ECR_URL)/thirdparty/socat:latest socat

build/argocd/%: ## Build custom image for argocd with helmfile
	docker build --rm \
		--build-arg ARGO_VERSION="$*" \
		--build-arg SOPS_VERSION="3.5.0" \
		--build-arg HELMFILE_VERSION="0.98.1" \
		-t $(ECR_URL)/thirdparty/argocd-helmfile:$*  argocd-helmfile

push/argocd/%: docker/login ## Push custom image for argocd with helmfile
	docker push $(ECR_URL)/thirdparty/argocd-helmfile:$*

# https://suitecrm.com/download/
build/suitecrm/%: ## Build custom image for suitecrm
	docker build --rm \
		--build-arg SUITECRM_VERSION="$*" \
		-t $(ECR_URL)/thirdparty/suitecrm:$* suitecrm

push/suitecrm/%: docker/login ## Push custom image for suitecrm
	docker push $(ECR_URL)/thirdparty/suitecrm:$*

docker/login:
	awssso --region ${SSO_REGION} login -p ${AWS_PROFILE} -a ${AWS_PROFILE}
	$$(aws ecr get-login --no-include-email --region $(ECR_REGION))
