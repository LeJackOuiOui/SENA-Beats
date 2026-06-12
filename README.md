# Orbe de Energía - Play/Pause + Volumen

## Descripción

Se reemplazó el botón estándar de reproducción/pausa de `TrackDetailScreen` por un **Orbe de Energía**: una esfera animada que cumple doble función:

- **Indicador visual de volumen** — su tamaño y "glow" (resplandor) reaccionan en tiempo real al volumen físico del dispositivo.

## Comportamiento del Orbe

| Volumen del dispositivo | Tamaño del orbe                     | Glow / Resplandor                                             | Ícono visible                          |
| ----------------------- | ----------------------------------- | ------------------------------------------------------------- | -------------------------------------- |
| 0%                      | ~16px (punto pequeño)               | Sin sombra                                                    | No (muy pequeño para mostrarlo)        |
| ~20% - 100%             | Escala progresivamente hasta ~130px | Intensidad y radio del `boxShadow` aumentan proporcionalmente | Sí, centrado, también escala levemente |

- Al **subir el volumen**, el orbe se expande como una burbuja de energía y su resplandor morado se intensifica.
- Al **bajar el volumen a 0**, el orbe se reduce a un punto pequeño sin sombra.
- Cuando la pista está **reproduciéndose**, el orbe completo escala un 10% extra (`AnimatedScale`) como retroalimentación adicional de estado.

## Archivos modificados

### `lib/screens/track_detail_screen.dart`

- Se eliminó el `IconButton` + `AnimatedScale` original.
- Se agregó el widget `PlayPauseOrb`, que fusiona ambas responsabilidades (play/pause + indicador de volumen).

### `lib/providers/music_provider.dart`

- Se integró el paquete [`volume_controller`](https://pub.dev/packages/volume_controller) (v3.6.0) para:
  - Leer el volumen físico actual del dispositivo (`getVolume()`).
  - Escuchar cambios en tiempo real cuando el usuario usa los botones físicos de volumen (`addListener`).
  - Permitir ajustar el volumen del sistema desde la app (`setVolume()`).
- Nuevo estado expuesto: `volume` (double, 0.0 - 1.0) y método `setVolume(double)`.
- Se corrigieron dos bugs existentes:
  - `_isPlaying` ahora se establece correctamente a `true` al reproducir una pista nueva (antes quedaba en `false` aunque el audio sonara).
  - `_updateThemeColor` ahora notifica a los listeners en todos los casos (antes solo lo hacía dentro del `catch`), y se llama también al reproducir una pista por primera vez (antes solo al reanudar).

## Dependencias nuevas

```yaml
dependencies:
  volume_controller: ^3.6.0
```

## Permisos

No se requieren permisos adicionales en `AndroidManifest.xml` ni en `Info.plist`. El paquete `volume_controller` utiliza APIs estándar de audio (`AudioManager` en Android) que no requieren declaración ni permisos en tiempo de ejecución.
