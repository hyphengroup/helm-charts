# Kubernetes AWS EC2 Node lifecycle labeler

This chart installs the [kube-node-lifecycle-labeller](https://github.com/compareasiagroup/kube-node-lifecycle-labeller)
as a daemonset across the cluster nodes.

## Purpose

Spot instances on EC2 come with significant cost savings, but with the burden of instance being terminated if
the market price goes higher than the maximum price you have configured.

The lifecycle labeller fetches the LifeCycle attribute of a node and conditionally adds labels and taints based on EC2 lifecycle

## Installation

You should install into the `kube-system` namespace, but this is not a requirement. The following example assumes this has been chosen.

```
helm install ./deploy/chart --namespace kube-system
```

## Configuration

The following table lists the configurable parameters of the kube-node-lifecycle-labeller chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | container image repository | `mgmt/kube-node-lifecycle-labeller`
`image.tag` | container image tag | `1.15.3-1`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`rbac.create` | if `true`, create & use RBAC resources | `true`
`spot.labels` | space separated list of labels to add for spot instances | `"LifeCycle=Ec2Spot"`
`spot.taints` | space separated list of taints to add for spot instances | `spotInstance=true:PreferNoSchedule`
`onDemand.labels` | space separated list of labels to add for onDemand instances | `"LifeCycle=OnDemand"`
`onDemand.taints` | space separated list of taints to add for onDemand instances | ``
`serviceAccount.create` | if `true`, create a service account | `true`
`serviceAccount.name` | the name of the service account to use. If not set and `create` is `true`, a name is generated using the fullname template. | ``
`resources` | pod resource requests & limits | `{}`
`nodeSelector` | node labels for pod assignment | `{}`
`tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`priorityClassName` | pod priorityClassName for pod. | ``
`hostNetwork` | controls whether the pod may use the node network namespace | `true`
`podAnnotations` | annotations to be added to pods | `{}`
`updateStrategy` | can be either `RollingUpdate` or `OnDelete` | `RollingUpdate`
