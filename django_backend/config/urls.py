from django.contrib import admin
from django.urls import path, include
# from common.views import healthz
from apps.common.views import healthz

urlpatterns = [
    path("admin/", admin.site.urls),
    path("healthz", healthz),
    path("api/", include("apps.users.urls")),
    path("api/", include("apps.tasks.urls")),
]
