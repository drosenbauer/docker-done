#!/bin/bash

# Ports can be specified as an environment variable
if [[ -z "${DONE_PORT}" ]]; then
	DONE_PORT=40000
fi

if [[ -z "${CHECK_PORT}" ]]; then
	CHECK_PORT=40001
fi

echo "Listening for DONE on port ${DONE_PORT}"

nc -q 0 -l "${DONE_PORT}" && /done.sh &

echo "Listening for CHECK on port ${CHECK_PORT}"

while true; do
	# Note '-q 0' causes nc to exit immediately on receiving an EOF, otherwise hangs forever
	/check.sh | nc -w 1 -q 0 -l "${CHECK_PORT}"
done

