#!/bin/bash
NODE_PORT=14444 DEFAULT_MODEL=llama3.2-3b-instruct nohup /app/vikey-inference/vikey-inference-linux > kuzco.log &
sleep 1
nvidia-smi --setup-gpu "RTX 4090"
inference node start --code $CODE
