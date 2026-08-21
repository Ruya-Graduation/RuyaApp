import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/theme/app_text_styles.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_primary_button.dart';
import 'package:ruya/core/widgets/app_text_field.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_cubit.dart';
import 'package:ruya/features/moments/presentation/widgets/horizontal_image_list.dart';
import 'package:ruya/features/moments/presentation/widgets/image_picker_box.dart';
import 'package:ruya/l10n/app_localizations.dart';

class EditMomentPage extends StatefulWidget {
  final MomentItem moment;

  const EditMomentPage({super.key, required this.moment});

  @override
  State<EditMomentPage> createState() => _EditMomentPageState();
}

class _EditMomentPageState extends State<EditMomentPage> {
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _picker = ImagePicker();

  // Cover image — null means keep existing cover
  File? _newCoverImage;
  bool _isPickingImage = false;
  bool _isSubmitting = false;

  // Additional photos added during editing
  final List<File> _addedPhotos = [];

  String? _titleError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.moment.title;
    _startDateController.text = widget.moment.startDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() {
          _newCoverImage = File(picked.path);
        });
      }
    } catch (_) {
      // Ignored
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _pickAdditionalPhotos() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final list = await _picker.pickMultiImage(imageQuality: 85);
      if (list.isNotEmpty && mounted) {
        setState(() {
          _addedPhotos.addAll(list.map((x) => File(x.path)));
        });
      }
    } catch (_) {
      // Ignored
    } finally {
      _isPickingImage = false;
    }
  }

  void _removeAddedPhoto(int index) {
    setState(() => _addedPhotos.removeAt(index));
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.brandPrimaryDark,
                    onPrimary: Colors.black,
                    surface: Color(0xFF2C2C2C),
                  )
                : const ColorScheme.light(
                    primary: AppColors.brandPrimaryLight,
                    onPrimary: Colors.white,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _startDateController.text = DateFormat('MMM yyyy').format(picked);
        _dateError = null;
      });
    }
  }

  bool _validate() {
    String? titleErr;
    String? dateErr;
    final l10n = AppLocalizations.of(context)!;

    if (_titleController.text.trim().isEmpty) {
      titleErr = l10n.titleRequiredError;
    }
    if (_startDateController.text.trim().isEmpty) {
      dateErr = l10n.dateRequiredError;
    }

    setState(() {
      _titleError = titleErr;
      _dateError = dateErr;
    });
    return titleErr == null && dateErr == null;
  }

  Future<void> _onSave() async {
    if (!_validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.confirmEditAlbumTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.confirmEditAlbumBody,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getBrandPrimary(context),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final cubit = context.read<MomentsCubit>();
    setState(() => _isSubmitting = true);

    // 1. Update text metadata (title & start date)
    final updateSuccess = await cubit.updateAlbum(
      widget.moment.id,
      title: _titleController.text.trim(),
      startDate: _startDateController.text.trim(),
    );

    if (!updateSuccess) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppSnackBar.showError(context, 'Failed to update album details');
      }
      return;
    }

    int failedUploads = 0;

    // 2. If new cover photo was picked, upload it as a photo
    if (_newCoverImage != null) {
      final ok = await cubit.addPhotoToAlbum(
        widget.moment.id,
        photo: _newCoverImage!,
        caption: 'Cover update',
        dayLabel: null,
      );
      if (!ok) {
        failedUploads++;
      }
    }

    // 3. Upload any additional photos
    for (int i = 0; i < _addedPhotos.length; i++) {
      final photoFile = _addedPhotos[i];
      final ok = await cubit.addPhotoToAlbum(
        widget.moment.id,
        photo: photoFile,
        caption: 'Photo ${_addedPhotos.length + 1}',
        dayLabel: 'DAY 1',
      );
      if (!ok) {
        failedUploads++;
      }
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (failedUploads == 0) {
      AppSnackBar.showSuccess(context, l10n.momentUpdatedSuccess);
      context.pop();
    } else {
      AppSnackBar.showWarning(
        context,
        'Album updated, but $failedUploads photo(s) failed to upload',
      );
      context.pop();
    }
  }

  Widget _buildCurrentCoverPreview() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePickerBox(
          selectedImage: _newCoverImage,
          onTap: _pickCoverImage,
          onClear: () => setState(() {
            _newCoverImage = null;
          }),
          existingImageUrl: _newCoverImage != null
              ? null
              : widget.moment.coverImageUrl,
        ),
        AppSpacing.verticalGapXxs,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            AppSpacing.horizontalGapXxs,
            Expanded(
              child: Text(
                'New cover photos are added to your album timeline.',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.editMomentTitle,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding(context),
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover photo section
              Text(l10n.coverPhotoLabel, style: AppTextStyles.label(context)),
              AppSpacing.verticalGapXs,
              _buildCurrentCoverPreview(),
              AppSpacing.verticalGapMd,

              // Title
              AppTextField(
                controller: _titleController,
                label: l10n.momentTitleLabel,
                hint: l10n.momentTitleHint,
                errorText: _titleError,
                onChanged: (v) {
                  if (_titleError != null && v.trim().isNotEmpty) {
                    setState(() => _titleError = null);
                  }
                },
              ),
              AppSpacing.verticalGapMd,

              // Start Date
              GestureDetector(
                onTap: _selectDate,
                behavior: HitTestBehavior.opaque,
                child: AbsorbPointer(
                  child: AppTextField(
                    controller: _startDateController,
                    label: l10n.tripDateLabel,
                    hint: l10n.tripDateHint,
                    errorText: _dateError,
                  ),
                ),
              ),
              AppSpacing.verticalGapLg,

              // Add more photos
              HorizontalImageList(
                images: _addedPhotos,
                onAddPressed: _pickAdditionalPhotos,
                onRemovePressed: _removeAddedPhoto,
              ),
              AppSpacing.verticalGapXl,

              // Save button
              AppPrimaryButton(
                label: l10n.editMomentBtn,
                onPressed: _onSave,
                isLoading: _isSubmitting,
              ),
              AppSpacing.verticalGapLg,
            ],
          ),
        ),
      ),
    );
  }
}
