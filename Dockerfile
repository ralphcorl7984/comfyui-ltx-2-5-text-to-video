# ============================================================
# RunPod Serverless ComfyUI
# LTX-2.5 Text-to-Video / Image-to-Video
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# ComfyUI model configuration
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# API workflow bundled into the image
COPY api-workflow.json /api-workflow.json

# Optional UI workflow
COPY workflow.json /workflow.json
