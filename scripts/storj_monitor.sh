#! /bin/bash

STORAGE_DIR="..."
BOOTSTRAP_URL="bootstrap.storj.io"
BOOTSTRAP_PORT="8888"

case "$1" in

    writable-dir)
        # check that your node can write to the storage directory
        if [[ -w "$STORAGE_DIR" ]]; then
           echo 1
        else
           echo 0
        fi
        ;;
    node-online)
        # check that your node is online
        OUT=$(docker inspect -f '{{.State.Running}}' storagenode)
        if [[ "$OUT" == "true" ]]; then
            echo 1
        else 
            echo 0
        fi
        ;;
    bootstrappable)
        # check that your node can properly bootstrap
        STATUS=$(nc -zw3 "$BOOTSTRAP_URL" "$BOOTSTRAP_PORT" && echo 1 || echo 0)
        echo "$STATUS"
        ;;

esac