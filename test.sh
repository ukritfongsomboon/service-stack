#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counter for passed/failed tests
TESTS_PASSED=0
TESTS_FAILED=0

# Load environment variables
if [ ! -f .env ]; then
    echo -e "${RED}❌ .env file not found${NC}"
    exit 1
fi
source .env

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🧪 Testing UkritStack Services${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Function to test MongoDB
test_mongodb() {
    echo -e "${YELLOW}Testing MongoDB...${NC}"

    if docker exec ukritstack_mongodb mongosh --quiet --eval "db.runCommand('ping')" &> /dev/null; then
        echo -e "${GREEN}✅ MongoDB is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ MongoDB is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test Redis
test_redis() {
    echo -e "${YELLOW}Testing Redis...${NC}"

    if docker exec ukritstack_redis redis-cli -a "${REDIS_PASSWORD}" ping &> /dev/null; then
        echo -e "${GREEN}✅ Redis is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ Redis is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test PostgreSQL
test_postgres() {
    echo -e "${YELLOW}Testing PostgreSQL...${NC}"

    if docker exec ukritstack_postgres pg_isready -U "${POSTGRES_USER}" &> /dev/null; then
        echo -e "${GREEN}✅ PostgreSQL is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ PostgreSQL is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test MinIO
test_minio() {
    echo -e "${YELLOW}Testing MinIO...${NC}"

    if curl -s http://localhost:${MINIO_PORT}/minio/health/live &> /dev/null; then
        echo -e "${GREEN}✅ MinIO is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ MinIO is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test Mongo Express
test_mongo_express() {
    echo -e "${YELLOW}Testing Mongo Express...${NC}"

    if curl -s http://localhost:${MONGO_EXPRESS_PORT} &> /dev/null; then
        echo -e "${GREEN}✅ Mongo Express is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ Mongo Express is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test Redis Insight
test_redis_insight() {
    echo -e "${YELLOW}Testing Redis Insight...${NC}"

    if curl -s http://localhost:${REDIS_INSIGHT_PORT} &> /dev/null; then
        echo -e "${GREEN}✅ Redis Insight is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ Redis Insight is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test Adminer
test_adminer() {
    echo -e "${YELLOW}Testing Adminer...${NC}"

    if curl -s http://localhost:${ADMINER_PORT} &> /dev/null; then
        echo -e "${GREEN}✅ Adminer is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ Adminer is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to test Centrifugo
test_centrifugo() {
    echo -e "${YELLOW}Testing Centrifugo...${NC}"

    if curl -s http://localhost:${CENTRIFUGO_PORT:-8000}/health &> /dev/null; then
        echo -e "${GREEN}✅ Centrifugo is running and responding${NC}\n"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ Centrifugo is not responding${NC}\n"
        ((TESTS_FAILED++))
    fi
}

# Function to check container status
check_container_status() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Container Status${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    docker-compose ps
    echo
}

# Function to show service endpoints
show_endpoints() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Service Endpoints${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    echo -e "${GREEN}MongoDB${NC}           : mongodb://admin:password123@localhost:${MONGO_PORT}/"
    echo -e "${GREEN}Mongo Express${NC}     : http://localhost:${MONGO_EXPRESS_PORT}"
    echo -e "${GREEN}Redis${NC}             : redis://localhost:${REDIS_PORT}"
    echo -e "${GREEN}Redis Insight${NC}     : http://localhost:${REDIS_INSIGHT_PORT}"
    echo -e "${GREEN}PostgreSQL${NC}        : postgresql://admin:postgres_password123@localhost:${POSTGRES_PORT}/ukritstack_db"
    echo -e "${GREEN}Adminer${NC}           : http://localhost:${ADMINER_PORT}"
    echo -e "${GREEN}MinIO API${NC}         : http://localhost:${MINIO_PORT}"
    echo -e "${GREEN}MinIO Console${NC}     : http://localhost:${MINIO_CONSOLE_PORT}"
    echo -e "${GREEN}Centrifugo${NC}        : http://localhost:${CENTRIFUGO_PORT:-8000}"
    echo
}

# Function to show container logs
show_logs() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Recent Logs${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    echo -e "${YELLOW}MongoDB Logs:${NC}"
    docker-compose logs --tail=3 mongodb
    echo

    echo -e "${YELLOW}Mongo Express Logs:${NC}"
    docker-compose logs --tail=3 mongo-express
    echo

    echo -e "${YELLOW}Redis Logs:${NC}"
    docker-compose logs --tail=3 redis
    echo

    echo -e "${YELLOW}Redis Insight Logs:${NC}"
    docker-compose logs --tail=3 redis-insight
    echo

    echo -e "${YELLOW}PostgreSQL Logs:${NC}"
    docker-compose logs --tail=3 postgres
    echo

    echo -e "${YELLOW}Adminer Logs:${NC}"
    docker-compose logs --tail=3 adminer
    echo

    echo -e "${YELLOW}MinIO Logs:${NC}"
    docker-compose logs --tail=3 minio
    echo

    echo -e "${YELLOW}Centrifugo Logs:${NC}"
    docker-compose logs --tail=3 centrifugo
    echo
}

# Run all tests
check_container_status
test_mongodb
test_mongo_express
test_redis
test_redis_insight
test_postgres
test_adminer
test_minio
test_centrifugo

# Show endpoints
show_endpoints

# Show summary
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🧪 Test Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

echo -e "${GREEN}Passed: ${TESTS_PASSED}${NC}"
echo -e "${RED}Failed: ${TESTS_FAILED}${NC}\n"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}\n"

    # Ask if user wants to see logs
    echo -e "${YELLOW}Do you want to see detailed logs? (y/n)${NC}"
    read -r response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        show_logs
    fi

    exit 0
else
    echo -e "${RED}❌ Some tests failed!${NC}\n"

    # Ask if user wants to see logs
    echo -e "${YELLOW}Do you want to see detailed logs? (y/n)${NC}"
    read -r response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        show_logs
    fi

    exit 1
fi
