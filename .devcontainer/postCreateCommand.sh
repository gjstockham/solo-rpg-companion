#!/bin/bash
git config --global --add safe.directory /workspace
npm install -g @anthropic-ai/claude-code@latest
npx -y playwright install chrome --with-deps