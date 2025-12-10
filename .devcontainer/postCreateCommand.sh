#!/bin/bash
git config --global --add safe.directory /workspace

# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code@latest

# Install Playwright with Chrome for E2E testing
npx -y playwright install chrome --with-deps

# Install Electron runtime dependencies for GUI testing
# These are required to run Electron apps in the container
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    xvfb \
    libgtk-3-0 \
    libnotify-dev \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    libatspi2.0-0 \
    libdrm2 \
    libgbm1 \
    libxcb-dri3-0