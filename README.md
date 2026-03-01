# MalasRaíces S.A.

App móvil en Flutter para gestión de propiedades en arriendo con backend en FastAPI.

## Requisitos

- Flutter 3.0+
- Python 3.10+
- pip

## Instalación

### App Flutter
```bash
cd malas_raices
flutter pub get
flutter doctor
```

### Backend FastAPI
```bash
cd malas_raices_api
pip install fastapi uvicorn python-multipart
```

## Ejecución

Se necesitan dos terminales abiertas al mismo tiempo.

**Terminal 1 — Backend:**
```bash
cd malas_raices_api
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 — Flutter:**
```bash
cd malas_raices
flutter run
```

## Documentación de la API

Con el servidor corriendo, abre en tu navegador:
```
http://localhost:8000/docs
```

Ahí puedes probar todos los endpoints de forma interactiva.

## Usuarios de prueba

| Email                    | Contraseña | Rol          |
|--------------------------|------------|--------------|
| carlos@malasraices.com   | 123456     | Propietario  |
| maria@correo.com         | 123456     | Arrendatario |

## Stack tecnológico

- **Frontend:** Flutter / Dart
- **Backend:** FastAPI / Python
- **Base de datos:** Archivos JSON
- **Almacenamiento de imágenes:** Carpeta /uploads en el servidor

## Autor

Juan Pablo Carvajal Giraldo
Desarrollo de Aplicaciones Móviles — UPB Bucaramanga