#!/bin/bash
NODE_PORT=14444 DEFAULT_MODEL=llama3.2-3b-instruct nohup /app/vikey-inference/vikey-inference-linux > kuzco.log &
inference node start --code $CODE
