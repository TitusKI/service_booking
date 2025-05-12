import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:service_booking/presentation/widgets/filter_bottom_sheet.dart';
import 'package:service_booking/presentation/widgets/main_drawer.dart';
import '../../../core/constants/app_constants.dart';
import '../../controllers/services_controller.dart';
import '../../widgets/service_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/empty_state.dart';
import 'add_edit_service.dart';
import 'service_detail_screen.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  final ServicesController controller = Get.find<ServicesController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchServices();
    });

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MainDrawer(),
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Text('services'.tr),
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    onPressed: () => Get.to(() => const AddEditServiceScreen()),
                    tooltip: 'add_service'.tr,
                  ),
                ],
              ),
            ],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged:
                          (value) => controller.searchQuery.value = value,
                      decoration: InputDecoration(
                        hintText: 'search_services'.tr,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Obx(
                          () =>
                              controller.searchQuery.value.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed:
                                        () => controller.searchQuery.value = '',
                                  )
                                  : const SizedBox.shrink(),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed:
                        () => FilterBottomSheet.show(context, controller),
                    tooltip: 'filter'.tr,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final isSelected =
                        category == controller.selectedCategory.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category.tr),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              controller.selectedCategory.value = category;
                            });
                          }
                        },
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        selectedColor: theme.colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const LoadingIndicator(type: LoadingType.list);
                }

                final services = controller.filteredServices;

                if (services.isEmpty) {
                  if (controller.errorMessage.isNotEmpty) {
                    return EmptyState(
                      title: 'error'.tr,
                      message: controller.errorMessage.value.tr,
                      icon: Icons.error_outline,
                      actionText: 'retry'.tr,
                      onActionPressed: () => controller.fetchServices(),
                    );
                  }

                  return EmptyState(
                    title: 'no_services_found'.tr,
                    message: 'try_adjusting_search'.tr,
                    icon: Icons.search_off,
                    actionText:
                        controller.searchQuery.value.isNotEmpty ||
                                controller.selectedCategory.value != 'All'
                            ? 'reset_filters'.tr
                            : null,
                    onActionPressed:
                        controller.searchQuery.value.isNotEmpty ||
                                controller.selectedCategory.value != 'All'
                            ? () {
                              controller.searchQuery.value = '';
                              controller.maxPriceFilter.value = 1000;
                              controller.minPriceFilter.value = 0;
                              setState(() {
                                controller.selectedCategory.value = 'All';
                              });
                            }
                            : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchServices(),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: AppConstants.smallPadding,
                        bottom: 80,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: AppConstants.defaultAnimationDuration,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: ServiceCard(
                                service: service,
                                onTap:
                                    () => Get.to(
                                      () => ServiceDetailScreen(
                                        initialService: service,
                                      ),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                    ),

                                onDelete:
                                    () => controller.performDeleteService(
                                      service.id,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Get.to(
              () => const AddEditServiceScreen(),
              transition: Transition.downToUp,
            ),
        icon: const Icon(Icons.add),
        label: Text('add_service'.tr),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
