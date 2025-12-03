#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Available services
SERVICES=("mongodb" "mongo-express" "redis" "redis-insight" "postgres" "adminer" "minio" "prometheus" "grafana" "mongodb-exporter" "postgres-exporter" "redis-exporter" "minio-exporter" "node-exporter" "cadvisor")
SELECTED_SERVICES=()

# Function to show help
show_help() {
    cat << EOF
${BLUE}═══════════════════════════════════════════════════════════${NC}
${BLUE}  🚀 UkritStack - Service Starter${NC}
${BLUE}═══════════════════════════════════════════════════════════${NC}

${YELLOW}Usage:${NC}
  ./start.sh [OPTIONS] [SERVICES...]

${YELLOW}Options:${NC}
  --help              Show this help message
  --list              List available services
  --interactive       Interactive menu to select services
  --all               Start all services (default)

${YELLOW}Examples:${NC}
  ./start.sh                          # Start all services
  ./start.sh mongodb redis postgres   # Start specific services
  ./start.sh --interactive            # Interactive selection menu
  ./start.sh --list                   # Show available services

${YELLOW}Available Services:${NC}

  ${BLUE}Core Services:${NC}
  • mongodb           (Document Database)
  • mongo-express     (MongoDB Web UI)
  • redis             (Cache Database)
  • redis-insight     (Redis Web UI)
  • postgres          (Relational Database)
  • adminer           (PostgreSQL Web UI)
  • minio             (Object Storage)

  ${BLUE}Monitoring Stack:${NC}
  • prometheus        (Metrics Collection)
  • grafana           (Metrics Visualization)
  • mongodb-exporter  (MongoDB Metrics Exporter)
  • postgres-exporter (PostgreSQL Metrics Exporter)
  • redis-exporter    (Redis Metrics Exporter)
  • minio-exporter    (MinIO Metrics Exporter)
  • node-exporter     (Host Machine Metrics)
  • cadvisor          (Docker Container Metrics)

${YELLOW}Service Groups:${NC}
  • databases         (mongodb, redis, postgres, minio)
  • monitoring        (prometheus, grafana, mongodb-exporter, postgres-exporter, redis-exporter, minio-exporter)
  • all               (All services)

${BLUE}═══════════════════════════════════════════════════════════${NC}
EOF
}

# Function to list services
list_services() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📋 Available Services${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    for i in "${!SERVICES[@]}"; do
        echo -e "${GREEN}$((i+1)).${NC} ${SERVICES[$i]}"
    done
    echo ""
}

# Function for interactive selection
interactive_select() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🎯 Select Services to Start${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    list_services

    echo -e "${YELLOW}Select services (comma-separated numbers or names):${NC}"
    echo -e "Example: 1,2,4 or mongodb,redis,postgres"
    echo -e "Enter 'all' for all services, or 'q' to quit: ${NC}"
    read -r input

    if [ "$input" = "q" ]; then
        echo -e "${YELLOW}Cancelled${NC}"
        exit 0
    fi

    if [ "$input" = "all" ]; then
        SELECTED_SERVICES=("${SERVICES[@]}")
        return
    fi

    # Parse input
    IFS=',' read -ra items <<< "$input"
    for item in "${items[@]}"; do
        item=$(echo "$item" | xargs) # Trim whitespace

        # Check if it's a number
        if [[ "$item" =~ ^[0-9]+$ ]]; then
            index=$((item - 1))
            if [ $index -ge 0 ] && [ $index -lt ${#SERVICES[@]} ]; then
                SELECTED_SERVICES+=("${SERVICES[$index]}")
            fi
        else
            # Check if it's a service name
            for service in "${SERVICES[@]}"; do
                if [ "$service" = "$item" ]; then
                    SELECTED_SERVICES+=("$item")
                    break
                fi
            done
        fi
    done

    # Remove duplicates
    SELECTED_SERVICES=($(printf '%s\n' "${SELECTED_SERVICES[@]}" | sort -u))

    if [ ${#SELECTED_SERVICES[@]} -eq 0 ]; then
        echo -e "${RED}❌ No valid services selected${NC}"
        exit 1
    fi
}

# Function to validate service names
validate_services() {
    local services=("$@")
    local invalid=()

    for service in "${services[@]}"; do
        if [[ ! " ${SERVICES[@]} " =~ " ${service} " ]]; then
            invalid+=("$service")
        fi
    done

    if [ ${#invalid[@]} -gt 0 ]; then
        echo -e "${RED}❌ Invalid services: ${invalid[*]}${NC}"
        echo -e "${YELLOW}Use './start.sh --list' to see available services${NC}"
        exit 1
    fi
}

# Main script starts here
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🚀 Starting UkritStack Services${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Parse arguments
if [ $# -eq 0 ]; then
    # No arguments - start all services
    SELECTED_SERVICES=("${SERVICES[@]}")
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
elif [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
    list_services
    exit 0
elif [ "$1" = "--interactive" ] || [ "$1" = "-i" ]; then
    interactive_select
elif [ "$1" = "--all" ]; then
    SELECTED_SERVICES=("${SERVICES[@]}")
else
    # Specific services provided
    SELECTED_SERVICES=("$@")
    validate_services "${SELECTED_SERVICES[@]}"
fi

# Show selected services
echo -e "${PURPLE}📌 Selected Services:${NC}"
for service in "${SELECTED_SERVICES[@]}"; do
    echo -e "   ${GREEN}✓${NC} $service"
done
echo ""

# Check if docker and docker-compose are installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed${NC}"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ .env file not found${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Loading environment variables from .env${NC}"
source .env

# Initialize data directories
if [ ! -d ./data ]; then
    echo -e "${YELLOW}📁 Initializing data directories...${NC}"
    ./init-data-dirs.sh
else
    echo -e "${GREEN}✅ Data directories already exist${NC}"
fi

echo -e "${YELLOW}📦 Starting Docker containers...${NC}\n"

# Build compose command with selected services
COMPOSE_CMD="docker-compose up -d"
for service in "${SELECTED_SERVICES[@]}"; do
    COMPOSE_CMD="$COMPOSE_CMD $service"
done

# Execute compose command
$COMPOSE_CMD

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ Containers started successfully${NC}\n"

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📊 Service Status${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    docker-compose ps

    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🔗 Service Endpoints${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"

    # Show endpoints only for selected services
    for service in "${SELECTED_SERVICES[@]}"; do
        case $service in
            mongodb)
                echo -e "${GREEN}MongoDB${NC}           : mongodb://admin:password123@localhost:${MONGO_PORT}/"
                ;;
            mongo-express)
                echo -e "${GREEN}Mongo Express${NC}     : http://localhost:${MONGO_EXPRESS_PORT}"
                ;;
            redis)
                echo -e "${GREEN}Redis${NC}             : redis://localhost:${REDIS_PORT}"
                ;;
            redis-insight)
                echo -e "${GREEN}Redis Insight${NC}     : http://localhost:${REDIS_INSIGHT_PORT}"
                ;;
            postgres)
                echo -e "${GREEN}PostgreSQL${NC}        : postgresql://admin:postgres_password123@localhost:${POSTGRES_PORT}/ukritstack_db"
                ;;
            adminer)
                echo -e "${GREEN}Adminer${NC}           : http://localhost:${ADMINER_PORT}"
                ;;
            minio)
                echo -e "${GREEN}MinIO API${NC}         : http://localhost:${MINIO_PORT}"
                echo -e "${GREEN}MinIO Console${NC}     : http://localhost:${MINIO_CONSOLE_PORT}"
                ;;
            prometheus)
                echo -e "${GREEN}Prometheus${NC}        : http://localhost:${PROMETHEUS_PORT}"
                ;;
            grafana)
                echo -e "${GREEN}Grafana${NC}           : http://localhost:${GRAFANA_PORT} (User: admin / Password: ${GRAFANA_PASSWORD})"
                ;;
            mongodb-exporter)
                echo -e "${GREEN}MongoDB Exporter${NC}  : http://localhost:${MONGODB_EXPORTER_PORT}/metrics"
                ;;
            postgres-exporter)
                echo -e "${GREEN}PostgreSQL Exporter${NC}: http://localhost:${POSTGRES_EXPORTER_PORT}/metrics"
                ;;
            redis-exporter)
                echo -e "${GREEN}Redis Exporter${NC}    : http://localhost:${REDIS_EXPORTER_PORT}/metrics"
                ;;
            minio-exporter)
                echo -e "${GREEN}MinIO Exporter${NC}    : http://localhost:${MINIO_EXPORTER_PORT}/metrics"
                ;;
            node-exporter)
                echo -e "${GREEN}Node Exporter${NC}     : http://localhost:${NODE_EXPORTER_PORT}/metrics"
                ;;
            cadvisor)
                echo -e "${GREEN}cAdvisor${NC}          : http://localhost:${CADVISOR_PORT}"
                ;;
        esac
    done

    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    echo -e "${YELLOW}⏳ Waiting for services to be healthy...${NC}\n"
    sleep 5

    # Check health status
    echo -e "${BLUE}Health Status:${NC}"
    docker-compose ps --format "table {{.Service}}\t{{.Status}}"

else
    echo -e "${RED}❌ Failed to start containers${NC}"
    exit 1
fi
