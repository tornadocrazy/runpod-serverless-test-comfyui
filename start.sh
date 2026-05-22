#!/usr/bin/env bash
# Wrapper around the base image's /start.sh — runs link_models.sh first to
# materialize the HF Model Cache into /comfyui/models/, then hands off to
# the original startup unchanged.
set -e

echo "worker-comfyui: Linking models from RunPod Model Cache..."
/link_models.sh
echo "worker-comfyui: Models linked, handing off to base /start.sh"

exec /start-original.sh
