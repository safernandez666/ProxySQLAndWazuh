#!/bin/bash
# Script para mantener el symlink actualizado

while true; do
    # Encontrar el archivo más reciente
    LATEST_LOG=$(ls -t /var/log/proxysql/queries.log.* 2>/dev/null | head -1)
    
    if [ -n "$LATEST_LOG" ]; then
        # Actualizar symlink
        ln -sf "$LATEST_LOG" /var/log/proxysql/queries.log
    fi
    
    # Esperar 60 segundos
    sleep 60
done