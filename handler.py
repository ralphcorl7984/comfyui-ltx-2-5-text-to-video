import json
import uuid
from pathlib import Path

import runpod


WORKFLOW_PATH = Path("/workflow.json")


def load_workflow():
    """
    Load the API-format ComfyUI workflow bundled in the container.
    """

    if not WORKFLOW_PATH.exists():
        raise FileNotFoundError(
            f"Workflow file not found: {WORKFLOW_PATH}"
        )

    with WORKFLOW_PATH.open("r", encoding="utf-8") as f:
        return json.load(f)


def handler(job):
    """
    RunPod Serverless handler.

    Expected request:

    {
        "input": {
            "workflow": {
                ... complete API workflow ...
            }
        }
    }

    OR, to use the workflow bundled in the Docker image:

    {
        "input": {}
    }
    """

    job_input = job.get("input", {})

    # --------------------------------------------------------
    # Load the workflow bundled in the Docker image.
    # --------------------------------------------------------

    workflow = load_workflow()

    # --------------------------------------------------------
    # Optional workflow override.
    #
    # If the caller sends:
    #
    # "workflow": { ... }
    #
    # use that workflow instead.
    # --------------------------------------------------------

    custom_workflow = job_input.get("workflow")

    if custom_workflow is not None:

        if isinstance(custom_workflow, dict):
            workflow = custom_workflow

        elif isinstance(custom_workflow, str):
            workflow = json.loads(custom_workflow)

        else:
            raise ValueError(
                "'workflow' must be an object or JSON string"
            )

    # --------------------------------------------------------
    # Return the workflow to the RunPod ComfyUI worker.
    # --------------------------------------------------------

    return {
        "workflow": workflow,
        "request_id": str(uuid.uuid4()),
    }


runpod.serverless.start({
    "handler": handler
})
