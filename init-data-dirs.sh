#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  📁 Initializing Data Directories${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Create data directory structure
echo -e "${YELLOW}Creating data directory structure...${NC}\n"

# Base data directory
mkdir -p ./data

# MongoDB directories
mkdir -p ./data/mongodb/db
mkdir -p ./data/mongodb/config
echo -e "${GREEN}✅ Created: ./data/mongodb/{db,config}${NC}"

# Redis directories
mkdir -p ./data/redis
echo -e "${GREEN}✅ Created: ./data/redis${NC}"

# Redis Insight directories
mkdir -p ./data/redis-insight
echo -e "${GREEN}✅ Created: ./data/redis-insight${NC}"

# PostgreSQL directories
mkdir -p ./data/postgresql
echo -e "${GREEN}✅ Created: ./data/postgresql${NC}"

# MinIO directories
mkdir -p ./data/minio
echo -e "${GREEN}✅ Created: ./data/minio${NC}"

# Prometheus directories (Monitoring)
mkdir -p ./data/prometheus
echo -e "${GREEN}✅ Created: ./data/prometheus${NC}"

# Grafana directories (Monitoring)
mkdir -p ./data/grafana
echo -e "${GREEN}✅ Created: ./data/grafana${NC}"

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  📂 Directory Structure${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

tree ./data -L 3 2>/dev/null || find ./data -type d | sort

echo -e "\n${GREEN}✅ Data directories initialized successfully!${NC}\n"

echo -e "${YELLOW}Directory permissions:${NC}"
ls -la ./data | grep -E "^d"

echo -e "\n${BLUE}Ready to start services with: ./start.sh${NC}\n"
