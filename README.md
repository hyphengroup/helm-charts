# helm-charts

For OpenSource projects - when we don't have time to push into helm/charts

## Testing Charts

**Tested with Helm 2.16.1**

Basic testing (requires Helm and a configured kubectl with working context):

```
make test/<chart>
make clean
```

## Pushing Charts

Charts are published to gh-pages branch:

Pushing charts:

```
make push/<chart>
```

## Using Charts

Add the Helm repo URL:

```
helm repo add cag-public https://compareasiagroup.github.io/helm-charts
"cag-public" has been added to your repositories
```
