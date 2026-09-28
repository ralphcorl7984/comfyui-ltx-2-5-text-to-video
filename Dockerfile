# ============================================================
# RunPod Serverless ComfyUI
# LTX-2.5 Text-to-Video
#
# Client sends only:
#   prompt
#   duration
#   resolution
#
# The fixed API workflow is loaded internally.
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# ------------------------------------------------------------
# ComfyUI model paths
# ------------------------------------------------------------

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# ------------------------------------------------------------
# Fixed API workflow
# ------------------------------------------------------------

COPY api-workflow.json /api-workflow.json

# ------------------------------------------------------------
# Custom RunPod handler
# ------------------------------------------------------------

COPY handler.py /handler.py

# ------------------------------------------------------------
# Worker startup script
# ------------------------------------------------------------

COPY start.sh /start.sh

RUN chmod +x /start.sh

# ------------------------------------------------------------
# Start ComfyUI + custom Serverless handler
# ------------------------------------------------------------

CMD ["/start.sh"]
