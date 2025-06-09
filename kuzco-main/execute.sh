#!/bin/bash
NODE_PORT=14444 nohup /app/vikey-inference-linux > kuzco.log &
inference node start --code $CODE
