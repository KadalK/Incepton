NAME = inception

SRCS_DIR = ./srcs
COMPOSE = docker compose -f $(SRCS_DIR)/docker-compose.yml

DATA_DIR = /home/kapinarc/data
DB_DIR = $(DATA_DIR)/mariadb
WP_DIR = $(DATA_DIR)/wordpress

all: build up

build: prepare
	$(COMPOSE) build

up: prepare
	$(COMPOSE) up -d

down:
	-$(COMPOSE) down

clean:
	-$(COMPOSE) down -v

fclean: clean
	-docker system prune -a --volumes -f
	-sudo rm -rf $(DB_DIR)/*
	-sudo rm -rf $(WP_DIR)/*

re: fclean all

prepare:
	@mkdir -p $(DB_DIR)
	@mkdir -p $(WP_DIR)

.PHONY: all build up down clean fclean re prepare