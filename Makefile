NAME = inception
DATA_DIR = /home/natferna/data
COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

build:
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
	docker image rm -f inception-mariadb inception-wordpress inception-nginx 2>/dev/null || true
	rm -rf $(DATA_DIR)/wordpress
	rm -rf $(DATA_DIR)/mariadb

re: fclean all

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

.PHONY: all build up down clean fclean re logs ps