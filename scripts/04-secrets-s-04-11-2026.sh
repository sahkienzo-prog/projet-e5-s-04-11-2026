set -eu
cd "$(dirname "$0")/.."
set -a
. ./.env
set +a
case "$STRIPE_SECRET_KEY" in sk_test_*) ;; *) echo 'Une cle Stripe de test est obligatoire'; exit 1;; esac
case "$STRIPE_PUBLISHABLE_KEY" in pk_test_*) ;; *) echo 'Une cle publique Stripe de test est obligatoire'; exit 1;; esac
case "$PRICE" in price_*) ;; *) echo 'Identifiant price_ obligatoire'; exit 1;; esac
mkdir -p secrets
chmod 700 secrets
umask 077
printf 'STRIPE_SECRET_KEY=%s\nSTRIPE_PUBLISHABLE_KEY=%s\nPRICE=%s\nSTRIPE_WEBHOOK_SECRET=%s\n' "$STRIPE_SECRET_KEY" "$STRIPE_PUBLISHABLE_KEY" "$PRICE" "$STRIPE_WEBHOOK_SECRET" > secrets/stripe.env
for env in mlops preprod prod; do
  ns="$env-s-04-11-2026"
  sudo k3s kubectl apply -f "k8s/$env/namespace.yaml"
  sudo k3s kubectl -n "$ns" create secret generic stripe-s-04-11-2026 --from-env-file=secrets/stripe.env --dry-run=client -o yaml | sudo k3s kubectl apply -f -
  sudo k3s kubectl -n "$ns" label secret stripe-s-04-11-2026 nom=sahki empreinte=s-04-11-2026 --overwrite
done
