FROM runpod/worker-comfyui:5.4.1-base

RUN pip install https://huggingface.co/iwr-redmond/linux-wheels/resolve/main/insightface-0.7.3-cp312-cp312-linux_x86_64.whl onnxruntime-gpu==1.20.0

# Install custom nodes
RUN comfy-node-install \
    comfyui_essentials \
    comfyui-impact-pack \
    comfyui-inpaint-cropandstitch \
    comfyui-kjnodes \
    rgthree-comfy \
    teacache \
    comfyui-reactor \
    comfyui-rmbg

# --------------------------------------------------------------------
# 🔹 NSFW detector
RUN comfy model download \
    --url https://huggingface.co/liuhaotian/nsfw_detector/resolve/main/config.json \
    --relative-path models/nsfw_detector/vit-base-nsfw-detector \
    --filename config.json

RUN comfy model download \
    --url https://huggingface.co/liuhaotian/nsfw_detector/resolve/main/model.safetensors \
    --relative-path models/nsfw_detector/vit-base-nsfw-detector \
    --filename model.safetensors

RUN comfy model download \
    --url https://huggingface.co/liuhaotian/nsfw_detector/resolve/main/preprocessor_config.json \
    --relative-path models/nsfw_detector/vit-base-nsfw-detector \
    --filename preprocessor_config.json

# --------------------------------------------------------------------
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

# --------------------------------------------------------------------
# 🔹 BiRefNet RMBG
RUN comfy model download \
    --url https://huggingface.co/1038lab/BiRefNet/resolve/main/birefnet.py \
    --relative-path models/RMBG/BiRefNet \
    --filename birefnet.py

RUN comfy model download \
    --url https://huggingface.co/1038lab/BiRefNet/resolve/main/BiRefNet_config.py \
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
