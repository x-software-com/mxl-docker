#!/bin/bash
set -e

if [ -z ${NO_STRIP} ] || [ "${NO_STRIP}" == "0" ]; then
	FILENAME="$(echo $@ | awk '{print $NF}')"
	strip --strip-debug --strip-unneeded ${FILENAME}
fi

/opt/linuxdeploy/usr/bin/patchelf.binary $@
