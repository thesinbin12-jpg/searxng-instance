FROM searxng/searxng:latest

# Copy custom settings and entrypoint
COPY settings.yml /etc/searxng/settings.yml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Health check endpoint (for Render + cron-job.org)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/healthz || exit 1

# Use custom entrypoint with self-ping
ENTRYPOINT ["/entrypoint.sh"]