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
# ProdigioSOVolcan — SSO con Google (Django + django-allauth)

Este repositorio contiene una pequeña aplicación Django que demuestra inicio de sesión mediante Google (SSO) usando `django-allauth`.

Objetivo para el evaluador: ejecutar la aplicación con un único comando y verificar el flujo SSO. El servicio Docker se llama `prodigiosovolcan` y expone el puerto `9778`.

Requisitos previos
- Tener Docker y Docker Compose instalados en la máquina del evaluador.
- (Opcional para pruebas locales) Python 3.11+, `pip` y `docker` instalados.

Ejecución (único paso)

1. Copia o crea un archivo `.env` en la raíz del proyecto con las variables obligatorias (no subirlo al repositorio):

```
SECRET_KEY="cualquier-valor-seguro"
DEBUG=1
GOOGLE_CLIENT_ID=TU_GOOGLE_CLIENT_ID.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=TU_GOOGLE_CLIENT_SECRET
```

2. Levantar la aplicación (recomendado):

```powershell
docker compose up --build
```

Esto construye la imagen y levanta el servicio `prodigiosovolcan` (puerto mapeado `9778:9778`). El `entrypoint` del contenedor ejecuta automáticamente: migraciones, `collectstatic` y el comando `init_socialapp` que crea/actualiza la `SocialApp` de Google usando `GOOGLE_CLIENT_ID` y `GOOGLE_CLIENT_SECRET`.

URLs útiles
- Aplicación: http://localhost:9778/
- Callback de Google (debe estar configurado en Google Console):
	- `http://localhost:9778/accounts/google/login/callback/`
- Admin Django (si creas superuser dentro del contenedor o localmente): http://localhost:9778/admin/

Qué verificar como evaluador
- Abrir la página principal y hacer clic en "Iniciar sesión con Google".
- Tras completar el flujo de Google deberías ver tu nombre en pantalla y un usuario creado en la base de datos SQLite (`db.sqlite3`).
- Reiniciar el contenedor y volver a iniciar sesión para confirmar persistencia de usuarios.

Credenciales de Google (configuración)
- En Google Cloud Console crea unas credenciales OAuth 2.0 del tipo "Client ID" (aplicación web).
- Establece:
	- Authorized redirect URIs: `http://localhost:9778/accounts/google/login/callback/`
	- Authorized JavaScript origins: `http://localhost:9778`
- Usa los valores en el `.env` o como secretos en tu plataforma de despliegue.

Notas para auditoría técnica
- Servicio Docker: el `docker-compose.yml` define el servicio `prodigiosovolcan` y monta variables desde `.env`.
- El contenedor inicializa la app automáticamente (migrate + init_socialapp). No se requiere intervención en el panel Django para crear la `SocialApp`.
- La base de datos por defecto es SQLite (`db.sqlite3`) para simplicidad y persistencia entre reinicios del contenedor (si el volumen/archivo se mantiene en la carpeta del proyecto).

Desarrollo local sin Docker (opcional)
- Crear virtualenv (PowerShell):

```powershell
python -m venv .venv
& .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
cp .env.example .env # editar valores
& .\.venv\Scripts\python.exe manage.py migrate
& .\.venv\Scripts\python.exe manage.py init_socialapp
& .\.venv\Scripts\python.exe manage.py runserver 0.0.0.0:9778
```

Seguridad y manejo de secretos
- NO comitees tu `.env` con credenciales reales. Usa `.env.example` para documentar variables.
- En CI/production usa el gestor de secretos de la plataforma (GitHub Secrets, Vault, etc.) y no el archivo `.env` del repositorio.

Acceso al admin (si necesitas inspeccionar datos)
- Crear superuser manualmente dentro del contenedor o en local:

```powershell
& .\.venv\Scripts\python.exe manage.py createsuperuser
```

HTTPS / producción (opcional)
- Como extra puedes añadir un proxy `nginx` y `certbot` al `docker-compose.yml` para servir HTTPS con Let's Encrypt en un dominio real. Puedo proporcionar un ejemplo si lo deseas.

¿Qué hice para que esto sea evaluable rápidamente?
- Añadí un script de entrada (`docker-entrypoint.sh`) que ejecuta `migrate`, `collectstatic` y el comando `init_socialapp`.
- El comando `init_socialapp` crea/actualiza la `SocialApp` de Google a partir de las variables de entorno, evitando pasos manuales en el Admin.

Próximos pasos (opcional)
- Puedo añadir un workflow de GitHub Actions que construya la imagen y la publique en un registro (GHCR o Docker Hub).
- Si quieres, genero el ejemplo de `docker-compose` con `nginx` + `certbot` para facilitar el despliegue HTTPS.

Si quieres que yo haga el commit y el push de este `README.md` actualizado al repositorio remoto, dímelo y lo realizo.
