import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';

class EditableListTile extends StatefulWidget {
  final String title;
  final String initialValue;
  final IconData leadingIcon;
  final ValueChanged<String> onSave;

  const EditableListTile({
    super.key,
    required this.title,
    required this.initialValue,
    required this.leadingIcon,
    required this.onSave,
  });

  @override
  State<EditableListTile> createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (!_isEditing) {
        _controller.text = widget.initialValue; // Reset to current value when opening
      }
      _isEditing = !_isEditing;
    });
  }

  void _save() {
    widget.onSave(_controller.text);
    setState(() {
      _isEditing = false;
    });
  }

  void _cancel() {
    setState(() {
      _controller.text = widget.initialValue;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final brandColor = AppColors.getBrandPrimary(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.getDivider(context),
            width: 1,
          ),
        ),
      ),
      child: _isEditing
          ? Row(
              children: [
                Icon(widget.leadingIcon, color: brandColor),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: widget.title,
                      isDense: true,
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: AppColors.successGreen),
                  onPressed: _save,
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: AppColors.errorRed),
                  onPressed: _cancel,
                ),
              ],
            )
          : InkWell(
              onTap: _toggleEdit,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.leadingIcon, color: brandColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isRtl ? Icons.chevron_left : Icons.chevron_right,
                    color: AppColors.getMutedText(context),
                  ),
                ],
              ),
            ),
    );
  }
}
