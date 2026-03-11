#!/usr/bin/env bash

# Останавливать скрипт при любой ошибке
set -e

# Настройка цветов для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Начинаем установку Marketplace Prototype...${NC}\n"

# 1. Проверка зависимостей
echo -e "${YELLOW}Проверка зависимостей...${NC}"
if ! command -v git &> /dev/null; then echo -e "${RED}❌ Ошибка: Git не установлен!${NC}"; exit 1; fi
if ! command -v docker &> /dev/null; then echo -e "${RED}❌ Ошибка: Docker не установлен!${NC}"; exit 1; fi
if ! command -v make &> /dev/null; then echo -e "${RED}❌ Ошибка: Make не установлен!${NC}"; exit 1; fi
echo -e "${GREEN}✅ Все зависимости установлены.${NC}\n"

# 2. Создание рабочей директории
PROJECT_DIR="marketplace-workspace"
echo -e "${BLUE}📂 Создаем папку ${PROJECT_DIR}...${NC}"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# 3. Клонирование репозиториев (ЗАМЕНИТЕ ССЫЛКИ НА СВОИ)
echo -e "${BLUE}📦 Клонируем репозитории...${NC}"
git clone https://github.com/karim3487/marketplace-stack.git || echo "Stack уже склонирован"
git clone https://github.com/karim3487/marketplace-backend.git || echo "Backend уже склонирован"
git clone https://github.com/karim3487/marketplace-frontend.git || echo "Frontend уже склонирован"
echo -e "${GREEN}✅ Репозитории загружены.${NC}\n"

# 4. Запуск проекта
echo -e "${BLUE}🐳 Поднимаем Docker контейнеры...${NC}"
cd marketplace-stack

# Создаем .env из примера
make setup || true

make up
# 5. Ожидание БД и накатывание данных
echo -e "${YELLOW}⏳ Ожидание готовности API (может занять до 30 секунд)...${NC}"
until $(curl --output /dev/null --silent --fail http://localhost:8000/health); do
    printf '.'
    sleep 2
done
echo -e " ${GREEN}Готово!${NC}"

echo -e "${BLUE}🗄 Накатываем миграции и тестовые данные...${NC}"
docker exec marketplace_backend uv run alembic upgrade head
docker exec marketplace_backend uv run python scripts/create_admin.py
docker exec marketplace_backend uv run python scripts/seed.py

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}🎉 Установка успешно завершена! Проект запущен.${NC}"
echo -e "${GREEN}====================================================${NC}"
echo -e "🔗 Frontend:      http://localhost:5173"
echo -e "🔗 Backend API:   http://localhost:8000/docs"
echo -e "🔗 MinIO Console: http://localhost:9001 (admin / changeme)"
echo -e "===================================================="
echo -e "Чтобы остановить проект, перейдите в папку ${PROJECT_DIR}/marketplace-stack и выполните 'make down'"