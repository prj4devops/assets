#!/bin/env bash
helm install jenkins \
--set persistence.existingClaim=jenkins \
--set master.adminPassword=admin \
--set master.nodeSelector."kubernetes\.io/hostname"=m-k8s \
--set master.tolerations[0].key=node-role.kubernetes.io/master \
--set master.tolerations[0].effect=NoSchedule \
--set master.tolerations[0].operator=Exists \
--set master.runAsUser=1000 \
--set master.fsGroup=1000 \
--set master.tag=2.249.1-lts-centos7 \
--version=2.7.1 \
jenkins/jenkins
