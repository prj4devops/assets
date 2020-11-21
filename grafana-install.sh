#!/usr/bin/env bash
helm install grafana \
--set persistence.enabled=true \
--set persistence.existingClaim=grafana \
--set service.type=LoadBalancer \
--set tolerations[0].key=node-role.kubernetes.io/master \
--set tolerations[0].effect=NoSchedule \
--set tolerations[0].operator=Exists \
--set nodeSelector."kubernetes\.io/hostname"=m-k8s \
-f grafana_ini.yaml \
grafana/grafana
