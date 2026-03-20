import 'dart:async';
import 'package:flame/components.dart';
import 'package:pixel_adv/pixel_adventure.dart';

enum PlayerState { idle, run }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure> {
  String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 11);
    runAnimation = _spriteAnimation("Run", 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
    };
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int frames) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: frames, // frames
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
