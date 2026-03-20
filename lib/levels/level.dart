import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adv/actors/player.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2(16, 16));
    addAll([level]);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(
      "spawn_points",
    );

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case "player":
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
      }
    }
    return super.onLoad();
  }
}
