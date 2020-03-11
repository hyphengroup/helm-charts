# Airflow helm chart (KubernetesExecutor + s3 logging)

Fork from [BrechtDeVlieger/airflow-kube-helm](https://github.com/BrechtDeVlieger/airflow-kube-helm)

Objectives:

- Remove Option to deploy Postgres chart as part of this chart
- Run Airflow on Kubernetes using the KubernetesExecutor. 
- Use s3 for all logging
- git Sync with SSH for all DAGS (ssh config is not included in chart)
- Provide option to manage most secrets outside of Helm values

## Git Sync secrets

git-sync SSH secret and configmap are not managed by this Helm chart:

i.e. to create a ConfigMap adding github.com to known hosts ([ref](https://serverfault.com/questions/856194/securely-add-a-host-e-g-github-to-the-ssh-known-hosts-file)):

First verify the output of the below command with the fingerprint on [github docs](https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection)

```
ssh-keyscan -t rsa github.com | tee github-key-temp | ssh-keygen -lf -
```

If it matches, create configmap for `known_hosts`

```
kubectl -n default create cm airflow-dag-git-configmap --from-file known_hosts=github-key-temp # --dry-run -o yaml
rm github-key-temp
```

i.e create ssh deploy key for Git repository:

```
$ ssh-keygen -t rsa -b 4096 -C "airflow@<environment-cluster>"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/me/.ssh/id_rsa): /Users/me/.ssh/id_airflow
...

kubectl create secret --namespace default generic airflow-dag-git-key --type=opaque \
    --from-file=gitSshKey=$HOME/.ssh/id_airflow
```

NOTE: 1.10.9 has the secret key hardcoded to `gitSshKey`!

TODO:

- Config [auth](https://airflow.apache.org/docs/stable/security.html#web-authentication)
