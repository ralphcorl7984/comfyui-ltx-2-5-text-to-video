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
# LTX-2.5 ComfyUI - RunPod Serverless
# ============================================================

# Clean base image containing:
# - ComfyUI
# - comfy-cli
# - ComfyUI Manager
FROM runpod/worker-comfyui:5.10.0-base

# Install the RunPod Python package if needed
RUN pip install --no-cache-dir runpod

# Copy the RunPod Serverless handler into the image
COPY handler.py /handler.py
COPY workflows /workflows

# ============================================================
# ComfyUI working directory
# ============================================================

WORKDIR /root/runpod-slim/ComfyUI


# ============================================================
# Create required model directories
# ============================================================

RUN mkdir -p \
    /root/runpod-slim/ComfyUI/models/Unknown \
    /root/runpod-slim/ComfyUI/models/vae \
    /root/runpod-slim/ComfyUI/models/text_encoders \
    /root/runpod-slim/ComfyUI/models/diffusion_models \
    /root/runpod-slim/ComfyUI/models/latent_upscale_models


# ============================================================
# Download LTX-2.5 models
#
# HF_TOKEN is provided as a BuildKit secret:
#
# docker buildx build \
#   --secret id=hf_token,env=HF_TOKEN \
#   -t ltx-2.5-comfyui:latest .
#
# The token is NOT stored in the Docker image.
# ============================================================

RUN --mount=type=secret,id=hf_token \
    set -eu; \
    \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)"; \
    \
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
            \
            echo "Download attempt ${i}/5"; \
            \
            if HF_TOKEN="${HF_TOKEN}" comfy model download \
                --url "${URL}" \
                --relative-path "${RELATIVE_PATH}" \
                --filename "${FILENAME}"; then \
                \
                echo "Successfully downloaded: ${FILENAME}"; \
                return 0; \
                \
            fi; \
            \
            if [ "${i}" -eq 5 ]; then \
                echo ""; \
                echo "ERROR: Failed to download ${FILENAME} after 5 attempts."; \
                exit 1; \
            fi; \
            \
            SLEEP="$(echo "${BACKOFFS}" | cut -d ' ' -f "${i}")"; \
            \
            echo "Download failed."; \
            echo "Retrying in ${SLEEP} seconds..."; \
            sleep "${SLEEP}"; \
        done; \
    }; \
    \
    \
    # -------------------------------------------------------- \
    # 1. LTX-2.5 Video VAE BF16 \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-video-vae-bf16.safetensors" \
        "models/vae" \
        "ltx-2.5-video-vae-bf16.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # 2. LTX-2.5 Audio VAE BF16 \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-audio-vae-bf16.safetensors" \
        "models/vae" \
        "ltx-2.5-audio-vae-bf16.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # 3. Gemma 4 12B + Projection BF16 \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-bf16.safetensors" \
        "models/Unknown" \
        "gemma4-12b-with-proj-ltx-2.5-bf16.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # 4. LTX-2.5 Latent Spatial Upscaler BF16 \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/latent_upscale_models/ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors" \
        "models/latent_upscale_models" \
        "ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # 5. LTX-2.5 22B Distilled Transformer INT8 ConvRot \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors" \
        "models/diffusion_models" \
        "ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # 6. Gemma 4 12B + Projection INT8 ConvRot \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors" \
        "models/text_encoders" \
        "gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors"; \
    \
    \
    # -------------------------------------------------------- \
    # 7. Gemma 4 E2B INT8 ConvRot \
    # -------------------------------------------------------- \
    download_model \
        "https://huggingface.co/Comfy-Org/gemma-4/resolve/main/text_encoders/gemma4_e2b_it_int8_convrot.safetensors" \
        "models/text_encoders" \
        "gemma4_e2b_it_int8_convrot.safetensors"


# ============================================================
# Download LTX-2.5 22B Distilled Transformer BF16
#
# This is intentionally kept in addition to the INT8 ConvRot
# transformer above.
#
# Location:
# models/Unknown/
#
# NOTE:
# This is the signed Hugging Face Xet/CDN URL supplied in your
# original Dockerfile.
# ============================================================

RUN set -eu; \
    \
    BACKOFFS="10 20 30 60 90"; \
    \
    URL='https://us.aws.cdn.hf.co/xet-bridge-us/6a61c8ecb9886ba1f72a8841/9f6bd0b1090d83fa6aaeee390a34b9c5338416c5cf600ef46c0c59a76fa9a325?X-Xet-Cas-Uid=6ab3aecd3f395db9c4e22eee&response-content-disposition=attachment%3B+filename*%3DUTF-8%27%27ltx-2.5-22b-distilled-transformer-bf16.safetensors%3B+filename%3D%22ltx-2.5-22b-distilled-transformer-bf16.safetensors%22%3B&user_id=6ab3aecd3f395db9c4e22eee&Expires=1790334372&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly91cy5hd3MuY2RuLmhmLmNvL3hldC1icmlkZ2UtdXMvNmE2MWM4ZWNiOTg4NmJhMWY3MmE4ODQxLzlmNmJkMGIxMDkwZDgzZmE2YWFlZWUzOTBhMzRiOWM1MzM4NDE2YzVjZjYwMGVmNDZjMGM1OWE3NmZhOWEzMjVcXD9YLVhldC1DYXMtVWlkPTZhYjNhZWNkM2YzOTVkYjljNGUyMmVlZSZyZXNwb25zZS1jb250ZW50LWRpc3Bvc2l0aW9uPWF0dGFjaG1lbnQlM0IrZmlsZW5hbWUlMkElM0RVVEYtOCUyNyUyN2x0eC0yLjUtMjJiLWRpc3RpbGxlZC10cmFuc2Zvcm1lci1iZjE2LnNhZmV0ZW5zb3JzJTNCK2ZpbGVuYW1lJTNEJTIybHR4LTIuNS0yMmItZGlzdGlsbGVkLXRyYW5zZm9ybWVyLWJmMTYuc2FmZXRlbnNvcnMlMjIlM0ImdXNlcl9pZD02YWIzYWVjZDNmMzk1ZGI5YzRlMjJlZWUiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkVwb2NoVGltZSI6MTc5MDMzNDM3Mn19fV19&Signature=MEUCIQCLLi63cFdC4UIzxdp8a-uhc8QUfhdwlkv7jiab6nqQagIgXlF6jfpuDxU73MwDmgWPdz9X6kpiEJlKkK19qXcootU_&Key-Pair-Id=01KXEF4KZ1B6FV465MAWR4M21F&Hash-Algorithm=SHA256'; \
    \
    for i in 1 2 3 4 5; do \
        \
        echo ""; \
        echo "============================================================"; \
        echo "Downloading LTX-2.5 22B Distilled Transformer BF16"; \
        echo "Attempt ${i}/5"; \
        echo "============================================================"; \
        \
        if comfy model download \
            --url "${URL}" \
            --relative-path "models/Unknown" \
            --filename "ltx-2.5-22b-distilled-transformer-bf16.safetensors"; then \
            \
            echo "Successfully downloaded BF16 transformer."; \
            break; \
        fi; \
        \
        if [ "${i}" -eq 5 ]; then \
            echo "ERROR: BF16 transformer download failed after 5 attempts." >&2; \
            exit 1; \
        fi; \
        \
        SLEEP="$(echo "${BACKOFFS}" | cut -d ' ' -f "${i}")"; \
        echo "Retrying in ${SLEEP} seconds..."; \
        sleep "${SLEEP}"; \
    done


# ============================================================
# Verify installation
# ============================================================

RUN echo ""; \
    echo "============================================================"; \
    echo "LTX-2.5 MODEL INSTALLATION COMPLETE"; \
    echo "============================================================"; \
    echo ""; \
    echo "ComfyUI model directory:"; \
    echo "/root/runpod-slim/ComfyUI/models"; \
    echo ""; \
    echo "Installed model files:"; \
    find /root/runpod-slim/ComfyUI/models \
        -type f \
        -printf '%p | %s bytes\n' | sort; \
    echo ""; \
    echo "============================================================"


# ============================================================
# Do NOT override ENTRYPOINT or CMD.
#
# runpod/worker-comfyui:5.10.0-base already provides the
# RunPod ComfyUI worker startup configuration.
# ============================================================
