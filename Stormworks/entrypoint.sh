#!/bin/bash
sleep 1
TZ=${TZ:-UTC}
export TZ

# Colors and formatting
PURPLE='\033[35m\033[1m'
RESET='\033[0m'
YELLOW='\033[1m\033[93m'
GREEN='\033[1m\033[32m'
BLUE='\033[1m\033[94m'
CYAN='\033[1m\033[96m'

# Display a welcoming message with style
echo -e "${CYAN}Welcome to the ${GREEN}Stormworks${CYAN} Server!${RESET}"
echo -e "${PURPLE}Initializing game server...${RESET}"

# Display version information and current time
echo -e "${BLUE}Game Server Version:${YELLOW} 1.0.0${RESET}"
echo -e "${BLUE}Current Time:${YELLOW} $(date)${RESET}"
echo -e "${BLUE}Timezone:${YELLOW} ${TZ}${RESET}"

echo -e "${CYAN}Starting the game server now...${RESET}"

echo -e "${GREEN}\"The best way to predict the future is to create it.\"${RESET}"
echo -e "${YELLOW}- Abraham Lincoln${RESET}"

echo -e "${CYAN}Game Server is now live!${RESET}"

if [ ! -d "/home/container/stormworks_server" ]; then
    echo -e "${RED}Error: Game server directory not found! Exiting...${RESET}"
    exit 1
fi

echo -e "${PURPLE}Launching Stormworks game server...${RESET}"

eval "$STARTUP"