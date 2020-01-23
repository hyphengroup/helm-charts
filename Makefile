include .env
export $(shell sed 's/=.*//' .env)

REPO := git@github.com:compareasiagroup/helm-charts.git
URL := https://compareasiagroup.github.io/helm-charts/


help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z%/_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

gh-pages:
	mkdir gh-pages
	cd gh-pages; git init && \
		git remote add origin $(REPO) && \
		git fetch && \
		git checkout gh-pages

stacks/up/%: ## Stand up docker-compose stack
	docker-compose -p $* -f stacks/$*.yml up -d

stacks/down/%: ## Remove docker-compose stack and volumes
	docker-compose -p $* -f stacks/$*.yml down -v

stacks/logs/%: ## Remove docker-compose stack and volumes
	docker-compose -p $* -f stacks/$*.yml logs -f

stacks/bash/%: stacks/up/% ## exec bash in docker-compose stack
	docker-compose -p $* -f stacks/$*.yml exec $* bash

test/charts/%: ## Lint, Render and dry-run Chart against current context
	helm lint charts/$*
	-rm -rf charts/$*/test/
	mkdir -p charts/$*/test/
	helm template -n $* --output-dir charts/$*/test charts/$*
	kubectl apply --dry-run -f charts/$*/test/$*/templates/

push/charts/%: gh-pages ## Package & Push chart
	helm package charts/$*/ -d gh-pages/
	helm repo index gh-pages --url $(URL)
	cd gh-pages && \
		git add . && \
		git commit -am"Publishing $*-$$(grep version ../charts/$*/Chart.yaml | sed 's/^.*: //g')" && \
		git push origin

clean: ## Deletes all first level folders called test (use with care)
	rm -rf charts/*/test
