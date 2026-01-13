#!/bin/bash
# Build and push Docker image for Aroti backend

set -e

IMAGE_NAME="aroti/backend-api"
VERSION="${1:-latest}"

echo "Building Docker image: ${IMAGE_NAME}:${VERSION}"

# Build image
docker build -t "${IMAGE_NAME}:${VERSION}" .
docker tag "${IMAGE_NAME}:${VERSION}" "${IMAGE_NAME}:latest"

echo "Build complete: ${IMAGE_NAME}:${VERSION}"
echo "To push to registry, run:"
echo "  docker push ${IMAGE_NAME}:${VERSION}"
echo "  docker push ${IMAGE_NAME}:latest"
