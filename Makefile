CONTAINER_NAME=move-files-action

compile: 
	CGO_ENABLED=0 GOOS=linux \
	go build -a \
	-installsuffix cgo \
	-trimpath \
	-ldflags "-s -w -extldflags '-static'" \
	-tags netgo \
	-o main . && \
	strip main && \
	upx -q -9 main

build: compile
	docker build -t ${CONTAINER_NAME}:latest .

run: build
	docker run --rm ${CONTAINER_NAME}:latest
