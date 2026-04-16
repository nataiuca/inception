NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

build:
	mkdir -p /Users/$(USER)/data/wordpress  
	mkdir -p /Users/$(USER)/data/mariadb
	$(COMPOSE) build

up: build
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
	docker image rm -f inception-mariadb inception-wordpress inception-nginx 2>/dev/null || true
	sudo rm -rf /Users/$(USER)/data/wordpress
	sudo rm -rf /Users/$(USER)/data/mariadb

re: fclean all

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

.PHONY: all build up down clean fclean re logs ps