#!/bin/bash

apt-get update
apt-get install -y curl

curl -sfL https://get.k3s.io | sh -

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
chmod 644 /vagrant/node-token

sudo kubectl version --client