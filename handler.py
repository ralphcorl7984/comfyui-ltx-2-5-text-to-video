# import runpod

# def handler(job):
#     job_input = job.get("input", {})

#     # Process your input here
#     # Example: text = job_input.get("prompt")

#     return {"status": "success", "output": "Your result here"}

# runpod.serverless.start({"handler": handler})


import json
import os
import time
import uuid
import urllib.request
import urllib.parse

import runpod


COMFY_HOST = os.getenv("COMFY_HOST", "127.0.0.1")
COMFY_PORT = int(os.getenv("COMFY_PORT", "8188"))

COMFY_URL = f"http://{COMFY_HOST}:{COMFY_PORT}"


def queue_prompt(workflow):
    """
    Submit a ComfyUI API workflow.
    """

    client_id = str(uuid.uuid4())

    payload = {
        "prompt": workflow,
        "client_id": client_id,
    }

    data = json.dumps(payload).encode("utf-8")

    request = urllib.request.Request(
        f"{COMFY_URL}/prompt",
        data=data,
        headers={
            "Content-Type": "application/json"
        },
        method="POST",
    )

    with urllib.request.urlopen(request) as response:
        return json.loads(response.read().decode("utf-8"))


def get_history(prompt_id):
    """
    Get the ComfyUI execution history.
    """

    with urllib.request.urlopen(
        f"{COMFY_URL}/history/{prompt_id}"
    ) as response:
        return json.loads(response.read().decode("utf-8"))


def wait_for_completion(prompt_id, timeout=1800):
    """
    Wait until ComfyUI finishes the workflow.
    """

    start_time = time.time()

    while True:

        if time.time() - start_time > timeout:
            raise TimeoutError(
                f"ComfyUI workflow timed out after {timeout} seconds"
            )

        history = get_history(prompt_id)

        if prompt_id in history:
            return history[prompt_id]

        time.sleep(2)


def handler(job):

    job_input = job.get("input", {})

    workflow = job_input.get("workflow")

    if workflow is None:
        return {
            "status": "error",
            "error": "Missing 'workflow' in input"
        }

    try:

        # ----------------------------------------------------
        # Submit workflow to ComfyUI
        # ----------------------------------------------------

        result = queue_prompt(workflow)

        prompt_id = result.get("prompt_id")

        if not prompt_id:
            return {
                "status": "error",
                "error": "ComfyUI did not return a prompt_id",
                "details": result,
            }

        # ----------------------------------------------------
        # Wait for ComfyUI
        # ----------------------------------------------------

        history = wait_for_completion(prompt_id)

        # ----------------------------------------------------
        # Return ComfyUI result
        # ----------------------------------------------------

        return {
            "status": "success",
            "prompt_id": prompt_id,
            "history": history,
        }

    except Exception as e:

        return {
            "status": "error",
            "error": str(e),
        }


runpod.serverless.start({
    "handler": handler
})
