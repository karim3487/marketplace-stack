.PHONY: help setup up up-infra down restart logs ps clean

# Цель по умолчанию, если просто написать make
help:
	@echo "Доступные команды:"
	@echo "  make setup    - Скопировать .env.example в .env (если его нет)"
	@echo "  make up       - Поднять весь стек (postgres, minio, backend, frontend) в фоне"
	@echo "  make up-infra - Поднять ТОЛЬКО инфраструктуру (postgres, minio) для локальной разработки"
	@echo "  make down     - Остановить и удалить контейнеры"
	@echo "  make restart  - Перезапустить весь стек"
	@echo "  make logs     - Смотреть логи всех контейнеров в реальном времени"
	@echo "  make ps       - Показать статус контейнеров"
	@echo "  make clean    - ВНИМАНИЕ: Остановить контейнеры и УДАЛИТЬ все данные (volumes)"

# Первоначальная настройка
setup:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Файл .env успешно создан из .env.example. Не забудьте проверить настройки!"; \
	else \
		echo "Файл .env уже существует."; \
	fi

# Запуск всего стека
up:
	docker compose up -d

# Запуск только базы данных и хранилища (идеально для разработки бэкенда)
up-infra:
	docker compose up -d postgres minio

# Остановка стека
down:
	docker compose down

# Перезапуск
restart: down up

# Просмотр логов (нажмите Ctrl+C для выхода)
logs:
	docker compose logs -f

# Статус
ps:
	docker compose ps

# Полная очистка (удобно, если нужно накатить чистые миграции или сбросить MinIO)
clean:
	@echo "Удаление контейнеров и томов данных (volumes)..."
	docker compose down -v
	@echo "Очистка завершена."