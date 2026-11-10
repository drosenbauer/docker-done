#!/bin/bash

P1=
P2=
STOPPED=0

stop() {
	echo "Stopping socat processes..."
	STOPPED=1
	kill $P1 $P2 2>/dev/null
}

trap 'stop' TERM INT

# Ports can be specified as an environment variable
if [[ -z "${DONE_PORT}" ]]; then
	DONE_PORT=40000
fi

if [[ -z "${CHECK_PORT}" ]]; then
	CHECK_PORT=40001
fi

# Optional token for the DONE port: --token VALUE (or --token=VALUE) on the
# command line, or the DONE_TOKEN environment variable. The argument wins.
# An empty value means no token.
while [[ $# -gt 0 ]]; do
	case "$1" in
		--token)
			if [[ $# -lt 2 ]]; then
				echo "--token requires a value" >&2
				exit 2
			fi
			DONE_TOKEN="$2"
			shift 2
			;;
		--token=*)
			DONE_TOKEN="${1#--token=}"
			shift
			;;
		*)
			echo "Unknown argument: $1" >&2
			exit 2
			;;
	esac
done
export DONE_TOKEN

if [[ -n "${DONE_TOKEN}" ]]; then
	echo "DONE port requires a token"
else
	echo "DONE port accepts any connection (no token set)"
fi

echo "Listening for DONE on port ${DONE_PORT}"
socat "TCP-LISTEN:${DONE_PORT},fork" "EXEC:/done.sh" &
P1=$!

echo "Listening for CHECK on port ${CHECK_PORT}"
socat "TCP-LISTEN:${CHECK_PORT},fork" "EXEC:/check.sh" &
P2=$!

echo "DONE PID: $P1"
echo "CHECK PID: $P2"

# Block until a socat exits or a signal arrives. Unlike a `read` loop this
# doesn't depend on stdin, so it can't spin when the container has no TTY.
wait -n

if [[ "${STOPPED}" == "1" ]]; then
	# Asked to stop: reap the children and exit cleanly
	wait
	echo "Terminated"
	exit 0
fi

# A listener died on its own; shut down so the container is restarted/flagged
echo "A socat process exited unexpectedly" >&2
stop
wait
exit 1
