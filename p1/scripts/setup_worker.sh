#!/bin/bash

apt-get update
apt-get install -y curl

export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN=$(cat /vagrant/node-token)

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -

sudo kubectl version --client