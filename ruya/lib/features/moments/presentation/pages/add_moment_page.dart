import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/theme/app_text_styles.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_primary_button.dart';
import 'package:ruya/core/widgets/app_text_field.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_cubit.dart';
import 'package:ruya/features/moments/presentation/widgets/horizontal_image_list.dart';
import 'package:ruya/features/moments/presentation/widgets/image_picker_box.dart';
import 'package:ruya/l10n/app_localizations.dart';

class AddMomentPage extends StatefulWidget {
  final File? initialCoverImage;

  const AddMomentPage({super.key, this.initialCoverImage});

  @override
  State<AddMomentPage> createState() => _AddMomentPageState();
}

class _AddMomentPageState extends State<AddMomentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _picker = ImagePicker();

  File? _coverImage;
  final List<File> _additionalPhotos = [];
  bool _isSubmitting = false;
  bool _isPickingImage = false;
  String? _coverError;
  String? _titleError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    if (widget.initialCoverImage != null) {
      _coverImage = widget.initialCoverImage;
    }
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
          _coverImage = File(picked.path);
          _coverError = null;
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
      final pickedList = await _picker.pickMultiImage(imageQuality: 85);
      if (pickedList.isNotEmpty && mounted) {
        setState(() {
          _additionalPhotos.addAll(pickedList.map((x) => File(x.path)));
        });
      }
    } catch (_) {
      // Ignored
    } finally {
      _isPickingImage = false;
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _additionalPhotos.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.brandPrimaryDark,
                    onPrimary: Colors.black,
                    surface: AppColors.getSurface(context),
                  )
                : ColorScheme.light(
                    primary: AppColors.getBrandPrimary(context),
                    onPrimary: Colors.white,
                    surface: AppColors.getSurface(context),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formatted = DateFormat('MMM yyyy').format(pickedDate);
      setState(() {
        _startDateController.text = formatted;
        _dateError = null;
      });
    }
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context)!;

    String? coverErr;
    String? titleErr;
    String? dateErr;

    if (_coverImage == null) {
      coverErr = l10n.coverRequiredError;
    }
    if (_titleController.text.trim().isEmpty) {
      titleErr = l10n.titleRequiredError;
    }
    if (_startDateController.text.trim().isEmpty) {
      dateErr = l10n.dateRequiredError;
    }

    if (coverErr != null || titleErr != null || dateErr != null) {
      setState(() {
        _coverError = coverErr;
        _titleError = titleErr;
        _dateError = dateErr;
      });
      return;
    }

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim();
    final startDate = _startDateController.text.trim();
    final cubit = context.read<MomentsCubit>();

    final createdAlbum = await cubit.createMoment(
      title: title,
      startDate: startDate,
      coverPhoto: _coverImage,
    );

    if (!mounted) return;

    if (createdAlbum == null) {
      setState(() => _isSubmitting = false);
      AppSnackBar.showError(context, 'Failed to create memory album');
      return;
    }

    int failedPhotos = 0;
    if (_additionalPhotos.isNotEmpty) {
      for (int i = 0; i < _additionalPhotos.length; i++) {
        final photoFile = _additionalPhotos[i];
        final ok = await cubit.addPhotoToAlbum(
          createdAlbum.id,
          photo: photoFile,
          caption: 'Photo ${i + 1}',
          dayLabel: 'DAY 1',
        );
        if (!ok) {
          failedPhotos++;
        }
      }
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (failedPhotos == 0) {
      AppSnackBar.showSuccess(context, l10n.momentCreatedSuccess);
      context.pop();
    } else {
      AppSnackBar.showWarning(
        context,
        'Album created, but $failedPhotos photo(s) failed to upload',
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.createMomentTitle,
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover photo section
                Text(l10n.coverPhotoLabel, style: AppTextStyles.label(context)),
                AppSpacing.verticalGapXs,
                ImagePickerBox(
                  selectedImage: _coverImage,
                  onTap: _pickCoverImage,
                  onClear: () => setState(() => _coverImage = null),
                  errorText: _coverError,
                ),
                AppSpacing.verticalGapMd,

                // Title input field
                AppTextField(
                  controller: _titleController,
                  label: l10n.momentTitleLabel,
                  hint: l10n.momentTitleHint,
                  errorText: _titleError,
                  onChanged: (val) {
                    if (_titleError != null && val.trim().isNotEmpty) {
                      setState(() => _titleError = null);
                    }
                  },
                ),
                AppSpacing.verticalGapMd,

                // Start Date input field
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

                // Multiple photos picker section
                HorizontalImageList(
                  images: _additionalPhotos,
                  onAddPressed: _pickAdditionalPhotos,
                  onRemovePressed: _removePhoto,
                ),
                AppSpacing.verticalGapXl,

                // Submit Button
                AppPrimaryButton(
                  label: l10n.createMomentBtn,
                  onPressed: _onSubmit,
                  isLoading: _isSubmitting,
                ),
                AppSpacing.verticalGapLg,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
