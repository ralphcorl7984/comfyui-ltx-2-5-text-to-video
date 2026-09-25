# ============================================================
# Base image
# ============================================================
FROM runpod/worker-comfyui:5.10.0-base

# ============================================================
# ComfyUI working directory
# ============================================================
WORKDIR /comfyui

# ============================================================
# Copy workflow into the image
#
# Your repository contains:
#   workflow.json
#
# NOT:
#   workflows/
# ============================================================
COPY workflow.json /workflow.json

# ============================================================
# Environment
# ============================================================
ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# ============================================================
# Hugging Face authentication
#
# HF_TOKEN should be supplied as a BuildKit secret when
# building the image.
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    pip install --no-cache-dir -U huggingface_hub && \
    huggingface-cli download Comfy-Org/LTX-2.5 \
        --include "split_files/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors" \
        --local-dir /comfyui/models

# ============================================================
# LTX-2.5 Gemma text encoder
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    huggingface-cli download Comfy-Org/LTX-2.5 \
        --include "split_files/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors" \
        --local-dir /comfyui/models

# ============================================================
# LTX-2.5 Video VAE
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    huggingface-cli download Lightricks/LTX-Video \
        --include "ltx-2.5-video-vae-bf16.safetensors" \
        --local-dir /comfyui/models

# ============================================================
# LTX-2.5 Audio VAE
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    huggingface-cli download Lightricks/LTX-2.5 \
        --include "ltx-2.5-audio-vae-bf16.safetensors" \
        --local-dir /comfyui/models

# ============================================================
# LTX-2.5 Latent Spatial Upscaler
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    huggingface-cli download Lightricks/LTX-2.5 \
        --include "ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors" \
        --local-dir /comfyui/models

# ============================================================
# Optional: BF16 transformer
#
# Your workflow also references:
# ltx-2.5-22b-distilled-transformer-bf16.safetensors
#
# Keep this if you want BOTH BF16 and INT8 variants available.
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    huggingface-cli download Lightricks/LTX-2.5 \
        --include "ltx-2.5-22b-distilled-transformer-bf16.safetensors" \
        --local-dir /comfyui/models

# ============================================================
# Optional: BF16 Gemma
#
# Your workflow also references:
# gemma4-12b-with-proj-ltx-2.5-bf16.safetensors
#
# Keep this if you want BOTH BF16 and INT8 variants available.
# ============================================================

RUN --mount=type=secret,id=hf_token \
    HF_TOKEN="$(cat /run/secrets/hf_token)" && \
    huggingface-cli download Lightricks/LTX-2.5 \
        --include "gemma4-12b-with-proj-ltx-2.5-bf16.safetensors" \
        --local-dir /comfyui/models
