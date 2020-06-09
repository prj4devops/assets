#!/bin/bash
export deploy=$1
cd deployment
echo "----- before deploy"
kustomize edit add label deploy:$deploy -f
kustomize edit set namesuffix -- -$deploy
kustomize edit set image 192.168.1.101:8443/echo-buildtime:$deploy
kustomize build . | kubectl apply -f -
echo "----- after new deploy"
kubectl get deployment -o wide
while true;
do
export replicas=$(kubectl get deployment --selector=app=echo-buildtime,deploy=$deploy -o jsonpath --template="{.items[0].status.replicas}")
export ready=$(kubectl get deployment --selector=app=echo-buildtime,deploy=$deploy -o jsonpath --template="{.items[0].status.readyReplicas}")
echo "replicas: $replicas, readyReplicas: $ready"
if [ "$ready" == "$replicas" ]; then
  echo "switching new deployment"
  cd ../service
  kustomize edit add label deploy:$deploy -f
  kustomize build . | kubectl apply -f -
  sleep 3
  kubectl delete deployment --selector=app=echo-buildtime,deploy!=$deploy
  echo "----- after old deploy remove"
  kubectl get deployment -o wide
  break
else
  sleep 1
fi
done
