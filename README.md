# docker-done
A tiny Docker container that can be used as a minimal boolean status indicator.

# How to use it

The container listens using `socat` on two ports, the DONE port and the CHECK port. (These are 40000 and 40001 by default, respectively.)

On any connection to the DONE port, the container's status is set to DONE. Any subsequent connections to the CHECK port will return the string `DONE`. If the container's status is not DONE, a connection to the check port will return nothing.

## Ports

Set `DONE_PORT` and `CHECK_PORT` environment variables to change the ports.

## Requiring a token on the DONE port (optional)

By default, *any* connection to the DONE port marks the container DONE, including port scanners and TCP health probes. To require a shared secret instead, set a token with either:

    docker run -e DONE_TOKEN=s3cret docker-done
    docker run docker-done --token s3cret      # or --token=s3cret

If both are given, `--token` wins. An empty token means no token.

With a token set, the client must send it as the first line within 5 seconds. A matching token returns `DONE` and sets the status; anything else returns `DENIED` and changes nothing.

    devin$ printf 's3cret\n' | nc localhost 40000
    DONE

Note that a token passed as an argument or environment variable is visible via `docker inspect` and `ps` on the host. It's meant to prevent accidental completion, not to protect against someone with access to the Docker daemon. The CHECK port never needs a token.

## Example

An initial CHECK returns nothing, meaning not done:

    devin$ nc localhost 40001
    

Connecting to the DONE port flags this as DONE:

    devin$ nc localhost 40000
    DONE

All subsequent CHECKs will return DONE:

    devin$ nc localhost 40001
    DONE
    
    devin$ nc localhost 40001
    DONE
    
