# 1. Usar una imagen oficial de Python ligera
FROM python:3.11-slim

# 2. Configurar variables de entorno para optimizar Python en contenedores
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# 4. Instalar dependencias del sistema esenciales
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 5. Copiar e instalar los requerimientos de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copiar todo el código de tu backend al contenedor
COPY . .

# 7. Informar el puerto que usará el contenedor (coincide con el Ingress de Azure)
EXPOSE 8000

# 8. Comando para arrancar Uvicorn leyendo el puerto asignado dinámicamente por Azure
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
