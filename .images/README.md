# Custom images

## Pre-req

requires:
- docker
- awssso
- aws-cli 

create `.env` file similar to:

```
ECR_URL=...
REGION=ap-southeast-1
SSO_REGION=us-east-1
AWS_PROFILE=...
```

## Building

```
make build/airflow/1.10.7
```

## Pushing

```
make push/airflow/1.10.7
```
