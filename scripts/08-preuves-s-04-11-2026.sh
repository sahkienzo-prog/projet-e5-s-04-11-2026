set -eu
cd "$(dirname "$0")/.."
mkdir -p logs
sudo k3s kubectl get nodes -o wide > logs/nodes-s-04-11-2026.log
sudo k3s kubectl get pods,deploy,svc,ingress,hpa,networkpolicy,resourcequota -A -o wide > logs/etat-s-04-11-2026.log
sudo k3s kubectl get events -A --sort-by=.metadata.creationTimestamp > logs/events-s-04-11-2026.log
for env in mlops preprod prod; do
  ns="$env-s-04-11-2026"
  sudo k3s kubectl -n "$ns" describe deployments,hpa,networkpolicies > "logs/describe-$env-s-04-11-2026.log"
  for app in stripe podinfo nginx; do
    sudo k3s kubectl -n "$ns" logs -l "app=$app-s-04-11-2026" --all-containers=true --prefix=true --tail=1000 > "logs/application-$env-$app-s-04-11-2026.log" 2>&1 || true
  done
done
sudo journalctl -u k3s --no-pager -n 300 > logs/k3s-s-04-11-2026.log
git log --oneline > logs/git-s-04-11-2026.log
