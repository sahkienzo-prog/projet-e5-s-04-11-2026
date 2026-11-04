set -eu
cd "$(dirname "$0")/.."
env="${1:-mlops}"
app="${2:-podinfo}"
case "$env" in mlops|preprod|prod) ;; *) exit 1;; esac
case "$app" in stripe) port=4242;; podinfo) port=9898;; nginx) port=80;; *) exit 1;; esac
ns="$env-s-04-11-2026"
mkdir -p logs
sudo k3s kubectl -n "$ns" top pods > "logs/mesures-avant-$env-$app.log"
sudo k3s kubectl -n "$ns" run "charge-$app-s-04-11-2026" --image=alpine:3.22 --labels=nom=sahki,empreinte=s-04-11-2026 --restart=Never -- sh -c "apk add --no-cache apache2-utils && ab -t 180 -n 10000000 -c 100 http://$app-s-04-11-2026:$port/"
for i in $(seq 1 36); do
  date -Is
  sudo k3s kubectl -n "$ns" get hpa "$app-s-04-11-2026"
  sudo k3s kubectl -n "$ns" top pods
  sleep 10
done > "logs/autoscaling-$env-$app.log" 2>&1
sudo k3s kubectl -n "$ns" logs "charge-$app-s-04-11-2026" > "logs/charge-$env-$app.log"
sudo k3s kubectl -n "$ns" delete pod "charge-$app-s-04-11-2026"
sudo k3s kubectl -n "$ns" get hpa > "logs/retour-$env-$app.log"
