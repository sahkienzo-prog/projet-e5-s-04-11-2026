set -eu
cd "$(dirname "$0")/.."
ip=$(hostname -I | awk '{print $1}')
dns=$(printf '%s' "$ip" | tr . -)
for env in mlops preprod prod; do
  sed -Ei "s/([.]test|[.][0-9-]+[.]sslip[.]io)/.$dns.sslip.io/g" "k8s/$env/ingress.yaml" "k8s/$env/stripe.yaml"
  sudo k3s kubectl apply -f "k8s/$env/ingress.yaml" -f "k8s/$env/stripe.yaml"
done
sed -Ei "s/([.]test|[.][0-9-]+[.]sslip[.]io)/.$dns.sslip.io/g" k8s/observability/netdata.yaml
sudo k3s kubectl apply -f k8s/observability/netdata.yaml
printf 'Adresse de la VM : %s\n' "$ip"
printf 'Suffixe des adresses : .%s.sslip.io\n' "$dns"
