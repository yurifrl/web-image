all:
	docker-compose build
	docker push yurifl/web:latest

build:
	docker-compose build

push.image:
	docker push yurifl/web:latest
