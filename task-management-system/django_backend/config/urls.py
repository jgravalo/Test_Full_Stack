from django.contrib import admin
from django.urls import path
# from common.views import healthz
from apps.common.views import healthz

urlpatterns = [
    path("admin/", admin.site.urls),
    path("healthz", healthz),
]
