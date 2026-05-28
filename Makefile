NAME = inception

DATA_DIR = /home/natferna/data
COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: $(NAME)

$(NAME): build up

build:
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all build up down clean fclean re
