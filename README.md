# 📝 Task Management System

Task management system built with **Django REST Framework**, **PostgreSQL**, **Redis**, and **Celery**.  
Includes **JWT authentication**, background and scheduled task execution, and a fully containerized architecture ready for deployment.

---

## 🚀 Key Features

- **REST API** for user and task management.
- **JWT Authentication** with SimpleJWT.
- **Celery + Redis** for background and periodic tasks.
- **PostgreSQL** as the relational database.
- Fully **dockerized** environment.
- Scripts and `Makefile` to simplify common commands.
- Automated tests with Django.

---

## 📦 Requirements

- [Docker](https://docs.docker.com/get-docker/)  
- [Docker Compose](https://docs.docker.com/compose/)  
- (Optional) GNU Make

---

## ⚙️ Setup

1. Clone the repository:

   ```bash
   git clone <repo-url>
   cd <repo-name>
   ```

2. Configure environment variables:  

   Copy the example file:

   ```bash
   cp .env.sample .env
   ```

   Relevant variables:

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

## ▶️ Running the project

Start services:

```bash
docker-compose up -d --build
```

Check status:

```bash
docker-compose ps
```

Available services:

- `tms_web` → Django API
- `tms_db` → PostgreSQL
- `tms_redis` → Redis
- `tms_worker` → Celery Worker
- `tms_beat` → Celery Beat (scheduled tasks)

---

## 🔑 Authentication

Get token:

```bash
curl -X POST http://localhost:8000/api/token/   -H "Content-Type: application/json"   -d '{"username":"user","password":"password"}'
```

Example response:

```json
{
  "access": "<jwt-access>",
  "refresh": "<jwt-refresh>"
}
```

Use token with protected endpoints:

```bash
curl http://localhost:8000/api/me/   -H "Authorization: Bearer <jwt-access>"
```

---

## 📚 Main Endpoints

### 👤 Users

- `POST /api/token/` → obtain JWT token  
- `GET /api/me/` → authenticated user

### ✅ Tasks

- `POST /api/tasks/` → create task  
- `GET /api/tasks/` → list tasks  
- `GET /api/tasks/{id}/` → retrieve  
- `PATCH /api/tasks/{id}/` → update  
- `DELETE /api/tasks/{id}/` → delete  

Example:

```bash
curl -X POST http://localhost:8000/api/tasks/   -H "Authorization: Bearer <jwt-access>"   -H "Content-Type: application/json"   -d '{"title":"first task","description":"learn django with docker"}'
```

---

## ⏱️ Background Tasks

The system includes an example periodic task:

- `apps.tasks.tasks.log_pending_tasks` → runs every minute and logs info.

Check logs:

```bash
docker-compose logs -f worker
docker-compose logs -f beat
```

Run manually from Django shell:

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

Simple test for shell:

```bash
sh tests.sh
```

---

## 🛠️ Useful Commands

With `docker-compose`:

```bash
docker-compose up -d        # start
docker-compose down         # stop
docker-compose logs -f <service-name>  # Django logs
```

With `Makefile` (if available):

```bash
make up
make ls
make down
make migrate
```

---

## 🩺 Troubleshooting

- **relation "tasks_task" does not exist**  
  Run migrations:
  ```bash
  docker-compose exec web python manage.py migrate
  ```

- **Worker not processing tasks**  
  Ensure `tms_worker` and `tms_beat` are running.

- **JWT 401 Unauthorized**  
  Check credentials and header:
  ```
  Authorization: Bearer <access-token>
  ```

---

## 📌 Final Notes

This project is a **production-ready backend API**, extendable with a frontend in React, Vue, Angular, or any HTTP client.
