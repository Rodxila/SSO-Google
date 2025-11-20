FROM python:3.11-slim
WORKDIR /app

# Copia todo el proyecto
COPY . /app

# Instala dependencias
RUN pip install --no-cache-dir -r /app/requirements.txt

# Da permisos al script de entrada
RUN chmod +x /app/docker-entrypoint.sh

# Configura entorno
ENV PYTHONUNBUFFERED=1
EXPOSE 9778

# Ejecuta el script como punto de entrada
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:9778", "--workers", "1"]
