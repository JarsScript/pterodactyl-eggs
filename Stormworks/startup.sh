#!/bin/bash

# Set environment variables
STEAMCMD_DIR="/steamcmd"
SERVER_DIR="/home/container/stormworks_server"
APP_ID=1247090
PORT="${SERVER_PORT:-25564}"
MAX_PLAYERS="${MAX_PLAYERS:-16}"
SERVER_NAME="${SERVER_NAME:-'Stormworks Server'}"
STEAM_USERNAME="${STEAM_USERNAME}"
STEAM_PASSWORD="${STEAM_PASSWORD}"
STEAM_GUARD_CODE="${STEAM_GUARD_CODE}"

# Check if Steam Username and Password are provided, if not, fallback to anonymous login
if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
  echo "Steam credentials not provided, logging in as anonymous."
  ANONYMOUS_LOGIN=true
else
  ANONYMOUS_LOGIN=false
fi

# Check if Steam Guard code is required
if [ ! -z "$STEAM_GUARD_CODE" ]; then
  echo "2FA is enabled. Using provided Steam Guard code."
else
  if [ -z "$STEAM_USERNAME" ] || [ -z "$STEAM_PASSWORD" ]; then
    echo "2FA is enabled, but no Steam Guard code was provided. Logging in anonymously."
  fi
fi

# Install SteamCMD if not already installed, it seems to be needed
if [ ! -f "$STEAMCMD_DIR/steamcmd.sh" ]; then
  echo "SteamCMD not found. Installing..."
  mkdir -p $STEAMCMD_DIR
  wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O /tmp/steamcmd_linux.tar.gz
  tar -xvzf /tmp/steamcmd_linux.tar.gz -C $STEAMCMD_DIR
  rm /tmp/steamcmd_linux.tar.gz
fi

if [ "$ANONYMOUS_LOGIN" = true ]; then
  echo "Logging in anonymously to SteamCMD."
  $STEAMCMD_DIR/steamcmd.sh +login anonymous +force_install_dir $SERVER_DIR +app_update $APP_ID validate +quit
else
  # Login with user credentials and 2FA if provided
  if [ ! -z "$STEAM_GUARD_CODE" ]; then
    echo "Using Steam Guard code for authentication."
    $STEAMCMD_DIR/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +twofactor $STEAM_GUARD_CODE +force_install_dir $SERVER_DIR +app_update $APP_ID validate +quit
  else
    echo "Logging in without Steam Guard (2FA)."
    $STEAMCMD_DIR/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir $SERVER_DIR +app_update $APP_ID validate +quit
  fi
fi

# Check if the server configuration exists, if not, generate one
if [ ! -f "$SERVER_DIR/server_config.xml" ]; then
  echo "Generating default server configuration..."
  cat > "$SERVER_DIR/server_config.xml" <<EOL
<server>
  <name>$SERVER_NAME</name>
  <port>$PORT</port>
  <max_players>$MAX_PLAYERS</max_players>
  <password></password>
</server>
EOL
fi

echo "Starting the Stormworks server on port $PORT..."
cd $SERVER_DIR
wine server.exe