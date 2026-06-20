import 'dart:math' as math;

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class GeocodingCacheOptions {
  GeocodingCacheOptions._();

  static const cacheDuration = Duration(days: 30);

  /// ~111 meter grid. Standard proximity bucket for reverse geocoding cache.
  static const coordinatePrecision = 3;

  static CacheOptions reverseGeocoding(CacheStore store) {
    return CacheOptions(
      store: store,
      policy: CachePolicy.forceCache,
      maxStale: cacheDuration,
      hitCacheOnNetworkFailure: true,
      hitCacheOnErrorCodes: [500, 502, 503],
      priority: CachePriority.low,
      keyBuilder: _reverseGeocodingKeyBuilder,
    );
  }

  static CacheOptions placesSearch(CacheStore store) {
    return CacheOptions(
      store: store,
      policy: CachePolicy.forceCache,
      maxStale: cacheDuration,
      hitCacheOnNetworkFailure: true,
      hitCacheOnErrorCodes: [500, 502, 503],
      priority: CachePriority.low,
      keyBuilder: _placesSearchKeyBuilder,
    );
  }

  static bool shouldCachePlacesQuery(String? query) {
    final normalized = normalizeQuery(query);
    return normalized != null && normalized.isNotEmpty;
  }

  static double? quantizeCoordinate(double? value) {
    if (value == null) return null;

    final factor = math.pow(10, coordinatePrecision).toDouble();
    return (value * factor).round() / factor;
  }

  static String? normalizeQuery(String? query) {
    final trimmed = query?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.toLowerCase();
  }

  static String _reverseGeocodingKeyBuilder({
    required Uri url,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _buildCacheKey(_uriWithQuantizedCoordinates(url));
  }

  static String _placesSearchKeyBuilder({
    required Uri url,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _buildCacheKey(_uriWithNormalizedPlacesQuery(url));
  }

  static String _buildCacheKey(Uri url) {
    return CacheOptions.defaultCacheKeyBuilder(
      url: url,
      headers: null,
      body: null,
    );
  }

  static Uri _uriWithQuantizedCoordinates(Uri url) {
    final params = Map<String, String>.from(url.queryParameters);

    for (final key in ['lat', 'lng']) {
      final rawValue = params[key];
      if (rawValue == null) continue;

      final quantized = quantizeCoordinate(double.tryParse(rawValue));
      if (quantized != null) {
        params[key] = quantized.toString();
      }
    }

    return url.replace(queryParameters: params);
  }

  static Uri _uriWithNormalizedPlacesQuery(Uri url) {
    final params = Map<String, String>.from(url.queryParameters);
    final query = params['query'];

    if (query != null) {
      params['query'] = query.trim().toLowerCase();
    }

    return _uriWithQuantizedCoordinates(
      url.replace(queryParameters: params),
    );
  }
}
