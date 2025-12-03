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

## 📊 แสดงผลการตรวจสอบ (Monitoring Stack)

| บริการ | ชื่อคอนเทนเนอร์ | พอร์ต | การเข้าถึง |
|--------|-----------------|-------|-----------|
| **Prometheus** | `ukritstack_prometheus` | 9090 | `http://localhost:9090` |
| **Grafana** | `ukritstack_grafana` | 3000 | `http://localhost:3000` |
| **cAdvisor** | `ukritstack_cadvisor` | 8082 | `http://localhost:8082` |
| **Node Exporter** | `ukritstack_node_exporter` | 9100 | `http://localhost:9100` |
| **MongoDB Exporter** | `ukritstack_mongodb_exporter` | 9216 | `http://localhost:9216` |
| **PostgreSQL Exporter** | `ukritstack_postgres_exporter` | 9187 | `http://localhost:9187` |
| **Redis Exporter** | `ukritstack_redis_exporter` | 9121 | `http://localhost:9121` |

### การเข้าถึง Grafana
```
URL: http://localhost:3000
ชื่อผู้ใช้: admin
รหัสผ่าน: admin123
```

### แดชบอร์ดที่มีให้ใช้งาน
1. **Overview Dashboard** - เมตริกระบบ, สถานะคอนเทนเนอร์, เวลาทำงาน (วัน/ชั่วโมง/นาที/วินาที)
2. **MinIO Dashboard** - เมตริกการจัดเก็บข้อมูล (CPU, Memory, Network, Errors, Latency)

### เมตริกพื้นฐานที่ตรวจสอบ
- **ระบบ**: การใช้งาน CPU, หน่วยความจำ, พื้นที่ดิสก์, เวลาทำงาน
- **เครือข่าย**: แบนด์วิดท์, ปริมาณการไป่อ่อต่อคอนเทนเนอร์
- **คอนเทนเนอร์**: CPU, หน่วยความจำ, เครือข่ายต่อคอนเทนเนอร์
- **พื้นที่เก็บข้อมูล**: สถานะความเป็นปกติของ MinIO, อัตราการร้องขอ, ข้อผิดพลาด
- **ประสิทธิภาพ**: ความล่าช้า, ปริมาณการร้องขอ

### การเข้าถึงบริการการตรวจสอบ

#### Prometheus
```bash
# URL
http://localhost:9090

# คุณสมบัติ
- การเก็บข้อมูลเมตริกและการค้นหา
- การจัดการกฎการแจ้งเตือน
- การค้นพบบริการ
- การเก็บข้อมูลในอดีต (30 วัน)

# ตัวอย่างการสอบถาม:
node_cpu_seconds_total              # เมตริก CPU ของโฮสต์
container_memory_usage_bytes        # หน่วยความจำของคอนเทนเนอร์
container_network_receive_bytes_total # ปริมาณการไป่อ่อเครือข่าย
```

#### Grafana
```bash
# URL
http://localhost:3000

# การเข้าสู่ระบบเริ่มต้น
ชื่อผู้ใช้: admin
รหัสผ่าน: admin123

# แดชบอร์ดที่มีให้ใช้งาน:
1. UkritStack Overview
   - สถานะความเป็นปกติของระบบ
   - การใช้งาน CPU, Memory, Disk
   - ปริมาณการไป่อ่อเครือข่าย
   - เมตริกคอนเทนเนอร์
   - เวลาทำงาน (วัน, ชั่วโมง, นาที, วินาที)

2. MinIO - การตรวจสอบพื้นที่เก็บข้อมูล
   - การใช้พื้นที่เก็บข้อมูล (ทั้งหมด, ใช้แล้ว, ว่าง)
   - เปอร์เซ็นต์พื้นที่เก็บข้อมูล
   - อัตราการร้องขอ S3
   - อัตราข้อผิดพลาด (4xx, 5xx)
   - ความล่าช้าของการร้องขอ
   - แบนด์วิดท์เครือข่าย
```

#### การตั้งค่าการสกัด Prometheus
เป้าหมายที่กำหนดค่าไว้ใน `monitoring/prometheus.yml`:
- **prometheus** - การตรวจสอบตัวเอง Prometheus
- **mongodb** - เมตริก MongoDB ผ่าน exporter
- **postgresql** - เมตริก PostgreSQL ผ่าน exporter
- **redis** - เมตริก Redis ผ่าน exporter
- **cadvisor** - เมตริกคอนเทนเนอร์ (CPU, Memory, Network)
- **node** - เมตริกเครื่องโฮสต์
- **minio** - เมตริกการจัดเก็บข้อมูล MinIO (หากเปิดใช้งาน exporter)

### การตั้งค่าการแจ้งเตือนแบบกำหนดเอง

แก้ไข `monitoring/prometheus.yml` เพื่อเพิ่มกฎการแจ้งเตือน:
```yaml
groups:
  - name: service_alerts
    rules:
      - alert: HighCPUUsage
        expr: rate(container_cpu_usage_seconds_total[5m]) > 0.8
        for: 5m
        annotations:
          summary: "ตรวจพบการใช้งาน CPU สูง"
```

### รายละเอียดการตั้งค่า Exporter

#### MongoDB Exporter
- **พอร์ต**: 9216
- **การเชื่อมต่อ**: เชื่อมต่อไปยัง `mongodb:27017` ด้วยข้อมูลรับรอง admin
- **เมตริก**: การดำเนินการในฐานข้อมูล, การเชื่อมต่อ, การจัดเก็บข้อมูล

#### PostgreSQL Exporter
- **พอร์ต**: 9187
- **การเชื่อมต่อ**: เชื่อมต่อไปยัง `postgres:5432`
- **เมตริก**: ขนาดฐานข้อมูล, ประสิทธิภาพการค้นหา, การเชื่อมต่อ

#### Redis Exporter
- **พอร์ต**: 9121
- **การเชื่อมต่อ**: เชื่อมต่อไปยัง `redis:6379` ด้วยรหัสผ่าน
- **เมตริก**: การใช้หน่วยความจำ, คีย์, การดำเนินการ

#### Node Exporter
- **พอร์ต**: 9100
- **เมตริก**: CPU โฮสต์, หน่วยความจำ, ดิสก์, เครือข่าย
- **ความครอบคลุม**: เมตริกทั่วทั้งระบบ

#### cAdvisor
- **พอร์ต**: 8082
- **เมตริก**: CPU, หน่วยความจำ, เครือข่าย, I/O ระดับคอนเทนเนอร์
- **หมายเหตุ**: ให้เมตริกคอนเทนเนอร์แบบเรียลไทม์

### การดูประวัติเมตริก

1. **แนวโน้มระยะสั้น** (ชั่วโมงที่แล้ว):
   - ใช้ Grafana พร้อมช่วงเวลาเริ่มต้น
   - โหลดแดชบอร์ดใหม่เพื่อดูการอัปเดตล่าสุด

2. **การวิเคราะห์ในอดีต** (30 วันที่แล้ว):
   - Prometheus เก็บข้อมูลไว้ 30 วัน
   - ใช้ Prometheus UI เพื่อค้นหาข้อมูลในอดีต
   - ส่งออกข้อมูลเพื่อการวิเคราะห์

3. **ส่งออกเมตริก**:
```bash
# ส่งออกจาก Prometheus API
curl 'http://localhost:9090/api/v1/query_range?query=container_cpu_usage_seconds_total&start=2025-12-01T00:00:00Z&end=2025-12-02T00:00:00Z&step=60s'
```

### คำแนะนำประสิทธิภาพ

1. **ประสิทธิภาพของแดชบอร์ด Grafana**:
   - ลดช่วงเวลาการค้นหาเพื่อให้โหลดเร็วขึ้น
   - ใช้การสอบถามการรวมข้อมูล (aggregation) เพื่อประสิทธิภาพที่ดีขึ้น
   - จำกัดจำนวนของชุดข้อมูลเวลา (time-series) ในแผง

2. **การเพิ่มประสิทธิภาพของการสอบถาม Prometheus**:
   - ใช้ rate() สำหรับตัวนับ (counters)
   - ใช้เครื่องหมายการจับคู่เฉพาะ (label matchers)
   - หลีกเลี่ยงเมตริกด้วยค่า cardinality สูง

3. **การจัดการพื้นที่เก็บข้อมูล**:
   - การเก็บข้อมูลของ Prometheus ถูกตั้งค่าเป็น 30 วัน
   - ปรับ `PROMETHEUS_RETENTION` ใน .env หากจำเป็น
   - ตรวจสอบพื้นที่ดิสก์: `df -h ./data/prometheus`

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
