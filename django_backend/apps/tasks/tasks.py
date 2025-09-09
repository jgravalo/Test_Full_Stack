from celery import shared_task
from django.contrib.auth import get_user_model
from .models import Task
import logging

logger = logging.getLogger(__name__)
User = get_user_model()

@shared_task
def log_pending_tasks():
    """
    Tarea periódica: cuenta tareas pendientes por usuario y lo deja en logs.
    Así verificas que beat dispara y worker ejecuta.
    """
    for u in User.objects.all():
        pending = Task.objects.filter(owner=u, is_done=False).count()
        logger.info(f"[Celery] {u.username} tiene {pending} tareas pendientes.")
    return "ok"

@shared_task(bind=True, max_retries=3, default_retry_delay=5)
def uppercase_title(self, task_id):
    """
    Tarea on-demand: transforma a mayúsculas el título de una Task.
    Sirve para probar ejecución inmediata via .delay()
    """
    try:
        t = Task.objects.get(pk=task_id)
        t.title = t.title.upper()
        t.save(update_fields=["title"])
        return {"id": t.id, "title": t.title}
    except Task.DoesNotExist as exc:
        raise self.retry(exc=exc)
