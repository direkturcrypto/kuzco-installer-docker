#!/bin/bash

# Periksa argumen yang diberikan
if [ "$1" == "serve" ]; then
    # Jalankan perintah node
    cd /app && NODE_PORT=14444 DEFAULT_MODEL=llama3.2-3b-instruct ./vikey-inference-linux
else
    exit 1
fi
