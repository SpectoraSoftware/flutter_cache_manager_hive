import 'package:flutter_cache_manager/src/storage/cache_object.dart';
import 'package:clock/clock.dart';

class HiveCacheObject extends CacheObject {
  /// Remove this once new version is released
  final String key;

  /// When this cached item becomes invalid
  final int? validTillMs;

  /// Last time this entry was added/updated
  final int? touchedMs;


  HiveCacheObject(
    String url, {
    String? key,
    String? relativePath,
    String? eTag,
    required this.validTillMs,
    required this.touchedMs,
  })  : key = key ?? url,
        super(url,
            relativePath: relativePath!,
            validTill: DateTime.fromMillisecondsSinceEpoch(validTillMs!),
            eTag: eTag,
            id: (key ?? url).hashCode);

  factory HiveCacheObject.fromHiveMap(Map<dynamic, dynamic> map) =>
      HiveCacheObject(
        map['url'] as String,
        key: map['key'] as String,
        relativePath: map['relativePath'] as String,
        validTillMs: map['validTillMs'] as int? ?? 0,
        touchedMs: map['touchedMs'] as int? ?? 0,
        eTag: map['eTag'] as String,
      );

  

  Map<dynamic, dynamic> toHiveMap() => {
        'url': url,
        'key': key,
        'relativePath': relativePath,
        'validTillMs': validTillMs,
        'touchedMs': clock.now().millisecondsSinceEpoch,
        'eTag': eTag,
      };
}
