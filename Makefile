.PHONY: publish clean build image test run stop remove
IMAGE ?= acme.io/template-service-csharp
TEST_IMAGE ?= acme.io/test-template-service-csharp

RUN_CONFIG ?= -f docker-compose.yml
LOCAL_CONFIG ?= -f docker-compose.local.yml

DOCKER_COMPOSE ?= docker-compose
COMPOSE ?= $(DOCKER_COMPOSE) $(RUN_CONFIG)

publish:
	docker build --target publish -t $(IMAGE) .
	docker rmi -f $(IMAGE)

clean:
	docker rmi -f $(IMAGE)
	docker rmi -f $(TEST_IMAGE)
	docker system prune -f
	docker volume prune -f

build:
	docker build --target build -t $(IMAGE) .
	docker rmi -f $(IMAGE)

image:
	docker build -t $(IMAGE) .

test: 
	docker build --target test -t $(TEST_IMAGE) .
	docker create --name testcontainer $(TEST_IMAGE)
	docker cp testcontainer:/testresults ./testresults
	docker rm testcontainer
	docker rmi -f $(TEST_IMAGE)

run:
	$(COMPOSE) $(LOCAL_CONFIG) up

stop:
	$(COMPOSE) $(LOCAL_CONFIG) stop

remove:
	docker rmi -f $(IMAGE
	