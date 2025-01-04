#!/bin/bash
sleep 1
TZ=${TZ:-UTC}
export TZ

PURPLE='\033[35m\033[1m'
RESET='\033[0m'
YELLOW='\033[1m\033[93m'
GREEN='\033[1m\033[32m'
BLUE='\033[1m\033[94m'
CYAN='\033[1m\033[96m'
RED='\033[1m\033[91m'

PORT="${SERVER_PORT:-25564}"
SERVER_NAME="${SERVER_NAME:-'Stormworks Server'}"
MAX_PLAYERS="${MAX_PLAYERS:-16}"
WORLD_SAVE="${WORLD_SAVE:-""}"
DESPAWN_ON_LEAVE="${DESPAWN_ON_LEAVE:-"true"}"
PHYSICS_TIMESTEP="${PHYSICS_TIMESTEP:-"180"}"
WILDLIFE_ENABLED="${WILDLIFE_ENABLED:-"true"}"
STEAM_USERNAME="${STEAM_USERNAME}"
STEAM_PASSWORD="${STEAM_PASSWORD}"
STEAM_GUARD_CODE="${STEAM_GUARD_CODE}"

echo -e "${CYAN}Welcome to the ${GREEN}Stormworks${CYAN} Server!${RESET}"
echo -e "${PURPLE}Initializing game server...${RESET}"

echo -e "${BLUE}Game Server Version:${YELLOW} 1.0.0${RESET}"
echo -e "${BLUE}Current Time:${YELLOW} $(date)${RESET}"
echo -e "${BLUE}Timezone:${YELLOW} ${TZ}${RESET}"

# Modify server configuration dynamically
echo -e "${PURPLE}Generating/Updating server configuration...${RESET}"

cat > "/home/container/stormworks_server/server_config.xml" <<EOL
<server>
  <name>${SERVER_NAME}</name>
  <port>${PORT}</port>
  <max_players>${MAX_PLAYERS}</max_players>
  <password>${SERVER_PASSWORD}</password>
  <save_name>${WORLD_SAVE}</save_name>
  <despawn_on_leave>${DESPAWN_ON_LEAVE}</despawn_on_leave>
  <physics_timestep>${PHYSICS_TIMESTEP}</physics_timestep>
  <wildlife_enabled>${WILDLIFE_ENABLED}</wildlife_enabled>
</server>
EOL

# Login to SteamCMD with provided credentials or anonymously
echo -e "${PURPLE}Checking SteamCMD login...${RESET}"

if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
    echo -e "${YELLOW}No Steam credentials provided, logging in anonymously...${RESET}"
    ANONYMOUS_LOGIN=true
else
    ANONYMOUS_LOGIN=false
fi

if [ "$ANONYMOUS_LOGIN" = true ]; then
    echo -e "${CYAN}Logging in anonymously to SteamCMD...${RESET}"
    /steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container/stormworks_server +app_update 1247090 validate +quit
else
    if [ ! -z "$STEAM_GUARD_CODE" ]; then
        echo -e "${CYAN}Using Steam Guard code for authentication...${RESET}"
        /steamcmd/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +twofactor $STEAM_GUARD_CODE +force_install_dir /home/container/stormworks_server +app_update 1247090 validate +quit
    else
        echo -e "${CYAN}Logging in with provided Steam credentials...${RESET}"
        /steamcmd/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir /home/container/stormworks_server +app_update 1247090 validate +quit
    fi
fi

echo -e "${CYAN}Server configuration complete. Starting the server...${RESET}"

# Check if the server files exist
if [ ! -d "/home/container/stormworks_server" ]; then
    echo -e "${RED}Error: Game server directory not found! Exiting...${RESET}"
    exit 1
fi

# Start the server
echo -e "${PURPLE}Launching Stormworks game server...${RESET}"
eval "$STARTUP"