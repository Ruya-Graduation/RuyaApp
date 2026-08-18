import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final bool isRecording;
  final bool isAvailable;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onCancelRecording;

  const MicButton({
    super.key,
    required this.isRecording,
    this.isAvailable = true,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onCancelRecording,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _pulseController.forward();
        }
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.forward();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAvailable) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mic_off_rounded,
          color: Colors.grey,
          size: 20,
        ),
      );
    }

    return GestureDetector(
      onLongPressStart: (_) => widget.onStartRecording(),
      onLongPressEnd: (_) => widget.onStopRecording(),
      onLongPressCancel: () => widget.onCancelRecording(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          final scale = widget.isRecording ? _scaleAnimation.value : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isRecording
                      ? const [Color(0xFFE57373), Color(0xFFD32F2F)]
                      : const [Color(0xFFD4A373), Color(0xFFC49060)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.isRecording
                            ? const Color(0xFFE57373)
                            : const Color(0xFFD4A373))
                        .withValues(alpha: widget.isRecording ? 0.5 : 0.35),
                    blurRadius: widget.isRecording ? 14 : 8,
                    spreadRadius: widget.isRecording ? 2 : 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                widget.isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          );
        },
      ),
    );
  }
}
