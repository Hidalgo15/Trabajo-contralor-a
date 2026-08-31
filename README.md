# consultas_y_contrataciones

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Cómo ejecutar la app en web (navegador Chrome)

La app consulta la API pública de la Contraloría
(`https://consultas.contraloria.gob.do/verificacgr/...`). Cuando se ejecuta en
el navegador, este **bloquea las peticiones a ese dominio por CORS** (el
servidor no devuelve `Access-Control-Allow-Origin` para `localhost`). Por eso,
para desarrollo en web hay que lanzar Chrome con el flag
`--disable-web-security` **más un perfil de usuario separado** (Chrome ignora
ese flag con el perfil normal).

### Requisitos previos

- Flutter SDK instalado (el proyecto requiere Dart `^3.11.0`, p. ej. Flutter 3.47.x).
- Chrome instalado.

### Opción A — Desde VS Code (recomendada)

Existe un `.vscode/launch.json` de desarrollo (no se sube al repo, está en
`.gitignore`) con la configuración **"Chrome (CORS off - dev)"**. Para usarla:

1. Abre `lib/main.dart`.
2. `Run > Start Debugging` (F5).
3. Elige la configuración **"Chrome (CORS off - dev)"**.
4. En la pantalla de Verifica CGR, ingresa un RNC (9 dígitos) o cédula
   (11 dígitos) y busca.

Esta configuración lanza Chrome con:
- `--disable-web-security` (desactiva el bloqueo CORS).
- `--user-data-dir` dentro de `.chrome-cors-dev` en tu carpeta de usuario
  (perfil aislado, no altera tu Chrome normal).

Si tu `.vscode/launch.json` se borró, puedes regenerarlo con:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Chrome (CORS off - dev)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "deviceId": "chrome",
      "args": [
        "--web-browser-flag=--disable-web-security",
        "--web-browser-flag=--user-data-dir=${userHome}\\.chrome-cors-dev"
      ]
    }
  ]
}
```

### Opción B — Desde la terminal

```sh
flutter run -d chrome --web-browser-flag=--disable-web-security --web-browser-flag=--user-data-dir=%USERPROFILE%\.chrome-cors-dev
```

### ⚠️ Advertencias

- `--disable-web-security` es **solo para desarrollo**. Desactiva una
  protección del navegador. No lo uses para navegar sitios normales.
- No subas `.vscode/launch.json` al repo compartido.
- En **producción** y en apps móviles/escritorio (Android/iOS/Windows) no hace
  falta este truco: no hay navegador ni bloqueo CORS. Solo afecta a la web.

