COMPOSE = docker compose --env-file srcs/.env -f srcs/docker-compose.yml
DATA_DIR = /home/natferna/data

.PHONY: all build up down restart logs ps clean fclean re

all: up

build:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) build

up:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af
	docker volume prune -f
	rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

re: fclean all
