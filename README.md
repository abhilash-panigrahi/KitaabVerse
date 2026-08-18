# KitaabVerse 

A Spring Boot microservices bookstore — catalog, orders, notifications, and a webapp, all behind a gateway.

## Services

| Service | Role | Port |
|---|---|---|
| `bookstore-webapp` | Thymeleaf storefront, OAuth2 login | `8080` |
| `api-gateway` | Routes requests, aggregates OpenAPI docs | `8989` |
| `catalog-service` | Book catalog CRUD | `8081` |
| `order-service` | Order processing, publishes events | `8082` |
| `notification-service` | Sends order emails via RabbitMQ events | `8083` |

Each service owns its own Postgres database; they only talk over REST (via the gateway) and RabbitMQ.

## Stack

Java 21 · Spring Boot 3 · Spring Data JPA · Spring Cloud Gateway · Spring Security (OAuth2) · PostgreSQL · RabbitMQ · Keycloak · Thymeleaf · Alpine.js · Bootstrap · Testcontainers · Prometheus/Loki/Tempo/Grafana

## Run it

```bash
git clone https://github.com/abhilash-panigrahi/KitaabVerse.git
cd KitaabVerse
task start_infra   # Postgres, RabbitMQ, Keycloak, MailHog
task start         # builds + runs all services in Docker
```

Or run services individually:

```bash
./mvnw -pl catalog-service spring-boot:run
./mvnw -pl order-service spring-boot:run
./mvnw -pl notification-service spring-boot:run
./mvnw -pl api-gateway spring-boot:run
./mvnw -pl bookstore-webapp spring-boot:run
```

| What | Where |
|---|---|
| Storefront | http://localhost:8080 |
| API Gateway / Swagger | http://localhost:8989 |
| RabbitMQ console | http://localhost:15672 (guest/guest) |
| MailHog | http://localhost:8025 |
| Keycloak | http://localhost:9191 (admin/admin1234) |

Monitoring stack: `task start_monitoring` → Grafana on http://localhost:3000 (admin/admin123).

## Test

```bash
./mvnw clean verify
```
