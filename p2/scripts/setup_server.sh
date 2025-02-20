#!/bin/bash

apt-get update
apt-get install -y curl


curl -sfL https://get.k3s.io | sh -

sudo kubectl apply -f ./confs/web-app-1/web-app-1-deployement.yaml
sudo kubectl apply -f ./confs/web-app-2/web-app-2-deployement.yaml
sudo kubectl apply -f ./confs/web-app-3/web-app-3-deployement.yaml
sudo kubectl apply -f ./confs/web-app-1/web-app-1-service.yaml
sudo kubectl apply -f ./confs/web-app-2/web-app-2-service.yaml
sudo kubectl apply -f ./confs/web-app-3/web-app-3-service.yaml
sudo kubectl apply -f ./confs/ingress.yaml
