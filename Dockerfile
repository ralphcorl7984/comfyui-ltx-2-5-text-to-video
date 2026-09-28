# ============================================================
# RunPod Serverless ComfyUI
# LTX-2.5 Text-to-Video / Image-to-Video
#
# UI workflow is intentionally NOT copied into the image.
# api-workflow.json is the Serverless/API workflow.
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base

# ------------------------------------------------------------
# Python / runtime environment
# ------------------------------------------------------------

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# ------------------------------------------------------------
# ComfyUI model paths
#
# Models are stored on the RunPod Network Volume at:
#
# /runpod-volume/runpod-slim/ComfyUI/models
#
# extra_model_paths.yaml maps this location into ComfyUI.
# ------------------------------------------------------------

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# ------------------------------------------------------------
# Serverless API workflow
#
# IMPORTANT:
# - api-workflow.json = API workflow used by Serverless
# - workflow.json     = UI workflow, intentionally excluded
#
# Do NOT rename or modify this file.
# ------------------------------------------------------------

COPY api-workflow.json /api-workflow.json
