#!/bin/bash

sudo apt-get update -y


K3S_URL="https://192.168.56.110:6443" 
K3S_TOKEN=""
curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -

sudo systemctl status k3s-agent

