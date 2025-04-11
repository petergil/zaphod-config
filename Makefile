
ZAPHOD_WORK_DIR="${HOME}/programming/zaphod"

DOCKER=podman
ZAPHOD_CONTAINER=zaphod-build
ZMK_IMAGE=zmkfirmware/zmk-build-arm:stable

build:
	${DOCKER} exec ${ZAPHOD_CONTAINER} /__w/zaphod-config/tools/build
	${DOCKER} exec ${ZAPHOD_CONTAINER} /__w/zaphod-config/tools/extract-artifact

clean: stop-container
	${DOCKER} rm ${ZAPHOD_CONTAINER}

init:
	${DOCKER} create --name ${ZAPHOD_CONTAINER} \
		--workdir /__w  \
		-v "${ZAPHOD_WORK_DIR}/zaphod-config/":"/__w/zaphod-config":ro \
		-v "${ZAPHOD_WORK_DIR}/artifacts/":"/__w/artifacts/" \
		--entrypoint "tail" \
		${ZMK_IMAGE} "-f" "/dev/null"

pull:
	${DOCKER} pull ${ZMK_IMAGE}

prep: init start-container

start-container:
	${DOCKER} start ${ZAPHOD_CONTAINER}

stop-container:
	${DOCKER} stop ${ZAPHOD_CONTAINER}
