
.PHONY: all docker
all: bins/runas docker

docker: 
	./build_docker.sh

bins/%: %
	cp $< $@

