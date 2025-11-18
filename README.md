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
& ".\.venv\Scripts\python.exe" manage.py init_socialapp
```

4. Run development server

```powershell
& ".\.venv\Scripts\python.exe" manage.py runserver 0.0.0.0:9778
```

Visit `http://localhost:9778` — the homepage shows a "Iniciar sesión con Google" button. When first logging in via Google, a user will be created in the local DB and next logins will persist (SSO persistence).

If you deploy behind a reverse proxy (nginx) and want to serve static files from a folder, run:

```powershell
& ".\.venv\Scripts\python.exe" manage.py collectstatic --noinput
```

**Important:** Configure your Google OAuth credential in Google Cloud Console to allow redirect URIs:

- Redirect URI: `http://localhost:9778/accounts/google/login/callback/`
- JavaScript origin: `http://localhost:9778`

## Docker Compose (prod/dev)

The repository contains `docker-compose.yml` and `Dockerfile.dockerfile`. Run:

```powershell
docker compose up --build
```

This builds a container named `prodigiosovolcan` and maps port `9778` to the host. `.env` is used for environment variables.

Note: the Docker run command uses `gunicorn` by default for production. For development you can change the command to `python manage.py runserver 0.0.0.0:9778` in the `Dockerfile.dockerfile` or use volumes and hot reload.

The image now includes an entrypoint script that runs database migrations, `collectstatic` and the `init_socialapp` management command automatically when the container starts. This means after `docker compose up --build` the app will be migrated and the Google `SocialApp` initialized using `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` from `.env`.

If you prefer to run the commands manually, set a different command in `docker-compose.yml` or use `docker compose run --rm prodigiosovolcan sh` and execute the management commands inside the container.

## Publish to GitHub (safe handling of secrets)

1. Make sure you do NOT commit real secrets. Use the provided `.env.example` and keep your real `.env` locally.

```powershell
# Remove `.env` from the index if it was accidentally committed
git rm --cached .env || true
echo ".env" >> .gitignore
git add .gitignore .env.example README.md
git commit -m "Remove .env from repo, add .env.example and docs"
```

2. Push to your GitHub remote (replace `origin` and `main` if different):

```powershell
git push origin main
```

3. On GitHub repository settings add two repository secrets: `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`.

4. If you deploy via CI (GitHub Actions) or to a server, make sure those secrets are injected as environment variables into the Docker runtime or the host environment. The provided `docker-compose.yml` reads variables from `.env` for local runs; in production use your platform's secret management.

If you want, I can add a simple GitHub Actions workflow that builds the Docker image and pushes it to Docker Hub or deploys it to a server using the repository secrets.

## Adding the SocialApp manually (if you prefer Admin UI)

1. Create a superuser:

```powershell
& ".\.venv\Scripts\python.exe" manage.py createsuperuser
```

2. Log into `http://localhost:9778/admin/` and create a `SocialApp` (provider: Google) with your credentials and attach it to the default `example.com` site (or change the site `domain` to `localhost:9778` first).
Guía rápida para el evaluador

Objetivo: arrancar la aplicación y verificar el flujo SSO con Google.

Requisitos mínimos
- Docker y Docker Compose instalados en la máquina del evaluador.

Variables necesarias
- Crea un archivo `.env` en la raíz del proyecto con estas variables:
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
