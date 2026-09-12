import runpod


def handler(event):
    data = event.get("input", {})

    return {
        "ok": True,
        "message": "batta-wan22-serverless worker is running",
        "input": data,
    }


runpod.serverless.start({"handler": handler})
