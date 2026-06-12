import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:palette_generator/palette_generator.dart'; // Extraer el color
import '../models/track.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Track? _currentTrack;
  bool _isPlaying = false;

  Color _themeColor = Colors.deepPurple;
  Color get themeColor => _themeColor;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  // --- Volumen ---
  double _volume = 1.0;
  double get volume => _volume;

  final VolumeController _volumeController = VolumeController.instance;

  MusicProvider() {
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      notifyListeners();
    });

    _initVolumeListener();
  }

  Future<void> _initVolumeListener() async {
    _volumeController.showSystemUI = false;

    try {
      _volume = await _volumeController.getVolume();
    } catch (e) {
      _volume = 1.0;
    }
    notifyListeners();

    _volumeController.addListener((newVolume) {
      _volume = newVolume;
      notifyListeners();
    });
  }

  Future<void> setVolume(double newVolume) async {
    _volume = newVolume.clamp(0.0, 1.0);
    _volumeController.setVolume(_volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _volumeController.removeListener();
    super.dispose();
  }

  Future<void> playTrack(Track track) async {
    if (_currentTrack?.id == track.id) {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        await _audioPlayer.resume();
        _isPlaying = true;
        _updateThemeColor(track.image);
      }
    } else {
      _currentTrack = track;
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(_volume); // aplicar volumen actual
      await _audioPlayer.play(UrlSource(track.previewUrl));
      _isPlaying = true; // <-- corregido: ahora sí está sonando
      _updateThemeColor(track.image);
    }

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 40, amplitude: 100);
    }
    notifyListeners();
  }

  Future<void> _updateThemeColor(String imageUrl) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
            NetworkImage(imageUrl),
            size: const Size(200, 200),
          );

      _themeColor =
          paletteGenerator.vibrantColor?.color ??
          paletteGenerator.dominantColor?.color ??
          Colors.deepPurple;
    } catch (e) {
      _themeColor = Colors.deepPurple;
    }
    notifyListeners(); // <-- antes solo se notificaba en el catch
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentTrack = null;
    _isPlaying = false;
    notifyListeners();
  }
}
