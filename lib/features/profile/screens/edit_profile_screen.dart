import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _noKtpController;
  late TextEditingController _alamatController;
  late TextEditingController _kotaController;
  late TextEditingController _kodePosController;
  late TextEditingController _noTeleponController;
  late TextEditingController _noHandphoneController;
  late TextEditingController _kewarganegaraanController;
  late TextEditingController _nimController;
  late TextEditingController _ipkController;
  late TextEditingController _bidangController;
  late TextEditingController _disabilitasController;
  late TextEditingController _emailController;
  late TextEditingController _univController;

  String? _selectedJenisKelamin;
  String? _selectedStatusPerkawinan;
  String? _selectedAgama;
  String? _selectedPendidikan;
  DateTime? _selectedTanggalLahir;
  bool _isSaving = false; // true when Save button pressed (vs photo upload)
  bool _isDeletingPhoto = false;

  // Skills/Keahlian, Experience, and Education
  List<String> _skills = [];
  List<Experience> _experiences = [];
  List<Education> _education = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _tempatLahirController = TextEditingController(
      text: widget.profile.tempatLahir,
    );
    _noKtpController = TextEditingController(text: widget.profile.noKtp);
    _alamatController = TextEditingController(text: widget.profile.alamat);
    _kotaController = TextEditingController(text: widget.profile.kota);
    _kodePosController = TextEditingController(text: widget.profile.kodePos);
    _noTeleponController = TextEditingController(
      text: widget.profile.noTelepon,
    );
    _noHandphoneController = TextEditingController(
      text: widget.profile.noHandphone,
    );
    _kewarganegaraanController = TextEditingController(
      text: widget.profile.kewarganegaraan,
    );
    _nimController = TextEditingController(text: widget.profile.nim);
    _ipkController = TextEditingController(text: widget.profile.ipk);
    _bidangController = TextEditingController(text: widget.profile.bidang);
    _disabilitasController = TextEditingController(
      text: widget.profile.disabilitas,
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _univController = TextEditingController(text: 'Universitas Dian Nuswantoro');

    _selectedJenisKelamin = widget.profile.jenisKelamin;
    _selectedStatusPerkawinan = widget.profile.statusPerkawinan;
    _selectedAgama = widget.profile.agama;
    _selectedPendidikan = widget.profile.pendidikanTertinggi;

    if (widget.profile.tanggalLahir != null) {
      _selectedTanggalLahir = DateTime.tryParse(widget.profile.tanggalLahir!);
    }

    _skills = List<String>.from(widget.profile.skills);
    _experiences = List<Experience>.from(widget.profile.experiences);
    _education = List<Education>.from(widget.profile.education);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tempatLahirController.dispose();
    _noKtpController.dispose();
    _alamatController.dispose();
    _kotaController.dispose();
    _kodePosController.dispose();
    _noTeleponController.dispose();
    _noHandphoneController.dispose();
    _kewarganegaraanController.dispose();
    _nimController.dispose();
    _ipkController.dispose();
    _bidangController.dispose();
    _disabilitasController.dispose();
    _emailController.dispose();
    _univController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedTanggalLahir) {
      setState(() {
        _selectedTanggalLahir = picked;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) return;

    if (mounted) {
      context.read<ProfileBloc>().add(
        UploadProfilePicture(File(result.files.single.path!)),
      );
    }
  }

  void _deleteImage() {
    final bloc = context.read<ProfileBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Foto Profil?'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus foto profil Anda?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _isDeletingPhoto = true);
              bloc.add(const DeleteProfilePicture());
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    // Get the latest photoUrl from bloc state (may have been updated by UploadProfilePicture)
    final currentPhotoUrl =
        context.read<ProfileBloc>().state.userProfile?.photoUrl ??
        widget.profile.photoUrl;

    setState(
      () => _isSaving = true,
    ); // Mark as saving so listener can navigate back
    final updatedProfile = UserProfile(
      id: widget.profile.id,
      email: widget.profile.email,
      name: _nameController.text,
      photoUrl: currentPhotoUrl,
      tempatLahir: _tempatLahirController.text,
      tanggalLahir: _selectedTanggalLahir?.toIso8601String().split('T').first,
      noKtp: _noKtpController.text,
      jenisKelamin: _selectedJenisKelamin,
      alamat: _alamatController.text,
      kota: _kotaController.text,
      kodePos: _kodePosController.text,
      noTelepon: _noTeleponController.text,
      noHandphone: _noHandphoneController.text,
      kewarganegaraan: _kewarganegaraanController.text,
      statusPerkawinan: _selectedStatusPerkawinan,
      agama: _selectedAgama,
      pendidikanTertinggi: _selectedPendidikan,
      nim: _nimController.text,
      ipk: _ipkController.text,
      bidang: _bidangController.text,
      disabilitas: _disabilitasController.text,
      skills: _skills,
      experiences: _experiences,
      education: _education,
    );
    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Edit Profil',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
            ),
            Text(
              'Perbarui profil untuk perekrut',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface.withValues(alpha: 0.9),
        elevation: 0,
        foregroundColor: AppColors.onSurface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            if (_isSaving) {
              // Profile save complete → go back
              _isSaving = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Profil berhasil diperbarui'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            } else if (_isDeletingPhoto) {
              _isDeletingPhoto = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Foto profil berhasil dihapus'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              // Photo upload complete → show snackbar, stay on screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.photo, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Foto profil berhasil diupload'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else if (state.status == ProfileStatus.failure) {
            _isSaving = false;
            _isDeletingPhoto = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal menyimpan profil. Coba lagi.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final profile = state.userProfile ?? widget.profile;
          final isLoading = state.status == ProfileStatus.loading;
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, keyboardHeight + 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfilePhotoSection(profile, isLoading),
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(profile),
                    const SizedBox(height: 24),
                    _buildContactInfoSection(profile),
                    const SizedBox(height: 24),
                    _buildPersonalDetailsSection(profile),
                    const SizedBox(height: 24),
                    _buildAcademicInfoSection(profile),
                    const SizedBox(height: 24),
                    _buildEducationSection(),
                    const SizedBox(height: 24),
                    _buildSkillsSection(),
                    const SizedBox(height: 24),
                    _buildExperienceSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: _buildActionsRow(isLoading),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionsRow(bool isLoading) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Batal',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Simpan',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProfilePhotoSection(UserProfile profile, bool isLoading) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Foto Profil', style: AppTextStyles.headlineSmall),
              if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
                GestureDetector(
                  onTap: isLoading ? null : _deleteImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hapus',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.error,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child:
                        (profile.photoUrl != null &&
                            profile.photoUrl!.isNotEmpty)
                        ? Image.network(
                            profile.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Image.asset('assets/images/dcc.png'),
                          )
                        : Image.asset(
                            'assets/images/dcc.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: isLoading ? null : _pickAndUploadImage,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Rekomendasi: Kotak, min 500x500px, di bawah 2MB.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(UserProfile profile) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Dasar', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField('Nama Lengkap', _nameController),
          _buildTextField(
            'Email',
            _emailController,
            readOnly: true,
            helperText: 'Email tidak dapat diubah',
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Tempat Lahir', _tempatLahirController),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildDatePicker('Tanggal Lahir')),
            ],
          ),
          _buildDropdownField(
            'Jenis Kelamin',
            ['Laki-laki', 'Perempuan'],
            _selectedJenisKelamin,
            (val) => setState(() => _selectedJenisKelamin = val),
          ),
          _buildTextField('Kewarganegaraan', _kewarganegaraanController),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(UserProfile profile) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Kontak', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField('Alamat', _alamatController, maxLines: 3),
          Row(
            children: [
              Expanded(child: _buildTextField('Kota', _kotaController)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Kode Pos',
                  _kodePosController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _buildTextField(
            'Telepon Rumah',
            _noTeleponController,
            keyboardType: TextInputType.phone,
          ),
          _buildTextField(
            'Nomor Handphone',
            _noHandphoneController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection(UserProfile profile) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Pribadi', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField(
            'No KTP (NIK)',
            _noKtpController,
            keyboardType: TextInputType.number,
          ),
          _buildDropdownField(
            'Agama',
            ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'],
            _selectedAgama,
            (val) => setState(() => _selectedAgama = val),
          ),
          _buildDropdownField(
            'Status Perkawinan',
            ['Belum Menikah', 'Menikah', 'Cerai'],
            _selectedStatusPerkawinan,
            (val) => setState(() => _selectedStatusPerkawinan = val),
          ),
          _buildTextField('Informasi Disabilitas', _disabilitasController),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoSection(UserProfile profile) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Akademik', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField(
            'Universitas / Institusi',
            _univController,
            readOnly: true,
          ),
          _buildTextField('Bidang / Jurusan', _bidangController),
          Row(
            children: [
              Expanded(child: _buildTextField('NIM', _nimController)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'IPK',
                  _ipkController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Keahlian', style: AppTextStyles.headlineSmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Max 5',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._skills.map(
                (skill) => Chip(
                  label: Text(
                    skill,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.primary,
                  deleteIconColor: Colors.white,
                  onDeleted: () {
                    setState(() {
                      _skills.remove(skill);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
              ActionChip(
                label: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.primary,
                ),
                backgroundColor: AppColors.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.transparent),
                ),
                onPressed: () {
                  _showAddSkillDialog();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Keahlian'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Contoh: Flutter, UI/UX, Python',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty && _skills.length < 5) {
                setState(() {
                  _skills.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pengalaman', style: AppTextStyles.headlineSmall),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                ),
                onPressed: () => _showExperienceBottomSheet(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_experiences.isEmpty)
            Text(
              'Belum ada pengalaman ditambahkan.',
              style: AppTextStyles.bodySmall,
            )
          else
            ..._experiences.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.title, style: AppTextStyles.labelLarge),
                          Text(exp.company, style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(
                            exp.date,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      onPressed: () =>
                          _showExperienceBottomSheet(editIndex: index),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Pengalaman?'),
                            content: const Text(
                              'Apakah Anda yakin ingin menghapus pengalaman ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _experiences.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showExperienceBottomSheet({int? editIndex}) {
    final isEdit = editIndex != null;
    final existing = isEdit ? _experiences[editIndex] : null;

    final titleController = TextEditingController(text: existing?.title ?? '');
    final companyController = TextEditingController(
      text: existing?.company ?? '',
    );
    final dateController = TextEditingController(text: existing?.date ?? '');
    final descController = TextEditingController(
      text: existing?.description ?? '',
    );
    bool isActive = existing?.isActive ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 32,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isEdit ? 'Edit Pengalaman' : 'Tambah Pengalaman',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  _buildSheetTextField('Posisi/Jabatan', titleController),
                  const SizedBox(height: 16),
                  _buildSheetTextField('Perusahaan', companyController),
                  const SizedBox(height: 16),
                  _buildSheetTextField(
                    'Periode (Mth YYYY - Mth YYYY)',
                    dateController,
                  ),
                  const SizedBox(height: 16),
                  _buildSheetTextField(
                    'Deskripsi',
                    descController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: isActive,
                        onChanged: (val) {
                          setStateSheet(() => isActive = val ?? false);
                        },
                        activeColor: AppColors.primary,
                      ),
                      Text(
                        'Masih bekerja disini',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            companyController.text.isNotEmpty) {
                          final newExp = Experience(
                            title: titleController.text,
                            company: companyController.text,
                            date: dateController.text,
                            description: descController.text,
                            isActive: isActive,
                          );
                          setState(() {
                            if (isEdit) {
                              _experiences[editIndex] = newExp;
                            } else {
                              _experiences.add(newExp);
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Simpan' : 'Tambah',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pendidikan', style: AppTextStyles.headlineSmall),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                ),
                onPressed: () => _showEducationBottomSheet(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            'Pendidikan Tertinggi',
            ['SMA/SMK', 'D1', 'D2', 'D3', 'D4', 'S1', 'S2', 'S3'],
            _selectedPendidikan,
            (val) => setState(() => _selectedPendidikan = val),
          ),
          const SizedBox(height: 8),
          if (_education.isEmpty)
            Text(
              'Belum ada riwayat pendidikan ditambahkan.',
              style: AppTextStyles.bodySmall,
            )
          else
            ..._education.asMap().entries.map((entry) {
              final index = entry.key;
              final edu = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            edu.institution,
                            style: AppTextStyles.labelLarge,
                          ),
                          Text(edu.degree, style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(
                            edu.period,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 10,
                            ),
                          ),
                          if (edu.location.isNotEmpty)
                            Text(
                              edu.location,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      onPressed: () =>
                          _showEducationBottomSheet(editIndex: index),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Pendidikan?'),
                            content: const Text(
                              'Apakah Anda yakin ingin menghapus riwayat pendidikan ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _education.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showEducationBottomSheet({int? editIndex}) {
    final isEdit = editIndex != null;
    final existing = isEdit ? _education[editIndex] : null;

    final institutionController = TextEditingController(
      text: existing?.institution ?? '',
    );
    final degreeController = TextEditingController(
      text: existing?.degree ?? '',
    );
    final periodController = TextEditingController(
      text: existing?.period ?? '',
    );
    final locationController = TextEditingController(
      text: existing?.location ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEdit ? 'Edit Pendidikan' : 'Tambah Pendidikan',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 24),
                _buildSheetTextField('Institusi', institutionController),
                const SizedBox(height: 16),
                _buildSheetTextField(
                  'Gelar/Jenjang (contoh: S1 Teknik Informatika)',
                  degreeController,
                ),
                const SizedBox(height: 16),
                _buildSheetTextField(
                  'Periode (Mth YYYY - Mth YYYY)',
                  periodController,
                ),
                const SizedBox(height: 16),
                _buildSheetTextField('Lokasi', locationController),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (institutionController.text.isNotEmpty &&
                          degreeController.text.isNotEmpty) {
                        final newEdu = Education(
                          institution: institutionController.text,
                          degree: degreeController.text,
                          period: periodController.text,
                          location: locationController.text,
                        );
                        setState(() {
                          if (isEdit) {
                            _education[editIndex] = newEdu;
                          } else {
                            _education.add(newEdu);
                          }
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isEdit ? 'Simpan' : 'Tambah',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Styled text field for use inside bottom sheets
  Widget _buildSheetTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    helperText,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            style: AppTextStyles.bodyMedium,
            icon: const Icon(
              Icons.expand_more,
              color: AppColors.onSurfaceVariant,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(24),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              child: Text(
                _selectedTanggalLahir == null
                    ? 'Pilih Tanggal'
                    : _selectedTanggalLahir!.toIso8601String().split('T').first,
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
