ifneq ("$(wildcard srcs/.env)","")
	include srcs/.env
	export
	ifndef PATH_TO_DOCKER_COMPOSE
		$(error PATH_TO_DOCKER_COMPOSE is not in srcs/.env)
	endif
else
	$(error .env is not in srcs/)
endif
# --nocache 
build:
	@mkdir -p $(SAVE_LOCALLY)/wordpress
	@mkdir -p $(SAVE_LOCALLY)/mariadb
	@sudo chown -R www-data:www-data /home/ibehluli/data/mariadb
	@sudo chmod -R 700 /home/ibehluli/data/mariadb
	@sudo chown -R www-data:www-data /home/ibehluli/data/wordpress
	@sudo chmod -R 755 /home/ibehluli/data/wordpress
	docker-compose -f $(PATH_TO_DOCKER_COMPOSE) build
up:
	docker-compose -f $(PATH_TO_DOCKER_COMPOSE) up -d
down:
	docker-compose -f $(PATH_TO_DOCKER_COMPOSE) down
down--volume:
	docker-compose -f $(PATH_TO_DOCKER_COMPOSE) down -v
rmi:
	docker rmi -f $(MARIADB_IMAGE_NAME) | true
	docker rmi -f $(WORDPRESS_IMAGE_NAME) | true
	docker rmi -f $(NGINX_IMAGE_NAME) | true

run:	build up

clean:	down--volume rmi

deep-clean:
	@sudo rm -rf $(SAVE_LOCALLY)/wordpress
	@sudo rm -rf $(SAVE_LOCALLY)/mariadb
	@sudo rm -rf $(SAVE_LOCALLY)
	@docker system prune --all
	@docker builder prune --all

re:	clean run

.PHONY: build up down down--volume rmi run clean re
