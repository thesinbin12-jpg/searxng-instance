#!/bin/bash
set -e

# Generate secret key if not set
if [ "$SECRET_KEY" = "CHANGE_ME_GENERATE_WITH_OPENSSL_RAND_HEX_32" ] || [ -z "$SECRET_KEY" ]; then
    export SECRET_KEY=$(openssl rand -hex 32)
    echo "Generated SECRET_KEY: $SECRET_KEY"
    # Update settings.yml with generated key
    sed -i "s|CHANGE_ME_GENERATE_WITH_OPENSSL_RAND_HEX_32|$SECRET_KEY|g" /etc/searxng/settings.yml
fi

# Set base URL from Render environment if available
if [ -n "$RENDER_EXTERNAL_URL" ]; then
    sed -i "s|https://searxng-thesinbin12.onrender.com|$RENDER_EXTERNAL_URL|g" /etc/searxng/settings.yml
    echo "Updated base_url to: $RENDER_EXTERNAL_URL"
fi

# Use PORT from Render (default 10000), fallback to 8080
export PORT=${PORT:-10000}
echo "Starting SearXNG on port $PORT"

# Update settings.yml port
sed -i "s|port: 8080|port: $PORT|g" /etc/searxng/settings.yml

# Start self-ping in background (keeps container warm)
(
    sleep 30  # Wait for server to start
    while true; do
        if curl -f -s -m 5 "http://localhost:$PORT/health" > /dev/null 2>&1; then
            echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) [self-ping] OK"
        else
            echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) [self-ping] FAILED"
        fi
        sleep 300  # Self-ping every 5 minutes
    done
) &

# Start SearXNG (granian server) - it should respect PORT env var
exec python -m searx.webapp
