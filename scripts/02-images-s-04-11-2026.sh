set -eu
cd "$(dirname "$0")/.."
mkdir -p logs
for app in stripe podinfo nginx; do
  sudo docker build -t "$app-s-04-11-2026:1" "images/$app-s-04-11-2026" > "logs/build-$app-s-04-11-2026.log" 2>&1
  sudo docker tag "$app-s-04-11-2026:1" "etest15/$app-s-04-11-2026:1"
  sudo docker save "etest15/$app-s-04-11-2026:1" -o "/tmp/$app-s-04-11-2026.tar"
  sudo k3s ctr images import "/tmp/$app-s-04-11-2026.tar"
done
