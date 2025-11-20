import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class MusicService {
  // Patrón Singleton para una única instancia
  static final MusicService _singleton = MusicService._internal();

  factory MusicService() {
    return _singleton;
  }

  MusicService._internal();

  // 1. Propiedades
  late final Soundpool _soundpool;
  int _soundId = 0; // ID del sonido cargado
  int _streamId = 0; // ID del stream de reproducción actual
  final String _assetPath = 'assets/music/coffe_music_play.mp3';

  // Estado para manejar las restricciones de Chrome en la LoadingScreen
  bool _isPlaying = false;
  bool get isMusicPlaying => _isPlaying;

  // 2. Inicializa el pool y prepara la carga
  void init() {
    // Configura el SoundPool para manejar música
    _soundpool = Soundpool.fromOptions(
      options: const SoundpoolOptions(streamType: StreamType.music),
    );
    // Intenta cargar el sonido inmediatamente (no bloquea la UI)
    _loadSound();
  }

  // 3. Carga el archivo en la memoria (CORRECCIÓN 1: loadInt -> load)
  Future<void> _loadSound() async {
    if (_soundId == 0) {
      try {
        final ByteData data = await rootBundle.load(_assetPath);
        // Usa 'load' para cargar el asset.
        _soundId = await _soundpool.load(data);
      } catch (e) {
        print("Error al cargar el sonido con Soundpool: $e");
        // Nota: Este error es el 'Format error' si el MP3 no es CBR 192kbps.
      }
    }
  }

  // 4. Reproduce (o reanuda) y maneja el bucle
  Future<void> playMusic() async {
    // Asegura que el sonido esté cargado
    if (_soundId == 0) {
      await _loadSound();
    }

    // Comienza la reproducción solo si el sonido está cargado y NO está activo
    if (_soundId != 0 && _streamId == 0) {
      _streamId = await _soundpool.play(
  _soundId,
  // ¡No se permiten más argumentos posicionales ni nombrados!
);

      if (_streamId > 0) {
        _isPlaying = true;
        print("Música iniciada con soundpool. Stream ID: $_streamId");
      }
    } else if (_streamId != 0 && !_isPlaying) {
      // Si ya está cargado y pausado, reanuda
      _soundpool.resume(_streamId);
      _isPlaying = true;
    }
  }

  // 5. Métodos de control
  void stopMusic() {
    if (_streamId != 0) {
      _soundpool.stop(_streamId);
      _streamId = 0;
      _isPlaying = false;
      print("Música detenida.");
    }
  }

  void pauseMusic() {
    if (_streamId != 0) {
      _soundpool.pause(_streamId);
      _isPlaying = false;
    }
  }

  void resumeMusic() {
    if (_streamId != 0) {
      _soundpool.resume(_streamId);
      _isPlaying = true;
    }
  }

  void dispose() {
    _soundpool.release();
    _soundId = 0;
    _streamId = 0;
    _isPlaying = false;
  }
}
