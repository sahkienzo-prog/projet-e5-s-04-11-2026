set -eu
cd "$(dirname "$0")/.."
for env in mlops preprod prod; do
  ns="$env-s-04-11-2026"
  sudo k3s kubectl apply -f "k8s/$env/namespace.yaml"
  if ! sudo k3s kubectl -n "$ns" get secret stripe-s-04-11-2026 > /dev/null 2>&1; then
    sudo k3s kubectl -n "$ns" create secret generic stripe-s-04-11-2026 --from-literal=PRICE=price_non_configure --from-literal=STRIPE_PUBLISHABLE_KEY= --from-literal=STRIPE_SECRET_KEY= --from-literal=STRIPE_WEBHOOK_SECRET=
    sudo k3s kubectl -n "$ns" label secret stripe-s-04-11-2026 nom=sahki empreinte=s-04-11-2026
  fi
done
printf 'Apercu uniquement : le paiement ne fonctionne pas sans les vraies cles de test.\n'
