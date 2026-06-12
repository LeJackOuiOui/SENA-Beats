import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/track.dart';
import '../providers/music_provider.dart';

class TrackDetailScreen extends StatelessWidget {
  final Track track;
  const TrackDetailScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final volume = musicProvider.volume; // 0.0 - 1.0

    return Scaffold(
      appBar: AppBar(title: Text(track.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'avatar-${track.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  track.image,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              track.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              track.artist,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // --- Orbe-botón de Play/Pause + Volumen ---
            PlayPauseOrb(
              volume: volume,
              isPlaying: musicProvider.isPlaying,
              onPressed: () => musicProvider.playTrack(track),
            ),

            const SizedBox(height: 30),
            SizedBox(width: 250),
          ],
        ),
      ),
    );
  }
}

/// Esfera que funciona como botón de play/pause, y cuyo tamaño/glow
/// reaccionan al volumen actual del dispositivo.
class PlayPauseOrb extends StatelessWidget {
  final double volume; // 0.0 a 1.0
  final bool isPlaying;
  final VoidCallback onPressed;

  const PlayPauseOrb({
    super.key,
    required this.volume,
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tamaño base = punto pequeño cuando volumen = 0, hasta burbuja grande
    final double baseSize = 16.0;
    final double maxExtra = 114.0; // size llega a 130px con volumen = 1.0
    final double size = baseSize + (maxExtra * volume);

    // Intensidad del glow proporcional al volumen
    final double glowIntensity = volume;

    // Área de toque fija, independiente del tamaño visual del orbe
    const double tapAreaSize = 130.0;

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: tapAreaSize,
        height: tapAreaSize,
        child: Center(
          child: AnimatedScale(
            scale: isPlaying ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.deepPurpleAccent.withValues(alpha: 0.9),
                    Colors.deepPurple.withValues(
                      alpha: 0.4 + 0.4 * glowIntensity,
                    ),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withValues(
                      alpha: 0.6 * glowIntensity,
                    ),
                    blurRadius: 20 * glowIntensity + 2,
                    spreadRadius: 8 * glowIntensity,
                  ),
                ],
              ),
              child: volume > 0.2
                  ? Center(
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 18 + (28 * volume),
                      ),
                    )
                  : null, // con el orbe muy pequeño, no se fuerza el ícono dentro
            ),
          ),
        ),
      ),
    );
  }
}
