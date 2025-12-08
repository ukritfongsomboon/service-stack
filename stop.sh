#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🛑 Stopping UkritStack Services${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed${NC}"
    exit 1
fi

echo -e "${YELLOW}🛑 Stopping containers (keeping volumes)...${NC}\n"
docker-compose down

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ All containers stopped successfully${NC}\n"
    echo -e "${YELLOW}💾 Volumes preserved (data persisted)${NC}\n"

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Final Status${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    docker-compose ps

    echo -e "\n${GREEN}Ready to start services again with: ./start.sh${NC}\n"
else
    echo -e "${RED}❌ Failed to stop containers${NC}"
    exit 1
fi
