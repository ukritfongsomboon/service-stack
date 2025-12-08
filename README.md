# UkritStack 🚀

A comprehensive Docker Compose stack for running multiple backend services with monitoring. Includes databases (MongoDB, Redis, PostgreSQL), storage (MinIO), real-time messaging (Centrifugo), web UIs, and complete monitoring stack (Prometheus + Grafana).

## 📋 Prerequisites

- Docker Desktop (or Docker Engine)
- Docker Compose (v1.29 or higher)
- 4GB RAM minimum
- curl (for health checks)

## 🚀 Quick Start

```bash
# 1. Start all services
./start.sh

# 2. Test services health
./test.sh

# 3. Stop services (data preserved)
./stop.sh
```

**Note:** Data directories are automatically initialized on first start.

## 📊 Services & Port Assignments

All services use ports **18801-18817** for easy management and no standard port conflicts.

### 🗄️ Database Services

| Service | Port | Access | Credentials | Description |
|---------|------|--------|-------------|-------------|
| MongoDB | **18801** | `mongodb://admin:password123@localhost:18801/` | admin / password123 | Document Database |
| Mongo Express | **18802** | `http://localhost:18802` | admin / admin123 | MongoDB Web UI |
| Redis | **18803** | `redis://localhost:18803` | password: redis_password123 | In-Memory Cache |
| Redis Insight | **18804** | `http://localhost:18804` | (auto-configured) | Redis Web UI |
| PostgreSQL | **18805** | `postgresql://admin:postgres_password123@localhost:18805/ukritstack_db` | admin / postgres_password123 | Relational Database |
| Adminer | **18806** | `http://localhost:18806` | admin / postgres_password123 | PostgreSQL Web UI |

### 🏪 Storage Services

| Service | Port | Access | Credentials | Description |
|---------|------|--------|-------------|-------------|
| MinIO API | **18807** | `http://localhost:18807` | minioadmin / minio_password123 | Object Storage API |
| MinIO Console | **18808** | `http://localhost:18808` | minioadmin / minio_password123 | MinIO Web Console |

### 🔄 Real-time Services

| Service | Port | Access | Credentials | Description |
|---------|------|--------|-------------|-------------|
| Centrifugo | **18809** | `http://localhost:18809` | (configured via .env) | WebSocket Messaging |

### 📊 Monitoring Stack

| Service | Port | Access | Credentials | Description |
|---------|------|--------|-------------|-------------|
| Prometheus | **18810** | `http://localhost:18810` | (no authentication) | Metrics Collection |
| Grafana | **18811** | `http://localhost:18811` | admin / admin123 | Metrics Visualization |

### 📈 Metrics Exporters

| Service | Port | Access | Credentials | Description |
|---------|------|--------|-------------|-------------|
| MongoDB Exporter | **18812** | `http://localhost:18812/metrics` | (no authentication) | MongoDB Metrics |
| PostgreSQL Exporter | **18813** | `http://localhost:18813/metrics` | (no authentication) | PostgreSQL Metrics |
| Redis Exporter | **18814** | `http://localhost:18814/metrics` | (no authentication) | Redis Metrics |
| MinIO Exporter | **18815** | `http://localhost:18815/metrics` | (no authentication) | MinIO Metrics |
| Node Exporter | **18816** | `http://localhost:18816/metrics` | (no authentication) | Host Metrics |
| cAdvisor | **18817** | `http://localhost:18817` | (no authentication) | Container Metrics |

## 🔧 Configuration

Configuration is managed through `.env` file. Copy the configuration below to your `.env` file:

```env
# ============================================================================
# 🚀 UKRITSTACK ENVIRONMENT CONFIGURATION
# ============================================================================
# This file contains all environment variables for UkritStack services.
# Edit values as needed for your development environment.
# ⚠️  WARNING: Change all default passwords before using in production!
# ============================================================================

# ============================================================================
# 🗄️ DATABASE SERVICES
# ============================================================================

# ----------------------------------------------------------------------------
# MongoDB - Document Database
# ----------------------------------------------------------------------------
MONGO_VERSION=7.0
MONGO_PORT=18801
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=password123
MONGO_DATABASE=ukritstack

# ----------------------------------------------------------------------------
# Redis - In-Memory Cache Database
# ----------------------------------------------------------------------------
REDIS_VERSION=7-alpine
REDIS_PORT=18803
REDIS_PASSWORD=redis_password123

# ----------------------------------------------------------------------------
# PostgreSQL - Relational Database
# ----------------------------------------------------------------------------
POSTGRES_VERSION=15-alpine
POSTGRES_PORT=18805
POSTGRES_USER=admin
POSTGRES_PASSWORD=postgres_password123
POSTGRES_DB=ukritstack_db

# ============================================================================
# 🎨 DATABASE UI MANAGEMENT TOOLS
# ============================================================================

# ----------------------------------------------------------------------------
# Mongo Express - MongoDB Web UI
# ----------------------------------------------------------------------------
MONGO_EXPRESS_VERSION=latest
MONGO_EXPRESS_PORT=18802
MONGO_EXPRESS_USERNAME=admin
MONGO_EXPRESS_PASSWORD=admin123

# ----------------------------------------------------------------------------
# Redis Insight - Redis Web UI
# ----------------------------------------------------------------------------
REDIS_INSIGHT_VERSION=latest
REDIS_INSIGHT_PORT=18804

# ----------------------------------------------------------------------------
# Adminer - PostgreSQL Web UI (Multi-Database Support)
# ----------------------------------------------------------------------------
ADMINER_VERSION=latest
ADMINER_PORT=18806

# ============================================================================
# 🏪 STORAGE SERVICES
# ============================================================================

# ----------------------------------------------------------------------------
# MinIO - Object Storage (S3-Compatible)
# ----------------------------------------------------------------------------
MINIO_VERSION=latest
MINIO_PORT=18807
MINIO_CONSOLE_PORT=18808
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minio_password123

# ============================================================================
# 🔄 REAL-TIME SERVICES
# ============================================================================

# ----------------------------------------------------------------------------
# Centrifugo - Real-Time WebSocket Messaging Server
# ----------------------------------------------------------------------------
CENTRIFUGO_VERSION=v6
CENTRIFUGO_PORT=18809

# Token HMAC secret key (used for JWT token validation)
# ⚠️  Change this to a secure random string in production!
CENTRIFUGO_TOKEN_HMAC_SECRET_KEY=bbe7d157-a253-4094-9759-06a8236543f9

# API key for server-to-server communication
# ⚠️  Change this to a secure random string in production!
CENTRIFUGO_API_KEY=d7627bb6-2292-4911-82e1-615c0ed3eebb

# Admin panel configuration
CENTRIFUGO_ADMIN=true
CENTRIFUGO_ADMIN_PASSWORD=d0683813-0916-4c49-979f-0e08a686b727
CENTRIFUGO_ADMIN_SECRET=4e9eafcf-0120-4ddd-b668-8dc40072c78e

# Allowed origins for CORS (comma-separated, empty = allow all)
CENTRIFUGO_ALLOWED_ORIGINS=

# ============================================================================
# 📊 MONITORING STACK
# ============================================================================

# ----------------------------------------------------------------------------
# Prometheus - Metrics Collection and Storage
# ----------------------------------------------------------------------------
PROMETHEUS_VERSION=latest
PROMETHEUS_PORT=18810
PROMETHEUS_RETENTION=30d

# ----------------------------------------------------------------------------
# Grafana - Metrics Visualization and Dashboards
# ----------------------------------------------------------------------------
GRAFANA_VERSION=latest
GRAFANA_PORT=18811
GRAFANA_USER=admin
GRAFANA_PASSWORD=admin123

# ============================================================================
# 📈 METRICS EXPORTERS
# ============================================================================

# ----------------------------------------------------------------------------
# MongoDB Exporter - Monitors MongoDB Metrics
# ----------------------------------------------------------------------------
MONGODB_EXPORTER_IMAGE=percona/mongodb_exporter:0.47.2
MONGODB_EXPORTER_PORT=18812

# ----------------------------------------------------------------------------
# PostgreSQL Exporter - Monitors PostgreSQL Metrics
# ----------------------------------------------------------------------------
POSTGRES_EXPORTER_IMAGE=prometheuscommunity/postgres-exporter:latest
POSTGRES_EXPORTER_PORT=18813

# ----------------------------------------------------------------------------
# Redis Exporter - Monitors Redis Metrics
# ----------------------------------------------------------------------------
REDIS_EXPORTER_IMAGE=oliver006/redis_exporter:latest
REDIS_EXPORTER_PORT=18814

# ----------------------------------------------------------------------------
# MinIO Exporter - Monitors MinIO Metrics
# ----------------------------------------------------------------------------
MINIO_EXPORTER_IMAGE=joepll/minio-exporter:latest
MINIO_EXPORTER_PORT=18815

# ----------------------------------------------------------------------------
# Node Exporter - Host Machine Metrics (CPU, Memory, Disk)
# ----------------------------------------------------------------------------
NODE_EXPORTER_IMAGE=prom/node-exporter:latest
NODE_EXPORTER_PORT=18816

# ----------------------------------------------------------------------------
# cAdvisor - Docker Container Metrics
# ----------------------------------------------------------------------------
CADVISOR_IMAGE=gcr.io/cadvisor/cadvisor:latest
CADVISOR_PORT=18817

# ============================================================================
# END OF CONFIGURATION
# ============================================================================
```

**Security:** Default credentials are for development only. Change all passwords in `.env` for production use.

## 🧪 Available Scripts

### Start Services
```bash
./start.sh                      # Start all services
./start.sh mongodb redis        # Start specific services
./start.sh --interactive        # Interactive selection
./start.sh --list              # Show available services
```

### Test Services
```bash
./test.sh                      # Test all services health
```

Tests include:
- Database connectivity (MongoDB, Redis, PostgreSQL)
- Web UI availability (Mongo Express, Redis Insight, Adminer)
- Storage service health (MinIO, Centrifugo)
- Monitoring stack status (Prometheus, Grafana)

### Stop Services
```bash
./stop.sh                      # Stop all (data preserved)
```

## 📊 Monitoring & Dashboards

Access Grafana at `http://localhost:18811` (admin / admin123)

**Available Dashboards:**
- **System Overview** - CPU, Memory, Disk, Network, Container metrics
- **MinIO Dashboard** - Storage usage, S3 operations, errors, latency

**Prometheus Targets:**
- All database services (MongoDB, PostgreSQL, Redis)
- Storage services (MinIO)
- Host metrics (Node Exporter)
- Container metrics (cAdvisor)

**Data Retention:** 30 days (configurable via `PROMETHEUS_RETENTION` in .env)

## 📊 Common Docker Commands

```bash
# View status
docker-compose ps

# View logs
docker-compose logs -f                    # All services
docker-compose logs -f mongodb           # Specific service

# Execute commands
docker exec -it ukritstack_mongodb mongosh
docker exec -it ukritstack_redis redis-cli
docker exec -it ukritstack_postgres psql -U admin -d ukritstack_db

# Stop specific service
docker-compose stop mongodb

# Remove everything
docker-compose down -v                   # ⚠️ Data will be lost!
```

## 🗂️ Data Management

Data is stored in `./data/` using bind mounts:

```
./data/
├── mongodb/          # MongoDB data
├── redis/            # Redis data (AOF, RDB)
├── postgresql/       # PostgreSQL data
├── minio/            # MinIO objects
├── redis-insight/    # Redis Insight config
├── prometheus/       # Prometheus metrics (30d retention)
└── grafana/          # Grafana dashboards
```

### Backup & Restore

```bash
# Backup all data
tar -czf backup-$(date +%Y%m%d-%H%M%S).tar.gz ./data

# Backup specific service
tar -czf mongodb-backup-$(date +%Y%m%d).tar.gz ./data/mongodb

# Restore from backup
tar -xzf backup-TIMESTAMP.tar.gz
```

## ⚠️ Troubleshooting

### Services won't start

```bash
# Check port conflicts
lsof -i :18801-18817

# View error logs
docker-compose logs <service-name>

# Check container status
docker-compose ps
```

### Can't connect to service

1. Verify service is running: `docker-compose ps`
2. Check port in `.env` file
3. Verify credentials
4. Test from container: `docker exec -it ukritstack_<service> <test-command>`

### Out of disk space

```bash
# Clean Docker resources
docker system prune

# Check data directory size
du -sh ./data/*

# Remove old Prometheus data
rm -rf ./data/prometheus/*
```

### Service keeps restarting

```bash
# Check detailed logs
docker-compose logs --tail=100 <service-name>

# Inspect container
docker inspect ukritstack_<service-name>

# Check resource usage
docker stats
```

## 🔐 Security Best Practices

⚠️ **Default credentials are for DEVELOPMENT only!**

For production:

1. **Change all passwords** in `.env`
2. **Use environment-specific configs**:
   ```bash
   cp .env .env.production
   nano .env.production
   docker-compose --env-file .env.production up -d
   ```
3. **Don't commit `.env`** to version control
4. **Use Docker secrets** or orchestration tools (Kubernetes)
5. **Restrict network access** to containers
6. **Enable SSL/TLS** for all services
7. **Regular security updates** for Docker images

## 📁 Project Structure

```
.
├── configs/
│   ├── monitoring/
│   │   ├── prometheus.yml           # Prometheus config
│   │   └── grafana/provisioning/    # Grafana dashboards
│   └── centrifugo/
│       └── config.json              # Centrifugo config
├── data/                            # Persistent data (bind mounts)
├── docker-compose.yml               # Service definitions
├── .env                             # Environment variables
├── start.sh                         # Start services
├── stop.sh                          # Stop services
├── test.sh                          # Test services
├── init-data-dirs.sh               # Initialize data directories
└── README.md                        # This file
```

## 🔗 Service Documentation

- [Docker Compose](https://docs.docker.com/compose/)
- [MongoDB](https://docs.mongodb.com/)
- [Redis](https://redis.io/documentation)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [MinIO](https://docs.min.io/)
- [Centrifugo](https://centrifugal.dev/)
- [Prometheus](https://prometheus.io/docs/)
- [Grafana](https://grafana.com/docs/)

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report issues
- Suggest improvements
- Submit pull requests
- Share your custom configurations

## 📝 License

This project is provided as-is for development purposes.

---

**Version:** 1.0.0
**Last Updated:** 2025-12-08
**Happy Coding!** 🎉
