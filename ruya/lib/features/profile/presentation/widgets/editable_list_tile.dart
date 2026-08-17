import 'package:flutter/material.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: _isEditing
          ? Row(
              children: [
                Icon(widget.leadingIcon, color: const Color(0xFFD4A373)),
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
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: _save,
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
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
                      color: const Color(0xFFD4A373).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.leadingIcon, color: const Color(0xFFD4A373), size: 20),
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
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
    );
  }
}
