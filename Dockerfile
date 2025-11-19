FROM python:3.11-slim
WORKDIR /app

# Copia e instala dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código
COPY . .

ENV PYTHONUNBUFFERED=1

# Exponer puerto que usa Django (9778)
EXPOSE 9778

# Copy entrypoint and make executable
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Comando por defecto: entrypoint runs migrations/init_socialapp then exec gunicorn
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:9778", "--workers", "1"]