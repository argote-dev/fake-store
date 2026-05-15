# Fake Store App

Una aplicación de comercio electrónico moderna construida con Flutter, que demuestra una arquitectura limpia, gestión de estado avanzada y persistencia de datos local.

## Características

- **Catálogo de Productos:** Exploración de productos por categorías.
- **Carrito de Compras:** Gestión completa del carrito (agregar, eliminar, actualizar cantidades).
- **Persistencia Local:** Uso de SQLite para mantener el carrito y preferencias incluso sin conexión.
- **Internacionalización (i18n):** Soporte completo para Inglés y Español (Latinoamérica).
- **Modo Oscuro/Claro:** Soporte de temas dinámicos.
- **Navegación Avanzada:** Enrutamiento declarativo y tipado.

## Stack Tecnológico

- **Framework:** [Flutter](https://flutter.dev)
- **Gestión de Estado:** [Riverpod](https://riverpod.dev)
- **Navegación:** [GoRouter](https://pub.dev/packages/go_router)
- **Networking:** [Dio](https://pub.dev/packages/dio)
- **Base de Datos Local:** [SQFLite](https://pub.dev/packages/sqflite)
- **Variables de Entorno:** [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)
- **Estilos:** Flexibilidad con widgets personalizados y Grid View escalonado.

## Prerrequisitos

- Flutter SDK: `^3.11.5`
- Dart SDK: Compatible con la versión de Flutter mencionada.
- Android Studio / VS Code con extensiones de Flutter y Dart.

## Configuración

### 1. Clonar el repositorio
```bash
git clone <url-del-repositorio>
cd fake_store
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar variables de entorno
La aplicación utiliza un archivo `.env` para la configuración de la API.
- Copia el archivo de ejemplo:
  ```bash
  cp .env.example .env
  ```
- Edita el archivo `.env` y configura la `BASE_URL` (por defecto apunta a una API de ejemplo):
  ```env
  BASE_URL=https://fakestoreapi.com
  ```

### 4. Generación de código (si aplica)
Si has realizado cambios en modelos o archivos que requieran generación de código:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Ejecución

Para ejecutar la aplicación en modo debug:

```bash
flutter run
```

Para compilar una versión de producción:

- **Android:** `flutter build apk`
- **iOS:** `flutter build ios`

## Pruebas

El proyecto incluye pruebas unitarias y de widgets para asegurar la calidad del código.

Ejecutar todas las pruebas:
```bash
flutter test
```

Verificar cobertura (opcional):
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Estructura del Proyecto

```text
lib/
├── common/         # Configuraciones globales, l10n, utilidades y entorno.
├── components/     # Módulos de la app (Home, Products, Shopping Cart, Categories).
│   └── <feature>/
│       ├── data/         # Repositorios y fuentes de datos.
│       ├── domain/       # Modelos y entidades.
│       └── presentation/ # Widgets, Screens y Providers de la UI.
├── network/        # Configuración de Dio y routers de API.
├── ui/             # Temas, componentes globales y configuración de rutas.
└── main.dart       # Punto de entrada de la aplicación.
```

## Contribuciones

1. Haz un Fork del proyecto.
2. Crea una rama para tu característica (`git checkout -b feature/AmazingFeature`).
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`).
4. Push a la rama (`git push origin feature/AmazingFeature`).
5. Abre un Pull Request.

---
Desarrollado usando Flutter y mucho Café.
