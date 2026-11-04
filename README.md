Projet E5 Kubernetes de Sahki Enzo
================================

Auteur : Sahki Enzo. Travail individuel. Date : 4 novembre 2026.
Empreinte : s-04-11-2026. Docker Hub : etest15.

Le projet utilise trois applications existantes : l’exemple officiel Stripe Checkout avec Flask, Podinfo et Nginx. Le code des applications n’a pas été développé pour ce projet. Les fichiers de configuration et les scripts ne contiennent pas de commentaires avec un dièse.

Le dossier contient les configurations Kubernetes, les Dockerfile, les scripts simples, les sources de Stripe avec sa licence et les journaux réels. Lire RAPPORT.md et RESULTATS.md pour distinguer les vérifications terminées des étapes à terminer avec les comptes personnels.

Accéder à la VM existante
------------------------

```powershell
multipass shell e5-s-04-11-2026
```

Puis dans Ubuntu :

```sh
cd /home/ubuntu/projet-e5-s-04-11-2026
```

Ordre des opérations sur une nouvelle VM
----------------------------------------

Depuis le dossier du projet dans PowerShell, lancer scripts/00-vm-s-04-11-2026.ps1. Cette création est réservée à une machine où la VM n’existe pas encore. Pour la VM déjà créée, ne pas relancer cette étape.

Dans Ubuntu, enregistrer la session avec script avant les commandes :

```sh
script -a logs/history-projet-SAHKI-ENZO-s-04-11-2026.log
bash scripts/01-installer-s-04-11-2026.sh
bash scripts/02-images-s-04-11-2026.sh
cp .env.example .env
nano .env
```

Renseigner DOCKERHUB_USER=etest15. Pour un paiement, renseigner les clés Stripe de test et un identifiant de prix créé dans le même compte de test. Ne jamais utiliser une clé live. Le script de secrets refuse les clés live.

```sh
bash scripts/03-publier-s-04-11-2026.sh
bash scripts/04-secrets-s-04-11-2026.sh
bash scripts/05-deployer-s-04-11-2026.sh
bash scripts/06-dockerhub-s-04-11-2026.sh
bash scripts/09-verifier-s-04-11-2026.sh
bash scripts/07-charge-s-04-11-2026.sh mlops stripe
bash scripts/07-charge-s-04-11-2026.sh mlops podinfo
bash scripts/07-charge-s-04-11-2026.sh mlops nginx
bash scripts/08-preuves-s-04-11-2026.sh
exit
```

Sans clés Stripe, remplacer uniquement l’étape 04-secrets par 04-apercu-sans-paiement. La page s’affiche, mais le bouton de paiement ne peut pas fonctionner. Ce mode ne valide pas la consigne de paiement.

Après modification d’un secret, redémarrer les déploiements Stripe :

```sh
for env in mlops preprod prod; do
  sudo k3s kubectl -n "$env-s-04-11-2026" rollout restart deployment/stripe-s-04-11-2026
done
```

Accès depuis Windows
-------------------

La VM créée possède actuellement l’adresse 172.26.141.177. Vérifier avec multipass info e5-s-04-11-2026, car elle peut changer après un redémarrage.

Ajouter les lignes de ACCES-WINDOWS.txt au fichier C:\Windows\System32\drivers\etc\hosts avec un éditeur lancé en administrateur. Ouvrir ensuite les adresses suivantes :

- http://stripe-mlops-s-04-11-2026.test
- http://podinfo-mlops-s-04-11-2026.test
- http://netdata-s-04-11-2026.test

Remplacer mlops par preprod ou prod pour les autres environnements. Ces adresses utilisent le réseau local de la VM, pas une publication sur Internet. Nginx n’a pas d’Ingress et n’est pas accessible par une adresse externe.

Sans modifier le fichier hosts, tester dans PowerShell :

```powershell
curl.exe -H 'Host: podinfo-mlops-s-04-11-2026.test' http://172.26.141.177
```

Versionnement et remise
----------------------

Le dépôt Git et ses commits sont dans ce dossier, y compris le dossier caché .git. Ne pas supprimer .git avant de remettre le projet. Le dépôt est local ; aucun dépôt GitHub distant n’est créé automatiquement.

Ne pas envoyer .env, le dossier secrets, ni les identifiants Docker. Avant d’ajouter de nouveaux logs, vérifier qu’ils ne contiennent pas de secrets. Consulter RESULTATS.md avant de rendre le rapport : le paiement et Docker Hub doivent être confirmés avec des preuves réelles.

Après une étape terminée :

```sh
git add k8s scripts logs README.md RAPPORT.md RESULTATS.md
git commit -m "Decrit precisement le travail realise"
git log --oneline
```

Le sujet demande aussi de réserver un créneau d’oral dans le fichier du cours et de déposer personnellement le rendu dans Teams.
