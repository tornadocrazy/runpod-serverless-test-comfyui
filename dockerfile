FROM runpod/worker-comfyui:5.4.1-base

# Install your selected custom nodes via comfy-cli
RUN comfy-node-install \
    comfyui_essentials \
    comfyui-impact-pack \
    comfyui-inpaint-cropandstitch \
    comfyui-kjnodes \
    rgthree-comfy \
    teacache

# Download models at build time from Hugging Face

# CLIP
RUN comfy model download \
    --url https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors \
    --relative-path models/clip \
    --filename clip_l.safetensors

# Diffusion model
RUN comfy model download \
    --url https://huggingface.co/jackzheng/flux-fill-FP8/resolve/main/fluxFillFP8_v10.safetensors \
    --relative-path models/diffusion_models \
    --filename fluxFillFP8_v10.safetensors

# LoRA
RUN comfy model download \
    --url https://huggingface.co/ali-vilab/ACE_Plus/resolve/main/portrait/comfyui_portrait_lora64.safetensors \
    --relative-path models/loras \
    --filename comfyui_portrait_lora64.safetensors

# Text encoder
RUN comfy model download \
    --url https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors \
    --relative-path models/text_encoders/t5 \
    --filename t5xxl_fp16.safetensors

# VAE
RUN comfy model download \
    --url https://huggingface.co/lovis93/testllm/resolve/ed9cf1af7465cebca4649157f118e331cf2a084f/ae.safetensors \
    --relative-path models/vae \
    --filename ae.safetensors

# Extra FLUX model (Turbo Alpha)
RUN comfy model download \
    --url https://huggingface.co/camenduru/FLUX.1-dev/resolve/fc63f3204a12362f98c04bc4c981a06eb9123eee/FLUX.1-Turbo-Alpha.safetensors \
    --relative-path models/diffusion_models \
    --filename FLUX.1-Turbo-Alpha.safetensors
