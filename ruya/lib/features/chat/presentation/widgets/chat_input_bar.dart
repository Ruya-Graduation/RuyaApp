import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/chat/presentation/widgets/mic_button.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// Bottom input bar with text field, image attachment, press-and-hold mic, and send button.
class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final File? selectedImage;
  final VoidCallback onClearImage;
  final ValueChanged<File> onImageSelected;
  final bool isRecording;
  final bool isMicAvailable;
  final String liveTranscript;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onCancelRecording;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.selectedImage,
    required this.onClearImage,
    required this.onImageSelected,
    this.isRecording = false,
    this.isMicAvailable = true,
    this.liveTranscript = '',
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onCancelRecording,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    final picker = ImagePicker();

    try {
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (picked != null) {
        final file = File(picked.path);
        final bytes = await file.length();
        const maxBytes = 10 * 1024 * 1024; // 10 MB limit

        if (!context.mounted) return;

        if (bytes > maxBytes) {
          AppSnackBar.showError(context, l10n.imageTooLarge);
          return;
        }

        onImageSelected(file);
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, e.toString());
      }
    }
  }

  void _showImagePickerSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFFD4A373)),
                  title: Text(
                    l10n.takePhoto,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: Color(0xFFD4A373)),
                  title: Text(
                    l10n.chooseFromGallery,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAF6F0),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isRecording)
              _RecordingIndicatorRibbon(
                transcript: liveTranscript,
                l10n: l10n,
                isDark: isDark,
              ),
            if (selectedImage != null && !isRecording)
              _SelectedImageThumbnail(
                image: selectedImage!,
                onRemove: onClearImage,
                isDark: isDark,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                children: [
                  // Attachment Icon Button
                  IconButton(
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: isDark ? const Color(0xFFD4A373) : const Color(0xFF8B6914),
                      size: 24,
                    ),
                    tooltip: l10n.attachImage,
                    onPressed: isRecording ? null : () => _showImagePickerSheet(context),
                  ),
                  const SizedBox(width: 4),

                  // Pill TextField
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: !isRecording,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: isRecording ? l10n.recording : l10n.typeMessage,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 12.0,
                        ),
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Press-and-hold Mic Button
                  MicButton(
                    isRecording: isRecording,
                    isAvailable: isMicAvailable,
                    onStartRecording: onStartRecording,
                    onStopRecording: onStopRecording,
                    onCancelRecording: onCancelRecording,
                  ),
                  const SizedBox(width: 8),

                  // Send Button
                  _SendButton(onSend: isRecording ? () {} : onSend),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedImageThumbnail extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;
  final bool isDark;

  const _SelectedImageThumbnail({
    required this.image,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      alignment: Alignment.centerLeft,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD4A373),
                width: 1.5,
              ),
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordingIndicatorRibbon extends StatelessWidget {
  final String transcript;
  final AppLocalizations l10n;
  final bool isDark;

  const _RecordingIndicatorRibbon({
    required this.transcript,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              transcript.isNotEmpty ? transcript : l10n.listening,
              style: TextStyle(
                fontSize: 13,
                fontStyle: transcript.isEmpty ? FontStyle.italic : FontStyle.normal,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            l10n.releaseToSend,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onSend;

  const _SendButton({required this.onSend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD4A373), Color(0xFFC49060)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A373).withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}
