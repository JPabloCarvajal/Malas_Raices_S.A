# MalasRaíces S.A.

App móvil en Flutter para gestión de propiedades en arriendo con backend en FastAPI.


## Tecnologías

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/dart-Language-blue?logo=dart">
  <img alt="Flutter" src="https://img.shields.io/badge/flutter-Framework-blue?logo=FLUTTER">
  <img alt="Py" src="https://img.shields.io/badge/Python-Api-yellow?logo=Python">
  <img alt="Api" src="https://img.shields.io/badge/Pip-Api_Images_Management-yellow?logo=Python">
  <img alt="Api" src="https://img.shields.io/badge/FastApi-Api_Develoment-green?logo=FastApi">
  <img alt="Db" src="https://img.shields.io/badge/json-Api_Database-white?logo=json">
</p>

## Previsualización

![videoap](https://github.com/user-attachments/assets/58d5b169-77bc-45eb-bbec-3f1caeef6312)

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

## Autores

Juan Pablo Carvajal Giraldo
Desarrollo de Aplicaciones Móviles — UPB Bucaramanga

Pedro Mateo Espinel Dominguez
Desarrollo de Aplicaciones Móviles — UPB Bucaramanga

Daniel Felipe Aguilar Latorre
Desarrollo de Aplicaciones Móviles — UPB Bucaramanga

Juan David Monsalve
Desarrollo de Aplicaciones Móviles — UPB Bucaramanga

Johan David Rodriguez Castro
Desarrollo de Aplicaciones Móviles — UPB Bucaramanga