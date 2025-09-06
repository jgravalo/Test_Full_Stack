#!/bin/bash
# echo login y obtener token jwt
# curl -X POST http://localhost:8000/api/auth/login/ \
#   -H "Content-Type: application/json" \
#   -d '{"username": "root", "password": "123456789"}'

# TU_ACCESS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU3MDk1NzU2LCJpYXQiOjE3NTcwOTU0NTYsImp0aSI6IjQ3MTE1ZTRiMjdiMjQ4NjQ5ZjFmZGMwZDQwYzdmMWExIiwidXNlcl9pZCI6IjEifQ.pFzsxO0Guyuawt-FCGvlHQwEh5kvn66i9piv2F14DIo

#!/bin/bash

# docker-compose run --rm web python manage.py createsuperuser

# Realiza login y obtiene el token de acceso
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username": "root", "password": "123456"}')

# Extrae el valor de 'access' usando jq
TU_ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.access')

echo "Authorization: Bearer $TU_ACCESS_TOKEN"
# ...resto del script...
echo
# echo; echo; echo; echo; echo; echo; echo; echo espacio; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo;
echo ver tu usuario actual
curl -X GET http://localhost:8000/api/me/ \
  -H "Authorization: Bearer $TU_ACCESS_TOKEN"
echo

echo
# echo; echo; echo; echo; echo; echo; echo; echo espacio; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo;
echo crear una tarea
curl -X POST http://localhost:8000/api/tasks/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TU_ACCESS_TOKEN" \
  -d '{"title": "primera tarea", "description": "aprender django con docker"}'
echo

echo
# echo; echo; echo; echo; echo; echo; echo; echo espacio; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo;
echo listar todas las tareas
curl -X GET http://localhost:8000/api/tasks/ \
  -H "Authorization: Bearer $TU_ACCESS_TOKEN"
echo

echo
# echo; echo; echo; echo; echo; echo; echo; echo espacio; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo;
echo ver la tarea con id 1
curl -X GET http://localhost:8000/api/tasks/1/ \
  -H "Authorization: Bearer $TU_ACCESS_TOKEN"
echo

echo
# echo; echo; echo; echo; echo; echo; echo; echo espacio; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo; echo;
echo actualizar la tarea con id 1
curl -X PUT http://localhost:8000/api/tasks/1/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TU_ACCESS_TOKEN" \
  -d '{"title": "primera tarea", "description": "actualizada", "is_done": true}'
echo

echo
