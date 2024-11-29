library stagexl_particle;

import 'dart:js_interop';
import 'dart:math' hide Point, Rectangle;
import 'package:web/web.dart' show CanvasRenderingContext2D;

import 'package:stagexl/stagexl.dart';

//-------------------------------------------------------------------------------------------------
// Credits to www.gamua.com
// Particle System Extension for the Starling framework
// The original code was release under the Simplified BSD License
// http://wiki.starling-framework.org/extensions/particlesystem
//-------------------------------------------------------------------------------------------------

part 'src/particle.dart';
part 'src/particle_color.dart';
part 'src/particle_emitter.dart';
part 'src/particle_render_program.dart';

typedef _Json = Map<String, Object?>;
