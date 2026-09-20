FROM searxng/searxng:2026.9.15-94218a3ac

# Set Render's port and bind address
ENV SEARXNG_PORT=10000
ENV SEARXNG_HOST=0.0.0.0

# Copy custom settings only
COPY settings.yml /etc/searxng/settings.yml

# Use base image's entrypoint (granian server with SEARXNG_PORT/SEARXNG_HOST)
