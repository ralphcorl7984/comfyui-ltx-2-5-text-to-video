import runpod

def handler(job):
    job_input = job.get("input", {})

    # Process your input here
    # Example: text = job_input.get("prompt")

    return {"status": "success", "output": "Your result here"}

runpod.serverless.start({"handler": handler})
