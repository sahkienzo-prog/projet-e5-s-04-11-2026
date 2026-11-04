set -eu
cd "$(dirname "$0")/.."
for env in mlops preprod prod; do
  sudo k3s kubectl apply -f "k8s/$env"
done
sudo k3s kubectl apply -f k8s/observability
sudo k3s kubectl get pods,svc,hpa -A
