# Kubernetes Web View Helm Chart

[Kubernetes Web View](https://github.com/hjacobs/kube-web-view) provides a web interface to list and view all Kubernetes resources

## Installing the Chart

Define kube config under `.secrets.config`

To install the chart with the release name my-release:

```console
$ helm install --name=my-release swat/kube-web-view
```

The command deploys Kubernetes Web View on the Kubernetes cluster in the default configuration.

## Accessing the UI

```console
$ kubectl proxy
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
