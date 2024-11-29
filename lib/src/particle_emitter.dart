part of stagexl_particle;

class ParticleEmitter extends DisplayObject implements Animatable {

  final _random = Random();

  late _Particle _rootParticle;
  late _Particle _lastParticle;

  final _renderTexture = RenderTexture(1024, 32, Color.Transparent);
  final _renderTextureQuads = <RenderTextureQuad>[];
  int _particleCount = 0;
  num _frameTime = 0;
  num _emissionTime = 0;

  static const EMITTER_TYPE_GRAVITY = 0;
  static const EMITTER_TYPE_RADIAL = 1;

  // emitter configuration
  int _emitterType = 0;
  num _locationX = 0;
  num _locationY = 0;
  num _locationXVariance = 0;
  num _locationYVariance = 0;

  // particle configuration
  int _maxNumParticles = 0;
  num _duration = 0;
  num _lifespan = 0;
  num _lifespanVariance = 0;
  num _startSize = 0;
  num _startSizeVariance = 0;
  num _endSize = 0;
  num _endSizeVariance = 0;

  // TODO: Implement shape
  // var _shape = 'circle';

  // gravity configuration
  num _gravityX = 0;
  num _gravityY = 0;
  num _speed = 0;
  num _speedVariance = 0;
  num _angle = 0;
  num _angleVariance = 0;
  num _radialAcceleration = 0;
  num _radialAccelerationVariance = 0;
  num _tangentialAcceleration = 0;
  num _tangentialAccelerationVariance = 0;

  // radial configuration
  num _minRadius = 0;
  num _maxRadius = 0;
  num _maxRadiusVariance = 0;
  num _rotatePerSecond = 0;
  num _rotatePerSecondVariance = 0;

  // color configuration
  // TODO Implement composite operation.
  // String _compositeOperation;
  late _ParticleColor _startColor;
  late _ParticleColor _endColor;

  //-------------------------------------------------------------------------------------------------

  ParticleEmitter(_Json config) {

    _rootParticle = _Particle(this);
    _lastParticle = _rootParticle;

    _emissionTime = 0;
    _frameTime = 0;
    _particleCount = 0;

    for(int i = 0; i < 32; i++) {
      _renderTextureQuads.add(_renderTexture.quad.cut(Rectangle(i * 32, 0, 32, 32)));
    }

    updateConfig(config);
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  void _drawParticleTexture() {

    final context = _renderTexture.canvas.getContext('2d') as CanvasRenderingContext2D;
    context.setTransform(1.toJS, 0, 0, 1.0, 0, 0);
    context.globalAlpha = 1.0;
    context.clearRect(0, 0, 1024, 32);

    const radius = 15;

    for(int i = 0; i < 32; i++) {

      num targetX = i * 32 + 15.5;
      num targetY = 15.5;

      var colorR = _startColor.red   + i * (_endColor.red   - _startColor.red  ) / 31;
      var colorG = _startColor.green + i * (_endColor.green - _startColor.green) / 31;
      var colorB = _startColor.blue  + i * (_endColor.blue  - _startColor.blue ) / 31;
      var colorA = _startColor.alpha + i * (_endColor.alpha - _startColor.alpha) / 31;

      if (i == 0) colorR = colorG = colorB = colorA = 1.0;

      final colorIntR = (255 * colorR).toInt();
      final colorIntG = (255 * colorG).toInt();
      final colorIntB = (255 * colorB).toInt();

      var gradient = context.createRadialGradient(targetX, targetY, 0, targetX, targetY, radius);
      gradient.addColorStop(0, 'rgba($colorIntR, $colorIntG, $colorIntB, $colorA)');
      gradient.addColorStop(1, 'rgba($colorIntR, $colorIntG, $colorIntB, 0.0)');
      context.beginPath();
      context.moveTo(targetX + radius, targetY);
      context.arc(targetX, targetY, radius, 0, pi * 2, false);
      context.fillStyle = gradient;
      context.fill();
    }

    _renderTexture.update();
  }

  //-------------------------------------------------------------------------------------------------

  void start({num? duration}) {
    _emissionTime = duration ?? _duration;
  }

  void stop(bool clear) {
    _emissionTime = 0;
    if (clear) _particleCount = 0;
  }

  void setEmitterLocation(num x, num y) {
    _locationX = x;
    _locationY = y;
  }

  RenderTexture get renderTexture => _renderTexture;

  int get particleCount => _particleCount;

  num get _randomVariance => _random.nextDouble() * 2.0 - 1.0;

  //-------------------------------------------------------------------------------------------------

  void updateConfig(_Json config) {

    // TODO: enum
    _emitterType = config['emitterType'] as int;

    final location = config['location'] as _Json;
    _locationX = location['x'] as num;
    _locationY = location['y'] as num;

    _maxNumParticles = config['maxParticles'] as int;

    // TODO: Duration
    _duration = config['duration'] as num;
    _lifespan = config['lifeSpan'] as num;

    _lifespanVariance = config['lifespanVariance'] as num;
    _startSize = config['startSize'] as num;
    _startSizeVariance = config['startSizeVariance'] as num;
    _endSize = config['finishSize'] as num;
    _endSizeVariance = config['finishSizeVariance'] as num;

    // TODO: implement shape
    // _shape = config['shape'];

    final locationVariance = config['locationVariance'] as _Json;
    _locationXVariance = locationVariance['x'] as num;
    _locationYVariance = locationVariance['y'] as num;

    _speed = config['speed'] as num;
    _speedVariance = config['speedVariance'] as num;

    _angle = (config['angle'] as num) * pi / 180;
    _angleVariance = (config['angleVariance'] as num) * pi / 180;

    final gravity = config['gravity'] as _Json;
    _gravityX = gravity['x'] as num;
    _gravityY = gravity['y'] as num;

    _radialAcceleration = config['radialAcceleration'] as num;
    _radialAccelerationVariance = config['radialAccelerationVariance'] as num;
    _tangentialAcceleration = config['tangentialAcceleration'] as num;
    _tangentialAccelerationVariance = config['tangentialAccelerationVariance'] as num;

    _minRadius = config['minRadius'] as num;
    _maxRadius = config['maxRadius'] as num;
    _maxRadiusVariance = config['maxRadiusVariance'] as num;
    _rotatePerSecond = (config['rotatePerSecond'] as num) * pi / 180;
    _rotatePerSecondVariance = (config['rotatePerSecondVariance'] as num) * pi / 180;

    // TODO
    // _compositeOperation = config['compositeOperation'];

    _startColor = _ParticleColor.fromJson(config['startColor'] as _Json);
    _endColor = _ParticleColor.fromJson(config['finishColor'] as _Json);

    if (_duration <= 0) _duration = double.infinity;
    _emissionTime = _duration;

    _drawParticleTexture();
  }

  //-------------------------------------------------------------------------------------------------

  bool advanceTime(num passedTime) {

    var particle = _rootParticle;
    var particleCount = _particleCount;

    // advance existing particles

    for (int i = 0; i < particleCount; i++) {

      var nextParticle = particle._nextParticle;
      if (nextParticle != null) {
        if (nextParticle._advanceParticle(passedTime)) {
          particle = nextParticle;
          continue;
        }
      }

      particle._nextParticle = nextParticle?._nextParticle;
      _lastParticle._nextParticle = nextParticle;

      if (nextParticle != null) {
        _lastParticle = nextParticle;
        _lastParticle._nextParticle = null;
      }

      _particleCount--;
    }

    // create and advance new particles

    if (_emissionTime > 0) {

      num timeBetweenParticles = _lifespan / _maxNumParticles;
      _frameTime += passedTime;

      while (_frameTime > 0) {

        if (_particleCount < _maxNumParticles) {

          var nextParticle = particle._nextParticle;
          if (nextParticle == null)
            nextParticle = _lastParticle = particle._nextParticle = _Particle(this);

          particle = nextParticle;
          particle._initParticle();
          particle._advanceParticle(_frameTime);
          _particleCount++;
        }

        _frameTime -= timeBetweenParticles;
      }

      _emissionTime = max(0, _emissionTime - passedTime);
    }

    //--------------------------------------------------------

    //return (_particleCount > 0);
    return true;
  }

  //-------------------------------------------------------------------------------------------------

  void render(RenderState renderState) {

    final renderContext = renderState.renderContext;
    final globalAlpha = renderState.globalAlpha;
    final globalMatrix = renderState.globalMatrix;
    _Particle? particle = _rootParticle;

    // renderState.renderQuad(_renderTextureQuads[0].renderTexture.quad);

    if (renderContext is RenderContextCanvas) {

      final context = renderContext.rawContext;
      renderContext.setTransform(globalMatrix);
      renderContext.setAlpha(globalAlpha);

      for(int i = 0; i < _particleCount; i++) {
        particle = particle?._nextParticle;
        particle?._renderParticleCanvas(context);
      }

    } else if (renderContext is RenderContextWebGL) {

      var renderTextureQuad = _renderTextureQuads[0];
      var renderProgram = renderContext.getRenderProgram(
          r'$ParticleRenderProgram', () => _ParticleRenderProgram());

      renderContext.activateRenderProgram(renderProgram);
      if (blendMode != null) renderContext.activateBlendMode(blendMode!);
      renderContext.activateRenderTexture(renderTextureQuad.renderTexture);
      renderProgram.globalMatrix = globalMatrix;

      for(int i = 0; i < _particleCount; i++) {
        particle = particle?._nextParticle;
        particle?._renderParticleWegGL(renderProgram);
      }
    }
  }

}
