#!/bin/bash

set -e

echo "============================================================"
echo "Starting LTX-2.5 ComfyUI Serverless Worker"
echo "============================================================"

echo "Starting ComfyUI..."

cd /comfyui

python3 main.py \
    --listen 127.0.0.1 \
    --port 8188 \
    --enable-cors-header \
    > /tmp/comfyui.log 2>&1 &

COMFY_PID=$!

echo "ComfyUI PID: ${COMFY_PID}"

echo "Starting RunPod handler..."

exec python3 -u /handler.py
