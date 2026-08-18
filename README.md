# KitaabVerse 

A Spring Boot microservices project for an online bookstore — split into independently deployable services communicating over REST and messaging, secured with OAuth2/OIDC, and backed by full observability tooling.

## Services

| Service | Role | Port |
|---|---|---|
| `bookstore-webapp` | Thymeleaf storefront, OAuth2 login | `8080` |
| `api-gateway` | Routes requests, aggregates OpenAPI docs | `8989` |
| `catalog-service` | Book catalog CRUD | `8081` |
| `order-service` | Order processing, publishes events | `8082` |
| `notification-service` | Sends order emails via RabbitMQ events | `8083` |

Each service owns its own Postgres database; they only talk over REST (via the gateway) and RabbitMQ.

## Tech stack
 
- **Java 25** / **Spring Boot 3** with **Spring Cloud Gateway**
- **PostgreSQL 18** — one database per service
- **RabbitMQ** — async order events
- **Keycloak** — OAuth2/OIDC authentication
- **MailHog** — catches dev email
- **Prometheus, Loki, Tempo, Grafana, Promtail** — metrics, logs, tracing
- **Testcontainers + JUnit 5** — integration tests against real containers

## Architecture

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/76b95ca5-b933-46d9-af7e-58252f077ac6" />

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
