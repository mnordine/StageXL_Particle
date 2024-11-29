library example01;

import 'package:web/web.dart';
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_particle/stagexl_particle.dart';

Future<void> main() async {

  final options = StageOptions()
    ..renderEngine = RenderEngine.WebGL
    ..backgroundColor = Color.Black;

  final canvas = window.document.querySelector('#stage') as HTMLCanvasElement;
  final stage = Stage(canvas, options: options);
  RenderLoop()..addStage(stage);

  //-------------------------

  final particleConfig = {
    "maxParticles":2000,
    "duration":0,
    "lifeSpan":0.7, "lifespanVariance":0.2,
    "startSize":16, "startSizeVariance":10,
    "finishSize":53, "finishSizeVariance":11,
    "shape":"circle",
    "emitterType":0,
    "location":{"x":0, "y":0},
    "locationVariance":{"x":5, "y":5},
    "speed":100, "speedVariance":33,
    "angle":0, "angleVariance":360,
    "gravity":{"x":0, "y":0},
    "radialAcceleration":20, "radialAccelerationVariance":0,
    "tangentialAcceleration":10, "tangentialAccelerationVariance":0,
    "minRadius":0, "maxRadius":100, "maxRadiusVariance":0,
    "rotatePerSecond":0, "rotatePerSecondVariance":0,
    "compositeOperation":"source-over",
    "startColor":{"red":1, "green":0.74, "blue":0, "alpha":1},
    "finishColor":{"red":1, "green":0, "blue":0, "alpha":0}
  };

  final particleEmitter = ParticleEmitter(particleConfig);
  particleEmitter.setEmitterLocation(100, 300);
  stage.addChild(particleEmitter);
  stage.juggler.add(particleEmitter);

  //-------------------------

  void mouseEventListener(e) {
    if (e.buttonDown) particleEmitter.setEmitterLocation(e.localX, e.localY);
  }

  final glassPlate = GlassPlate(800, 600);
  glassPlate.onMouseDown.listen(mouseEventListener);
  glassPlate.onMouseMove.listen(mouseEventListener);
  stage.addChild(glassPlate);

}
