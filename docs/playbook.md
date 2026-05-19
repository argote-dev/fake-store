# Playbook para Crear una Nueva Funcionalidad (Feature)

Este documento sirve como guía paso a paso para desarrolladores en **Fake Store App** al momento de extender la aplicación con nuevas características. La aplicación sigue los principios de **Clean Architecture** (Arquitectura Limpia) junto con **Riverpod** para la gestión de estado y **GoRouter** para la navegación.

---

## 🏗️ Estructura de una Característica (Feature)

Cada nueva funcionalidad debe residir dentro de su propia carpeta en `lib/components/<feature_name>/` y estructurarse de la siguiente manera:

```text
lib/components/<feature_name>/
├── <feature_name>.dart             # Barrel file que exporta data/ y domain/
├── <feature_name>_router.dart      # Rutas específicas de GoRouter para esta feature
├── domain/                         # Capa de Dominio (Reglas de negocio puras, sin dependencias externas)
│   ├── models/                     # Modelos o entidades puras de Dart
│   ├── repositories/               # Interfaces (contratos) de los repositorios
│   └── use_cases/                  # Casos de uso específicos de la feature
├── data/                           # Capa de Datos (Implementaciones de persistencia y red)
│   ├── datasources/
│   │   ├── local/                  # Acceso a base de datos SQFlite
│   │   └── remote/                 # Peticiones de red utilizando Dio a través de NetworkRouter
│   ├── mappers/                    # Traductores entre DTO/Entity y los modelos de Dominio
│   ├── models/
│   │   ├── dto/                    # Modelos de transferencia de red (JSON) con fromJson/toJson
│   │   ├── entity/                 # Estructuras de base de datos local con fromMap/toMap
│   │   └── path/                   # Endpoints de API que extienden de Path
│   ├── providers/                  # Providers de Riverpod para datasources, repositories y usecases
│   └── repositories/               # Implementación concreta del repositorio de Domain
└── presentation/                   # Capa de Presentación (UI y Estado)
    ├── controllers/                # Notifiers de Riverpod para gestionar el estado de la UI
    │   └── state/                  # Modelos inmutables de estado de las pantallas
    ├── screens/                    # Widgets Scaffold principales
    └── widgets/                    # Componentes UI reusables (átomos, moléculas)
```

---

## 🛠️ Paso a Paso para Implementar una Nueva Funcionalidad

Para ilustrar el proceso, utilizaremos como ejemplo la implementación de una funcionalidad de **Wishlist** (Lista de Deseos).

### Paso 1: Definir la Capa de Dominio (`domain`)

La capa de dominio representa el núcleo de la aplicación y debe ser independiente de cualquier framework o librería externa.

#### 1.1 Crear el Modelo de Dominio
Define un modelo puro de Dart en `lib/components/wishlist/domain/models/wishlist_item.dart`:
```dart
import 'package:fake_store/components/products/domain/models/product.dart';

class WishlistItem {
  final int id;
  final Product product;
  final DateTime addedAt;

  WishlistItem({
    required this.id,
    required this.product,
    required this.addedAt,
  });
}
```

#### 1.2 Crear el Contrato del Repositorio
Define la interfaz en `lib/components/wishlist/domain/repositories/wishlist_repository.dart`:
```dart
import 'package:fake_store/common/models/result.dart';
import '../models/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Result<List<WishlistItem>>> getWishlist();
  Future<Result<void>> addToWishlist(int productId);
  Future<Result<void>> removeFromWishlist(int productId);
}
```

#### 1.3 Crear el Caso de Uso (Use Case)
Crea clases de caso de uso enfocadas en una sola acción en `lib/components/wishlist/domain/use_cases/get_wishlist_use_case.dart`:
```dart
import 'package:fake_store/common/models/result.dart';
import '../models/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistUseCase {
  final WishlistRepository _repository;

  GetWishlistUseCase(this._repository);

  Future<Result<List<WishlistItem>>> execute() {
    return _repository.getWishlist();
  }
}
```

---

### Paso 2: Implementar la Capa de Datos (`data`)

La capa de datos se encarga de proveer información desde la red (API) o persistencia local (SQLite).

#### 2.1 Definir los Modelos de Datos (DTO y Entity)
* **DTO (Data Transfer Object)** para peticiones HTTP: `lib/components/wishlist/data/models/dto/wishlist_response.dart`.
* **Entity** para persistencia SQLite: `lib/components/wishlist/data/models/entity/wishlist_entity.dart`.
* **Path** para las rutas HTTP: `lib/components/wishlist/data/models/path/wishlist_path.dart`.

Ejemplo de `wishlist_path.dart`:
```dart
import 'package:fake_store/network/path/path.dart';

class WishlistPath extends Path {
  WishlistPath() : super(url: '/api/wishlist');
}
```

#### 2.2 Crear el Mapper
Traduce los objetos de la capa de datos en entidades de dominio en `lib/components/wishlist/data/mappers/wishlist_mapper.dart`:
```dart
import '../models/dto/wishlist_response.dart';
import '../../domain/models/wishlist_item.dart';
import 'package:fake_store/components/products/data/mappers/product_mapper.dart';

class WishlistMapper {
  static WishlistItem fromDtoToDomain(WishlistResponse dto) {
    return WishlistItem(
      id: dto.id,
      product: ProductMapper.fromDtoToDomain(dto.product),
      addedAt: DateTime.parse(dto.addedAt),
    );
  }
}
```

#### 2.3 Implementar las Fuentes de Datos (DataSources)
* **Remote DataSource**: Llama a la API utilizando `NetworkRouter` y `Dio`.
```dart
import 'package:fake_store/network/model/http/http_method.dart';
import 'package:fake_store/network/model/http/http_route.dart';
import 'package:fake_store/network/router/network_router.dart';
import 'package:fake_store/common/models/result.dart';
import '../../models/dto/wishlist_response.dart';
import '../../models/path/wishlist_path.dart';

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final NetworkRouter _router;
  WishlistRemoteDataSourceImpl(this._router);

  @override
  Future<Result<List<WishlistResponse>>> fetchWishlist() async {
    final route = HttpRoute(path: WishlistPath(), method: HttpMethod.get);
    final result = await _router.fetch<dynamic>(route);
    return result.map((data) {
      final list = data as List<dynamic>;
      return list.map((e) => WishlistResponse.fromJson(e as Map<String, dynamic>)).toList();
    });
  }
}
```

* **Local DataSource**: Persistencia SQLite en caché local.
```dart
import 'package:sqflite/sqflite.dart';
import '../../../../../database/database_service.dart';
// Implementación similar a ProductsLocalDataSource utilizando DatabaseService
```

#### 2.4 Implementar el Repositorio
Implementa la interfaz del repositorio unificando las fuentes de datos remota y local en `lib/components/wishlist/data/repositories/wishlist_repository_impl.dart`.

#### 2.5 Declarar los Providers de Riverpod
Crea `lib/components/wishlist/data/providers/wishlist_provider.dart` para inyectar todas las dependencias:
```dart
import 'package:riverpod/riverpod.dart';
import 'package:fake_store/network/router/provider/network_provider.dart';
import 'package:fake_store/database/database_provider.dart';
import '../datasources/remote/wishlist_remote_data_source.dart';
import '../repositories/wishlist_repository_impl.dart';
import '../../domain/use_cases/get_wishlist_use_case.dart';

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((ref) {
  return WishlistRemoteDataSourceImpl(ref.watch(networkProvider));
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(
    ref.watch(wishlistRemoteDataSourceProvider),
    ref.watch(wishlistLocalDataSourceProvider),
  );
});

final getWishlistUseCaseProvider = Provider<GetWishlistUseCase>((ref) {
  return GetWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});
```

---

### Paso 3: Crear la Capa de Presentación (`presentation`)

Esta capa maneja la lógica de estado de la pantalla y renderiza los widgets de la interfaz de usuario.

#### 3.1 Definir el Estado Inmutable de la Pantalla
Crea `lib/components/wishlist/presentation/controllers/state/wishlist_state.dart`:
```dart
import '../../domain/models/wishlist_item.dart';

class WishlistState {
  final List<WishlistItem> items;
  final bool isLoading;
  final String? error;

  WishlistState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  WishlistState copyWith({
    List<WishlistItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
```

#### 3.2 Crear el Controlador (State Controller)
Implementa el controlador de la pantalla heredando de `Notifier<State>` en `lib/components/wishlist/presentation/controllers/wishlist_controller.dart`:
```dart
import 'package:riverpod/riverpod.dart';
import 'state/wishlist_state.dart';
import '../../data/providers/wishlist_provider.dart';

class WishlistController extends Notifier<WishlistState> {
  @override
  WishlistState build() {
    Future.microtask(() => loadWishlist());
    return WishlistState(isLoading: true);
  }

  Future<void> loadWishlist() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(getWishlistUseCaseProvider).execute();
    result.when(
      success: (items) {
        state = state.copyWith(items: items, isLoading: false);
      },
      failure: (exception) {
        state = state.copyWith(isLoading: false, error: exception.toString());
      },
    );
  }
}

final wishlistControllerProvider = NotifierProvider<WishlistController, WishlistState>(
  WishlistController.new,
);
```

#### 3.3 Construir la Pantalla (Screen Widget)
Usa `ConsumerWidget` para conectarte a Riverpod en `lib/components/wishlist/presentation/screens/wishlist_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/wishlist_controller.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wishlistControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('\$${item.product.price}'),
                    );
                  },
                ),
    );
  }
}
```

---

### Paso 4: Enrutamiento (Routing)

Cada componente encapsula sus propias rutas de navegación.

#### 4.1 Definir las Rutas de la Feature
Crea `lib/components/wishlist/wishlist_router.dart`:
```dart
import 'package:go_router/go_router.dart';
import 'presentation/screens/wishlist_screen.dart';

final List<GoRoute> wishlistRoutes = [
  GoRoute(
    path: '/wishlist',
    builder: (context, state) => const WishlistScreen(),
  ),
];
```

#### 4.2 Registrar las Rutas Globales
Importa y agrega las rutas en el archivo centralizado `lib/ui/router/app_router.dart`:
```diff
import '../../components/shopping_cart/shopping_cart_router.dart';
+import '../../components/wishlist/wishlist_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ...homeRoutes,
    ...productsRoutes,
    ...shoppingCartRoutes,
+   ...wishlistRoutes,
  ],
);
```

---

### Paso 5: Internacionalización (i18n)

Añade los textos multilenguaje a los archivos `.arb` para mantener consistencia.

1. Abre `lib/common/l10n/app_en.arb` y añade la clave:
   ```json
   "wishlistTitle": "Wishlist",
   "@wishlistTitle": {
     "description": "Title for the wishlist screen"
   }
   ```
2. Abre `lib/common/l10n/app_es.arb` y traduce:
   ```json
   "wishlistTitle": "Lista de Deseos"
   ```
3. Flutter automáticamente reconstruirá las clases tipadas locales (gracias a `generate: true` en `pubspec.yaml`). Puedes consumirlo en tu UI usando:
   ```dart
   final l10n = AppLocalizations.of(context)!;
   print(l10n.wishlistTitle);
   ```

---

### Paso 6: Migración de Base de Datos Local (SQFlite)

Si tu característica requiere una nueva tabla de base de datos local:
1. Abre `lib/database/database_service.dart`.
2. Si es una versión existente en producción, incrementa el parámetro `version` en `openDatabase` y añade la migración en un handler `onUpgrade`.
3. Para desarrollo inicial, añade la sentencia `CREATE TABLE` en el callback `_onCreate`:
   ```dart
   await db.execute('''
     CREATE TABLE wishlist (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       product_id INTEGER,
       added_at TEXT NOT NULL
     )
   ''');
   ```

---

### Paso 7: Pruebas Unitarias y de Integración (Testing)

El playbook exige cobertura de pruebas para toda funcionalidad nueva.

#### 7.1 Pruebas de Casos de Uso con Mockito
Crea el test en `test/components/wishlist/domain/use_cases/get_wishlist_use_case_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_store/common/models/result.dart';
import 'package:fake_store/components/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:fake_store/components/wishlist/domain/use_cases/get_wishlist_use_case.dart';

import 'get_wishlist_use_case_test.mocks.dart';

@GenerateMocks([WishlistRepository])
void main() {
  late MockWishlistRepository mockRepository;
  late GetWishlistUseCase useCase;

  setUp(() {
    mockRepository = MockWishlistRepository();
    useCase = GetWishlistUseCase(mockRepository);
  });

  // Escribe los bloques test() estructurando en base al patrón Given/When/Then
}
```

#### 7.2 Ejecutar la Generación de Mocks y Tests
Ejecuta `build_runner` para compilar los archivos `.mocks.dart`:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Corre el set de pruebas para comprobar la salud de tu código:
```bash
flutter test
```

---

## 🧼 Reglas Generales de Calidad de Código
* **Clases de Datos Inmutables**: Utiliza constructores `const` y métodos `copyWith` siempre que sea posible.
* **Archivos Barrel**: No olvides crear los archivos barrel (`<feature_name>.dart`) para simplificar importaciones en otros componentes.
* **Manejo de Errores Tipados**: Utiliza el tipo genérico `Result<T>` en vez de lanzar excepciones descontroladas que rompan la aplicación.
* **Separación de Responsabilidades**: Las vistas no deben llamar directamente a las fuentes de datos ni lógica de red, siempre pasa a través de su caso de uso e inyección vía Riverpod.
