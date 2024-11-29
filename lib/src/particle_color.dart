part of stagexl_particle;

class _ParticleColor {
  final double red;
  final double green;
  final double blue;
  final double alpha;

  _ParticleColor.fromJson(_Json json) :
    red = (json['red'] as num? ?? 0).clamp(0, 1).toDouble(),
    green = (json['green'] as num? ?? 0).clamp(0, 1).toDouble(),
    blue = (json['blue'] as num? ?? 0).clamp(0, 1).toDouble(),
    alpha = (json['alpha'] as num? ?? 0).clamp(0, 1).toDouble();
}
