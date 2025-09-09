#!/bin/sh
set -e
ROLE="${1:-web}"

echo "Esperando a Postgres en $DB_HOST:$DB_PORT..."
python - <<'PY'
import os, socket, time
host=os.environ.get("DB_HOST","db"); port=int(os.environ.get("DB_PORT","5432"))
for _ in range(120):
    try:
        with socket.create_connection((host, port), timeout=2): print("postgres ok"); break
    except OSError:
        print("Postgres no disponible, reintentando..."); time.sleep(2)
else:
    raise SystemExit("Postgres no respondió a tiempo")
PY

if [ "$ROLE" = "web" ] && [ -f "manage.py" ]; then
  echo "Aplicando migraciones (solo web)..."
  python manage.py migrate --noinput || true
fi

case "$ROLE" in
  web)    echo "Arrancando Django en :8000"; exec python manage.py runserver 0.0.0.0:8000 ;;
  worker) echo "Arrancando Celery worker";    exec celery -A config worker -l info ;;
  beat)   echo "Arrancando Celery beat";       exec celery -A config beat -l info ;;
  *)      exec "$@" ;;
esac
