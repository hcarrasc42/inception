# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hcarrasc <hcarrasc@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/12 16:45:15 by hcarrasc          #+#    #+#              #
#    Updated: 2024/03/18 14:19:56 by hcarrasc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
DC_DIR = ./srcs/docker-compose.yml

# Rules

all: title up

build:
	$(DC) -f $(DC_DIR) build

up: setup-dirs build
	$(DC) -f $(DC_DIR) up -d

down:
	$(DC) -f $(DC_DIR) down

fclean: down
	@if [ -d $(HOME)/data ]; then sudo rm -rf $(HOME)/data; fi
	$(DC) -f $(DC_DIR) down -v
	docker system prune -a --force

re: down up

rebuild: fclean up

setup-dirs:
	@if [ ! -d $(HOME)/data ]; then mkdir -p $(HOME)/data/mariadb $(HOME)/data/wordpress; \
	chmod -R 777 $(HOME)/data; fi

status:
	@docker ps -a | awk '{printf "$(BLUE)"} NR==1 {print $1;next} {printf "$(WHITE)"} {print}'
	@docker images | awk '{printf "$(BLUE)"} NR==1 {print $1;next} {printf "$(WHITE)"} {print}'
	@docker volume ls | awk '{printf "$(BLUE)"} NR==1 {print $1;next} {printf "$(WHITE)"} {print}'
	@docker network ls | awk '{printf "$(BLUE)"} NR==1 {print $1;next} {printf "$(WHITE)"} {print}'

title:
	@echo "\n$(PURPLE)" "██╗███╗   ██╗ ██████╗███████╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗"
	@echo "$(BLUE)"     "██║████╗  ██║██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║"
	@echo "$(CYAN)"     "██║██╔██╗ ██║██║     █████╗  ██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║"
	@echo "$(PURPLE)"   "██║██║╚██╗██║██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║"
	@echo "$(BLUE)"     "██║██║ ╚████║╚██████╗███████╗██║        ██║   ██║╚██████╔╝██║ ╚████║"
	@echo "$(CYAN)"     "╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
	@echo               "\nby: hcarrasc\n" "$(WHITE)"

.PHONY: all build up down clean fclean re rebuild setup-dirs status title