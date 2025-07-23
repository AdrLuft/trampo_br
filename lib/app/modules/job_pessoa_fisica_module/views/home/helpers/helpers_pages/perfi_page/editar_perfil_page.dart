import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/profile_controller.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final ProfileController _controller = Get.find<ProfileController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(
      text: _controller.user.value?.name ?? '',
    );
    _emailController = TextEditingController(
      text: _controller.user.value?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: _controller.user.value?.phone ?? '',
    );
    _addressController = TextEditingController(
      text: _controller.user.value?.address ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      await _controller.updateUserData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
    }
  }

  void _showPhotoOptions() {
    final user = _controller.user.value;
    final hasProfileImage = user?.profileImageUrl?.isNotEmpty == true;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Opções de Foto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 34),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF6366F1)),
              title: Text(
                hasProfileImage ? 'Alterar Foto' : 'Adicionar Foto',
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Get.back();
                _controller.pickAndUploadProfileImage();
              },
            ),
            // Verifique se esta condição está sendo atendida
            if (hasProfileImage) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remover Foto',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _controller.removeProfileImage();
                },
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(body: _buildBody(isDark));
  }

  Widget _buildBody(bool isDark) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(isDark),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildProfileHeader(isDark),
                const SizedBox(height: 32),
                _buildForm(isDark),
                const SizedBox(height: 32),
                _buildActionButtons(isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF6366F1),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Obx(() {
      final user = _controller.user.value;
      final isUploading = _controller.isUploadingPhoto.value;

      return Column(
        children: [
          GestureDetector(
            onTap: isUploading ? null : _showPhotoOptions,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF6366F1).withAlpha(26),
                  child: ClipOval(
                    child:
                        user?.profileImageUrl?.isNotEmpty == true
                            ? CachedNetworkImage(
                              imageUrl: user!.profileImageUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) =>
                                      const CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) => const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color(0xFF6366F1),
                                  ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFF6366F1),
                            ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        width: 2,
                      ),
                    ),
                    child:
                        isUploading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isUploading ? 'Atualizando foto...' : 'Toque para alterar a foto',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildForm(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInputField(
            controller: _nameController,
            label: 'Nome Completo',
            icon: Icons.person_outline,
            isDark: isDark,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nome é obrigatório';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
            validator: (value) {
              if (value == null || !value.isEmail) {
                return 'Email inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _phoneController,
            label: 'Telefone',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _addressController,
            label: 'Endereço',
            icon: Icons.location_on_outlined,
            keyboardType: TextInputType.streetAddress,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white38 : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade700,
        ),
      ),
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Obx(() {
      final isLoading = _controller.isLoading.value;
      final isUploadingPhoto = _controller.isUploadingPhoto.value;
      final isDisabled = isLoading || isUploadingPhoto;

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isDisabled ? null : () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFF6366F1)),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isDisabled ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Salvar Alterações',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      );
    });
  }
}

// Helper class para compatibilidade
class PerfilPageHelper {
  static void showEditProfileDialog() {
    Get.to(() => const EditarPerfilPage());
  }
}
