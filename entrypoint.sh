#!/bin/bash
set -e

# Remove servidor potencialmente ainda em execução
rm -f /app/tmp/pids/server.pid

# Então execute o comando principal do container
exec "$@"