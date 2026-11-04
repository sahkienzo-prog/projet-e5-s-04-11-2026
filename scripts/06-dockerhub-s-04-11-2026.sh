set -eu
cd "$(dirname "$0")/.."
set -a
. ./.env
set +a
: "${DOCKERHUB_USER:?Renseigner DOCKERHUB_USER}"
for env in mlops preprod prod; do
  for app in stripe podinfo nginx; do
    sudo k3s kubectl -n "$env-s-04-11-2026" set image "deployment/$app-s-04-11-2026" "$app-s-04-11-2026=$DOCKERHUB_USER/$app-s-04-11-2026:1"
  done
done
