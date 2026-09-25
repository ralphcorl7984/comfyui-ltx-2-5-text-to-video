# ============================================================
# RunPod Serverless ComfyUI
# LTX-2.5 Text-to-Video / Image-to-Video
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base

WORKDIR /comfyui

# API workflow
COPY workflow.json /workflow.json

# Additional ComfyUI model paths
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Serverless handler
COPY handler.py /handler.py

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8
