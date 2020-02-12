# SOCAT

Tunnel through a kube cluster [ref gh issue](https://github.com/kubernetes/kubernetes/issues/72597#issuecomment-518617501)

```
kubectl run --restart=Never --image=alpine/socat TEMP_POD_NAME -- -d -d tcp-listen:PORT,fork,reuseaddr tcp-connect:HOSTNAME:PORT
kubectl wait --for=condition=Ready pod/TEMP_POD_NAME
kubectl port-forward pod/TEMP_POD_NAME LOCAL_PORT:PORT
```

```
kubectl delete pod/TEMP_POD_NAME --grace-period 1 --wait=false
```
