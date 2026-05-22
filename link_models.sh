#!/usr/bin/env bash
# Symlink model files from RunPod's HF Model Cache into ComfyUI's expected
# paths. Requires the endpoint to have Model Caching enabled with HF model
# ID `techwavelaps/aceplus-face`.
#
# Cache layout (per RunPod docs):
#   /runpod-volume/huggingface-cache/hub/models--<org>--<name>/
#       refs/main                    -> contains current snapshot hash
#       snapshots/<hash>/<file>      -> the actual files (overlay-mounted)
#
# Snapshot hash changes whenever the HF repo is updated, so resolve it
# dynamically from refs/main rather than hardcoding.

set -e

CACHE_ROOT=/runpod-volume/huggingface-cache/hub/models--techwavelaps--aceplus-face
REFS_FILE="$CACHE_ROOT/refs/main"

echo "[link_models] Waiting for HF model cache to be ready..."
WAIT=0
TIMEOUT=300
while [ ! -f "$REFS_FILE" ]; do
    if [ $WAIT -ge $TIMEOUT ]; then
        echo "[link_models] ERROR: HF model cache not ready after ${TIMEOUT}s." >&2
        echo "[link_models] Is the endpoint configured with Model Caching enabled" >&2
        echo "[link_models] for 'techwavelaps/aceplus-face'?" >&2
        exit 1
    fi
    sleep 2
    WAIT=$((WAIT + 2))
done
echo "[link_models] Cache mount detected after ${WAIT}s"

HASH=$(cat "$REFS_FILE")
SRC="$CACHE_ROOT/snapshots/$HASH"
echo "[link_models] Snapshot: $HASH"

if [ ! -d "$SRC" ]; then
    echo "[link_models] ERROR: snapshot directory missing: $SRC" >&2
    exit 1
fi

# Paths inside the HF repo == relative paths under /comfyui/models/.
FILES=(
    "clip/clip_l.safetensors"
    "diffusion_models/fluxFillFP8_v10.safetensors"
    "text_encoders/t5/t5xxl_fp16.safetensors"
    "vae/ae.safetensors"
    "loras/comfyui_portrait_lora64.safetensors"
    "loras/FLUX.1-Turbo-Alpha.safetensors"
    "facerestore_models/codeformer-v0.1.0.pth"
    "facerestore_models/GFPGANv1.3.pth"
    "facerestore_models/GFPGANv1.4.pth"
    "facerestore_models/GPEN-BFR-512.pth"
    "insightface/inswapper_128.onnx"
    "facedetection/detection_Resnet50_Final.pth"
    "facedetection/parsing_parsenet.pth"
    "RMBG/BiRefNet/birefnet.py"
    "RMBG/BiRefNet/BiRefNet_config.py"
    "RMBG/BiRefNet/config.json"
    "RMBG/BiRefNet/BiRefNet-general.safetensors"
)

MISSING=0
for f in "${FILES[@]}"; do
    target="/comfyui/models/$f"
    mkdir -p "$(dirname "$target")"
    ln -sf "$SRC/$f" "$target"
    if [ ! -e "$target" ]; then
        echo "[link_models] MISSING: $f" >&2
        MISSING=1
    fi
done

# buffalo_l.zip — extract once. InsightFace expects the unpacked dir, and the
# zip itself is read-only inside the cache snapshot, so extract into the
# writable container layer.
BUFFALO_DIR=/comfyui/models/insightface/models/buffalo_l
if [ ! -d "$BUFFALO_DIR" ] || [ -z "$(ls -A "$BUFFALO_DIR" 2>/dev/null)" ]; then
    echo "[link_models] Extracting buffalo_l..."
    mkdir -p "$BUFFALO_DIR"
    python -m zipfile -e "$SRC/insightface/models/buffalo_l.zip" "$BUFFALO_DIR"
fi

if [ $MISSING -eq 1 ]; then
    echo "[link_models] ERROR: one or more model files unavailable in cache." >&2
    exit 1
fi

echo "[link_models] All files linked successfully."
