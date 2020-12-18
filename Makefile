.PHONY: publish clean build image test run stop remove kube-apply-bash kube-delete-bash kube-apply-ps kube-delete-ps scan

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
	docker rmi -f $(IMAGE)

# Kubernetes via `Docker-Desktop` and `Minikube` Only supports Linux Containers.
# These `make` targets will only run with linux container builds.
# The Linux image must be available in the Minikube or Docker-Desktop Respository.
# Before running these check for the image by running `docker images` command.
# To switch to Minikube use the following command in powershell to switch the context
# . to use minikube. To return to the docker-desktop kubernetes context close and reopen
# . powershell and/or bash.

# *NIX/Bash.
kube-apply-bash:
	envsubst < ./kubernetes/kubernetes.tmpl > ./kubernetes/$(PROJECT).yml
	kubectl apply -f ./kubernetes/$(PROJECT).yml
	
kube-delete-bash:
	kubectl delete -f ./kubernetes/$(PROJECT).yml
	rm ./kubernetes/$(PROJECT).yml

# Windows powershell run.
# Need to run the .\kubernetes\envar.ps1 script to set the environment variables.
kube-apply-ps:
	envsubst < ./kubernetes/kubernetes.tmpl > ./kubernetes/$(PROJECT).yml
	kubectl apply -f ./kubernetes/$(PROJECT).yml
	
kube-delete-ps:
	kubectl delete -f ./kubernetes/$(PROJECT).yml
	del .\kubernetes\$(PROJECT).yml