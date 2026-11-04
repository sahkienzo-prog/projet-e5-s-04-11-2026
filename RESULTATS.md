Résultats vérifiés le 4 novembre 2026

VM Multipass e5-s-04-11-2026 créée : Ubuntu 24.04.5 LTS, 6 vCPU, 10 Go RAM, 35 Go disque. IP observée : 172.26.141.177.

K3s opérationnel : v1.36.5+k3s1, un nœud Ready. Trois images construites, trois environnements déployés, neuf Deployments applicatifs avec trois réplicas au repos, soit 27 pods applicatifs. Netdata fonctionne dans un namespace distinct.

HTTP : les pages Stripe et Podinfo répondent 200 dans mlops, preprod et prod. Le routage Podinfo depuis Windows vers la VM répond également 200. Nginx externe répond 404 ; un pod de mlops peut joindre Nginx en interne et ne peut pas joindre Nginx de prod. Preuve : logs/verification-s-04-11-2026.log. Netdata répond via son API : logs/netdata-info-s-04-11-2026.json.

Autoscaling : les trois applications de mlops sont passées de 3 à 20 réplicas sous charge, puis sont revenues à 3 après l’arrêt de la charge. Les autres environnements sont restés à 3. Preuves : logs/autoscaling-mlops-*.log et logs/retour-mlops-*.log. Le script de test collecte les mesures pendant six minutes pour chaque application.

Charge de 180 secondes, concurrence 100, exécutée simultanément sur les trois applications de mlops : Stripe 942079 requêtes, 5233,60 requêtes/s, 0 erreur ApacheBench ; Nginx 1622264 requêtes, 9012,51 requêtes/s, 0 erreur ApacheBench ; Podinfo 1533802 requêtes, 8521,06 requêtes/s. Le premier test Podinfo compte 1020291 différences de longueur, sans erreur de connexion ou de réception. Les pages Podinfo contiennent des valeurs propres au pod ; la taille peut varier. Le script est corrigé avec ab -l et le résultat du test complémentaire est conservé dans logs/charge-podinfo-correction-s-04-11-2026.log. Ces débits correspondent à ce TP et ne sont pas des garanties de performance.

Stripe : seule la page d’accueil et sa charge HTTP sont vérifiées à ce stade. PRICE=price_non_configure et des clés vides permettent l’aperçu, pas un paiement. Configuration des vraies clés de test et preuve du paiement dans le tableau Stripe à terminer. Aucune réussite de paiement n’est inventée.

Docker Hub : compte prévu etest15. Les images sont construites et importées localement. La connexion et la publication publique doivent être confirmées avant de considérer cette exigence comme terminée.

Git : dépôt local réel avec commits. Le dossier .git est conservé dans le rendu. Aucun historique antérieur fictif ni dépôt distant n’est revendiqué.

Configuration : les YAML, Dockerfile, scripts et exemples de variables sont sans commentaires dièse. Les sources originales de Stripe, dont les commentaires Python et les couleurs CSS, sont préservées avec leur licence. Le code métier n’a pas été développé pour ce projet.

Éléments personnels à terminer : configurer les accès de test, vérifier le paiement et les dépôts Docker Hub, relire le rapport, réserver l’oral et déposer le rendu individuel dans Teams. Les domaines .test nécessitent les lignes du fichier ACCES-WINDOWS.txt dans hosts pour un accès par navigateur depuis Windows.
