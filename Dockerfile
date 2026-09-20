FROM searxng/searxng:2026.9.15-94218a3ac

# Set Render's port and bind address
ENV SEARXNG_PORT=10000
ENV SEARXNG_HOST=0.0.0.0

# Copy custom settings and entrypoint
COPY settings.yml /etc/searxng/settings.yml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Health check endpoint - use SEARXNG_PORT and /healthz
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:${SEARXNG_PORT}/healthz || exit 1

# Use custom entrypoint with self-ping
ENTRYPOINT ["/entrypoint.sh"]
