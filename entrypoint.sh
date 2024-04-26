#!/bin/bash
sleep 1
TZ=${TZ:-UTC}
export TZ
# Custom script by: https://github.com/JarsScript
PURPLE='\033[35m\033[1m'
RESET='\033[0m'
YELLOW='\033[1m\033[93m'
# Print NPM, YARN, GIT, NODE Version and current time 
echo "${PURPLE}NPM Version: ${YELLOW}$(npm -v)${RESET}"
echo "${PURPLE}YARN Version: ${YELLOW}$(yarn -v)${RESET}"
echo "${PURPLE}GIT Version: ${YELLOW}$(git --version)${RESET}"
echo "${PURPLE}NODE Version: ${YELLOW}$(node -v)${RESET}"
echo "${PURPLE}Current Time: ${YELLOW}$(date)${RESET}"


cd /home/container/ || exit

#MODIFIED STARTUP
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
# Check if the modified startup script is valid
if ! [[ -f "${MODIFIED_STARTUP}" ]]; then
  echo "Invalid modified startup script: ${MODIFIED_STARTUP}"
	exit 1
fi
echo "-${PURPLE}container${YELLOW}@${PURPLE}home: ${RESET}${MODIFIED_STARTUP}"

bash "${MODIFIED_STARTUP}"