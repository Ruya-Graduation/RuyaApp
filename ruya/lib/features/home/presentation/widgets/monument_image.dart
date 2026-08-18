import 'package:flutter/material.dart';

/// Shared monument image widget that handles the remote-URL / local-asset
/// fallback logic in one place.
///
/// Resolution order:
///   1. If [imageUrl] is non-null and non-empty → render [Image.network] with
///      an [errorBuilder] that falls back to the local asset (handles broken
///      or expired remote URLs).
///   2. Otherwise → render [Image.asset] with [_fallbackAsset].
///
/// Import this widget anywhere a monument image is needed so the fallback
/// behaviour stays in sync if the backend adds real image URLs later.
class MonumentImage extends StatelessWidget {
  static const String _fallbackAsset = 'assets/images/egyptian_pyramids.png';

  final String? imageUrl;
  final double height;
  final BoxFit fit;

  const MonumentImage({
    super.key,
    required this.imageUrl,
    this.height = 180,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final hasRemoteUrl =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (hasRemoteUrl) {
      return Image.network(
        imageUrl!,
        height: height,
        width: double.infinity,
        fit: fit,
        // Fallback for broken/expired URLs — shows the bundled asset
        // rather than a broken-image icon.
        errorBuilder: (_, __, ___) => Image.asset(
          _fallbackAsset,
          height: height,
          width: double.infinity,
          fit: fit,
        ),
        // Show the local asset while the remote image is loading,
        // then crossfade to the remote one.
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return Image.asset(
            _fallbackAsset,
            height: height,
            width: double.infinity,
            fit: fit,
          );
        },
      );
    }

    return Image.asset(
      _fallbackAsset,
      height: height,
      width: double.infinity,
      fit: fit,
    );
  }
}
