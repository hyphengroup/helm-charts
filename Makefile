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

test/%: ## Lint, Render and dry-run Chart against current context
	helm lint $*
	-rm -rf $*/test/
	mkdir -p $*/test/
	helm template -n $* --output-dir $*/test $*
	kubectl apply --dry-run -f $*/test/$*/templates/

push/%: gh-pages ## Package & Push chart
	helm package $*/ -d gh-pages/
	helm repo index gh-pages --url $(URL)
	cd gh-pages && \
		git add . && \
		git commit -am"Publishing $*-$$(grep version ../$*/Chart.yaml | sed 's/^.*: //g')" && \
		git push origin

clean: ## Deletes all first level folders called test (use with care)
	rm -rf */test
