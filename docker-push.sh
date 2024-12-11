#!/bin/bash

IMAGE_NAME="ndrdmarshmallow/housie"
VERSION="1.0.0"

# Build the Docker image
docker build --platform linux/arm64 -t $IMAGE_NAME:latest -t $IMAGE_NAME:$VERSION .

# Push both the latest and version-specific tags
docker push $IMAGE_NAME:latest
docker push $IMAGE_NAME:$VERSION
