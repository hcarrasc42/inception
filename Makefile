# Colors
RED =    \033[0;31m
GREEN =  \033[0;32m
YELLOW = \033[0;33m
BLUE =   \033[0;34m
PURPLE = \033[0;35m
CYAN =   \033[0;36m
BOLD =   \033[0;1m
WHITE =  \033[0;0m

# Variables
DC = docker-compose
DC_DIR = srcs/docker-compose.yml

# Main Rules
all: title setup-dirs build up

build:
	@$(DC) -f $(DC_DIR) build
	@echo "$(GREEN)Imágenes construidas correctamente.$(WHITE)"

up:
	@$(DC) -f $(DC_DIR) up -d
	@echo "$(GREEN)Contenedores en ejecución.$(WHITE)"

down:
	@$(DC) -f $(DC_DIR) down
	@echo "$(YELLOW)Contenedores detenidos.$(WHITE)"

fclean: down
	@echo "$(YELLOW)Liberando todos los contenedores, imágenes, volúmenes y redes de Docker...$(WHITE)"
	@docker container prune --force
	@docker image prune --all --force
	@docker volume prune --force
	@docker volume rm $(shell docker volume ls -q --filter="name=wordpress") $(shell docker volume ls -q --filter="name=mariadb") || true
	@docker network prune --force
	@sudo rm -rf /home/hasi/data
	@echo "$(RED)Sistema completamente limpio.$(WHITE)"

re: fclean all

# Setup Directories for Volumes
setup-dirs:
	@if [ ! -d $(HOME)/data ]; then \
		mkdir -p $(HOME)/data/html $(HOME)/data/mysql; \
		chmod -R 777 $(HOME)/data; \
		echo "$(GREEN)Directorios de datos creados.$(WHITE)"; \
	else \
		echo "$(CYAN)Los directorios de datos ya existen.$(WHITE)"; \
	fi

# Check Status of Containers, Images, Volumes, and Networks
status:
	@echo "$(BLUE)Contenedores:$(WHITE)"
	@docker ps -a
	@echo "$(BLUE)Imágenes:$(WHITE)"
	@docker images
	@echo "$(BLUE)Volúmenes:$(WHITE)"
	@docker volume ls
	@echo "$(BLUE)Redes:$(WHITE)"
	@docker network ls

# Title Banner
title:
	@echo "\n$(PURPLE)" "██╗███╗   ██╗ ██████╗███████╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗"
	@echo "$(BLUE)"     "██║████╗  ██║██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║"
	@echo "$(CYAN)"     "██║██╔██╗ ██║██║     █████╗  ██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║"
	@echo "$(PURPLE)"   "██║██║╚██╗██║██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║"
	@echo "$(BLUE)"     "██║██║ ╚████║╚██████╗███████╗██║        ██║   ██║╚██████╔╝██║ ╚████║"
	@echo "$(CYAN)"     "╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
	@echo               "\nby: hcarrasc\n" "$(WHITE)"

.PHONY: all build up down stop clean fclean re rebuild setup-dirs status title
