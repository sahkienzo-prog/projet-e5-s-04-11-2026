set -eu
cd "$(dirname "$0")/.."
mkdir -p logs
ip=$(hostname -I | awk '{print $1}')
sudo k3s kubectl top pods -A > logs/mesures-repos-s-04-11-2026.log
for env in mlops preprod prod; do
  for app in stripe podinfo; do
    host="$app-$env-s-04-11-2026.172-26-141-177.sslip.io"
    code=$(curl -s -o /dev/null -w '%{http_code}' -H "Host: $host" "http://$ip")
    printf '%s %s\n' "$host" "$code"
    test "$code" = 200
  done
  code=$(curl -s -o /dev/null -w '%{http_code}' -H "Host: nginx-$env-s-04-11-2026.172-26-141-177.sslip.io" "http://$ip")
  printf 'nginx externe %s %s\n' "$env" "$code"
  test "$code" = 404
done
curl -fsS -H 'Host: netdata-s-04-11-2026.172-26-141-177.sslip.io' "http://$ip/api/v1/info" > logs/netdata-info-s-04-11-2026.json
sudo k3s kubectl -n mlops-s-04-11-2026 run verification-s-04-11-2026 --image=busybox:1.37 --restart=Never --labels=nom=sahki,empreinte=s-04-11-2026 --command -- sh -c 'wget -q -O /dev/null -T 5 http://nginx-s-04-11-2026 && echo INTERNE_OK; if wget -q -O /dev/null -T 5 http://nginx-s-04-11-2026.prod-s-04-11-2026.svc.cluster.local; then echo ISOLATION_ECHEC; exit 1; else echo ISOLATION_OK; fi'
sudo k3s kubectl -n mlops-s-04-11-2026 wait --for=jsonpath='{.status.phase}'=Succeeded pod/verification-s-04-11-2026 --timeout=120s
sudo k3s kubectl -n mlops-s-04-11-2026 logs verification-s-04-11-2026
sudo k3s kubectl -n mlops-s-04-11-2026 delete pod verification-s-04-11-2026
