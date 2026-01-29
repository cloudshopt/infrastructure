# CloudShopt Infrastructure

This repository contains Kubernetes/Helm infrastructure for the CloudShopt project.  
It provides local development (Docker Compose) and production/development deployments via GitHub Actions.

## Services

- **frontend-service** (Vue + Vite)
- **user-service** (Laravel) – auth (register/login/me), JWT
- **product-service** (Laravel) – product list/detail
- **order-service** (Laravel) – cart + orders
- **payment-service** (Laravel) – Stripe Checkout Session + webhooks
- Shared infrastructure: **ingress-nginx**, **MySQL**, **Redis**

---

## Local Development Setup

### Prerequisites
- Docker + Docker Compose

### Start local stack

```
docker compose up -d
```

### Local access

The local gateway runs on:
- Frontend: http://app.localhost/
- User API: http://app.localhost/api/users/
- Product API: http://app.localhost/api/products/
- Order API: http://app.localhost/api/orders/
- Payment API: http://app.localhost/api/payments/

### Useful health/diagnostics endpoints

Each service exposes diagnostics endpoints:
- ```GET /api/<service>/healthz```
- ```GET /api/<service>/info```
- ```GET /api/<service>/database```

Examples:

- ```http://app.localhost/api/products/healthz```
- ```http://app.localhost/api/orders/info```
- ```http://app.localhost/api/users/database```

## Swagger / OpenAPI

Each backend service provides an ```openapi.yaml``` used by Swagger UI.
The specs are located in each service repository in ```/docs/openapi.yaml``` file.

## Branching Strategy

This project uses two branches per repository:
- ```main``` (production)
- ```dev``` (development)

Workflow:
1. Work on ```dev``` (features, fixes).
2. Merge dev to main when ready for production release.
3. CI/CD deploys automatically based on the pushed branch.

## CI/CD Pipeline

CI/CD is implemented using GitHub Actions.

1. Build Docker image
2. Push image to container registry (Docker Hub)
3. Deploy Helm chart to AKS

### Environment mapping
- Push to ```dev``` deploys to dev namespace (cloudshopt-dev)
- Push to main → deploy to prod namespace (cloudshopt)


### Secrets

Sensitive values are stored in GitHub Secrets and injected during deployment.

## System Architecture

CloudShopt is built using a microservices architecture:
- **user-service** issues JWT tokens
- **frontend-service** stores JWT and calls backend APIs via the gateway
- **order-service** manages cart and order creation
- **payment-service** creates Stripe Checkout Session and handles Stripe webhooks
- **payment-service** updates order status through internal service-to-service calls
- **product-service** provides product catalog endpoints

### Request routing

All external traffic goes through ingress-nginx and is routed by path prefix:

- ```/```  frontend-service
- ```/api/users```  user-service
- ```/api/products``` product-service
- ```/api/orders```  order-service
- ```/api/payments```  payment-service

## Public URLs

Development: https://app-dev.timotejblazic.eu/

Production: https://app.timotejblazic.eu/

## Stripe Setup

### Local development (Stripe CLI)

Use Stripe CLI to forward webhooks to local gateway:
```
stripe login
stripe listen --forward-to http://app.localhost/api/payments/webhooks/stripe
```

Stripe CLI prints a ```whsec_``` secret. Set it as: ```STRIPE_WEBHOOK_SECRET```

### Production / Kubernetes (Stripe Dashboard)

We have two webhook endpoints:
- https://app-dev.timotejblazic.eu/api/payments/webhooks/stripe (dev)

- https://app.timotejblazic.eu/api/payments/webhooks/stripe (prod)

Copy the endpoint's ```whsec_``` into Kubernetes secrets (GitHub Secrets).