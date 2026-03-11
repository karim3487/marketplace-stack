# Marketplace Prototype - Infrastructure Stack

Этот репозиторий содержит конфигурацию для запуска всего проекта **Marketplace Prototype** "с нуля" с использованием Docker Compose. Проект представляет собой прототип маркетплейса с функционалом каталога, управления товарами, продавцами и историей изменений.

## 🏗 Архитектура стека

Стек состоит из следующих сервисов:

- **Frontend**: Vue 3 + Vite + Tailwind CSS (Nginx в Docker)
- **Backend**: FastAPI + SQLAlchemy 2.0 (Асинхронный драйвер `asyncpg`)
- **Database**: PostgreSQL 16
- **Storage**: MinIO (S3-совместимое хранилище для изображений товаров)

---

## 🚀 Быстрый запуск "В один клик" (Рекомендуется)

Самый быстрый способ развернуть весь проект с нуля (клонирование, запуск контейнеров, миграции и сидирование базы данных) — выполнить эту команду в вашем терминале:

```bash
curl -fsSL https://raw.githubusercontent.com/karim3487/marketplace-stack/main/install.sh | bash
```

_Скрипт автоматически создаст папку `marketplace-workspace`, скачает туда 3 необходимых репозитория (stack, backend, frontend), поднимет Docker-контейнеры и накатит тестовые данные._

---

## 🛠 Ручной запуск (Альтернатива)

Если вы предпочитаете контролировать процесс пошагово:

1. Клонируйте репозитории в одну общую папку:

```bash
git clone https://github.com/karim3487/marketplace-stack.git marketplace-stack
git clone https://github.com/karim3487/marketplace-backend.git marketplace-backend
git clone https://github.com/karim3487/marketplace-frontend.git marketplace-frontend

```

2. Перейдите в стек и запустите контейнеры:

```bash
cd marketplace-stack
make setup
make up

```

3. Настройте базу данных:

```bash
docker exec marketplace_backend uv run alembic upgrade head
docker exec marketplace_backend uv run python scripts/create_admin.py
docker exec marketplace_backend uv run python scripts/seed.py
```

### 4. Доступ к сервисам

| Сервис            | URL                                                      | Описание                             |
| ----------------- | -------------------------------------------------------- | ------------------------------------ |
| **Frontend**      | [http://localhost:5173](http://localhost:5173)           | Пользовательский интерфейс и Админка |
| **Backend API**   | [http://localhost:8000/docs](http://localhost:8000/docs) | Swagger документация API             |
| **MinIO Console** | [http://localhost:9001](http://localhost:9001)           | Управление S3 (admin / changeme)     |

---

## 🛠 Команды управления (Makefile)

В папке `marketplace-stack` доступен Makefile для удобного управления:

- `make up` — запустить весь стек в фоне.
- `make down` — остановить все сервисы.
- `make logs` — просмотр логов всех сервисов.
- `make up-infra` — запустить только Postgres и MinIO (полезно для локальной разработки бэкенда вне Docker).
- `make clean` — остановить проект и **полностью удалить** все данные (volumes).

---

## 📂 Структура данных

- `./volumes/pg_data` — данные PostgreSQL.
- `./volumes/minio_data` — файлы в MinIO.
- `../marketplace-backend` — исходный код бэкенда.
- `../marketplace-frontend` — исходный код фронтенда.
