# 🚀 Flutter Web - Despliegue Automático con GitHub Actions

Este proyecto muestra cómo desplegar una app Flutter Web automáticamente a un servidor Ubuntu remoto utilizando Docker y GitHub Actions.

## 🧱 Estructura del proyecto

flutter-web-app/
├── lib/
├── web/
├── pubspec.yaml
├── Dockerfile
├── README.md
└── .github/
└── workflows/
└── deploy.yml


## ⚙️ Despliegue automático

Cada vez que haces `git push` a la rama `main`, se ejecuta el flujo de trabajo:

1. Clona el código desde GitHub.
2. Se conecta por SSH al servidor Ubuntu.
3. Envía el código.
4. Construye la imagen Docker (con `flutter build web`).
5. Ejecuta un contenedor con Nginx en el puerto 80.

## 🔐 Secretos requeridos (en GitHub)

Debes configurar estos secretos:

| Secreto           | Descripción                                 |
|------------------|---------------------------------------------|
| SSH_PRIVATE_KEY  | Tu clave privada `id_rsa` (en formato PEM)  |
| SSH_HOST         | IP pública o privada del servidor Ubuntu    |
| SSH_USER         | Usuario con acceso SSH (ej: `ubuntu`)       |

## 📦 Dockerfile

```Dockerfile
FROM ubuntu:22.04
RUN apt update && apt install -y git curl unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
