#!/bin/bash

SHARDS=4
BASE_PORT=5000

abort() {
    echo "Error: $*"
    exit 1
}

gen_instances() {
    local slots_per_shard=$((16384 / SHARDS))
    echo "instances:"
    for ((i = 1; i <= SHARDS; i++)); do
        local port=$((BASE_PORT + i - 1))
        local start_slot=$(((i-1) * slots_per_shard))
        if [ $i == $SHARDS ]; then
            end_slot=16383
        else
            end_slot=$((start_slot + slots_per_shard - 1))
        fi

        echo "  - {\"port\": $port, \"start_hslot\": $start_slot, \"end_hslot\": $end_slot}"
    done
}

while [ $# -gt 0 ]; do
    case "$1" in
        --shards)
            shift
            [ $# -gt 0 ] || abort "Missing --shards argument"
            SHARDS=$1
            ;;
        --base-port)
            shift
            [ $# -gt 0 ] || abort "Missing --base-port argument"
            BASE_PORT=$1
            ;;
        *)
            abort "Unknown argument $1"
            ;;
    esac
    shift
done

echo "Creating instances.yml with the following configuration:"
echo "Shards: $SHARDS"
echo "Base Port: $BASE_PORT"

gen_instances > instances.yml