# Infrastructure

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

### Create users database + user
```
kubectl -n cloudshopt exec -it cloudshopt-mysql-0 -- bash
```

```
CREATE DATABASE cloudshopt_users CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'users'@'%' IDENTIFIED BY 'CHANGE_ME_USERS_DB_PASS';
GRANT ALL PRIVILEGES ON users.* TO 'users'@'%';
FLUSH PRIVILEGES;
```

### Install user-service with secrets

```
helm upgrade --install user-service ./helm/user-service -n cloudshopt \
-f helm/user-service/values.yaml \
-f helm/user-service-secrets.yaml
```
