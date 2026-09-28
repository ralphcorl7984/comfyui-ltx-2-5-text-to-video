import copy
import json
import logging
import os
import time
import uuid

import requests
import runpod


# ============================================================
# Configuration
# ============================================================

COMFY_HOST = os.getenv("COMFY_HOST", "127.0.0.1:8188")
COMFY_URL = f"http://{COMFY_HOST}"

WORKFLOW_PATH = "/api-workflow.json"

COMFY_READY_RETRIES = 600
COMFY_READY_DELAY = 1

COMFY_TIMEOUT = 3600


# ============================================================
# Logging
# ============================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
)

logger = logging.getLogger("ltx-serverless")


# ============================================================
# Resolution configuration
# ============================================================

# Public API value -> ComfyUI ResolutionSelector value
RESOLUTION_MAP = {
    "1:1": "1:1 (Square)",
    "3:4": "3:4 (Portrait Standard)",
    "4:3": "4:3 (Landscape Standard)",
    "9:16": "9:16 (Portrait)",
    "16:9": "16:9 (Landscape)",
}


# ============================================================
# Load workflow
# ============================================================

def load_workflow():
    logger.info(f"Loading workflow: {WORKFLOW_PATH}")

    with open(WORKFLOW_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


# ============================================================
# Resolution
# ============================================================

def apply_resolution(workflow, resolution):

    if resolution not in RESOLUTION_MAP:
        raise ValueError(
            f"Unsupported resolution '{resolution}'. "
            f"Supported resolutions: "
            f"{', '.join(RESOLUTION_MAP.keys())}"
        )

    workflow["409"]["inputs"]["aspect_ratio"] = RESOLUTION_MAP[
        resolution
    ]

    # Keep your current quality / memory configuration.
    # Your working workflow currently uses 0.9 MP.
    workflow["409"]["inputs"]["megapixels"] = 0.9

    return workflow


# ============================================================
# Prepare workflow
# ============================================================

def prepare_workflow(prompt, duration, resolution):

    workflow = load_workflow()

    # --------------------------------------------------------
    # Prompt
    # --------------------------------------------------------
    #
    # Node 452
    # PrimitiveStringMultiline
    #
    workflow["452"]["inputs"]["value"] = prompt

    # --------------------------------------------------------
    # Duration
    # --------------------------------------------------------
    #
    # Node 450
    # PrimitiveInt
    #
    workflow["450"]["inputs"]["value"] = duration

    # --------------------------------------------------------
    # Resolution
    # --------------------------------------------------------
    #
    # Node 409
    # ResolutionSelector
    #
    workflow = apply_resolution(
        workflow,
        resolution
    )

    return workflow


# ============================================================
# Wait for ComfyUI
# ============================================================

def wait_for_comfyui():

    logger.info(
        f"Waiting for ComfyUI at {COMFY_URL}"
    )

    for attempt in range(COMFY_READY_RETRIES):

        try:

            response = requests.get(
                f"{COMFY_URL}/system_stats",
                timeout=10,
            )

            if response.status_code == 200:

                logger.info(
                    "ComfyUI is ready."
                )

                return

        except requests.RequestException:
            pass

        if attempt % 10 == 0:

            logger.info(
                f"Waiting for ComfyUI... "
                f"attempt {attempt + 1}/"
                f"{COMFY_READY_RETRIES}"
            )

        time.sleep(COMFY_READY_DELAY)

    raise RuntimeError(
        "ComfyUI did not become available."
    )


# ============================================================
# Queue workflow
# ============================================================

def queue_workflow(workflow):

    client_id = str(uuid.uuid4())

    payload = {
        "prompt": workflow,
        "client_id": client_id,
    }

    logger.info(
        "Sending workflow to ComfyUI..."
    )

    response = requests.post(
        f"{COMFY_URL}/prompt",
        json=payload,
        timeout=60,
    )

    response.raise_for_status()

    result = response.json()

    if "error" in result:

        raise RuntimeError(
            f"ComfyUI rejected workflow: {result}"
        )

    prompt_id = result.get("prompt_id")

    if not prompt_id:

        raise RuntimeError(
            f"ComfyUI did not return prompt_id: {result}"
        )

    logger.info(
        f"Workflow queued: {prompt_id}"
    )

    return prompt_id


# ============================================================
# Wait for ComfyUI result
# ============================================================

def wait_for_result(prompt_id):

    logger.info(
        f"Waiting for generation: {prompt_id}"
    )

    start_time = time.time()

    while True:

        if time.time() - start_time > COMFY_TIMEOUT:

            raise TimeoutError(
                "ComfyUI generation timed out."
            )

        try:

            response = requests.get(
                f"{COMFY_URL}/history/{prompt_id}",
                timeout=30,
            )

            response.raise_for_status()

            history = response.json()

            if prompt_id in history:

                result = history[prompt_id]

                status = result.get(
                    "status",
                    {}
                )

                status_str = status.get(
                    "status_str"
                )

                # ------------------------------------------------
                # Completed
                # ------------------------------------------------

                if status.get("completed"):

                    logger.info(
                        f"Generation completed: {prompt_id}"
                    )

                    return result

                # ------------------------------------------------
                # Failed
                # ------------------------------------------------

                if status_str == "error":

                    raise RuntimeError(
                        f"ComfyUI generation failed: "
                        f"{result}"
                    )

        except requests.RequestException as e:

            logger.warning(
                f"History request failed: {e}"
            )

        time.sleep(2)


# ============================================================
# Extract generated files
# ============================================================

def extract_outputs(result):

    outputs = []

    for node_id, node_output in result.get(
        "outputs",
        {}
    ).items():

        if not isinstance(node_output, dict):
            continue

        for key in (
            "videos",
            "gifs",
            "images",
            "audio",
        ):

            items = node_output.get(key, [])

            if not isinstance(items, list):
                continue

            for item in items:

                if isinstance(item, dict):

                    outputs.append({
                        "node": node_id,
                        "type": key,
                        **item,
                    })

    return outputs


# ============================================================
# RunPod handler
# ============================================================

def handler(job):

    logger.info(
        f"Received job: {job.get('id')}"
    )

    job_input = job.get(
        "input",
        {}
    )

    # --------------------------------------------------------
    # Validate input
    # --------------------------------------------------------

    if not isinstance(job_input, dict):

        raise ValueError(
            "input must be an object"
        )

    prompt = job_input.get(
        "prompt"
    )

    duration = job_input.get(
        "duration",
        20
    )

    resolution = job_input.get(
        "resolution",
        "3:4"
    )

    # --------------------------------------------------------
    # Prompt
    # --------------------------------------------------------

    if not prompt:

        raise ValueError(
            "Missing required parameter: prompt"
        )

    if not isinstance(prompt, str):

        raise ValueError(
            "prompt must be a string"
        )

    prompt = prompt.strip()

    if not prompt:

        raise ValueError(
            "prompt cannot be empty"
        )

    # --------------------------------------------------------
    # Duration
    # --------------------------------------------------------

    try:

        duration = int(duration)

    except (TypeError, ValueError):

        raise ValueError(
            "duration must be an integer"
        )

    if duration < 1:

        raise ValueError(
            "duration must be at least 1 second"
        )

    if duration > 60:

        raise ValueError(
            "duration cannot exceed 60 seconds"
        )

    # --------------------------------------------------------
    # Resolution
    # --------------------------------------------------------

    if resolution not in RESOLUTION_MAP:

        raise ValueError(
            f"Unsupported resolution '{resolution}'. "
            f"Use one of: "
            f"{', '.join(RESOLUTION_MAP.keys())}"
        )

    # --------------------------------------------------------
    # Log parameters
    # --------------------------------------------------------

    logger.info(
        f"Prompt: {prompt[:200]}"
    )

    logger.info(
        f"Duration: {duration}s"
    )

    logger.info(
        f"Resolution: {resolution}"
    )

    # --------------------------------------------------------
    # Prepare fixed workflow
    # --------------------------------------------------------

    workflow = prepare_workflow(
        prompt=prompt,
        duration=duration,
        resolution=resolution,
    )

    # --------------------------------------------------------
    # Queue
    # --------------------------------------------------------

    prompt_id = queue_workflow(
        workflow
    )

    # --------------------------------------------------------
    # Wait
    # --------------------------------------------------------

    result = wait_for_result(
        prompt_id
    )

    # --------------------------------------------------------
    # Extract outputs
    # --------------------------------------------------------

    outputs = extract_outputs(
        result
    )

    # --------------------------------------------------------
    # Return
    # --------------------------------------------------------

    return {
        "status": "success",
        "prompt_id": prompt_id,
        "duration": duration,
        "resolution": resolution,
        "outputs": outputs,
    }


# ============================================================
# Start worker
# ============================================================

if __name__ == "__main__":

    wait_for_comfyui()

    logger.info(
        "Starting RunPod Serverless handler..."
    )

    runpod.serverless.start(
        {
            "handler": handler
        }
    )
