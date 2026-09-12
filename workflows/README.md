# Workflows (激NSFW向け)

Put the exported **ComfyUI API workflow JSON** here after the base ComfyUI
endpoint has been verified.

Recommended for heavy NSFW:
- Load both High Noise + Low Noise models
  (`wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` /
   `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`)
- Stack CubeyAI General NSFW HIGH/LOW
  (`NSFW-22-H-e8.safetensors` / `NSFW-22-L-e8.safetensors`)
- Add pose LoRAs
  (`wan2.2-i2v-high-sex-smashcut-v1.0.safetensors`,
   `W22_NSFW_Posing_Nude_i2v_HN_v2.safetensors` /
   `W22_NSFW_Posing_Nude_i2v_LN_v2.safetensors`)
- Expose strength sliders for each LoRA (default high)
- Dynamic fields: input image, explicit prompt, seed, frame count, LoRA strengths
- I2V には `clip_vision_h.safetensors` と `wan_2.1_vae.safetensors` が必要

Do not include a guessed workflow. Export from a known-working graph that already
has multi-LoRA support and high default strengths.
