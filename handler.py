# import runpod

# def handler(job):
#     job_input = job.get("input", {})

#     # Process your input here
#     # Example: text = job_input.get("prompt")

#     return {"status": "success", "output": "Your result here"}

# runpod.serverless.start({"handler": handler})


import json
import os
import uuid
from pathlib import Path

import runpod


WORKFLOW_DIR = Path("/workflows")


def load_workflow(name):
    """
    Load an API-format ComfyUI workflow from /workflows.
    """

    workflow_files = {
        "text_to_video": "LTX-2.5-Text-to-Video-api.json",
        "image_to_video": "LTX-2.5-Image-to-Video-api.json",
    }

    if name not in workflow_files:
        raise ValueError(
            f"Unknown workflow '{name}'. "
            f"Available workflows: {list(workflow_files.keys())}"
        )

    path = WORKFLOW_DIR / workflow_files[name]

    if not path.exists():
        raise FileNotFoundError(
            f"Workflow file not found: {path}"
        )

    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def handler(job):
    """
    RunPod Serverless handler.

    Expected input:

    {
        "workflow": "text_to_video",
        ...
    }

    or:

    {
        "workflow": "image_to_video",
        ...
    }
    """

    job_input = job.get("input", {})

    workflow_name = job_input.get("workflow")

    if not workflow_name:
        raise ValueError(
            "Missing 'workflow'. "
            "Use 'text_to_video' or 'image_to_video'."
        )

    workflow = load_workflow(workflow_name)

    # --------------------------------------------------------
    # Optional:
    #
    # If you want to send a complete API workflow directly,
    # allow the caller to override the saved workflow.
    # --------------------------------------------------------

    custom_workflow = job_input.get("workflow_json")

    if custom_workflow is not None:

        if isinstance(custom_workflow, str):
            workflow = json.loads(custom_workflow)

        elif isinstance(custom_workflow, dict):
            workflow = custom_workflow

        else:
            raise ValueError(
                "'workflow_json' must be an object or JSON string"
            )

    # --------------------------------------------------------
    # Return the workflow.
    #
    # IMPORTANT:
    # The official worker already knows how to submit the
    # workflow to ComfyUI.
    #
    # We return it in the format expected by the worker.
    # --------------------------------------------------------

    return {
        "workflow": workflow,
        "workflow_type": workflow_name,
        "request_id": str(uuid.uuid4()),
    }


runpod.serverless.start({
    "handler": handler
})
