# ============================================================
# RunPod Serverless ComfyUI
# LTX-2.5 Text-to-Video / Image-to-Video
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base

# ------------------------------------------------------------
# ComfyUI working directory
# ------------------------------------------------------------
WORKDIR /comfyui

# ------------------------------------------------------------
# Copy workflow
#
# Repository structure:
#
# .
# ├── Dockerfile
# ├── handler.py
# └── workflow.json
#
# There is NO workflows/ directory.
# ------------------------------------------------------------
COPY workflow.json /workflow.json

# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------
ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# ------------------------------------------------------------
# End
#
# Models are NOT downloaded during Docker build.
#
# They should be provided through the RunPod Network Volume
# / model storage and mounted into:
#
# /comfyui/models
# ------------------------------------------------------------
