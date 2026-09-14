FROM runpod/worker-comfyui:5.10.0-base

ENV NETWORK_VOLUME_DEBUG=true

RUN cat > /comfyui/extra_model_paths.yaml <<'YAML'
runpod_worker_comfy:
  base_path: /runpod-volume

  checkpoints: models/checkpoints/
  clip: models/clip/
  clip_vision: models/clip_vision/
  configs: models/configs/
  controlnet: models/controlnet/
  embeddings: models/embeddings/
  loras: models/loras/
  upscale_models: models/upscale_models/
  vae: models/vae/
  unet: models/unet/
  diffusion_models: models/diffusion_models/
  text_encoders: models/text_encoders/
YAML

RUN python3 - <<'PY'
import yaml

path = "/comfyui/extra_model_paths.yaml"

with open(path, "r", encoding="utf-8") as f:
    data = yaml.safe_load(f)

print(data)

assert "runpod_worker_comfy" in data
assert data["runpod_worker_comfy"]["base_path"] == "/runpod-volume"

print("extra_model_paths.yaml: OK")
PY

RUN cp /start.sh /start-base.sh

COPY scripts/start_with_persistent_logs.sh /start_with_persistent_logs.sh

RUN chmod +x /start_with_persistent_logs.sh

CMD ["/start_with_persistent_logs.sh"]
