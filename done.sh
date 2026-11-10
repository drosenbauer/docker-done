#!/bin/bash

# If DONE_TOKEN is set, the client must send it as the first line (within 5s).
# With no token set, any connection marks the container DONE.
if [[ -n "${DONE_TOKEN}" ]]; then
	IFS= read -r -t 5 line
	line="${line%$'\r'}"
	if [[ "${line}" != "${DONE_TOKEN}" ]]; then
		echo "DENIED"
		exit 1
	fi
fi

mkdir -p /tmp/done

echo "DONE"
