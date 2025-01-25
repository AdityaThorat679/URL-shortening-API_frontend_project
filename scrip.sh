#!/bin/bash
MINIKUBE_IP=$(minikube ip)
HOST_ENTRY="$MINIKUBE_IP url-hosting.com"
if ! grep -q "$HOST_ENTRY" /etc/hosts; then
  echo "$HOST_ENTRY" | sudo tee -a /etc/hosts
else
  echo "Host entry already exists"
fi