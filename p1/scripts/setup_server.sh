#!/bin/bash

# export DEBIAN_FRONTEND=noninteractive
apt-get update
apt install -y curl

# cat /home/vagrant/.ssh/me.pub >>/home/vagrant/.ssh/authorized_keys
# mkdir -p /root/.ssh

# cat /home/vagrant/.ssh/me.pub >>/root/.ssh/authorized_keys

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --node-ip=192.168.56.110 \
  --advertise-address=192.168.56.110 \
  --node-taint CriticalAddonsOnly=true:NoExecute" sh -

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
chmod 644 /vagrant/node-token

sudo kubectl version --client