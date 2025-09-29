FROM runpod/worker-comfyui:5.4.1-base

RUN pip install https://huggingface.co/iwr-redmond/linux-wheels/resolve/main/insightface-0.7.3-cp312-cp312-linux_x86_64.whl onnxruntime-gpu==1.20.0

# Install your selected custom nodes via comfy-cli
RUN comfy-node-install \
    comfyui_essentials \
    comfyui-impact-pack \
    comfyui-inpaint-cropandstitch \
    comfyui-kjnodes \
    rgthree-comfy \
    teacache \
    comfyui-reactor \
    comfyui-rmbg


# Replace sfw
COPY reactor_sfw.py /comfyui/custom_nodes/comfyui-reactor/scripts/reactor_sfw.py


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
    --relative-path models/loras \
    --filename FLUX.1-Turbo-Alpha.safetensors

# 🔹 InsightFace (buffalo_l full pack)
RUN comfy model download \
    --url https://github.com/deepinsight/insightface/releases/download/v0.7/buffalo_l.zip \
    --relative-path models/insightface/models \
    --filename buffalo_l.zip

# optional: unzip so Comfy doesn’t redownload
RUN apt-get update && apt-get install -y unzip && \
    unzip /comfyui/models/insightface/models/buffalo_l.zip -d /comfyui/models/insightface/models/buffalo_l && \
    rm /comfyui/models/insightface/models/buffalo_l.zip


# --------------------------------------------------------------------
# 🔹 Face detection models
RUN comfy model download \
    --url https://github.com/xinntao/facexlib/releases/download/v0.1.0/detection_Resnet50_Final.pth \
    --relative-path models/facedetection \
    --filename detection_Resnet50_Final.pth

RUN comfy model download \
    --url https://github.com/sczhou/CodeFormer/releases/download/v0.1.0/parsing_parsenet.pth \
    --relative-path models/facedetection \
    --filename parsing_parsenet.pth


RUN comfy model download \
    --url https://huggingface.co/ziixzz/codeformer-v0.1.0.pth/resolve/main/codeformer-v0.1.0.pth \
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


# --------------------------------------------------------------------
# 🔹 BiRefNet RMBG
RUN comfy model download \
    --url https://huggingface.co/1038lab/BiRefNet/raw/main/birefnet.py \
    --relative-path models/RMBG/BiRefNet \
    --filename birefnet.py

RUN comfy model download \
    --url https://huggingface.co/1038lab/BiRefNet/raw/main/BiRefNet_config.py \
    --relative-path models/RMBG/BiRefNet \
    --filename BiRefNet_config.py

RUN comfy model download \
    --url https://huggingface.co/1038lab/BiRefNet/resolve/main/config.json \
    --relative-path models/RMBG/BiRefNet \
    --filename config.json

RUN comfy model download \
    --url https://huggingface.co/1038lab/BiRefNet/resolve/main/BiRefNet-general.safetensors \
    --relative-path models/RMBG/BiRefNet \
    --filename BiRefNet-general.safetensors




