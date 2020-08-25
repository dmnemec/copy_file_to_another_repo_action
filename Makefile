CONTAINER_NAME=move-files-action
VERISON=0.1.0

build:
	echo "===BUILDING==="
	docker build -t ${CONTAINER_NAME}:latest -t ${CONTAINER_NAME}:latest .

run: build
	echo "===RUNNING==="
	docker run --rm \
	-e "GITHUB_USERNAME=dmnemec" \
	-e "USER_EMAIL=devin.nemec@gmail.com \
	-e API_TOKEN_GITHUB \
	-e "SOURCE_FILE=test.md" \
	-e "DESTINATION_FOLDER=test" \
	-e "GITHUB_REPO=dmnemec/release-test" \
	-e "DESTINATION_BRANCH=master" \
	${CONTAINER_NAME}:latest

