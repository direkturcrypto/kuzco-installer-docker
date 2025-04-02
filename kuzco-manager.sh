#!/bin/bash

BASE_DIR=$(pwd)
KUZCO_TEMPLATE="kuzco-main"
ACTION=""
COUNT=0
START_ID=1
END_ID=1

print_usage() {
    echo "Usage:"
    echo "  Setup Workers:   $0 setup --count <num> --start-from-id <id>"
    echo "  Start Worker:    $0 start <id> OR $0 start <start_id>-<end_id>"
    echo "  Stop Worker:     $0 stop <id> OR $0 stop <start_id>-<end_id>"
    echo "  Stop All:        $0 stop-all"
    exit 1
}

setup_workers() {
    for ((i=0; i<COUNT; i++)); do
        ID=$((START_ID + i))
        INSTANCE_DIR="$BASE_DIR/kuzco-worker-$ID"

        if [[ -d "$INSTANCE_DIR" ]]; then
            echo "⚠️  Instance $INSTANCE_DIR already exists. Skipping..."
            continue
        fi

        echo "📁 Creating instance kuzco-worker-$ID..."
        mkdir -p "$INSTANCE_DIR"
        cp -r "$KUZCO_TEMPLATE"/* "$INSTANCE_DIR"
        rm -rf "$INSTANCE_DIR/.ollama"  # Pastikan folder .ollama tidak ikut tercopy

        # Edit docker-compose.yml
        sed -i "s/kuzco-main/kuzco-worker-$ID/g" "$INSTANCE_DIR/docker-compose.yml"
        sed -i "s/WORKER_NAME:.*/WORKER_NAME: \"kuzco-worker-$ID\"/g" "$INSTANCE_DIR/docker-compose.yml"

        # Generate machine-id
        cd "$INSTANCE_DIR" || exit
        dbus-uuidgen > machine-id

        # Create .ollama and set permissions
        mkdir -p .ollama
        chmod -R 777 .ollama

        echo "✅ Instance kuzco-worker-$ID created successfully!"
        cd "$BASE_DIR" || exit
    done
}

start_worker() {
    for ((ID=START_ID; ID<=END_ID; ID++)); do
        INSTANCE_DIR="$BASE_DIR/kuzco-worker-$ID"
        if [[ ! -d "$INSTANCE_DIR" ]]; then
            echo "❌ Error: Instance $INSTANCE_DIR not found! Skipping..."
            continue
        fi
        cd "$INSTANCE_DIR" || exit
        echo "🚀 Starting kuzco-worker-$ID..."
        docker compose up -d --build
        echo "✅ kuzco-worker-$ID started!"
        cd "$BASE_DIR" || exit
    done
}

stop_worker() {
    for ((ID=START_ID; ID<=END_ID; ID++)); do
        INSTANCE_DIR="$BASE_DIR/kuzco-worker-$ID"
        if [[ ! -d "$INSTANCE_DIR" ]]; then
            echo "❌ Error: Instance $INSTANCE_DIR not found! Skipping..."
            continue
        fi
        cd "$INSTANCE_DIR" || exit
        echo "🛑 Stopping kuzco-worker-$ID..."
        docker compose down
        echo "✅ kuzco-worker-$ID stopped!"
        cd "$BASE_DIR" || exit
    done
}

stop_all_workers() {
    echo "🛑 Stopping all kuzco instances..."
    for dir in kuzco-worker-*; do
        if [[ -d "$dir" ]]; then
            cd "$dir" || continue
            echo "Stopping $dir..."
            docker-compose down
            cd "$BASE_DIR" || exit
        fi
    done
    echo "✅ All kuzco instances stopped!"
}

parse_range() {
    if [[ "$1" =~ ^[0-9]+-[0-9]+$ ]]; then
        START_ID=$(echo "$1" | cut -d'-' -f1)
        END_ID=$(echo "$1" | cut -d'-' -f2)
    else
        START_ID=$1
        END_ID=$1
    fi
}

# Argument parsing
case "$1" in
    setup)
        while [[ $# -gt 0 ]]; do
            case "$2" in
                --count)
                    COUNT="$3"
                    shift 2
                    ;;
                --start-from-id)
                    START_ID="$3"
                    shift 2
                    ;;
                *)
                    break
                    ;;
            esac
        done
        if [[ $COUNT -eq 0 ]]; then print_usage; fi
        setup_workers
        ;;
    start)
        if [[ -z "$2" ]]; then print_usage; fi
        parse_range "$2"
        start_worker
        ;;
    stop)
        if [[ -z "$2" ]]; then print_usage; fi
        parse_range "$2"
        stop_worker
        ;;
    stop-all)
        stop_all_workers
        ;;
    *)
        print_usage
        ;;
esac
