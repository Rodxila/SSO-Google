# Guía rápida para el evaluador

Objetivo
- Arrancar la aplicación y verificar el flujo de inicio de sesión con Google (SSO).

Requisitos mínimos
- Docker y Docker Compose instalados en la máquina del evaluador.

Variables necesarias
- Crear un archivo `.env` en la raíz del proyecto con estas variables:

```
SECRET_KEY="valor-secreto-cualquiera"
DEBUG=1
GOOGLE_CLIENT_ID=TU_GOOGLE_CLIENT_ID.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=TU_GOOGLE_CLIENT_SECRET
```

Arranque rápido
1) Ejecutar en PowerShell:

```powershell
docker compose up --build
```

2) Abrir en el navegador: `http://localhost:9778/`

Verificaciones principales
- Pulsar "Iniciar sesión con Google" y completar el flujo.
- Tras iniciar sesión deberías ver tu nombre y un usuario creado en la base de datos local (`db.sqlite3`).
- Reiniciar el servicio y volver a iniciar sesión para confirmar persistencia.

Acceso al panel de administración (opcional)
- Crear un superusuario dentro del contenedor:

```powershell
docker compose run --rm prodigiosovolcan python manage.py createsuperuser
```

- Entrar en `http://localhost:9778/admin/`.

Notas técnicas rápidas
- El contenedor ejecuta automáticamente migraciones, `collectstatic` e `init_socialapp` al arrancar.
- La aplicación usa SQLite (`db.sqlite3`) por defecto; el fichero se guarda en la raíz del proyecto.

Problemas comunes
- Si el inicio de sesión falla por redirect URI, verifica en Google Cloud Console que `http://localhost:9778/accounts/google/login/callback/` esté registrado.
- Si no ves estilos, espera a que termine `collectstatic` al arrancar el contenedor o recarga la página.

Contacto
- Si quieres que prepare un entorno con HTTPS o añada pruebas adicionales, dímelo y lo preparo.
