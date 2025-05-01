FROM ubuntu:22.04

# Instalar dependencias necesarias
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa wget

# Instalar Flutter desde GitHub (última versión estable)
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter

# Agregar Flutter y Dart al PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Descargar SDKs
RUN flutter doctor

# Crear carpeta de trabajo
WORKDIR /app

# Copiar código del proyecto
COPY . .

# Obtener dependencias
RUN flutter pub get

# Compilar para web
RUN flutter build web

# Etapa final: Nginx para servir la app
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
