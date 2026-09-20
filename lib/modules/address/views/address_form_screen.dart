import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/model/address_model.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../widgets/pinkora_app_bar.dart';
import '../controllers/address_controller.dart';

/// Add a new address, or edit one (pass an AddressModel as Get.arguments).
/// Pops with the saved AddressModel as result.
class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  static const _labels = ['Home', 'Office', 'Other'];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  AddressModel? _editing;
  String _label = 'Home';
  bool _isDefault = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final argument = Get.arguments;

    if (argument is AddressModel) {
      _editing = argument;
      _label = argument.label;
      _isDefault = argument.isDefault;
      _nameController.text = argument.name;
      _phoneController.text = argument.phone;
      _addressController.text = argument.address;
    } else {
      // Prefill from the profile to save typing.
      final UserModel? user = Get.find<AuthRepository>().currentUser;

      if (user != null) {
        _nameController.text = user.name;
        _phoneController.text = user.phone;
      }

      _isDefault = Get.find<AddressController>().addresses.isEmpty;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final saved = await Get.find<AddressController>().save(
      id: _editing?.id,
      label: _label,
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      isDefault: _isDefault,
    );

    if (!mounted) return;

    Get.back(result: saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar(
        _editing == null ? 'Add Address' : 'Edit Address',
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label('Address Label'),
              const SizedBox(height: 10),
              Row(
                children: _labels.map((label) {
                  final selected = label == _label;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _label = label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppColors.darkGrey,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const _Label('Full Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your full name',
                ),
                validator: (v) => Validators.required(v, 'Name'),
              ),
              const SizedBox(height: 16),
              const _Label('Phone Number'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '01XXXXXXXXX',
                ),
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              const _Label('Full Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                minLines: 3,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'House, road, area, city',
                ),
                validator: (v) => Validators.required(v, 'Address'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Set as default address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(
                    _saving ? 'Saving...' : 'Save Address',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGrey,
      ),
    );
  }
}
