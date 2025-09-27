FROM runpod/worker-comfyui:5.4.1-base

RUN pip install insightface onnxruntime-gpu==1.20.0

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/Gourieff/ComfyUI-ReActor.git

# install its Python deps (will include correct insightface version)
RUN pip install -r /comfyui/custom_nodes/ComfyUI-ReActor/requirements.txt

# Install your selected custom nodes via comfy-cli
RUN comfy-node-install \
    comfyui_essentials \
    comfyui-impact-pack \
    comfyui-inpaint-cropandstitch \
    comfyui-kjnodes \
    rgthree-comfy \
    teacache \
    comfyui-inspyrenet-rembg

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

RUN comfy model download \
    --url https://huggingface.co/ziixzz/codeformer-v0.1.0.pth/blob/main/codeformer-v0.1.0.pth \
    --relative-path models/facerestore_models \
    --filename codeformer-v0.1.0.pth

RUN comfy model download \
    --url https://huggingface.co/kaliansh/sdrep/resolve/690b63ac431cf8bed0998332079e926f845e7628/GFPGANv1.3.pth \
    --relative-path models/facerestore_models \
    --filename GFPGANv1.3.pth

RUN comfy model download \
    --url https://huggingface.co/gmk123/GFPGAN/resolve/main/GFPGANv1.4.pth \
    --relative-path models/facerestore_models \
    --filename GFPGANv1.4.pth

RUN comfy model download \
    --url https://huggingface.co/akhaliq/GPEN-BFR-512/resolve/main/GPEN-BFR-512.pth \
    --relative-path models/facerestore_models \
    --filename GPEN-BFR-512.pth

RUN comfy model download \
    --url https://huggingface.co/ezioruan/inswapper_128.onnx/resolve/main/inswapper_128.onnx \
    --relative-path models/insightface \
    --filename inswapper_128.onnx

RUN comfy model download \
    --url https://huggingface.co/lithiumice/insightface/resolve/1141cd22e2bff0d4036d10ba4151903605a8902d/models/buffalo_l/1k3d68.onnx \
    --relative-path models/insightface/buffalo_l \
    --filename 1k3d68.onnx

RUN comfy model download \
    --url https://huggingface.co/lithiumice/insightface/resolve/1141cd22e2bff0d4036d10ba4151903605a8902d/models/buffalo_l/2d106det.onnx \
    --relative-path models/insightface/buffalo_l \
    --filename 2d106det.onnx

RUN comfy model download \
    --url https://huggingface.co/lithiumice/insightface/resolve/1141cd22e2bff0d4036d10ba4151903605a8902d/models/buffalo_l/det_10g.onnx \
    --relative-path models/insightface/buffalo_l \
    --filename det_10g.onnx

RUN comfy model download \
    --url https://huggingface.co/lithiumice/insightface/resolve/1141cd22e2bff0d4036d10ba4151903605a8902d/models/buffalo_l/genderage.onnx \
    --relative-path models/insightface/buffalo_l \
    --filename genderage.onnx

RUN comfy model download \
    --url https://huggingface.co/lithiumice/insightface/resolve/1141cd22e2bff0d4036d10ba4151903605a8902d/models/buffalo_l/w600k_r50.onnx \
    --relative-path models/insightface/buffalo_l \
    --filename w600k_r50.onnx

RUN comfy model download \
    --url https://github.com/plemeri/transparent-background/releases/download/1.2.12/ckpt_fast.pth \
    --relative-path models/transparent-background \
    --filename ckpt_fast.pth


