set -eu
sudo apt-get update
sudo apt-get install -y docker.io curl git apache2-utils
sudo systemctl enable --now docker
curl -sfL https://get.k3s.io -o /tmp/install-k3s-s-04-11-2026.sh
sudo sh /tmp/install-k3s-s-04-11-2026.sh --write-kubeconfig-mode 600
for i in $(seq 1 30); do
  if sudo k3s kubectl get node "$(hostname)" > /dev/null 2>&1; then break; fi
  sleep 3
done
sudo k3s kubectl wait --for=condition=Ready node --all --timeout=180s
sudo k3s kubectl get nodes -o wide
