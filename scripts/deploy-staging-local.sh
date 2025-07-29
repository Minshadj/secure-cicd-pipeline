#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# The first argument to the script is the full image name and tag
# e.g., "realworld-app:build-1"
FULL_IMAGE_NAME=$1

echo "--- Deploying Staging Container from LOCAL image: ${FULL_IMAGE_NAME} ---"

# Stop and remove any old staging container
# The '|| true' part prevents the script from failing if the container doesn't exist
docker stop staging-app || true
docker rm staging-app || true

# Run the new container from the locally available image
# This will work because the 'docker build' command already made the image available.
docker run --name staging-app -p 5001:5000 -d ${FULL_IMAGE_NAME}

echo "--- Staging Deployment Complete ---"
