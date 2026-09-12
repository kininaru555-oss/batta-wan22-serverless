FROM runpod/worker-comfyui:5.10.0-base

ENV NETWORK_VOLUME_DEBUG=true

# Wan2.2用の追加モデルパス
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

# worker-comfyui標準の起動スクリプトを退避
RUN cp /start.sh /start-base.sh

# 永続ログ付きラッパー
COPY scripts/start_with_persistent_logs.sh /start_with_persistent_logs.sh

RUN chmod +x /start_with_persistent_logs.sh

CMD ["/start_with_persistent_logs.sh"]
