#!/bin/bash

# Periksa argumen yang diberikan
if [ "$1" == "serve" ]; then
    # Jalankan perintah node
    echo "Running Inference using Proxy"
    cd /app/vikey-inference && NODE_PORT=14444 DEFAULT_MODEL=llama-3.2-3b-instruct ./vikey-inference-linux
else
    exit 1
fi
