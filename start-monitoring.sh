#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  📊 UkritStack Monitoring Quick Start${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Check if monitoring guide exists
if [ ! -f ./monitoring/MONITORING_GUIDE.md ]; then
    echo -e "${RED}❌ Monitoring configuration not found${NC}"
    echo -e "${YELLOW}Make sure you're in the UkritStack root directory${NC}"
    exit 1
fi

# Check .env file
if [ ! -f .env ]; then
    echo -e "${RED}❌ .env file not found${NC}"
    exit 1
fi

source .env

# Show what will be started
echo -e "${YELLOW}📌 Starting Monitoring Stack with:${NC}"
echo -e "   ${GREEN}✓${NC} Prometheus (http://localhost:${PROMETHEUS_PORT})"
echo -e "   ${GREEN}✓${NC} Grafana (http://localhost:${GRAFANA_PORT})"
echo -e "   ${GREEN}✓${NC} MongoDB Exporter (http://localhost:${MONGODB_EXPORTER_PORT})"
echo -e "   ${GREEN}✓${NC} PostgreSQL Exporter (http://localhost:${POSTGRES_EXPORTER_PORT})"
echo -e "   ${GREEN}✓${NC} Redis Exporter (http://localhost:${REDIS_EXPORTER_PORT})"
echo -e "   ${GREEN}✓${NC} MinIO Exporter (http://localhost:${MINIO_EXPORTER_PORT})\n"

# Check if core services are running
echo -e "${YELLOW}🔍 Checking if core services are running...${NC}\n"

missing_services=()

if ! docker-compose ps mongodb | grep -q "running"; then
    missing_services+=("MongoDB")
fi

if ! docker-compose ps postgres | grep -q "running"; then
    missing_services+=("PostgreSQL")
fi

if ! docker-compose ps redis | grep -q "running"; then
    missing_services+=("Redis")
fi

if ! docker-compose ps minio | grep -q "running"; then
    missing_services+=("MinIO")
fi

if [ ${#missing_services[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  The following services are not running:${NC}"
    for service in "${missing_services[@]}"; do
        echo -e "   ${RED}✗${NC} $service"
    done
    echo ""
    echo -e "${YELLOW}Would you like to start the core services first? (y/n)${NC}"
    read -r response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        echo -e "${YELLOW}Starting core services...${NC}\n"
        ./start.sh mongodb postgres redis minio
    fi
fi

# Start monitoring stack
echo -e "\n${YELLOW}🚀 Starting monitoring services...${NC}\n"

docker-compose up -d prometheus grafana mongodb-exporter postgres-exporter redis-exporter minio-exporter

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ Monitoring stack started successfully!${NC}\n"

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📊 Monitoring Services Active${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    docker-compose ps prometheus grafana mongodb-exporter postgres-exporter redis-exporter minio-exporter

    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🔗 Access Points${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    echo -e "${GREEN}Grafana${NC}         : http://localhost:${GRAFANA_PORT}"
    echo -e "${YELLOW}Username${NC}       : admin"
    echo -e "${YELLOW}Password${NC}       : ${GRAFANA_PASSWORD}\n"

    echo -e "${GREEN}Prometheus${NC}     : http://localhost:${PROMETHEUS_PORT}\n"

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📚 Available Dashboards${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    echo -e "   ${GREEN}📊${NC} UkritStack Overview"
    echo -e "   ${GREEN}🍃${NC} MongoDB Monitoring"
    echo -e "   ${GREEN}🐘${NC} PostgreSQL Monitoring"
    echo -e "   ${GREEN}🔴${NC} Redis Monitoring"
    echo -e "   ${GREEN}🏪${NC} MinIO Monitoring\n"

    echo -e "${YELLOW}⏳ Waiting for services to be healthy (up to 30 seconds)...${NC}\n"
    sleep 10

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  ✅ Next Steps${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    echo -e "1. Open ${GREEN}http://localhost:${GRAFANA_PORT}${NC} in your browser"
    echo -e "2. Login with username: ${YELLOW}admin${NC}, password: ${YELLOW}${GRAFANA_PASSWORD}${NC}"
    echo -e "3. View the pre-configured dashboards in the left sidebar"
    echo -e "4. For more info, see ${YELLOW}./monitoring/MONITORING_GUIDE.md${NC}\n"

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

else
    echo -e "${RED}❌ Failed to start monitoring services${NC}"
    exit 1
fi
