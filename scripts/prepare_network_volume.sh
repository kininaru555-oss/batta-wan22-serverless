#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-/runpod-volume/models}"

mkdir -p \
  "$BASE/diffusion_models" \
  "$BASE/text_encoders" \
  "$BASE/vae" \
  "$BASE/loras" \
  "$BASE/checkpoints" \
  "$BASE/clip" \
  "$BASE/clip_vision"

echo "Prepared directories:"
find "$BASE" -maxdepth 1 -type d -print | sort
echo
echo "Place these REAL files:"
echo "  diffusion_models/"
echo "    wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"
echo "    wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
echo "  text_encoders/"
echo "    umt5_xxl_fp8_e4m3fn_scaled.safetensors"
echo "  vae/"
echo "    wan_2.1_vae.safetensors"
echo "  clip_vision/"
echo "    clip_vision_h.safetensors"
echo "  loras/"
echo "    NSFW-22-H-e8.safetensors"
echo "    NSFW-22-L-e8.safetensors"
echo "    wan2.2-i2v-high-sex-smashcut-v1.0.safetensors"
echo "    W22_NSFW_Posing_Nude_i2v_HN_v2.safetensors"
echo "    W22_NSFW_Posing_Nude_i2v_LN_v2.safetensors"
echo "    cxy_kiss_v02_high_noise.safetensors   (optional)"
echo "    cxy_kiss_v02_low_noise.safetensors    (optional)"
