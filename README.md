# UkritStack 🚀

A comprehensive Docker Compose setup for running multiple backend services with a single command. Includes MongoDB, Redis, PostgreSQL, MinIO with web UI management tools: Mongo Express, Redis Insight, and Adminer.

## 📋 Prerequisites

- Docker Desktop (or Docker Engine)
- Docker Compose (v1.29 or higher)
- 4GB RAM minimum
- curl (for health checks)

## 🔧 Quick Start

### 1. Initialize Data Directories (First time only)
```bash
./init-data-dirs.sh
```

### 2. Start All Services
```bash
./start.sh
```
**Note:** The `start.sh` script will automatically initialize data directories if they don't exist.

### 3. Test Services
```bash
./test.sh
```

### 4. Stop Services
```bash
./stop.sh
```

## 📦 Services Included

| Service | Container Name | Port | Access | Credentials |
|---------|----------------|------|--------|-------------|
| **MongoDB** | `ukritstack_mongodb` | 27017 | `mongodb://admin:password123@localhost:27017/` | admin / password123 |
| **Mongo Express** | `ukritstack_mongo_express` | 8081 | `http://localhost:8081` | admin / admin123 |
| **Redis** | `ukritstack_redis` | 6379 | `redis://localhost:6379` | (password: redis_password123) |
| **Redis Insight** | `ukritstack_redis_insight` | 5540 | `http://localhost:5540` | (auto-configured) |
| **PostgreSQL** | `ukritstack_postgres` | 5432 | `postgresql://admin:postgres_password123@localhost:5432/ukritstack_db` | admin / postgres_password123 |
| **Adminer** | `ukritstack_adminer` | 8080 | `http://localhost:8080` | admin / postgres_password123 |
| **MinIO** | `ukritstack_minio` | 9000, 9001 | API: `http://localhost:9000` Console: `http://localhost:9001` | minioadmin / minio_password123 |

## 📊 Monitoring Stack

| Service | Container Name | Port | Access |
|---------|----------------|------|--------|
| **Prometheus** | `ukritstack_prometheus` | 9090 | `http://localhost:9090` |
| **Grafana** | `ukritstack_grafana` | 3000 | `http://localhost:3000` |
| **cAdvisor** | `ukritstack_cadvisor` | 8082 | `http://localhost:8082` |
| **Node Exporter** | `ukritstack_node_exporter` | 9100 | `http://localhost:9100` |
| **MongoDB Exporter** | `ukritstack_mongodb_exporter` | 9216 | `http://localhost:9216` |
| **PostgreSQL Exporter** | `ukritstack_postgres_exporter` | 9187 | `http://localhost:9187` |
| **Redis Exporter** | `ukritstack_redis_exporter` | 9121 | `http://localhost:9121` |

### Grafana Access
```
URL: http://localhost:3000
Username: admin
Password: admin123
```

### Available Dashboards
1. **Overview Dashboard** - System metrics, container status, uptime (days/hours/minutes/seconds)
2. **MinIO Dashboard** - Object storage metrics (CPU, Memory, Network, Errors, Latency)

### Core Metrics Monitored
- **System**: CPU Usage, Memory, Disk Space, Uptime
- **Network**: Bandwidth, Traffic per Container
- **Containers**: CPU, Memory, Network per Container
- **Storage**: MinIO health, request rates, errors
- **Performance**: Latency, request throughput

### Accessing Monitoring Services

#### Prometheus
```bash
# URL
http://localhost:9090

# Features
- Metrics storage and querying
- Alert rule management
- Service discovery
- Historical data retention (30 days)

# Example queries:
node_cpu_seconds_total              # Host CPU metrics
container_memory_usage_bytes        # Container memory
container_network_receive_bytes_total # Network traffic
```

#### Grafana
```bash
# URL
http://localhost:3000

# Default Login
Username: admin
Password: admin123

# Available Dashboards:
1. UkritStack Overview
   - System health status
   - CPU, Memory, Disk usage
   - Network traffic
   - Container metrics
   - Uptime (Days, Hours, Minutes, Seconds)

2. MinIO - Object Storage Monitoring
   - Storage usage (Total, Used, Free)
   - Storage percentage
   - S3 request rates
   - Error rates (4xx, 5xx)
   - Request latency
   - Network bandwidth
```

#### Prometheus Scrape Configuration
Configured targets in `monitoring/prometheus.yml`:
- **prometheus** - Prometheus self-monitoring
- **mongodb** - MongoDB metrics via exporter
- **postgresql** - PostgreSQL metrics via exporter
- **redis** - Redis metrics via exporter
- **cadvisor** - Container metrics (CPU, Memory, Network)
- **node** - Host machine metrics
- **minio** - MinIO storage metrics (if exporter enabled)

### Setting Up Custom Alerts

Edit `monitoring/prometheus.yml` to add alert rules:
```yaml
groups:
  - name: service_alerts
    rules:
      - alert: HighCPUUsage
        expr: rate(container_cpu_usage_seconds_total[5m]) > 0.8
        for: 5m
        annotations:
          summary: "High CPU usage detected"
```

### Exporter Configuration Details

#### MongoDB Exporter
- **Port**: 9216
- **Query**: Connects to `mongodb:27017` with admin credentials
- **Metrics**: Database operations, connections, storage

#### PostgreSQL Exporter
- **Port**: 9187
- **Query**: Connects to `postgres:5432`
- **Metrics**: Database size, query performance, connections

#### Redis Exporter
- **Port**: 9121
- **Query**: Connects to `redis:6379` with password
- **Metrics**: Memory usage, keys, operations

#### Node Exporter
- **Port**: 9100
- **Metrics**: Host CPU, Memory, Disk, Network
- **Coverage**: System-wide metrics

#### cAdvisor
- **Port**: 8082
- **Metrics**: Container-level CPU, Memory, Network, I/O
- **Note**: Provides real-time container metrics

### Viewing Metrics History

1. **Short-term trends** (last hour):
   - Use Grafana with default time range
   - Reload dashboard to see latest updates

2. **Historical analysis** (last 30 days):
   - Prometheus retains data for 30 days
   - Use Prometheus UI to query historical data
   - Export data for analysis

3. **Export Metrics**:
```bash
# Export from Prometheus API
curl 'http://localhost:9090/api/v1/query_range?query=container_cpu_usage_seconds_total&start=2025-12-01T00:00:00Z&end=2025-12-02T00:00:00Z&step=60s'
```

### Performance Tips

1. **Grafana Dashboard Performance**:
   - Reduce query time range for faster loads
   - Use aggregation queries for better performance
   - Limit the number of time-series on a panel

2. **Prometheus Query Optimization**:
   - Use rate() for counters
   - Use specific label matchers
   - Avoid too many cardinality metrics

3. **Storage Management**:
   - Prometheus retention is set to 30 days
   - Adjust `PROMETHEUS_RETENTION` in .env if needed
   - Monitor disk space: `df -h ./data/prometheus`

## 🔐 Configuration

All configuration is stored in `.env` file. Edit values as needed:

```env
# MongoDB Configuration
MONGO_VERSION=7.0
MONGO_PORT=27017
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=password123
MONGO_DATABASE=ukritstack

# Redis Configuration
REDIS_VERSION=7-alpine
REDIS_PORT=6379
REDIS_PASSWORD=redis_password123

# PostgreSQL Configuration
POSTGRES_VERSION=15-alpine
POSTGRES_PORT=5432
POSTGRES_USER=admin
POSTGRES_PASSWORD=postgres_password123
POSTGRES_DB=ukritstack_db

# MinIO Configuration
MINIO_VERSION=latest
MINIO_PORT=9000
MINIO_CONSOLE_PORT=9001
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minio_password123

# Mongo Express Configuration
MONGO_EXPRESS_VERSION=latest
MONGO_EXPRESS_PORT=8081
MONGO_EXPRESS_USERNAME=admin
MONGO_EXPRESS_PASSWORD=admin123

# Redis Insight Configuration
REDIS_INSIGHT_VERSION=latest
REDIS_INSIGHT_PORT=5540

# Adminer Configuration
ADMINER_VERSION=latest
ADMINER_PORT=8080
```

## 🧪 Available Scripts

### `start.sh` - Start Services
Starts all Docker containers and displays service endpoints.

```bash
./start.sh
```

**Output includes:**
- Container status
- Service endpoints
- Health check status

### `stop.sh` - Stop Services
Stops all running containers. You'll be prompted to choose whether to keep or remove volumes.

```bash
./stop.sh
```

**Options:**
- Keep volumes (data persisted) - Default
- Remove volumes (data deleted)

### `test.sh` - Test All Services
Tests connectivity and health of all services with detailed status report.

```bash
./test.sh
```

**Tests:**
- ✅ MongoDB connection
- ✅ Mongo Express availability
- ✅ Redis connection
- ✅ PostgreSQL connection
- ✅ MinIO health check

**Features:**
- Container status overview
- Service endpoint list
- Option to view detailed logs

## 🌐 Service Access Examples

### MongoDB
```bash
# Connect via mongodb client
mongosh mongodb://admin:password123@localhost:27017/

# Or use Mongo Express Web UI
# http://localhost:8081
# Username: admin
# Password: admin123
```

### Redis
```bash
# Connect via redis-cli
redis-cli -p 6379 -a redis_password123

# Test connection
redis-cli ping

# Or use Redis Insight Web UI
# http://localhost:5540
# (Redis connection is auto-configured)
```

### Redis Insight
```bash
# Access Web UI
# http://localhost:5540
#
# Features:
# - Visual data browser
# - Key-value explorer
# - Performance analysis
# - Command execution
```

### PostgreSQL
```bash
# Connect via psql
psql -h localhost -U admin -d ukritstack_db

# Password: postgres_password123

# Or use Adminer Web UI
# http://localhost:8080
# Server: postgres
# Username: admin
# Password: postgres_password123
# Database: ukritstack_db
```

### Adminer
```bash
# Access Web UI
# http://localhost:8080
#
# Features:
# - Multi-database support (PostgreSQL, MySQL, SQLite, etc.)
# - SQL query execution
# - Table management
# - Data export/import
#
# Default connection:
# Server: postgres
# Username: admin
# Password: postgres_password123
# Database: ukritstack_db
```

### MinIO
```bash
# Access Web Console
# http://localhost:9001
# Username: minioadmin
# Password: minio_password123

# Access API
# http://localhost:9000
```

## 📊 Common Docker Commands

### View container status
```bash
docker-compose ps
```

### View real-time logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f mongodb
docker-compose logs -f mongo-express
docker-compose logs -f redis
docker-compose logs -f redis-insight
docker-compose logs -f postgres
docker-compose logs -f adminer
docker-compose logs -f minio
```

### Execute commands in containers
```bash
# MongoDB
docker exec -it ukritstack_mongodb mongosh --eval "db.runCommand('ping')"

# Redis
docker exec -it ukritstack_redis redis-cli ping

# PostgreSQL
docker exec -it ukritstack_postgres psql -U admin -d ukritstack_db -c "SELECT NOW();"
```

### Stop specific service
```bash
docker-compose stop mongodb
docker-compose stop redis
docker-compose stop postgres
docker-compose stop minio
docker-compose stop mongo-express
```

### Remove everything (containers + volumes)
```bash
docker-compose down -v
```

## 🔍 Health Checks

All services include health checks configured in `docker-compose.yml`. Docker automatically restarts unhealthy containers.

```bash
# View health status
docker ps --format "table {{.Names}}\t{{.Status}}"
```

## 🗂️ Volume Management

Data is persisted using **bind mounts** to local directories in `./data/`. This makes it easy to access, backup, and migrate data.

### Directory Structure

```
./data/
├── mongodb/
│   ├── db/              ← MongoDB data files
│   └── config/          ← MongoDB configuration
├── redis/               ← Redis data files (AOF, RDB)
├── redis-insight/       ← Redis Insight configuration
├── postgresql/          ← PostgreSQL data files
└── minio/               ← MinIO object storage
```

### Accessing Data Files

```bash
# View all data
ls -la ./data

# View specific service data
ls -la ./data/mongodb
ls -la ./data/postgresql
ls -la ./data/redis
ls -la ./data/minio
```

### Backup Data

```bash
# Backup all data
tar -czf backup-$(date +%Y%m%d-%H%M%S).tar.gz ./data

# Backup specific service
tar -czf mongodb-backup-$(date +%Y%m%d).tar.gz ./data/mongodb
```

### Restore Data

```bash
# Restore from backup
tar -xzf backup-TIMESTAMP.tar.gz
```

### Clean Data

```bash
# Remove all data (CAUTION: Data will be lost!)
rm -rf ./data

# Remove specific service data
rm -rf ./data/mongodb
rm -rf ./data/postgresql
```

## ⚠️ Troubleshooting

### Services won't start
```bash
# Check if ports are already in use
lsof -i :27017  # MongoDB
lsof -i :8081   # Mongo Express
lsof -i :6379   # Redis
lsof -i :5540   # Redis Insight
lsof -i :5432   # PostgreSQL
lsof -i :8080   # Adminer
lsof -i :9000   # MinIO
lsof -i :9001   # MinIO Console

# View error logs
docker-compose logs <service-name>
```

### Can't connect to service
1. Verify service is running: `docker-compose ps`
2. Check if port is correct in .env
3. Verify credentials
4. Test from within container:
```bash
docker exec -it ukritstack_mongodb mongosh --eval "db.runCommand('ping')"
```

### Out of disk space
```bash
# Remove unused Docker resources
docker system prune

# Remove all volumes (WARNING: data loss)
docker volume prune
```

### Service keeps restarting
```bash
# Check service logs
docker-compose logs --tail=50 <service-name>

# Inspect container
docker inspect ukritstack_<service-name>
```

## 🔐 Security Notes

⚠️ **IMPORTANT:** The default credentials in `.env` are for development only.

For production:
1. Change all passwords in `.env`
2. Use environment-specific `.env` files
3. Don't commit `.env` to version control
4. Use Docker secrets or container orchestration (K8s) for secrets management
5. Restrict network access to containers
6. Use strong, unique passwords

### Example production setup
```bash
# Create .env.production
cp .env .env.production

# Edit with secure values
nano .env.production

# Use specific env file
docker-compose --env-file .env.production up -d
```

## 📁 Project Structure

```
.
├── docker-compose.yml    # Docker Compose configuration
├── .env                  # Environment variables
├── start.sh             # Start services script
├── stop.sh              # Stop services script
├── test.sh              # Test services script
└── README.md            # This file
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Redis Documentation](https://redis.io/documentation)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MinIO Documentation](https://docs.min.io/)
- [Mongo Express Documentation](https://github.com/mongo-express/mongo-express)

## 🤝 Contributing

Feel free to modify configurations and scripts to suit your needs.

## 📝 License

This project is provided as-is for development purposes.

---

**Last Updated:** 2025-12-03

**Happy Coding!** 🎉
