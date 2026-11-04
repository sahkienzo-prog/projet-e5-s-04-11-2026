Résultats vérifiés le 4 novembre 2026

VM Multipass e5-s-04-11-2026 créée : Ubuntu 24.04.5 LTS, 6 vCPU, 10 Go RAM, 35 Go disque. IP observée : 172.26.141.177.

K3s opérationnel : v1.36.5+k3s1, un nœud Ready. Trois images construites, trois environnements déployés, neuf Deployments applicatifs avec trois réplicas au repos, soit 27 pods applicatifs. Netdata fonctionne dans un namespace distinct.

HTTP : les pages Stripe et Podinfo répondent 200 dans mlops, preprod et prod. Le routage Podinfo depuis Windows vers la VM répond également 200. Nginx externe répond 404 ; un pod de mlops peut joindre Nginx en interne et ne peut pas joindre Nginx de prod. Preuve : logs/verification-s-04-11-2026.log. Netdata répond via son API : logs/netdata-info-s-04-11-2026.json.

Autoscaling : les trois applications de mlops sont passées de 3 à 20 réplicas sous charge, puis sont revenues à 3 après l’arrêt de la charge. Les autres environnements sont restés à 3. Preuves : logs/autoscaling-mlops-*.log et logs/retour-mlops-*.log. Le script de test collecte les mesures pendant six minutes pour chaque application.

Charge de 180 secondes, concurrence 100, exécutée simultanément sur les trois applications de mlops : Stripe 942079 requêtes, 5233,60 requêtes/s, 0 erreur ApacheBench ; Nginx 1622264 requêtes, 9012,51 requêtes/s, 0 erreur ApacheBench ; Podinfo 1533802 requêtes, 8521,06 requêtes/s. Le premier test Podinfo compte 1020291 différences de longueur, sans erreur de connexion ou de réception. Les pages Podinfo contiennent des valeurs propres au pod ; la taille peut varier. Le script est corrigé avec ab -l. Le nouveau test de 30 secondes donne 371762 requêtes, 12391,30 requêtes/s et zéro erreur. Son résultat est conservé dans logs/charge-podinfo-correction-s-04-11-2026.log. Ces débits correspondent à ce TP et ne sont pas des garanties de performance.

Stripe : clés de test appliquées dans les trois environnements. Produit et tarif de 1 euro créés en mode test, prix price_1UY4UvRzPSnzcY1KIgx0xce9. Une session Checkout a été créée par POST vers l’application déployée, puis réglée dans le navigateur avec la carte fictive 4242. L’API confirme status=complete, payment_status=paid, amount_total=100 EUR en centimes, livemode=false. Paiement pi_3UY4YxRzPSnzcY1K0q5jGYoI. Preuves : logs/stripe-paiement-test-s-04-11-2026.json et preuves/stripe-succes-s-04-11-2026.png. Sahki Enzo a confirmé dans le chat avoir vu ce paiement réussi dans son tableau Stripe de test. Cette vérification visuelle est une confirmation de l’utilisateur ; l’agent n’a pas capturé le tableau personnel car l’accès Chrome n’était pas autorisé. La capture fournie montre la page de succès de l’application.

Docker Hub : les trois images etest15/stripe-s-04-11-2026:1, etest15/podinfo-s-04-11-2026:1 et etest15/nginx-s-04-11-2026:1 sont publiées. Leur téléchargement anonyme a été vérifié avec HTTP 200 pour chacune. Preuve : logs/dockerhub-public-s-04-11-2026.json. Les neuf déploiements utilisent ces références et leur rollout est terminé. Les images publiées sont pour Linux amd64, architecture de cette VM.

Git : dépôt local réel avec commits. Le dossier .git est conservé dans le rendu. Aucun historique antérieur fictif ni dépôt distant n’est revendiqué.

Configuration : les YAML, Dockerfile, scripts et exemples de variables sont sans commentaires dièse. Les sources originales de Stripe, dont les commentaires Python et les couleurs CSS, sont préservées avec leur licence. Le code métier n’a pas été développé pour ce projet.

Éléments personnels à terminer : relire et comprendre le rapport, ajouter si souhaité une capture du tableau Stripe personnel, réserver l’oral et déposer le rendu individuel dans Teams. Les domaines sslip.io fonctionnent sans modifier hosts. Le premier paiement utilisait encore un ancien nom .test : après paiement, le retour ne se résolvait pas. Le nom a été corrigé, puis la page de succès de cette même session a été vérifiée avec la nouvelle adresse.
