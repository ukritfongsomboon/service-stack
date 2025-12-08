# UkritStack Monitoring Guide

Complete monitoring stack for MongoDB, PostgreSQL, Redis, and MinIO using Prometheus and Grafana.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Grafana (Port 3000)                      │
│              Visualize Metrics & Create Alerts              │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                   Prometheus (Port 9090)                    │
│              Collect & Store Metrics (30 days)              │
└──────────────────────────┬──────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┬───────────────┐
        │                  │                  │               │
   ┌────▼─────┐    ┌──────▼──────┐   ┌──────▼──────┐  ┌─────▼──────┐
   │ MongoDB  │    │ PostgreSQL  │   │    Redis    │  │   MinIO    │
   │ Exporter │    │  Exporter   │   │  Exporter   │  │  Exporter  │
   │(Port9216)│    │  (Port 9187)│   │ (Port 9121) │  │(Port 9290) │
   └─────┬────┘    └──────┬──────┘   └──────┬──────┘  └─────┬──────┘
         │                 │                 │              │
   ┌─────▼─────┐    ┌──────▼──────┐   ┌──────▼──────┐  ┌─────▼──────┐
   │  MongoDB  │    │ PostgreSQL  │   │    Redis    │  │   MinIO    │
   │ (Port 27017)   │  (Port 5432)│   │  (Port 6379)│  │(Port 9000) │
   └───────────┘    └─────────────┘   └─────────────┘  └────────────┘
```

## Getting Started

### 1. Initialize Monitoring Data Directories

The monitoring setup will automatically initialize the required directories when you start the services.

### 2. Start Monitoring Stack

To start only the monitoring services (without the main services):

```bash
# Start Prometheus, Grafana, and all exporters
./start.sh prometheus grafana mongodb-exporter postgres-exporter redis-exporter minio-exporter
```

Or to start everything together:

```bash
# Start all services including monitoring
./start.sh --all
```

### 3. Access Monitoring Tools

Once the services are running, you can access:

| Service | URL | Credentials |
|---------|-----|-------------|
| **Grafana** | http://localhost:3000 | admin / admin123 |
| **Prometheus** | http://localhost:9090 | (No auth) |
| **MongoDB Exporter** | http://localhost:9216/metrics | (Metrics endpoint) |
| **PostgreSQL Exporter** | http://localhost:9187/metrics | (Metrics endpoint) |
| **Redis Exporter** | http://localhost:9121/metrics | (Metrics endpoint) |
| **MinIO Exporter** | http://localhost:9290/metrics | (Metrics endpoint) |

## Available Dashboards

After logging into Grafana, the following dashboards will be automatically provisioned:

### 1. **UkritStack Overview**
- Shows the status of all services
- Displays active connections for each service
- Shows overall uptime metrics

### 2. **MongoDB Monitoring**
- Connection counts
- Operations per second
- Memory usage
- Network I/O (bytes in/out)

### 3. **PostgreSQL Monitoring**
- Active connections
- Transaction rates
- Database size
- Cache hit ratio

### 4. **Redis Monitoring**
- Connected clients
- Commands per second
- Memory usage (used vs max)
- Cache hit rate

### 5. **MinIO Monitoring**
- Total storage capacity
- Used storage
- Available storage
- Storage usage percentage
- Network I/O
- API request rates

## Configuration Files

### Prometheus Configuration
**File:** `monitoring/prometheus.yml`

Defines:
- Global scrape interval (15 seconds)
- All scrape targets (exporters)
- Metric retention policy (30 days by default)

To modify retention time, edit `.env`:
```bash
PROMETHEUS_RETENTION=30d  # Options: 1d, 7d, 30d, 90d, 1y, etc.
```

### Grafana Provisioning
**Directory:** `monitoring/grafana/provisioning/`

Contains:
- `datasources/prometheus.yml` - Prometheus data source configuration
- `dashboards/dashboards.yml` - Dashboard provisioning config
- `dashboards/*-dashboard.json` - Actual dashboard definitions

Dashboards are automatically loaded when Grafana starts.

## Environment Variables

Add to `.env` file to customize:

```bash
# Prometheus
PROMETHEUS_VERSION=latest
PROMETHEUS_PORT=9090
PROMETHEUS_RETENTION=30d

# Exporters
MONGODB_EXPORTER_IMAGE=percona/mongodb_exporter:latest
MONGODB_EXPORTER_PORT=9216

POSTGRES_EXPORTER_IMAGE=prometheuscommunity/postgres-exporter:latest
POSTGRES_EXPORTER_PORT=9187

REDIS_EXPORTER_IMAGE=oliver006/redis_exporter:latest
REDIS_EXPORTER_PORT=9121

MINIO_EXPORTER_IMAGE=minio/minio-exporter:latest
MINIO_EXPORTER_PORT=9290

# Grafana
GRAFANA_VERSION=latest
GRAFANA_PORT=3000
GRAFANA_USER=admin
GRAFANA_PASSWORD=admin123
```

## Common Tasks

### Change Grafana Password

Edit `.env`:
```bash
GRAFANA_PASSWORD=your_new_password
```

Then restart Grafana:
```bash
docker-compose up -d grafana
```

### Increase Prometheus Retention

Edit `.env`:
```bash
PROMETHEUS_RETENTION=90d
```

Then restart Prometheus:
```bash
docker-compose up -d prometheus
```

### View Prometheus Metrics

1. Open http://localhost:9090
2. Click "Graph" tab
3. Enter any metric name in the query box, e.g.:
   - `mongodb_connections`
   - `pg_stat_activity_count`
   - `redis_connected_clients`
   - `minio_total_storage_bytes`

### Create Custom Dashboard

1. Access Grafana at http://localhost:3000
2. Click "+" → "Dashboard"
3. Add panels with queries like:
   ```
   rate(mongodb_mongod_op_counters_total[5m])
   pg_stat_database_tup_fetched
   redis_commands_processed_total
   minio_s3_requests_total
   ```

### View Exporter Metrics Directly

Check raw metrics from each exporter:

```bash
# MongoDB
curl http://localhost:9216/metrics

# PostgreSQL
curl http://localhost:9187/metrics

# Redis
curl http://localhost:9121/metrics

# MinIO
curl http://localhost:9290/metrics
```

## Troubleshooting

### Prometheus not collecting metrics

1. Check Prometheus targets: http://localhost:9090/targets
2. Verify exporters are running: `docker-compose ps`
3. Check exporter logs:
   ```bash
   docker-compose logs mongodb-exporter
   docker-compose logs postgres-exporter
   docker-compose logs redis-exporter
   docker-compose logs minio-exporter
   ```

### Dashboards not showing in Grafana

1. Wait 30-60 seconds for Grafana to load dashboards
2. Refresh the browser page
3. Check Grafana logs:
   ```bash
   docker-compose logs grafana
   ```

### No metrics in Prometheus

1. Verify target services are running:
   ```bash
   docker-compose ps mongodb postgres redis minio
   ```

2. Check network connectivity:
   ```bash
   docker-compose exec prometheus ping mongodb
   docker-compose exec prometheus ping postgres
   docker-compose exec prometheus ping redis
   docker-compose exec prometheus ping minio
   ```

### Exporter connection errors

1. Verify credentials in `.env` match service configurations
2. Check exporter logs for connection errors
3. Ensure services are accessible (check firewall/security groups if remote)

## Performance Tuning

### Reduce Prometheus Storage Usage

Edit `docker-compose.yml` and adjust retention:
```yaml
command:
  - '--storage.tsdb.retention.time=7d'  # Reduce from 30d to 7d
```

### Increase Scrape Interval

If you don't need real-time data, edit `monitoring/prometheus.yml`:
```yaml
global:
  scrape_interval: 30s  # Change from 15s to 30s
  evaluation_interval: 30s
```

## Next Steps

1. **Set up Alerting:** Configure alert rules in Prometheus
2. **Export Dashboards:** Share dashboards with your team
3. **Custom Metrics:** Instrument your application code with Prometheus libraries
4. **Backup:** Regularly backup Prometheus data in `./data/prometheus/`

## Useful Metric Queries

### MongoDB
```promql
# Connection count
mongodb_connections

# Operations per second
rate(mongodb_mongod_op_counters_total[5m])

# Memory usage
mongodb_memory_bytes
```

### PostgreSQL
```promql
# Active connections
pg_stat_activity_count

# Rows scanned per second
rate(pg_stat_user_tables_seq_tup_read[5m])

# Database size
pg_database_size_bytes
```

### Redis
```promql
# Connected clients
redis_connected_clients

# Commands per second
rate(redis_commands_processed_total[5m])

# Memory usage
redis_memory_used_bytes

# Hit rate
redis_keyspace_hits_total / (redis_keyspace_hits_total + redis_keyspace_misses_total)
```

### MinIO
```promql
# Storage usage
minio_used_storage_bytes / minio_total_storage_bytes

# Requests per second
rate(minio_s3_requests_total[5m])

# Network I/O
rate(minio_network_recv_bytes_total[5m])
```

## Support

For issues or questions:
1. Check the logs: `docker-compose logs [service]`
2. Verify service health: `./start.sh` shows status
3. Review Prometheus targets: http://localhost:9090/targets
