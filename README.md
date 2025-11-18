# SSO Google (Django + django-allauth)

Breve descripción
- Pequeña aplicación Django que muestra un flujo de inicio de sesión con Google (SSO) usando `django-allauth`.

Requisitos
- Docker y Docker Compose (recomendado).  
- Opcional (desarrollo): Python 3.11+, `pip` y `virtualenv`.

Variables de entorno
- Crea un archivo `.env` en la raíz del proyecto con, como mínimo:

```
SECRET_KEY="valor-secreto-cualquiera"
DEBUG=1
GOOGLE_CLIENT_ID=TU_GOOGLE_CLIENT_ID.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=TU_GOOGLE_CLIENT_SECRET
```

Ejecución rápida (usar Docker)
1) Desde la raíz del proyecto ejecutar:

```powershell
docker compose up --build
```

2) Abrir en el navegador: `http://localhost:9778/`

La imagen y el `entrypoint` están preparados para ejecutar migraciones, `collectstatic` y el comando `init_socialapp` al arrancar, por lo que, con las variables correctas en `.env`, no es necesario configuración manual en el admin.

Uso y comprobaciones
- Pulsa "Iniciar sesión con Google" y completa el flujo de OAuth.
- Tras completar el login verás tu nombre y se creará un usuario en la base de datos local (`db.sqlite3`).
- Reinicia el servicio y vuelve a iniciar sesión para comprobar persistencia.

Desarrollo local (opcional, si no quieres Docker)
1) Crear entorno virtual, instalar dependencias y ejecutar localmente:

```powershell
python -m venv .venv
& .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
cp .env.example .env # editar valores
& .\.venv\Scripts\python.exe manage.py migrate
& .\.venv\Scripts\python.exe manage.py init_socialapp
& .\.venv\Scripts\python.exe manage.py runserver 0.0.0.0:9778
```

Acceso al admin (opcional)
- Crear un superusuario dentro del contenedor o localmente:

```powershell
docker compose run --rm prodigiosovolcan python manage.py createsuperuser
```

Luego acceder a `http://localhost:9778/admin/`.

Configuración de Google OAuth
- En Google Cloud Console crea credenciales OAuth (aplicación web) y añade:
	- Authorized redirect URI: `http://localhost:9778/accounts/google/login/callback/`
	- Authorized JavaScript origin: `http://localhost:9778`

Notas de seguridad y despliegue
- No comites el archivo `.env` con credenciales reales. Usa `.env.example` como plantilla.
- En producción usa un mecanismo seguro de gestión de secretos (Vault, secretos del proveedor o variables de entorno del orquestador).

Resolución de problemas comunes
- Error de redirect: verifica que la URL de callback esté registrada en Google Cloud Console.
- Problemas con CSS/estilos: espera a que `collectstatic` finalice o forzar recarga del navegador.

Si quieres que deje todas las plantillas totalmente en español (texto visible en la UI), puedo buscarlas y traducirlas ahora.
