#!/bin/sh -e

# This script ensures that plugins using Manifest V2 in Google Chrome and Chromium browsers will remain functional until June 2025.
# Enabling policies in chromium browsers disables secure DNS option. 

RC='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
CYAN='\033[36m'
GREEN='\033[32m'

# Check if script runs as root
checkRoot() {
if [ "$EUID" -ne 0 ]; then
  printf "%b\n" "${RED}Please run with root privileges.${RC}"
  exit
fi
}

# Check command
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Applying policy for Google Chrome
extendManifestV2Chrome() {
    if command_exists google-chrome; then
       printf "%b\n" "${YELLOW}Extending manifestV2 till June 2025 for Google Chrome...${RC}"
       sudo mkdir -p /etc/opt/chrome/policies/managed
       echo '{ "ExtensionManifestV2Availability": 2 }' | sudo tee /etc/opt/chrome/policies/managed/mypolicy.json
       printf "%b\n" "${GREEN}Done. Check chrome://policy to see if it is applied.${RC}"
    else
        printf "%b\n" "${GREEN}Google Chrome is not installed.${RC}"
    fi
}

# Applying policy for chromium browsers
extendManifestV2Chromium() {
    if command_exists chromium-browser || command_exists chromium || command_exists thorium-browser || command_exists vivaldi; then
        printf "%b\n" "${YELLOW}Extending manifestV2 till June 2025 for Chromium based browsers...${RC}"
        sudo mkdir -p /etc/chromium/policies/managed
        echo '{ "ExtensionManifestV2Availability": 2 }' | sudo tee /etc/chromium/policies/managed/mypolicy.json
        printf "%b\n" "${GREEN}Done. Check chrome://policy to see if it is applied.${RC}"
    else
        printf "%b\n" "${GREEN}Chromium based browsers are not installed.${RC}"
    fi
}

checkRoot
extendManifestV2Chrome
extendManifestV2Chromium
