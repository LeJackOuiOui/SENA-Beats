# Cambios Detectados

## Descripción

En este `README.md` se especifican los cambios encontrados por nuestro equipo en el proyecto SENA Beats en su ultimo commit.

## Archivos modificados

### `lib/main.dart`

- Se añadió el `import` para la dependencia de Supabase.
- Se añadió la `url` y `anon_key` para el acceso a la base de datos de Supabase.
- `main()` cambio a ser una función `async` con `WidgetsFlutterBinding.ensureInitialized()`.

### `lib/models/track.dart`

- Se añadió el metodo `fromJson` para leer la información de los datos en Supabase.

### `lib/screens/main_screen.dart`

- Se añadió el `import` para acceder a `remote_missions_screen.dart`.
- Se añadió una opción en `BottomNavigatorBar` para permitir el acceso a `remote_missions_screen.dart`.
- En `BottomNavigatorBar` se agregaron las propiedades de:
- - `type: BottomNavigationBarType.fixed`
- - `backgroundColor: Theme.of(context).colorScheme.surface`
- - `selectedItemColor: Theme.of(context).colorScheme.primary`
- - `unselectedItemColor: Colors.grey`
- Los items en `BottomNavigatorBar` pasaron a ser `const`.

## Dependencias nuevas

```yaml
dependencies:
  supabase_flutter: ^2.12.4
```

## Archivos Nuevos

- Se creo el archivo `lib/screens/remote_missions_screen.dart` para leer y mostrar al usuario la información almacenada en Supabase.
- Se añadió el archivo `lib/screens/track_detail_screen.dart` para poder pausar y reproducir las canciones.
- Se creo el archivo `lib/services/supabase_service` para poder tener el servicio de conexión con la base de datos de Supabase.
