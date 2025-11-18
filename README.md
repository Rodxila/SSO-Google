# SSO Google Example (Django + allauth)

This repository contains a small Django app that demonstrates Google SSO using `django-allauth`.

## Quick start (local)

1. Create a virtualenv and install dependencies (Windows PowerShell):

```powershell
python -m venv .venv
& .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

2. Copy `.env` (or update) and set your Google OAuth credentials:

```text
SECRET_KEY="..."
DEBUG=1
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

3. Apply Django migrations and create the SocialApp that links the Google provider with your site:

```powershell
& ".\.venv\Scripts\python.exe" manage.py migrate
# Guía rápida para el evaluador

Objetivo: arrancar la aplicación y verificar el flujo SSO con Google.

Requisitos mínimos
- Docker y Docker Compose instalados en la máquina del evaluador.

Variables necesarias
- Crea un archivo `.env` en la raíz del proyecto con estas variables:

```
SECRET_KEY="valor-secreto-cualquiera"
DEBUG=1
GOOGLE_CLIENT_ID=TU_GOOGLE_CLIENT_ID.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=TU_GOOGLE_CLIENT_SECRET
```

Arranque rápido

1) Ejecutar (PowerShell):

```powershell
docker compose up --build
```

2) Abrir en el navegador: `http://localhost:9778/`

Qué comprobar
- Hacer clic en "Iniciar sesión con Google" y completar el flujo.
- Tras el login deberías ver tu nombre y que se ha creado un usuario en la base de datos (`db.sqlite3`).
- Reinicia el contenedor (`Ctrl+C` en la terminal y vuelve a `docker compose up`) y vuelve a iniciar sesión para comprobar persistencia.

Acceso al admin Django (opcional)
- Crear un superuser dentro del contenedor:

```powershell
docker compose run --rm prodigiosovolcan python manage.py createsuperuser
```

- Acceder a `http://localhost:9778/admin/`.

Notas técnicas rápidas
- El contenedor ejecuta automáticamente migraciones, `collectstatic` y `init_socialapp` al arrancar, por lo que no es necesario crear la `SocialApp` en el admin.
- La base de datos por defecto es `db.sqlite3` y se guarda en el directorio del proyecto.

Problemas comunes
- Si el login falla por redirect URI, comprueba en Google Cloud Console que `http://localhost:9778/accounts/google/login/callback/` esté en los Redirect URIs.
- Si no ves cambios en CSS, espera a que `collectstatic` termine al arrancar el contenedor o recarga la página.

Contacto del autor
- Si necesitas que haga alguna prueba adicional o prepare un entorno con HTTPS, dime y lo preparo.
