all:
	docker-compose build
	docker push yurifl/node:latest

build:
	docker-compose build

push.image:
	docker push yurifl/node:latest
