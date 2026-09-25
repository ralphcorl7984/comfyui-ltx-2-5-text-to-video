# # clean base image containing only comfyui, comfy-cli and comfyui-manager
# FROM runpod/worker-comfyui:5.10.0-base

# # build-time tokens for gated downloads are read from BuildKit secret
# # mounts — they are never written to a layer or to image history.
# # pass via: docker buildx build --secret id=hf_token,env=HF_TOKEN .

# # download models into comfyui
# RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://us.aws.cdn.hf.co/xet-bridge-us/6a61c8ecb9886ba1f72a8841/9f6bd0b1090d83fa6aaeee390a34b9c5338416c5cf600ef46c0c59a76fa9a325?X-Xet-Cas-Uid=6ab3aecd3f395db9c4e22eee&response-content-disposition=attachment%3B+filename*%3DUTF-8%27%27ltx-2.5-22b-distilled-transformer-bf16.safetensors%3B+filename%3D%22ltx-2.5-22b-distilled-transformer-bf16.safetensors%22%3B&user_id=6ab3aecd3f395db9c4e22eee&Expires=1790334372&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly91cy5hd3MuY2RuLmhmLmNvL3hldC1icmlkZ2UtdXMvNmE2MWM4ZWNiOTg4NmJhMWY3MmE4ODQxLzlmNmJkMGIxMDkwZDgzZmE2YWFlZWUzOTBhMzRiOWM1MzM4NDE2YzVjZjYwMGVmNDZjMGM1OWE3NmZhOWEzMjVcXD9YLVhldC1DYXMtVWlkPTZhYjNhZWNkM2YzOTVkYjljNGUyMmVlZSZyZXNwb25zZS1jb250ZW50LWRpc3Bvc2l0aW9uPWF0dGFjaG1lbnQlM0IrZmlsZW5hbWUlMkElM0RVVEYtOCUyNyUyN2x0eC0yLjUtMjJiLWRpc3RpbGxlZC10cmFuc2Zvcm1lci1iZjE2LnNhZmV0ZW5zb3JzJTNCK2ZpbGVuYW1lJTNEJTIybHR4LTIuNS0yMmItZGlzdGlsbGVkLXRyYW5zZm9ybWVyLWJmMTYuc2FmZXRlbnNvcnMlMjIlM0ImdXNlcl9pZD02YWIzYWVjZDNmMzk1ZGI5YzRlMjJlZWUiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkVwb2NoVGltZSI6MTc5MDMzNDM3Mn19fV19&Signature=MEUCIQCLLi63cFdC4UIzxdp8a-uhc8QUfhdwlkv7jiab6nqQagIgXlF6jfpuDxU73MwDmgWPdz9X6kpiEJlKkK19qXcootU_&Key-Pair-Id=01KXEF4KZ1B6FV465MAWR4M21F&Hash-Algorithm=SHA256' --relative-path models/Unknown --filename 'ltx-2.5-22b-distilled-transformer-bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-video-vae-bf16.safetensors' --relative-path models/vae --filename 'ltx-2.5-video-vae-bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-audio-vae-bf16.safetensors' --relative-path models/vae --filename 'ltx-2.5-audio-vae-bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-bf16.safetensors' --relative-path models/Unknown --filename 'gemma4-12b-with-proj-ltx-2.5-bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Lightricks/LTX-2.5/resolve/main/latent_upscale_models/ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors' --relative-path models/latent_upscale_models --filename 'ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Lightricks/LTX-2.5/resolve/main/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors' --relative-path models/diffusion_models --filename 'ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors' --relative-path models/text_encoders --filename 'gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# RUN --mount=type=secret,id=hf_token BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" comfy model download --url 'https://huggingface.co/Comfy-Org/gemma-4/resolve/main/text_encoders/gemma4_e2b_it_int8_convrot.safetensors' --relative-path models/text_encoders --filename 'gemma4_e2b_it_int8_convrot.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done


# ============================================================
# LTX-2.5 ComfyUI RunPod Serverless Worker
# ============================================================

FROM runpod/worker-comfyui:5.10.0-base


# ============================================================
# Environment
# ============================================================

ENV PYTHONUNBUFFERED=1

# The official RunPod ComfyUI worker uses port 3000 internally
# for the worker -> ComfyUI communication.
ENV COMFY_HOST=127.0.0.1
ENV COMFY_PORT=3000

# ============================================================
# Working directory
# ============================================================

WORKDIR /comfyui


# ============================================================
# Python dependencies
#
# The base image already contains runpod, requests, and the
# other dependencies required by the official worker.
#
# requirements.txt is copied for any additional dependencies
# you want to maintain in your repository.
# ============================================================

COPY requirements.txt /requirements.txt

RUN if [ -s /requirements.txt ]; then \
        pip install --no-cache-dir -r /requirements.txt; \
    fi


# ============================================================
# Custom handler
#
# IMPORTANT:
# The base image already has /handler.py.
#
# We replace it with our custom handler.
# ============================================================

COPY handler.py /handler.py


# ============================================================
# Optional workflow files
#
# Keep these in your repository as:
#
# workflows/
#   LTX-2.5-Image-to-Video-api.json
#   LTX-2.5-Text-to-Video-api.json
#
# They are copied into the image so the handler can load them.
# ============================================================

COPY workflows /workflows


# ============================================================
# Model directories
# ============================================================

RUN mkdir -p \
    /comfyui/models/Unknown \
    /comfyui/models/vae \
    /comfyui/models/text_encoders \
    /comfyui/models/diffusion_models \
    /comfyui/models/latent_upscale_models


# ============================================================
# Model downloader helper
# ============================================================

RUN --mount=type=secret,id=hf_token \
    set -eu; \
    \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)"; \
    BACKOFFS="10 20 30 60 90"; \
    \
    download_model() { \
        URL="$1"; \
        RELATIVE_PATH="$2"; \
        FILENAME="$3"; \
        \
        echo ""; \
        echo "============================================================"; \
        echo "Downloading: ${FILENAME}"; \
        echo "Destination: ${RELATIVE_PATH}/${FILENAME}"; \
        echo "============================================================"; \
        \
        for i in 1 2 3 4 5; do \
            echo "Attempt ${i}/5"; \
            \
            if HF_TOKEN="${HF_TOKEN}" comfy model download \
                --url "${URL}" \
                --relative-path "${RELATIVE_PATH}" \
                --filename "${FILENAME}"; then \
                \
                echo "SUCCESS: ${FILENAME}"; \
                return 0; \
            fi; \
            \
            if [ "${i}" -eq 5 ]; then \
                echo "ERROR: Failed to download ${FILENAME}" >&2; \
                exit 1; \
            fi; \
            \
            SLEEP="$(echo "${BACKOFFS}" | cut -d ' ' -f "${i}")"; \
            echo "Retrying in ${SLEEP} seconds..."; \
            sleep "${SLEEP}"; \
        done; \
    }; \
    \
    \
    # -------------------------------------------------------- \
    # VIDEO VAE \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-video-vae-bf16.safetensors" \
        "models/vae" \
        "ltx-2.5-video-vae-bf16.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # AUDIO VAE \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-audio-vae-bf16.safetensors" \
        "models/vae" \
        "ltx-2.5-audio-vae-bf16.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # GEMMA 4 12B BF16 + PROJECTION \
    # Keep this in models/Unknown as requested. \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-bf16.safetensors" \
        "models/Unknown" \
        "gemma4-12b-with-proj-ltx-2.5-bf16.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # LATENT UPSCALER \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/latent_upscale_models/ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors" \
        "models/latent_upscale_models" \
        "ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # LTX-2.5 22B INT8 CONVROT \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors" \
        "models/diffusion_models" \
        "ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # GEMMA 4 12B INT8 CONVROT \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors" \
        "models/text_encoders" \
        "gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # GEMMA E2B INT8 CONVROT \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Comfy-Org/gemma-4/resolve/main/text_encoders/gemma4_e2b_it_int8_convrot.safetensors" \
        "models/text_encoders" \
        "gemma4_e2b_it_int8_convrot.safetensors"


# ============================================================
# LTX-2.5 22B DISTILLED TRANSFORMER BF16
#
# Keep this model in addition to the INT8 ConvRot model.
# ============================================================

RUN set -eu; \
    BACKOFFS="10 20 30 60 90"; \
    \
    URL='https://us.aws.cdn.hf.co/xet-bridge-us/6a61c8ecb9886ba1f72a8841/9f6bd0b1090d83fa6aaeee390a34b9c5338416c5cf600ef46c0c59a76fa9a325?X-Xet-Cas-Uid=6ab3aecd3f395db9c4e22eee&response-content-disposition=attachment%3B+filename*%3DUTF-8%27%27ltx-2.5-22b-distilled-transformer-bf16.safetensors%3B+filename%3D%22ltx-2.5-22b-distilled-transformer-bf16.safetensors%22%3B&user_id=6ab3aecd3f395db9c4e22eee&Expires=1790334372&Policy=eyJTdGF0ZW1lbnQiOlt7IkpZaX...'; \
    \
    for i in 1 2 3 4 5; do \
        echo "Downloading BF16 transformer - attempt ${i}/5"; \
        \
        if comfy model download \
            --url "${URL}" \
            --relative-path "models/Unknown" \
            --filename "ltx-2.5-22b-distilled-transformer-bf16.safetensors"; then \
            \
            echo "SUCCESS: BF16 transformer"; \
            break; \
        fi; \
        \
        if [ "${i}" -eq 5 ]; then \
            echo "ERROR: BF16 transformer download failed" >&2; \
            exit 1; \
        fi; \
        \
        SLEEP="$(echo "${BACKOFFS}" | cut -d ' ' -f "${i}")"; \
        echo "Retrying in ${SLEEP} seconds..."; \
        sleep "${SLEEP}"; \
    done


# ============================================================
# Verify models
# ============================================================

RUN echo "============================================================" && \
    echo "LTX-2.5 MODELS" && \
    echo "============================================================" && \
    find /comfyui/models -type f -printf '%p | %s bytes\n' | sort && \
    echo "============================================================"


# ============================================================
# IMPORTANT
#
# Do NOT add:
#
# CMD ["python", "/handler.py"]
#
# The RunPod base image already provides:
#
# CMD ["/start.sh"]
#
# /start.sh:
#   1. Performs GPU checks
#   2. Starts ComfyUI
#   3. Starts /handler.py
#
# We deliberately preserve that behavior.
# ============================================================
