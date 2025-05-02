# 🚀 Flutter Web - Despliegue Automático con GitHub Actions

Este proyecto muestra cómo desplegar automáticamente una aplicación Flutter Web a un servidor Ubuntu remoto utilizando **Docker** y **GitHub Actions**.

---

## 🧱 Estructura del Proyecto

```
flutter-web-app/
├── lib/
├── web/
├── pubspec.yaml
├── Dockerfile
├── README.md
└── .github/
    └── workflows/
        └── deploy.yml
```

---

## ⚙️ Despliegue Automático

Cada vez que haces `git push` a la rama `main`, se ejecuta el siguiente flujo:

1. ✅ Clona el código desde GitHub.
2. 🔐 Se conecta por SSH al servidor Ubuntu.
3. 📤 Envía el código comprimido.
4. 🛠️ Construye la imagen Docker (ejecutando `flutter build web`).
5. 🚢 Corre un contenedor con Nginx sirviendo la app en el puerto 80.

---

## 🔐 Secretos Requeridos (en GitHub)

Debes configurar estos **secrets** en tu repositorio:

| Secreto           | Descripción                                 |
|------------------|---------------------------------------------|
| `SSH_PRIVATE_KEY` | Tu clave privada `id_rsa` (en formato PEM) |
| `SSH_HOST`        | IP o dominio de tu servidor Ubuntu         |
| `SSH_USER`        | Usuario con acceso SSH (ej: `ubuntu`)      |
| `SSH_PORT`        | Puerto SSH (usualmente `22`)               |

> Ve a **Settings > Secrets and variables > Actions** para agregarlos.

---

## 📦 Dockerfile

Este archivo define una imagen multietapa que construye la app y la sirve con Nginx:

```dockerfile
# Etapa 1: Construcción de la app Flutter
FROM ubuntu:22.04
RUN apt update && apt install -y git curl unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web

# Etapa 2: Servir con Nginx
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
```

---

## ✅ Resultado Esperado

Una vez desplegada, tu aplicación estará disponible en:

```
http://<SSH_HOST>/
```

o en tu dominio si configuraste uno apuntando a ese servidor.

---

