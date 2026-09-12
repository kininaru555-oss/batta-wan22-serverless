FROM runpod/worker-comfyui:5.10.0-base
ENV NETWORK_VOLUME_DEBUG=true

RUN python3 - <<'PY'
from pathlib import Path
p = Path("/comfyui/extra_model_paths.yaml")
t = p.read_text() if p.exists() else ""
add = """
        diffusion_models: models/diffusion_models/
        text_encoders: models/text_encoders/
"""
if "diffusion_models:" not in t:
    p.write_text(t.rstrip() + add + "\n")
print(p.read_text())
PY
