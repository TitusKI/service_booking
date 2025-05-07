import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/service_entity.dart';
import '../../widgets/custom_button.dart';
import 'add_edit_service.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Hero(
                tag: 'service-image-${service.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      service.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                    ),

                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.7, 1.0],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          service.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed:
                    () => Get.to(
                      () => AddEditServiceScreen(service: service),
                      transition: Transition.rightToLeftWithFade,
                    ),
                tooltip: 'edit'.tr,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              service.availability
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.availability
                              ? 'available'.tr
                              : 'unavailable'.tr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                service.availability
                                    ? Colors.green[700]
                                    : Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < service.rating.floor()
                              ? Icons.star
                              : index < service.rating
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 24,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        service.rating.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.defaultPadding),
                  const Divider(),
                  const SizedBox(height: AppConstants.defaultPadding),

                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        icon: Icons.attach_money,
                        title: 'price'.tr,
                        value: '\$${service.price.toStringAsFixed(2)}',
                        color: Colors.green,
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      _buildInfoCard(
                        context,
                        icon: Icons.access_time,
                        title: 'duration'.tr,
                        value: '${service.duration} ${'minutes'.tr}',
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  Text('description'.tr, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'This is a detailed description of the ${service.name} service. It includes information about what the service entails, what customers can expect, and any special requirements or considerations.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  Text('whats_included'.tr, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppConstants.smallPadding),
                  _buildIncludedItem(
                    context,
                    'Professional service by experienced staff',
                    true,
                  ),
                  _buildIncludedItem(
                    context,
                    'Quality equipment and materials',
                    true,
                  ),
                  _buildIncludedItem(context, 'Satisfaction guarantee', true),
                  _buildIncludedItem(
                    context,
                    'Free follow-up consultation',
                    service.price > 50,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'price'.tr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${service.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: CustomButton(
                text: 'book_now'.tr,
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('booking_confirmation'.tr),
                      content: Text(
                        '${'booking_question'.tr} ${service.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('cancel'.tr),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();

                            Get.snackbar(
                              'success'.tr,
                              'booking_successful'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              borderRadius: 10,
                              margin: const EdgeInsets.all(10),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                          ),
                          child: Text('confirm'.tr),
                        ),
                      ],
                    ),
                  );
                },
                isDisabled: !service.availability,
                color: service.availability ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncludedItem(
    BuildContext context,
    String text,
    bool isIncluded,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isIncluded ? Icons.check_circle : Icons.cancel,
            color: isIncluded ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isIncluded
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                decoration: isIncluded ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
