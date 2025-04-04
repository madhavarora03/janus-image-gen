#!/bin/bash

# Set variables
REPO_PATH="~/janus-image-gen"
IMAGE_NAME="janus-image-gen"
PORT=8501
NGROK_DOMAIN="titmouse-selected-hardly.ngrok-free.app"

# Navigate to the repository
echo "[+] Navigating to repository: $REPO_PATH"
cd "$REPO_PATH" || exit 1

# Pull the latest changes from GitHub
echo "[+] Pulling latest changes from GitHub"
git pull origin main || exit 1

# Build the Docker image
echo "[+] Building Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" . || exit 1

# Stop any existing container
echo "[+] Stopping existing container"
docker stop "$IMAGE_NAME" || true

echo "[+] Removing old container"
docker rm "$IMAGE_NAME" || true

# Run the new container with GPU support
echo "[+] Running new container with GPU support"
docker run --gpus all -p $PORT:$PORT -d --name "$IMAGE_NAME" "$IMAGE_NAME" || exit 1

# Kill any running ngrok process
echo "[+] Killing any running ngrok process"
pkill -f ngrok || true

# Start ngrok
echo "[+] Starting ngrok to expose service"
nohup ngrok http http://0.0.0.0:$PORT --domain=$NGROK_DOMAIN > /dev/null 2>&1 &

echo "[+] Deployment completed successfully!"
