
ZAPHOD_WORK_DIR="${HOME}/programming/zaphod"

DOCKER=podman
DEXEC=${DOCKER} exec ${ZAPHOD_CONTAINER}
ZAPHOD_CONTAINER=zaphod-build
ZMK_IMAGE=zmkfirmware/zmk-build-arm:stable

.SILENT:

build: start-container container-build container-artifact

clean: stop-container
	${DOCKER} rm ${ZAPHOD_CONTAINER}

container-artifact:
	${DEXEC} /__w/zaphod-config/tools/extract-artifact

container-build:
	${DEXEC} /__w/zaphod-config/tools/build

container-init-env: start-container
	${DEXEC} /__w/zaphod-config/tools/init-env

create-container:
	${DOCKER} create --name ${ZAPHOD_CONTAINER} \
		--workdir /__w  \
		-v "${ZAPHOD_WORK_DIR}/zaphod-config/":"/__w/zaphod-config":ro \
		-v "${ZAPHOD_WORK_DIR}/artifacts/":"/__w/artifacts/" \
		--entrypoint "tail" \
		${ZMK_IMAGE} "-f" "/dev/null"

init: create-container container-init-env

pull:
	${DOCKER} pull ${ZMK_IMAGE}

prep: init 

start-container:
	${DOCKER} start ${ZAPHOD_CONTAINER}

stop-container:
	${DOCKER} stop -t=1 ${ZAPHOD_CONTAINER}
