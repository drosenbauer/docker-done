#!/bin/bash

P1=
P2=
DONE=0

stop() {
	DONE=1
	kill $P1
	kill $P2
}

trap 'stop' SIGTERM

# Ports can be specified as an environment variable
if [[ -z "${DONE_PORT}" ]]; then
	DONE_PORT=40000
fi

if [[ -z "${CHECK_PORT}" ]]; then
	CHECK_PORT=40001
fi

echo "Listening for DONE on port ${DONE_PORT}"
echo "Listening for CHECK on port ${CHECK_PORT}"

socat TCP-LISTEN:"${DONE_PORT}" EXEC:"bash /done.sh" &
P1=$!

socat TCP-LISTEN:"${CHECK_PORT}" EXEC:"bash /check.sh" &
P2=$! 

echo "DONE PID: $P1"
echo "CHECK PID: $P2"

while [[ "${DONE}" == "0" ]]; do
	read || ( echo "Terminated"; exit )
done

