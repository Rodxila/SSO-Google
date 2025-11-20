#!/bin/sh
set -e

# Wait for DB? For sqlite it's not necessary, but keep hook for other DBs
# Run migrations, collectstatic, and create/update SocialApp from env vars
sed -i 's/\r$//' docker-entrypoint.sh

echo "[entrypoint] Running migrations..."
python manage.py migrate --noinput

echo "[entrypoint] Collecting static files..."
python manage.py collectstatic --noinput || true

echo "[entrypoint] Initializing SocialApp (Google) from env..."
python manage.py init_socialapp || true

# Exec the container CMD
exec "$@"
