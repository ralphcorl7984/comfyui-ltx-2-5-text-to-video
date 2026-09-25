# ============================================================
# RunPod Serverless ComfyUI
# LTX-2.5 Text-to-Video / Image-to-Video
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base

# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# ------------------------------------------------------------
# LTX-2.5 model paths
#
# The Network Volume is mounted by RunPod at:
#
# /runpod-volume
#
# We configure ComfyUI to discover the LTX models there.
# ------------------------------------------------------------

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# ------------------------------------------------------------
# Optional bundled workflow
# ------------------------------------------------------------

COPY workflow.json /workflow.json
