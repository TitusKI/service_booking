import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/service_entity.dart';
import '../../controllers/services_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddEditServiceScreen extends StatefulWidget {
  final ServiceEntity? service;

  const AddEditServiceScreen({super.key, this.service});

  @override
  State<AddEditServiceScreen> createState() => _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends State<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _ratingController;

  String _selectedCategory = 'Cleaning';
  bool _availability = true;

  bool _isImageValid = true;

  final ServicesController _servicesController = Get.find<ServicesController>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController = TextEditingController(
      text: widget.service?.price.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.service?.duration.toString() ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.service?.imageUrl ?? '',
    );
    _ratingController = TextEditingController(
      text: widget.service?.rating.toString() ?? '5.0',
    );

    if (widget.service != null) {
      _selectedCategory = widget.service!.category.tr;
      _availability = widget.service!.availability;
    }

    _imageUrlController.addListener(_validateImageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _imageUrlController.removeListener(_validateImageUrl);
    _imageUrlController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _validateImageUrl() {
    if (_imageUrlController.text.isEmpty) {
      setState(() {
        _isImageValid = true;
      });
      return;
    }

    final url = _imageUrlController.text;
    final parsedUri = Uri.tryParse(url);
    if (parsedUri == null || !parsedUri.isAbsolute) {
      setState(() {
        _isImageValid = false;
      });
      return;
    }

    setState(() {
      _isImageValid = true;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final service = ServiceEntity(
        id: widget.service?.id ?? const Uuid().v4(),
        name: _nameController.text,
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        availability: _availability,
        duration: int.parse(_durationController.text),
        rating: double.parse(_ratingController.text),
      );

      if (widget.service == null) {
        await _servicesController.performAddService(service);
      } else {
        await _servicesController.performUpdateService(service);
      }

      if (context.mounted) {
        Get.back(result: {'updatedService': service});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.service != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_service'.tr : 'add_new_service'.tr),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            CustomTextField(
              label: 'service_name'.tr,
              hint: 'enter_service_name'.tr,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'field_required'.tr;
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'category'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultRadius,
                    ),
                    border: Border.all(
                      color:
                          theme
                              .inputDecorationTheme
                              .enabledBorder
                              ?.borderSide
                              .color ??
                          Colors.transparent,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items:
                          _servicesController.categories
                              .where((category) => category != 'All')
                              .map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category.tr),
                                );
                              })
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                      style: theme.textTheme.bodyMedium,
                      dropdownColor: theme.cardColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: "${'price'.tr} (${'currency_symbol'.tr})",
                    hint: '0.00',
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_required'.tr;
                      }
                      if (double.tryParse(value) == null) {
                        return 'invalid_price'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: CustomTextField(
                    label: 'duration_minutes'.tr,
                    hint: '60',
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_required'.tr;
                      }
                      if (int.tryParse(value) == null) {
                        return 'invalid_duration'.tr;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            CustomTextField(
              label: 'image_url'.tr,
              hint: 'enter_image_url'.tr,
              controller: _imageUrlController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'field_required'.tr;
                }
                final parsedUri = Uri.tryParse(value);
                if (parsedUri == null || !parsedUri.isAbsolute) {
                  return 'invalid_url'.tr;
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            if (_imageUrlController.text.isNotEmpty)
              AnimatedContainer(
                duration: AppConstants.defaultAnimationDuration,
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.only(
                  bottom: AppConstants.defaultPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultRadius,
                  ),
                  border: Border.all(
                    color:
                        _isImageValid
                            ? theme.dividerColor
                            : theme.colorScheme.error,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultRadius,
                  ),
                  child:
                      _isImageValid
                          ? Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: theme.colorScheme.error,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'invalid_image'.tr,
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          )
                          : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.link_off,
                                  size: 40,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'invalid_url'.tr,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),

            CustomTextField(
              label: 'rating'.tr,
              hint: '5.0',
              controller: _ratingController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d\.?\d?')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'field_required'.tr;
                }
                final rating = double.tryParse(value);
                if (rating == null) {
                  return 'invalid_rating'.tr;
                }
                if (rating < 0 || rating > 5) {
                  return 'rating_range'.tr;
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'availability'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Container(
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultRadius,
                    ),
                    border: Border.all(
                      color:
                          theme
                              .inputDecorationTheme
                              .enabledBorder
                              ?.borderSide
                              .color ??
                          Colors.transparent,
                    ),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      _availability ? 'available'.tr : 'unavailable'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            _availability ? Colors.green[700] : Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _availability,
                    onChanged: (value) {
                      setState(() {
                        _availability = value;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red[100],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.largePadding),

            Obx(
              () => CustomButton(
                text: isEditing ? 'update_service'.tr : 'add_service_button'.tr,
                onPressed: _submitForm,
                isLoading: _servicesController.isLoading.value,
                isDisabled: !_isImageValid,
                icon: isEditing ? Icons.save : Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
