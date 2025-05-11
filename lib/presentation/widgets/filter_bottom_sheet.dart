import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/services_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  final ServicesController controller;

  const FilterBottomSheet({super.key, required this.controller});

  static Future<void> show(
    BuildContext context,
    ServicesController controller,
  ) {
    return Get.bottomSheet(
      FilterBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RxDouble minPrice;
  late RxDouble maxPrice;
  late RxBool showOnlyAvailable;

  @override
  void initState() {
    super.initState();

    minPrice = (widget.controller.minPriceFilter.value).obs;
    maxPrice = (widget.controller.maxPriceFilter.value).obs;
    showOnlyAvailable = (widget.controller.onlyAvailableFilter.value).obs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.defaultRadius),
          topRight: Radius.circular(AppConstants.defaultRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const Divider(),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(theme),
                  const SizedBox(height: 24),

                  _buildAvailabilitySection(theme),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('filter_services'.tr, style: theme.textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
          tooltip: 'close'.tr,
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'price_range'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text('${"currency_symbol".tr} ${minPrice.value.toInt()}'),
            ),
            Obx(
              () => Text('${"currency_symbol".tr} ${maxPrice.value.toInt()}'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => RangeSlider(
            values: RangeValues(minPrice.value, maxPrice.value),
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels(
              '${"currency_symbol".tr} ${minPrice.value.toInt()}',
              '${"currency_symbol".tr} ${maxPrice.value.toInt()}',
            ),
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
            onChanged: (RangeValues values) {
              minPrice.value = values.start;
              maxPrice.value = values.end;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'availability'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Obx(
              () => Switch(
                value: showOnlyAvailable.value,
                onChanged: (value) {
                  showOnlyAvailable.value = value;
                },
                activeColor: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text('show_only_available'.tr),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            widget.controller.selectedCategory.value = 'All';
            minPrice.value = 0;
            maxPrice.value = 1000;
            showOnlyAvailable.value = false;
            setState(() {});
          },
          child: Text('reset'.tr),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            widget.controller.applyFilters(
              minPrice: minPrice.value,
              maxPrice: maxPrice.value,
              onlyAvailable: showOnlyAvailable.value,
            );
            Get.back();
          },
          child: Text('apply'.tr),
        ),
      ],
    );
  }
}
