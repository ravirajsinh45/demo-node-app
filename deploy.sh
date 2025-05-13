#!/bin/bash
set -e  # Exit on any error

# Check if environment and branch parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Both environment and branch parameters are required"
    echo "Usage: bash deploy.sh <env> <branch>"
    echo "Example: bash deploy.sh prod main"
    exit 1
fi

# Get environment and branch from command line arguments
ENV=$1
BRANCH=$2

# Validate environment parameter
if [ "$ENV" != "prod" ] && [ "$ENV" != "dev" ]; then
    echo "Error: Invalid environment. Must be 'prod' or 'dev'"
    exit 1
fi

# Configuration
APP_NAME="demo-app" # Set your application name here
APP_DIR="" # Set your application directory here

# Port mapping
if [ "$ENV" = "prod" ]; then
  PORT=6001
else
  PORT=4005
fi

# Ensure NVM is available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Logging function - console only, no file
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$ENV] $1"
}

# Error handling
handle_error() {
    log "Error occurred in deployment script at line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Start deployment
log "Starting deployment process for $ENV environment using branch $BRANCH"

# Navigate to application directory
cd "$APP_DIR"
log "Changed to application directory: $APP_DIR"

# Update repository
log "Pulling latest changes from $BRANCH branch..."
git pull origin "$BRANCH"
log "Code updated successfully"

# Install dependencies
log "Installing dependencies..."
npm ci
log "Dependencies installed successfully"

# Reload application
log "Reloading PM2 application..."
if pm2 list | grep -q "$APP_NAME"; then
    pm2 reload all
    log "PM2 processes reloaded successfully"
else
    log "Warning: Application not found in PM2, attempting to start..."
    pm2 start ecosystem.config.js --env "$ENV"
fi

# Verify deployment
log "Verifying deployment..."
if curl -s "http://localhost:$PORT" | grep -q "Service is running"; then
    log "Deployment verified successfully!"
else
    log "Warning: Application health check failed"
fi

log "Deployment completed successfully for $ENV environment"
