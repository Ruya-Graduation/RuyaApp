import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';

class ScannerControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onPickGallery;
  final VoidCallback onToggleFlash;
  final VoidCallback onFlipCamera;
  final bool isFlashOn;

  const ScannerControls({
    super.key,
    required this.onCapture,
    required this.onPickGallery,
    required this.onToggleFlash,
    required this.onFlipCamera,
    this.isFlashOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gallery Picker Button
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.black.withValues(alpha: 0.55),
            child: IconButton(
              icon: const Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
                size: 24,
              ),
              onPressed: onPickGallery,
            ),
          ),

          // Central Capture Button
          GestureDetector(
            onTap: onCapture,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.9),
                  width: 4,
                ),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimaryLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandPrimaryLight.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          // Switch / Flip Camera Button
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.black.withValues(alpha: 0.55),
            child: IconButton(
              icon: const Icon(
                Icons.cameraswitch_outlined,
                color: Colors.white,
                size: 24,
              ),
              onPressed: onFlipCamera,
            ),
          ),
        ],
      ),
    );
  }
}
