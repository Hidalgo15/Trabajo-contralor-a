# Documentación del proyecto: consultas_y_contrataciones

## 1. Visión general

Este proyecto es una aplicación móvil/escritorio desarrollada en Flutter para consultar servicios públicos de la Contraloría del Estado. La app centraliza varias consultas en un mismo flujo de navegación, con una interfaz moderna, diseño institucional y acceso a distintos servicios desde una barra de navegación y un menú lateral.

En términos de arquitectura, el proyecto usa una separación clara entre:

- Core: infraestructura compartida, navegación, tema, widgets reutilizables y cliente HTTP.
- Feature: cada funcionalidad del negocio separada en su propio módulo.
- Presentación UI: pantallas, formularios, tarjetas y resultados.
- Dominio y datos: entidades, repositorios, datasource y validaciones del negocio.

## 2. Tecnologías y dependencias principales

El proyecto está definido en `pubspec.yaml` y usa principalmente:

- Flutter SDK
- `dio` para conexiones HTTP (aunque el cliente principal usa `http`)
- `http` para las llamadas a la API
- `shared_preferences` para persistir preferencias del usuario
- `printing` y `open_file` para exportación y apertura de PDF
- `pdf` para generar documentos PDF
- `webview_flutter` para reCAPTCHA o flujo WebView
- `intl` para formateo de fechas/números

La app también cuenta con un sistema de diseño propio basado en colores, tipografías, dimensiones y widgets reutilizables.

## 3. Estructura de carpetas

```text
lib/
  main.dart
  Core/
    Captcha/
    Formatos/
    GeneralFeatures/
    GenericRepository/
    Json/
    Navigation/
    NetWork/
    Presentation/
    Theme/
    Widgets/
  Feature/
    Ajustes/
    Ayuda/
    ConsultaCorrespondencia/
    ConsultaDeCertificaciónDeCargos/
    ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/
    ConsultaEmpleadosDelEstado/
    HubPrincipal/
    Servicios/
    SolicitudDeCertDeCargos/
```

### 3.1 `Core`

Contiene la infraestructura que es compartida por la aplicación entera:

- `Navigation`: shell principal, pestañas, navegación entre pantallas y acceso a servicios.
- `Theme`: colores, tipografías, tamaños, tema claro/oscuro, controlador de preferencias.
- `Widgets`: componentes UI reutilizables
- `NetWork`: cliente HTTP que encapsula llamadas a la API
- `Captcha`: manejo del reCAPTCHA y proveedores de validación de seguridad
- `Presentation`: overlays, estados de operación, utilidades de UX
- `Json`: utilidades para leer JSON de forma segura

### 3.2 `Feature`

Cada funcionalidad se organiza en módulos independientes por negocio:

- `Ajustes`: configuración y datos generales del sistema
- `Ayuda`: FAQ y contenido de ayuda
- `ConsultaCorrespondencia`: seguimiento de documentos/correspondencia
- `ConsultaDeCertificaciónDeCargos`: estado de solicitudes de certificación
- `ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR`: consulta principal de trámites proveniente de la Contraloría
- `ConsultaEmpleadosDelEstado`: consulta de empleados
- `HubPrincipal`: pantalla inicial
- `Servicios`: listado general de servicios

Cada feature suele seguir la lógica:

- `Data`: acceso a APIs y transformaciones de datos
- `Domain`: entidades, excepciones, repositorios y contratos
- `Presentation`: pantallas, widgets y formularios
- `Config`: configuración de ambiente y endpoints

## 4. Arquitectura general

El proyecto tiene una arquitectura orientada a capas, con una mezcla de patrones orientados a UI + repositorios + data source.

### 4.1 Capa de presentación

La capa de presentación está en `Feature/*/Presentation` y en el conjunto de widgets de `Core/Widgets`.

Responsabilidades:

- Renderizar pantallas del usuario
- Capturar entradas del usuario
- Mostrar estados de carga, errores y avisos
- Redirigir hacia otras pantallas o servicios

Ejemplos:

- `PaginaInicio`
- `PaginaServicios`
- `PaginaVerificaCgr`
- `PaginaResultadosCgr`
- `PaginaConsultaEmpleados`
- `PaginaAjustes`

### 4.2 Capa de dominio

Los modelos del negocio viven en `Feature/.../Domain/Entities` y `Domain/Repository`.

Aquí se definen:

- estructuras de datos del negocio (`ProveedorEntity`, `TramiteEntity`, `ContratoEntity`)
- excepciones propias del módulo (`VerificaCgrException`)
- interfaces del repositorio (`IVerificaCgrRepository`, `IconsultaEmpleadoRespository`)

### 4.3 Capa de datos

La capa `Data` encapsula la comunicación con servicios externos y la conversión del JSON a entidades del dominio.

Ejemplos:

- `VerificaCgrRemoteDataSource`: llama al backend y procesa la respuesta JSON
- `ApiClient`: centraliza las llamadas HTTP, manejo de errores y timeout
- `VerificaCgrRepository`: valida la lógica del negocio y comunica la UI con el data source

## 5. Flujo principal de ejecución

### 5.1 Inicio de la app

En `lib/main.dart` ocurre esto:

1. `WidgetsFlutterBinding.ensureInitialized()` inicializa Flutter.
2. `registrarLicenciasDeFuentes()` carga licencias de fuentes.
3. `ThemeController.cargar()` lee las preferencias guardadas por el usuario.
4. `runApp(MiAppContraloria(tema: tema));` inicia la aplicación.

La clase `MiAppContraloria` crea el `MaterialApp` con:

- tema claro y oscuro
- `ThemeMode` dinámico
- ajuste automático de escala del texto
- pantalla principal: `AppShell`

### 5.2 Shell principal

`AppShell` es el contenedor raíz de navegación. Tiene 4 pestañas:

- Inicio
- Servicios
- Ayuda
- Ajustes

Además, cada pestaña usa un `Navigator` propio dentro de un `IndexedStack` para conservar el historial de cada una y evitar perder el estado cuando se mueve entre tabs.

#### Clases importantes

- `AppShell`: contenedor principal con la barra inferior y los tabs.
- `AppShellScope`: InheritedWidget que expone funciones para cambiar de pestaña o abrir un servicio desde cualquier pantalla.
- `AppTab`: definiciones de índices para cada tab.

### 5.3 Registro y acceso a servicios

La lista de servicios está centralizada en `Core/Navigation/servicios_app.dart` mediante:

- `enum ServicioId`
- `class ServicioApp`
- `const List<ServicioApp> serviciosApp`

Esto hace que la pantalla de Inicio, la pantalla de Servicios y el menú lateral usen la misma fuente de verdad para todos los servicios.

## 6. Documentación de clases clave

## 6.1 Core

### `ApiClient`

Archivo: `lib/Core/NetWork/api_client.dart`

Responsabilidad:

- Encapsular llamadas HTTP con `http`
- Normalizar URLs y endpoints
- Manejar timeouts
- Decodificar JSON con UTF-8
- Lanzar errores consistentes con `ApiException`

Métodos principales:

- `get(String endpoint, {Map<String, String>? queryParams, Map<String, String>? headers})`
- `post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers})`
- `_procesarRespuesta(http.Response respuesta)`
- `decodificar(http.Response respuesta)`

### `ApiException`

Excepción central para representar errores de red/HTTP.

Atributos:

- `mensaje`: mensaje amigable para la UI
- `codigo`: código HTTP, si aplica
- `detalle`: información técnica para logs

### `ThemeController`

Archivo: `lib/Core/Theme/theme_controller.dart`

Responsabilidad:

- Guardar y leer preferencias visuales del usuario con `SharedPreferences`
- Cambiar entre tema claro, oscuro y sistema
- Cambiar tamaño del texto (estándar, grande, máximo)
- Notificar a la UI cuando cambian las preferencias

Métodos principales:

- `cargar()`
- `establecer(ThemeMode nuevo)`
- `establecerTexto(TamanoTexto nuevo)`

### `ThemeScope`

InheritedNotifier que expone el controlador de tema a la app mediante `ThemeScope.of(context)`.

### `AppShell`

Archivo: `lib/Core/Navigation/app_shell.dart`

Responsabilidad:

- Definir la navegación principal por pestañas
- Mantener cada pestaña con su propio historial
- Abrir servicios desde el Inicio o la pantalla de Servicios
- Gestionar retroceso del sistema

### `AppDrawer`

Archivo: `lib/Core/Widgets/app_drawer.dart`

Responsabilidad:

- Mostrar un menú lateral con accesos rápidos y secciones institucionales
- Permitir cambiar de servicio o navegar hacia otras pantallas

### `AppHeader`

Componente reusable para cabeceras de página con logo, título, botón de retroceso o acciones.

### `AppButton`, `AppTextField`, `FormCard`, `InfoBox`

Son widgets reutilizables para mantener coherencia visual y funcional en las pantallas.

## 6.2 Captcha y seguridad

### `CaptchaProvider`

Archivo: `lib/Core/Captcha/captcha_provider.dart`

Define la interfaz para cualquier mecanismo de captcha:

- `obtenerToken()`
- `invalidar()`

### `SinCaptcha`

Implementación dummy para cuando la validación está desactivada.

### `CaptchaCacheado`

Envuelve a un provider real para reutilizar un token ya obtenido y evitar repetir la verificación innecesariamente.

### `RecaptchaWebViewProvider`

Implementación que usa `WebView` para obtener un token de reCAPTCHA v3.

### `RecaptchaHost`

Widget que monta el host del WebView para que el provider pueda ejecutar la validación de seguridad específica.

## 6.3 Feature: Verifica CGR

Es el módulo más importante y completo del proyecto. Tiene una estructura clara por capas.

### `VerificaCgrConfig`

Archivo: `lib/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Config/verifica_cgr_config.dart`

Responsabilidad:

- Guardar puntos de conexión, claves públicas, entitlement de captcha y timeouts
- Permitir cambiar ambiente o activar validación de captcha sin tocar la UI

Atributos importantes:

- `baseUrl`
- `recaptchaSiteKey`
- `validarCaptcha`
- `timeout`

### `VerificaCgrRemoteDataSource`

Archivo: `lib/Feature/.../Data/verifica_cgr_remote_data_source.dart`

Responsabilidad:

- Llamar a los endpoints específicos del backend
- Realizar `GET /api/Consulta/GetTramitesProveedor`
- Realizar `POST /api/Consulta/validar` para captcha
- Convertir respuesta JSON a modelos de tipo y validación básica

Métodos principales:

- `obtenerTramites(String documento)`
- `validarCaptcha(String token)`

### `VerificaCgrRepository`

Archivo: `lib/Feature/.../Domain/Repository/verifica_cgr_repository.dart`

Responsabilidad:

- Validar entrada del usuario
- Ejecutar flujo de seguridad si aplica
- Llamar al datasource
- Transformar errores de red a excepciones del negocio
- Construir la entidad final `ConsultaResultadoEntity`

Métodos principales:

- `consultarTramites(String documento, {void Function(FaseOperacion fase)? onFase})`
- `documentoValido(String documento)`
- `soloDigitos(String texto)`
- `_validarCaptchaSiAplica()`

### `ConsultaResultadoEntity`

Archivo: `lib/Feature/.../Domain/Entities/consulta_resultado_entity.dart`

Es la respuesta completa de la consulta.

Atributos:

- `proveedor`
- `libramientos`
- `pagosDirectos`
- `contratos`
- `sistemasDesconocidos`

Métodos importantes:

- `fromJson(Map<String, dynamic> json)`
- `estaVacio`
- `total`
- `beneficiarioGeneral`
- `documentoGeneral`

### Entidades auxiliares

- `ProveedorEntity`: información del proveedor o persona consultada
- `TramiteEntity`: representa un trámite, libramiento o pago directo
- `ContratoEntity`: información contractual
- `EstadoTramite`: enum o modelo del estado del trámite

### `PaginaVerificaCgr`

Archivo: `lib/Feature/.../Presentation/paginaverificacgr.dart`

Es el formulario principal del módulo.

Funcionalidad:

- Recibe un documento (RNC o cédula)
- Valida la entrada del usuario
- Lanza la búsqueda
- Muestra un loading overlay con estado de operación
- Abre la pantalla de resultados al obtener la respuesta

Estados internos:

- `_isLoading`
- `_errorMessage`
- `_fase`

Métodos:

- `_buscarTramite()`
- `_mostrarError(String mensaje)`
- `_mensajeDeFase(FaseOperacion fase)`

### `PaginaResultadosCgr`

Archivo: `lib/Feature/.../Presentation/paginaresultadoscgr.dart`

Responsabilidad:

- Mostrar el resultado consolidado de la consulta
- Agrupar trámites, pagos directos y contratos
- Presentar resumen del proveedor y estados
- Permitir acciones adicionales (PDF, exportación, impresión)

### `VerificaCgrPdfService`

Archivo: `lib/Feature/.../Data/Pdf/verifica_cgr_pdf_service.dart`

Responsabilidad:

- Generar los PDFs de la consulta
- Crear documentos para trámite, contrato o consolidado
- Encapsular la lógica de impresión del documento

## 6.4 Feature: Empleados del Estado

Tiene una estructura similar:

- `Domain/Repository/consulta_empleado_repository.dart`
- `Domain/Entities/empleadoentity.dart`
- `Presentation/paginaconsultaempleados.dart`
- `Presentation/pagina_detalles_empleado.dart`

### `PaginaConsultaEmpleados`

Formulario para consultar información sobre empleados del Estado por documento. Suele validar el número, llamar al repositorio y navegar hacia una vista de detalle.

### `PaginaDetallesEmpleado`

Muestra el resultado específico del empleado consultado con información resumida o detallada.

## 6.5 Feature: Ajustes

- `pagina_ajustes.dart`: pantalla de configuración general
- `pagina_acerca.dart`: información institucional y sobre la app

Incluye:

- selector de tema
- selector de tamaño de texto
- información de la app
- contacto y datos institucionales

## 6.6 Feature: Ayuda

- `pagina_ayuda.dart`

Responsabilidad:

- Mostrar preguntas frecuentes
- Explicar el uso de la app
- Instrucciones para cada servicio o flujo principal

## 6.7 Feature: Servicios

- `pagina_servicios.dart`

Responsabilidad:

- Muestar la tarjeta de cada servicio disponible
- Redirigir a su pantalla específica
- Mantener una vista general del catálogo del sistema

## 6.8 Feature: Inicio

- `pagina_inicio.dart`

Responsabilidad:

- Pantalla principal de bienvenida
- Mostrar búsqueda rápida por servicios
- Muestra accesos rápidos y funcionalidad de búsqueda
- Integra el footer institucional

## 7. Patrones de diseño presentes en el proyecto

### 7.1 Navigation shell

Se usa un patrón de shell con `AppShell` + `IndexedStack` + `Navigator` por pestaña.

Esto permite:

- mantener el estado de cada tab
- no perder la navegación mientras cambia entre pestañas
- conservar historial dentro de cada módulo

### 7.2 InheritedWidget

El proyecto usa `InheritedWidget` para compartir datos globales sin pasar props en cada nivel:

- `AppShellScope`: expone navegación global
- `ThemeScope`: expone el controlador de tema

### 7.3 Repositorio + Data Source

La capa de dominio define contratos abstractos y la capa de datos implementa los accesos concretos.

Esto ayuda a:

- desacoplar UI de backend
- centralizar validaciones del negocio
- reutilizar lógica de servicios

### 7.4 Entidades de dominio

Las entidades representan resultados concretos del backend, como `ProveedorEntity`, `TramiteEntity`, `ContratoEntity` y `ConsultaResultadoEntity`.

### 7.5 Configuración por constante

El módulo de Verifica CGR usa `VerificaCgrConfig` para separar constantes de entorno y comportamientos de la pantalla.

## 8. Flujo de datos de un caso real: Verifica CGR

1. El usuario escribe un documento en `PaginaVerificaCgr`.
2. La pantalla valida que sea un RNC válido (9 dígitos) o cédula válida (11 dígitos).
3. Se crea el repositorio `VerificaCgrRepository` con un datasource `VerificaCgrRemoteDataSource`.
4. El repository llama a `apiClient.get(...)` o a la validación captcha si corresponde.
5. El `ApiClient` ejecuta la llamada HTTP y transforma la respuesta JSON.
6. `ConsultaResultadoEntity.fromJson()` crea la entidad final con proveedor, trámites y contratos.
7. La pantalla de resultados renderiza los datos y permite exportarlos a PDF o mostrarlos formateados.

## 9. Buenas prácticas implementadas

- Separación de capas por funcionalidad.
- Centralización de manejo de errores en `ApiException` y excepciones del dominio.
- Reutilización de widgets compartidos en `Core/Widgets`.
- Persistencia de preferencias del usuario en `SharedPreferences`.
- Manejo de estados de carga (`AppLoadingOverlay`).
- Sistema de diseño consistente con colores, tipografías y dimensiones.

## 10. Convenciones del proyecto

- Visuales reutilizables en `Core/Widgets`.
- Configuraciones y constantes en `Config` por feature.
- Entidades/domain models en `Domain/Entities`.
- Acceso a datos en `Data`.
- Pantallas en `Presentation`.
- Navegación global en `Core/Navigation`.

## 11. Cómo extender el proyecto

### Añadir un nuevo servicio

1. Crear el módulo dentro de `Feature/`.
2. Definir modelo del negocio en `Domain/Entities`.
3. Crear el `RemoteDataSource` en `Data`.
4. Crear el repositorio en `Domain/Repository`.
5. Crear la pantalla en `Presentation`.
6. Registrar el servicio en `Core/Navigation/servicios_app.dart`.
7. Añadir acceso desde Inicio/Servicios si aplica.

### Añadir una nueva pantalla compartida

1. Colocarla en `Core/Widgets` si es reutilizable.
2. Mantener estilo con `AppColors`, `AppDimens` y `AppTypography`.
3. Evitar lógica de negocio en widgets UI.

## 12. Resumen ejecutivo

La aplicación está construida con una estructura modular, orientada a servicios de consulta pública y organizada en capas. La parte más importante es el módulo de `Verifica CGR`, que sigue un patrón claro de:

- UI
- dominio
- repositorio
- datasource
- api client
- resultados modelados

Esto facilita mantenimiento, pruebas y extensión del sistema.

---

Si quieres, en el siguiente paso puedo hacer una segunda parte más profunda con:

1. documentación por archivo clase a clase,
2. un diagrama de arquitectura en Mermaid,
3. o una versión más técnica orientada a mantenedores y QA.
