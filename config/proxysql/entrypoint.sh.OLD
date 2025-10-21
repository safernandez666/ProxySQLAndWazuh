#!/bin/bash
set -e

# Esperar a que ProxySQL inicie y cree el log
sleep 5

# Crear symlink si no existe
if [ ! -L /var/log/proxysql/queries.log ]; then
    ln -sf /var/log/proxysql/queries.log.00000001 /var/log/proxysql/queries.log
fi

# Mantener el symlink actualizado cada 60 segundos
while true; do
    sleep 60
    if [ -f /var/log/proxysql/queries.log.00000001 ] && [ ! -L /var/log/proxysql/queries.log ]; then
        ln -sf /var/log/proxysql/queries.log.00000001 /var/log/proxysql/queries.log
    fi
done &

# Continuar con el proceso normal de ProxySQL
exec "$@"