#!/bin/bash
# Build Docker image for k3s deployment

set -e

IMAGE_NAME="aroti/backend-api"
VERSION="${1:-latest}"

echo "🐳 Building Docker image for k3s"
echo "================================="
echo ""
echo "Image: ${IMAGE_NAME}:${VERSION}"
echo ""

# Build image
echo "📦 Building Docker image..."
docker build -t "${IMAGE_NAME}:${VERSION}" .

# Tag as latest
if [ "$VERSION" != "latest" ]; then
    docker tag "${IMAGE_NAME}:${VERSION}" "${IMAGE_NAME}:latest"
fi

echo ""
echo "✓ Build complete: ${IMAGE_NAME}:${VERSION}"
echo ""

# Import to k3s
echo "📥 Importing image to k3s..."
docker save "${IMAGE_NAME}:${VERSION}" | sudo k3s ctr images import -

echo ""
echo "✅ Image imported to k3s successfully!"
echo ""
echo "Next steps:"
echo "  cd ../aroti-infra"
echo "  ./deploy.sh"
