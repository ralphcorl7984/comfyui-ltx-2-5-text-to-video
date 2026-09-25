FROM runpod/worker-comfyui:5.10.0-base

# ============================================================
# LTX-2.5 RunPod Serverless Worker
# ============================================================

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# ComfyUI location used by the RunPod worker
ENV COMFYUI_DIR=/workspace/runpod-slim/ComfyUI

WORKDIR /workspace/runpod-slim

# ============================================================
# Optional Python dependencies
# ============================================================

COPY requirements.txt /tmp/requirements.txt

RUN if [ -s /tmp/requirements.txt ]; then \
        pip install --no-cache-dir -r /tmp/requirements.txt; \
    fi

# ============================================================
# Create model directories
# ============================================================

RUN mkdir -p \
    /workspace/runpod-slim/ComfyUI/models/diffusion_models \
    /workspace/runpod-slim/ComfyUI/models/text_encoders \
    /workspace/runpod-slim/ComfyUI/models/vae \
    /workspace/runpod-slim/ComfyUI/models/latent_upscale_models \
    /workspace/runpod-slim/ComfyUI/models/Unknown \
    /workspace/runpod-slim/ComfyUI/input \
    /workspace/runpod-slim/ComfyUI/output

# ============================================================
# Hugging Face authentication
#
# IMPORTANT:
# LTX-2.5 is gated on Hugging Face.
#
# Pass the token as a Docker build secret:
#
# docker buildx build \
#   --secret id=hf_token,env=HF_TOKEN \
#   --platform linux/amd64 \
#   -t your-image .
#
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" && \
    if [ -z "$HF_TOKEN" ]; then \
        echo "ERROR: HF_TOKEN build secret is required."; \
        exit 1; \
    fi && \
    pip install --no-cache-dir -U huggingface_hub

# ============================================================
# LTX-2.5 DISTILLED BF16 TRANSFORMER
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="diffusion_models/ltx-2.5-22b-distilled-transformer-bf16.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# LTX-2.5 DISTILLED INT8 CONVROT TRANSFORMER
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# GEMMA 4 BF16
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="text_encoders/gemma4-12b-with-proj-ltx-2.5-bf16.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# GEMMA 4 INT8 CONVROT
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# LTX-2.5 VIDEO VAE - BF16
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="vae/ltx-2.5-video-vae-bf16.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# LTX-2.5 VIDEO VAE - CONV BF16
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="vae/ltx-2.5-video-vae-conv-bf16.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# LTX-2.5 AUDIO VAE - BF16
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="vae/ltx-2.5-audio-vae-bf16.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# LTX-2.5 LATENT SPATIAL UPSCALER
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    python - <<'PY'
import os
from huggingface_hub import hf_hub_download

token = os.environ["HF_TOKEN"]

hf_hub_download(
    repo_id="Lightricks/LTX-2.5",
    filename="latent_upscale_models/ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors",
    local_dir="/workspace/runpod-slim/ComfyUI/models",
    token=token,
)
PY

# ============================================================
# Copy workflows
# ============================================================

COPY workflows /workflows

# ============================================================
# Verify downloaded files
# ============================================================

RUN echo "============================================" && \
    echo "LTX-2.5 MODEL CHECK" && \
    echo "============================================" && \
    find /workspace/runpod-slim/ComfyUI/models \
        -type f \
        -name "*.safetensors" \
        -printf "%p\n" | sort && \
    echo "============================================"

# ============================================================
# IMPORTANT:
#
# Do NOT add CMD or ENTRYPOINT here.
#
# runpod/worker-comfyui:5.10.0-base already provides the
# RunPod startup/handler infrastructure.
# ============================================================
