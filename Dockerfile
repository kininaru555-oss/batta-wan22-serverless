# Batta Wan2.2 Serverless - 激NSFW特化 ComfyUI base
#
# Official RunPod worker-comfyui base image.
# Models are intentionally NOT baked into the image.
# Attach a RunPod Network Volume and place models under:
#   /runpod-volume/models/...
#
FROM runpod/worker-comfyui:5.1.0-base

# Optional: enable useful diagnostics for Network Volume model discovery.
ENV NETWORK_VOLUME_DEBUG=true

# The official worker-comfyui image already contains the RunPod serverless
# handler and ComfyUI startup logic, so no custom CMD is required here.
