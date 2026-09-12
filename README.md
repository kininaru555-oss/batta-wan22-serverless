# batta-wan22-serverless — 激NSFW特化 ComfyUI package

This package is modified for **heavy NSFW / uncensored** Wan 2.2 usage on RunPod Serverless + ComfyUI.

モデル本体はこの zip に含まれない。Network Volume に実ファイルを置く。

## Changes from original
- Network Volume layout rewritten with **real published filenames**
- Default recommendation shifted from mild Kiss LoRA to CubeyAI General NSFW HIGH/LOW
- Explicit guidance for high-strength multi-LoRA stacking
- Prompting advice updated for zero-censorship style

## What to replace on GitHub
Replace the repository-root `Dockerfile` with the one in this package.
Commit/push to `main`. RunPod endpoint connected to GitHub will rebuild.

## First deployment
- Max workers: 1
- Active workers: 0
- GPU: preferably 48GB+ or 80GB
- Network Volume: none (first test)
- Confirm official worker-comfyui starts cleanly

## Second step: attach Network Volume
Mount point: `/runpod-volume`
Model root: `/runpod-volume/models/`

See `NETWORK_VOLUME_LAYOUT.txt` for the real-filename layout.

## 必須ファイル（実名）

### Base (Comfy-Org/Wan_2.2_ComfyUI_Repackaged)
- `diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- `diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`
- `text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors`
- `vae/wan_2.1_vae.safetensors`  ← 14B は wan2.2_vae ではなくこちら
- `clip_vision/clip_vision_h.safetensors`  ← I2V 用

VRAM に余裕があれば fp16:
- `wan2.2_i2v_high_noise_14B_fp16.safetensors`
- `wan2.2_i2v_low_noise_14B_fp16.safetensors`
- `umt5_xxl_fp16.safetensors`

### 激NSFW推奨LoRA（実名）
必須級（CubeyAI WAN General NSFW）:
- `NSFW-22-H-e8.safetensors`
- `NSFW-22-L-e8.safetensors`
- Trigger: `nsfwsks`
- Civitai: https://civitai.com/models/1307155
- 旧 HIGH: `22-nsfw-HIGH-e6.safetensors`

追加で強いもの（仮名 Hardcore_Sex_Poses / Anatomy_Boost の実ファイル置換）:
- `wan2.2-i2v-high-sex-smashcut-v1.0.safetensors`
- `W22_NSFW_Posing_Nude_i2v_HN_v2.safetensors`
- `W22_NSFW_Posing_Nude_i2v_LN_v2.safetensors`

optional:
- `cxy_kiss_v02_high_noise.safetensors`
- `cxy_kiss_v02_low_noise.safetensors`

強度目安:
- 汎用NSFW: 0.85 〜 1.20
- 体位・ポーズ特化: 0.70 〜 1.00
- 複数同時積み推奨

## Prompting
遠慮なく露骨に書け。
例: nsfwsks, detailed pussy, penis penetration, deep penetration, cum dripping, ahegao, fucked silly, excessive fluids

## Why no custom handler.py
Official `runpod/worker-comfyui:5.1.0-base` already contains the serverless handler.
Do not add another handler.

## Next milestone
1. Commit this Dockerfile
2. Confirm rebuild & endpoint start
3. Attach Network Volume
4. Drop the files listed above (実名)
5. Add a known-working ComfyUI API workflow (with multi-LoRA nodes)
6. Connect Batta Market router
