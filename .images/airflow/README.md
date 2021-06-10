# docker-airflow

This repository contains forked **Dockerfile** of [apache-airflow](https://github.com/apache/incubator-airflow) from puckel/docker-airflow

## Changelog

- Bump to 1.10.15 - https://github.com/apache/airflow/releases/tag/1.10.15

## Informations

* Based on Python (3.7-slim-stretch) official Image [python:3.7-slim-stretch](https://hub.docker.com/_/python/)
* Following the Airflow release from [Python Package Index](https://pypi.python.org/pypi/apache-airflow)

## Airflow dependency management

Original image extra Airflow packages included by default as of 1.10.4:

```
crypto,postgres,hive,jdbc,mysql,ssh
```

The upstream image does not come with Kubernetes executor which needs to be enabled explicitly.

Make targets add `s3` and `kubernetes` sub packages (note: Airflow installation documents mention an `aws` sub-package, this does not seem to exist...)

`setup.py` defines the pip packages each dependency represent: https://sourcegraph.com/github.com/apache/airflow@1.10.6/-/blob/setup.py#L227

which points to https://pypi.org/project/kubernetes/#history -> https://github.com/kubernetes-client/python/tree/v10.0.1 at the time of writing

See also:
```
airflow@airflow-scheduler-86df8745f7-5vv6s:~$ pip freeze | grep -i kube
kubernetes==10.0.1
```

Kubernetes operator uses try_import in https://sourcegraph.com/github.com/apache/airflow@1.10.6/-/blob/airflow/contrib/kubernetes/kube_client.py#L22

airflow config is read through https://sourcegraph.com/github.com/apache/airflow@1.10.6/-/blob/airflow/contrib/executors/kubernetes_executor.py#L132

The KubernetesOperator uses following filters for the watchers it creates:

- `kwargs = {'label_selector': 'airflow-worker={}'.format(worker_uuid)}`
- `kwargs['resource_version'] = resource_version`
-  `for key, value in kube_config.kube_client_request_args.items(): kwargs[key] = value`

default kube client timeout is set to 1 minute

```
# The timeout is specified as [connect timeout, read timeout]
kube_client_request_args = {{"_request_timeout" : [60,60] }}
```
https://sourcegraph.com/github.com/apache/airflow@1.10.7/-/blob/airflow/config_templates/default_airflow.cfg#L27

this is why we see logs every minute for the Timeout...

We can test scheduler has sufficient rights in a python shell as follows:

```
from kubernetes import client,config
from airflow.configuration import conf


config.load_incluster_config()
c = client.CoreV1Api()
l = c.list_namespaced_pod(conf.get("kubernetes","namespace"))
print(l.items[0].metadata.name)

watcher = watch.Watch()
for event in watcher.stream(c.list_namespaced_pod,conf.get("kubernetes","namespace"), _request_timeout=[60,60]):
   print(event['object'].metadata.name+" "+event['type'])
```

## Build

Optionally install [Extra Airflow Packages](https://airflow.incubator.apache.org/installation.html#extra-package) and/or python dependencies at build time :

    docker build --rm --build-arg AIRFLOW_DEPS="datadog,dask" -t puckel/docker-airflow .
    docker build --rm --build-arg PYTHON_DEPS="flask_oauthlib>=0.9" -t puckel/docker-airflow .

or combined

    docker build --rm --build-arg AIRFLOW_DEPS="datadog,dask" --build-arg PYTHON_DEPS="flask_oauthlib>=0.9" -t puckel/docker-airflow .

Don't forget to update the airflow images in the docker-compose files to puckel/docker-airflow:latest.


## Configurating Airflow

It's possible to set any configuration value for Airflow from environment variables, which are used over values from the airflow.cfg.

The general rule is the environment variable should be named `AIRFLOW__<section>__<key>`, for example `AIRFLOW__CORE__SQL_ALCHEMY_CONN` sets the `sql_alchemy_conn` config option in the `[core]` section.

Required env vars:

- `AIRFLOW__CORE__FERNET_KEY`
- `AIRFLOW__CORE__EXECUTOR`
- `AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"`

Check out the [Airflow documentation](http://airflow.readthedocs.io/en/latest/howto/set-config.html#setting-configuration-options) for more details

You can also define connections via environment variables by prefixing them with `AIRFLOW_CONN_` - for example `AIRFLOW_CONN_POSTGRES_MASTER=postgres://user:password@localhost:5432/master` for a connection called "postgres_master". The value is parsed as a URI. This will work for hooks etc, but won't show up in the "Ad-hoc Query" section unless an (empty) connection is also created in the DB

## Custom Airflow plugins

Airflow allows for custom user-created plugins which are typically found in `${AIRFLOW_HOME}/plugins` folder. Documentation on plugins can be found [here](https://airflow.apache.org/plugins.html)

In order to incorporate plugins into your docker container
- Create the plugins folders `plugins/` with your custom plugins.
- Mount the folder as a volume by doing either of the following:
    - Include the folder as a volume in command-line `-v $(pwd)/plugins/:/usr/local/airflow/plugins`

## Install custom python package

- Create a file "requirements.txt" with the desired python modules
- Mount this file as a volume `-v $(pwd)/requirements.txt:/requirements.txt` (or add it as a volume in docker-compose file)
- You may mount a custom entrypoint.sh script to execute the pip install command (with --user option)

#