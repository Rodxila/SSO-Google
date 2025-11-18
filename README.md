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

## Extra (nginx + https)

To respond on a subdomain via HTTPS with Let's Encrypt, add an `nginx` service and certbot to your `docker-compose.yml`. The key steps:

- Configure an `nginx` container as reverse proxy that forwards the subdomain to `prodigiosovolcan:9778`.
- Make your DNS point the subdomain to your machine, or use `/etc/hosts` for local dev.
- Use `certbot` to request certificates for that domain; mount them into `nginx` and serve HTTPS.

I can provide a sample `docker-compose.yml` + `nginx` configuration if you want to add the HTTPS proxy.

---

If you want, I can also add automatic creation of `SocialApp` via migrations or create a `docker-compose` override for local development to run `manage.py migrate` and `init_socialapp` automatically on container start.
