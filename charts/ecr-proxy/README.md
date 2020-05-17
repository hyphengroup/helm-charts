# ECR Proxy Helm Chart

This chart deploys an ECR Proxy powered by nginx and [ecr-proxy-conf](https://github.com/compareasiagroup/ecr-proxy-conf).

## Why

Make ECR Repositories accessible through an internal endpoint which does not require authentication (pull only, repo access is controlled by the access key)

## How it works

The ecr-proxy-conf side car does the following:

1. Use AWS Access keys to fetch ECR Authentication tokens on an interval.
1. Generate nginx configuration to proxy requests to the ECR endpoint adding headers with ECR authentication
1. Send signal to nginx process to reload the configuration

This chart expects TLS secrets to do TLS termination (it does go through ingress but configures a Service of type Load Balancer directly to the nginx proxy).
Given the nginx process is reloaded on an interval, there is no concern for TLS secrets which have limited timeRange to expire.

