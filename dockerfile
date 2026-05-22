FROM runpod/worker-comfyui:5.4.1-base

RUN pip install https://huggingface.co/iwr-redmond/linux-wheels/resolve/main/insightface-0.7.3-cp312-cp312-linux_x86_64.whl onnxruntime-gpu==1.20.0

# Install your selected custom nodes via comfy-cli
# NOTE: comfyui-kjnodes pinned manually below — latest requires `wrap_attn`
# from a newer ComfyUI core than the 5.4.1-base image ships.
RUN comfy-node-install \
    comfyui_essentials \
    comfyui-impact-pack \
    comfyui-inpaint-cropandstitch \
    rgthree-comfy \
    teacache \
    comfyui-reactor \
    comfyui-rmbg

# Pin comfyui-kjnodes to last commit before sageattn/wrap_attn refactor
# (1585f9b on 2025-11-05 broke compatibility with ComfyUI 0.3.57)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git comfyui-kjnodes && \
    cd comfyui-kjnodes && \
    git checkout e64b67b8f4aa3a555cec61cf18ee7d1cfbb3e5f0 && \
    pip install -r requirements.txt


# Replace sfw
COPY reactor_sfw.py /comfyui/custom_nodes/comfyui-reactor/scripts/reactor_sfw.py

# ─────────────────────────────────────────────────────────────────────────────
# Models — NOT baked into the image. Pulled at runtime via RunPod's Model
# Cache feature (HF model: techwavelaps/aceplus-face), then linked into
# ComfyUI's expected paths by /link_models.sh at boot.
#
# Required endpoint setting on RunPod:
#   Endpoint > Model Caching > techwavelaps/aceplus-face
# ─────────────────────────────────────────────────────────────────────────────
ENV HF_HOME=/runpod-volume/huggingface-cache
ENV HF_HUB_CACHE=/runpod-volume/huggingface-cache

# Pre-create comfy model dirs so symlinks have parents.
RUN mkdir -p \
    /comfyui/models/clip \
    /comfyui/models/diffusion_models \
    /comfyui/models/text_encoders/t5 \
    /comfyui/models/vae \
    /comfyui/models/loras \
    /comfyui/models/facerestore_models \
    /comfyui/models/facedetection \
    /comfyui/models/insightface/models \
    /comfyui/models/RMBG/BiRefNet

# Wrapper start.sh runs link_models.sh, then execs base image's original /start.sh.
COPY link_models.sh /link_models.sh
COPY start.sh /start-wrapper.sh
RUN chmod +x /link_models.sh /start-wrapper.sh && \
    mv /start.sh /start-original.sh && \
    mv /start-wrapper.sh /start.sh
