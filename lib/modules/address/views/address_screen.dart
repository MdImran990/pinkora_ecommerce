import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/address_model.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/pinkora_app_bar.dart';
import '../controllers/address_controller.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar('My Address'),
      body: Obx(
            () {
          final list = controller.addresses;

          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.location_off_outlined,
              title: 'No saved address',
              message:
              'Add a delivery address to check out faster next time.',
              buttonLabel: 'Add Address',
              onButtonTap: () => Get.toNamed(AppRoutes.addressForm),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _AddressCard(
                address: list[index],
                controller: controller,
              );
            },
          );
        },
      ),
      bottomNavigationBar: Obx(
            () {
          if (controller.addresses.isEmpty) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.addressForm),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add New Address'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.controller,
  });

  final AddressModel address;
  final AddressController controller;

  IconData _icon() {
    switch (address.label) {
      case 'Office':
        return Icons.business_rounded;
      case 'Other':
        return Icons.place_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'Delete Address',
      middleText: 'Do you want to delete this address?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.back();
        controller.delete(address.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderColor: address.isDefault ? AppColors.primary : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon(), color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.name} • ${address.phone}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address.address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.grey,
              size: 20,
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  Get.toNamed(AppRoutes.addressForm, arguments: address);
                  break;
                case 'default':
                  controller.setDefault(address.id);
                  break;
                case 'delete':
                  _confirmDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              if (!address.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as default'),
                ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
