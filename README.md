# 📝 Task Management System

Sistema de gestión de tareas desarrollado con **Django REST Framework**, **PostgreSQL**, **Redis** y **Celery**.  
Incluye autenticación mediante **JWT**, ejecución de tareas en segundo plano y programadas, y una arquitectura lista para despliegue en contenedores Docker.

---

## 🚀 Características principales

- **API REST** para gestión de usuarios y tareas.
- **Autenticación JWT** con SimpleJWT.
- **Celery + Redis** para procesamiento en segundo plano y ejecución periódica.
- **PostgreSQL** como base de datos relacional.
- Entorno completamente **dockerizado**.
- Scripts y `Makefile` para simplificar comandos frecuentes.
- Tests automatizados con Django.

---

## 📦 Requisitos

- [Docker](https://docs.docker.com/get-docker/)  
- [Docker Compose](https://docs.docker.com/compose/)  
- (Opcional) GNU Make

---

## ⚙️ Configuración

1. Clonar el repositorio:

   ```bash
   git clone <url-del-repo>
   cd task-management-system
   ```

2. Configurar variables de entorno:  

   Copiar el archivo de ejemplo:

   ```bash
   cp .env.sample .env
   ```

   Variables relevantes:

   ```
   DJANGO_SECRET_KEY=dev-secret
   DJANGO_DEBUG=True
   DJANGO_ALLOWED_HOSTS=*
   
   POSTGRES_DB=tms
   POSTGRES_USER=tms
   POSTGRES_PASSWORD=tms
   POSTGRES_HOST=db
   POSTGRES_PORT=5432
   
   REDIS_URL=redis://redis:6379/1
   CELERY_BROKER_URL=redis://redis:6379/1
   CELERY_RESULT_BACKEND=redis://redis:6379/2
   TIME_ZONE=Europe/Madrid
   ```

---

## ▶️ Puesta en marcha

Levantar servicios:

```bash
docker-compose up -d --build
```

Comprobar estado:

```bash
docker-compose ps
```

Servicios disponibles:

- `tms_web` → API Django
- `tms_db` → PostgreSQL
- `tms_redis` → Redis
- `tms_worker` → Celery Worker
- `tms_beat` → Celery Beat (tareas programadas)

---

## 🔑 Autenticación

Obtener token:

```bash
curl -X POST http://localhost:8000/api/token/   -H "Content-Type: application/json"   -d '{"username":"usuario","password":"clave"}'
```

Ejemplo de respuesta:

```json
{
  "access": "<jwt-access>",
  "refresh": "<jwt-refresh>"
}
```

Usar el token en los endpoints protegidos:

```bash
curl http://localhost:8000/api/me/   -H "Authorization: Bearer <jwt-access>"
```

---

## 📚 Endpoints principales

### 👤 Usuarios

- `POST /api/token/` → obtener token JWT  
- `GET /api/me/` → usuario autenticado

### ✅ Tareas

- `POST /api/tasks/` → crear tarea  
- `GET /api/tasks/` → listar tareas  
- `GET /api/tasks/{id}/` → detalle  
- `PATCH /api/tasks/{id}/` → actualizar  
- `DELETE /api/tasks/{id}/` → eliminar  

Ejemplo:

```bash
curl -X POST http://localhost:8000/api/tasks/   -H "Authorization: Bearer <jwt-access>"   -H "Content-Type: application/json"   -d '{"title":"primera tarea","description":"aprender django con docker"}'
```

---

## ⏱️ Tareas en segundo plano

El sistema incluye un ejemplo de tarea periódica:

- `apps.tasks.tasks.log_pending_tasks` → se ejecuta cada minuto y escribe en logs.

Ver logs:

```bash
docker-compose logs -f worker
docker-compose logs -f beat
```

Ejemplo manual desde shell de Django:

```bash
docker-compose exec web python manage.py shell
```

```python
from apps.tasks.tasks import uppercase_title
from apps.tasks.models import Task

task = Task.objects.first()
uppercase_title.delay(task.id)
```

---

## 🧪 Tests

Ejecutar pruebas:

```bash
docker-compose exec web python manage.py test -v 2
```

---

## 🛠️ Comandos útiles

Con `docker-compose`:

```bash
docker-compose up -d        # levantar
docker-compose down         # parar
docker-compose logs -f web  # logs de Django
```

Con `Makefile` (si está disponible):

```bash
make up
make down
make migrate
make testv
```

---

## 🩺 Troubleshooting

- **relation "tasks_task" does not exist**  
  Ejecutar migraciones:
  ```bash
  docker-compose exec web python manage.py migrate
  ```

- **Worker no procesa tareas**  
  Asegúrate de que `tms_worker` y `tms_beat` están activos.

- **JWT 401 Unauthorized**  
  Verifica credenciales y el header:
  ```
  Authorization: Bearer <access-token>
  ```

---

## 📌 Notas finales

Este proyecto constituye una **API backend lista para producción**, extensible con frontend en React/Vue/Angular o cualquier cliente HTTP.
