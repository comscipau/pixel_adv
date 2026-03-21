import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adv/components/background_tile.dart';
import 'package:pixel_adv/components/checkpoint.dart';
import 'package:pixel_adv/components/collision_block.dart';
import 'package:pixel_adv/components/fruit.dart';
import 'package:pixel_adv/components/player.dart';
import 'package:pixel_adv/components/saw.dart';
import 'package:pixel_adv/pixel_adventure.dart';

class Level extends World with HasGameReference<PixelAdventure> {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    priority = 0;
    level = await TiledComponent.load("$levelName.tmx", Vector2(16, 16));
    addAll([level]);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(
      "spawn_points",
    );

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case "player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case "Fruit":
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case "Saw":
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case "Checkpoint":
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
        }
      }
    }
  }

  void _addCollisions() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("collisions");

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case "platform":
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
  }

  void _scrollingBackground() {
    const double viewWidth = 640;
    const double viewHeight = 360;
    const double tileSize = 64;

    final int numTilesX = (viewWidth / tileSize).ceil();
    final int numTilesY = (viewHeight / tileSize).ceil();

    final backgroundLayer = level.tileMap.getLayer('background');
    final backgroundColor =
        backgroundLayer?.properties.getValue('BackgroundColor') ?? 'Gray';

    for (int y = -1; y <= numTilesY; y++) {
      for (int x = 0; x <= numTilesX; x++) {
        final backgroundTile = BackgroundTile(
          color: backgroundColor,
          position: Vector2(x * tileSize, y * tileSize),
        );

        add(backgroundTile);
      }
    }
  }
}
