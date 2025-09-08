# comando base (puedes cambiar a "docker compose" si usas v2)
COMPOSE = docker-compose

# ========== comandos principales ==========
up:
	@if [ ! -f .env ]; then \
		echo "⚠️  no existe .env, copiando de .env.sample..."; \
		cp .env.sample .env; \
	fi
	$(COMPOSE) up --build -d
	# docker-compose run --rm web python manage.py migrate

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
		@echo "Deteniendo y eliminando contenedores..."
	# docker compose --env-file $(ENV_FILE) -f docker-compose.yml down
	@if [ ! -z "$$(docker ps -aq)" ]; then \
		docker stop $$(docker ps -aq); \
		docker rm $$(docker ps -aq); \
	fi
	@echo "Eliminando imágenes..."
	@docker rmi -f $$(docker images -aq) 2>/dev/null || true
	@echo "Eliminando volúmenes..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@echo "Eliminando redes personalizadas..."
	@docker network rm $$(docker network ls -q --filter type=custom) 2>/dev/null || true
logs:
	$(COMPOSE) logs -f

restart: down up

ps:
	$(COMPOSE) ps

migrate:
	$(COMPOSE) run --rm web python manage.py migrate

createsuperuser:
	$(COMPOSE) run --rm web python manage.py createsuperuser

shell:
	$(COMPOSE) run --rm web python manage.py shell

bash:
	$(COMPOSE) run --rm web bash

# limpia volúmenes y recompone desde cero
reset:
	$(COMPOSE) down -v
	$(COMPOSE) up --build -d

re: fclean up
