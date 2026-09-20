import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/pinkora_app_bar.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final AuthRepository _repo = Get.find<AuthRepository>();

  UserModel? _user;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _user = _repo.currentUser;

    _nameController.text = _user?.name ?? '';
    _emailController.text = _user?.email ?? '';
    _phoneController.text = _user?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final base = _user ??
        UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '',
          email: '',
        );

    final updated = base.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    await _repo.updateProfile(updated);

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().loadUser();
    }

    if (!mounted) return;

    Get.back();

    CustomSnackbar.success(
      'Profile Updated',
      'Your changes have been saved',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar('Edit Profile'),
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
              const _Label('Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return Validators.email(v);
                },
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
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return Validators.phone(v);
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving...' : 'Save Changes'),
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
