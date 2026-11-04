set -eu
cd "$(dirname "$0")/.."
set -a
. ./.env
set +a
: "${DOCKERHUB_USER:?Renseigner DOCKERHUB_USER dans .env}"
sudo docker login --username "$DOCKERHUB_USER"
for app in stripe podinfo nginx; do
  sudo docker tag "$app-s-04-11-2026:1" "$DOCKERHUB_USER/$app-s-04-11-2026:1"
  sudo docker push "$DOCKERHUB_USER/$app-s-04-11-2026:1"
done
