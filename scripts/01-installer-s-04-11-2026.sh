set -eu
sudo apt-get update
sudo apt-get install -y docker.io curl git apache2-utils
sudo systemctl enable --now docker
curl -sfL https://get.k3s.io -o /tmp/install-k3s-s-04-11-2026.sh
sudo sh /tmp/install-k3s-s-04-11-2026.sh --write-kubeconfig-mode 600
sudo k3s kubectl wait --for=condition=Ready node --all --timeout=180s
sudo k3s kubectl get nodes -o wide
