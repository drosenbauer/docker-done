# docker-done
A tiny Docker container that can be used as a minimal boolean status indicator.

# How to use it

The container listens using `socat` on two ports, the DONE port and the CHECK port. (These are 40000 and 40001 by default, respectively.)

On any connection to the DONE port, the container's status is set to DONE. Any subsequent connections to the CHECK port will return the string `DONE`. If the container's status is not DONE, a connection to the check port will return nothing.

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
    
