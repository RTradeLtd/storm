#! /bin/bash


# used to manage a storagenode

# configuration variables
VERSION="alpha"
EXPOSED_PORT="28967"
ETH_WALLET="...."
EMAIL="..."
ADDRESS="...:$EXPOSED_PORT"
BANDWIDTH="2TB"
STORAGE="2TB"
IDENTITY_DIR="/home/$USER/.local/share/storj/identity/storagenode"
STORAGE_DIR="..."

case "$1" in 

    create-identity)
        echo "enter minimum acceptable difficulty"
        read -r DIFFICULTY
        if [[ "$DIFFICULTY" -lt 30 ]]; then
            echo "[WARN] provided difficulty is less than 30, defaulting to 30"
            DIFFICULTY=30
        fi
        echo "enter concurrency setting, this should be equal to the number of logical cpu cores"
        read -r CONCURRENCY
        echo "[INFO] generating identity, this can take some time please be patient, running command in screen"
        screen -d -m identity_linux_amd64 create storagenode --difficulty "$DIFFICULTY" --concurrency "$CONCURRENCY"
        echo "[INFO] successfully generated identity"
        ;;
    authorize-identity)
        echo "enter your one-time use authorization token"
        read -r AUTH_TOKEN
        echo "[INFO] authorization storagenode identity"
        identity_linux_amd64 authorize storagenode "$AUTH_TOKEN"
        if [[ "$?" -ne 0 ]]; then
            echo "[ERROR] failed to authorize storagenode identity"
        else
            echo "[INFO] successfully authorized identity"
        fi
        ;;
    pull)
        # this is used to pull the storagenode docker container
        docker pull "storjlabs/storagenode:$VERSION"
        ;;
    run)
        echo "[INFO] running storagenode"
        docker run -d --restart unless-stopped -p "$EXPOSED_PORT":28967 \
            -e WALLET="$ETH_WALLET" \
            -e EMAIL="$EMAIL" \
            -e ADDRESS="$ADDRESS" \
            -e BANDWIDTH="$BANDWIDTH" \
            -e STORAGE="$STORAGE" \
            -v "$IDENTITY_DIR":/app/identity \
            -v "$STORAGE_DIR":/app/config \
            --name storagenode "storjlabs/storagenode:$VERSION"
        ;;
    start)
        docker start storagenode
        ;;
    dashboard)
        docker exec -it storagenode /app/dashboard.sh
        ;;
    upgrade)
        docker kill storagenode
        docker rm storagenode
        docker pull "storjlabs/storagenode:$VERSION"
        ;;
    kill)
        docker kill storagenode
        ;;
    *)
        echo "[ERROR] invalid invocation"
        echo "usage: ./storagenode_management.sh [create-identity | authorize-identity | pull | run | dashboard | upgrade | start | kill]"
        ;;

esac