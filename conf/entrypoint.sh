#!/bin/sh
set -eu

echo "Starting Lampa (version: ${LAMPA_VERSION:-unknown})"
echo "User: $(id -u):$(id -g)"

if [ ! -f ${LAMPA_CONFIG_PATH} ]; then
  echo "LAMPA configuration not found! (${LAMPA_CONFIG_PATH})"
else
  echo -e "LAMPA configuration:\n$(cat ${LAMPA_CONFIG_PATH})\n"
fi

exec "$@"
