# Infrastructure

## Local development

Start local development ```docker compose up```,
lahko dodaš tudi ```-d``` flag.

Databases will be created automatically from ```./mysql/init.sql```

Run Laravel migrations with
```docker compose exec php_users php artisan migrate```

Access MySQL server ```docker compose exec db mysql -u root -prootpass```




## Azure Cluster setup

### Namespaces
- First create namespaces for Ingress controller and Cloudshopt microservices:
```kubectl apply -f k8s/namespaces/```
- Check: ```kubectl get ns```

### Install ingress-nginx
Install ingress-nginx with Helm into ```ingress-nginx``` namespace

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
-n ingress-nginx \
-f helm/ingress-nginx-values.yaml
```

Why custom values?
https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/load-bal-ingress-c/create-unmanaged-ingress-controller?tabs=azure-cli

### Install MySQL and Redis servers

```
helm upgrade --install cloudshopt-mysql oci://registry-1.docker.io/bitnamicharts/mysql \
-n cloudshopt \
-f helm/mysql-values.yaml \
-f helm/mysql-secrets.yaml
```

```
helm upgrade --install cloudshopt-redis oci://registry-1.docker.io/bitnamicharts/redis \
-n cloudshopt \
-f helm/redis-values.yaml \
-f helm/redis-secrets.yaml
```

## Dev vs main
imamo dva namespace-a *cloudshopt* in *cloudshopt-dev*

dev:
users-dev.timotejblazic.eu

main (prod):
users.timotejblazic.eu