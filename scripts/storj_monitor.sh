#! /bin/bash

STORAGE_DIR="..."

case "$1" in

    writable-dir)
        if [[ -w "$STORAGE_DIR" ]]; then
           echo 1
        else
           echo 0
        fi
        ;;
    node-online)
        OUT=$(docker inspect -f '{{.State.Running}}' storagenode)
        if [[ "$OUT" == "true" ]]; then
            echo 1
        else 
            echo 0
        fi
        ;;

esac