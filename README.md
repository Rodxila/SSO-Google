# SSO Google (Django + django-allauth)

Breve descripción
- Pequeña aplicación Django que muestra un flujo de inicio de sesión con Google (SSO) usando `django-allauth`.

Requisitos
- Docker y Docker Compose (recomendado).  
- Opcional (desarrollo): Python 3.11+, `pip` y `virtualenv`.


Ejecución rápida (usar Docker)

0) clonar el repositorio https://github.com/Rodxila/SSO-Google.git

1) Cómo obtener el `GOOGLE_CLIENT_ID` y `GOOGLE_CLIENT_SECRET`:

  Abrir Google Cloud Console: https://console.cloud.google.com/

2) Crear o seleccionar un proyecto.

3) Configurar la pantalla de consentimiento (OAuth Consent Screen):
	- En el menú lateral selecciona "APIs y servicios" → "Pantalla de consentimiento OAuth".
	- Elige tipo "Externa" (si el proyecto será usado por cualquier cuenta) o "Interna" (solo cuentas de la organización).
	- Rellena el nombre de la aplicación, correo de soporte y dominios autorizados si se solicita.
	- Añade los scopes básicos: `openid`, `email`, `profile` (suelen ser suficientes para este ejemplo).

4) Crear credenciales OAuth 2.0:
	- En el menú lateral selecciona "APIs y servicios" → "Credenciales" → "Crear credenciales" → "ID de cliente de OAuth".
	- Tipo de aplicación: "Aplicación web".
	- En "Orígenes de JavaScript autorizados" añade: `http://localhost:9778`
	- En "URI de redireccionamiento autorizados" añade: `http://localhost:9778/accounts/google/login/callback/`
	- Crear y copia el `Client ID` y el `Client secret` que te proporcione la consola.

5) Pegar las credenciales en tu `.env` local
	- Crea el archivo `.env` en la raíz del proyecto y añade/actualiza:

```
GOOGLE_CLIENT_ID=tu-client-id-aqui.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=tu-client-secret-aqui
```

6) Consideraciones finales
	- Si usas el proyecto para pruebas con cuentas externas, la verificación del consentimiento de Google puede tardar o requerir que añadas usuarios de prueba; para uso local en desarrollo suele bastar con añadir los datos y probar el flujo.
	- No compartas el `GOOGLE_CLIENT_SECRET` públicamente. Manténlo en `.env` o en el sistema de gestión de secretos que uses.





7) Desde la raíz del proyecto ejecutar:

```powershell
docker compose up --build
```

8) Abrir en el navegador: `http://localhost:9778/`

La imagen y el `entrypoint` están preparados para ejecutar migraciones, `collectstatic` y el comando `init_socialapp` al arrancar, por lo que, con las variables correctas en `.env`, no es necesario configuración manual en el admin.

Uso y comprobaciones
- Pulsa "Iniciar sesión con Google" y completa el flujo de OAuth.
- Tras completar el login verás tu nombre y se creará un usuario en la base de datos local (`db.sqlite3`).
- Reinicia el servicio y vuelve a iniciar sesión para comprobar persistencia.


