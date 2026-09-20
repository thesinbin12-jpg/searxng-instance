FROM searxng/searxng:2026.9.15-94218a3ac

# Set Render's default port
ENV PORT=10000

# Copy custom settings and entrypoint
COPY settings.yml /etc/searxng/settings.yml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Health check endpoint - use PORT env var
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:${PORT}/health || exit 1

# Use custom entrypoint with self-ping
ENTRYPOINT ["/entrypoint.sh"]
