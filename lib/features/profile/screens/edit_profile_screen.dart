import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  String? _selectedJenisKelamin;
  String? _selectedStatusPerkawinan;
  String? _selectedAgama;
  String? _selectedPendidikan;
  DateTime? _selectedTanggalLahir;

  // Mock data for Skills/Keahlian and Experience
  List<String> _skills = [];
  List<Experience> _experiences = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _tempatLahirController = TextEditingController(text: widget.profile.tempatLahir);
    _noKtpController = TextEditingController(text: widget.profile.noKtp);
    _alamatController = TextEditingController(text: widget.profile.alamat);
    _kotaController = TextEditingController(text: widget.profile.kota);
    _kodePosController = TextEditingController(text: widget.profile.kodePos);
    _noTeleponController = TextEditingController(text: widget.profile.noTelepon);
    _noHandphoneController = TextEditingController(text: widget.profile.noHandphone);
    _kewarganegaraanController = TextEditingController(text: widget.profile.kewarganegaraan);
    _nimController = TextEditingController(text: widget.profile.nim);
    _ipkController = TextEditingController(text: widget.profile.ipk);
    _bidangController = TextEditingController(text: widget.profile.bidang);
    _disabilitasController = TextEditingController(text: widget.profile.disabilitas);

    _selectedJenisKelamin = widget.profile.jenisKelamin;
    _selectedStatusPerkawinan = widget.profile.statusPerkawinan;
    _selectedAgama = widget.profile.agama;
    _selectedPendidikan = widget.profile.pendidikanTertinggi;
    
    if (widget.profile.tanggalLahir != null) {
      _selectedTanggalLahir = DateTime.tryParse(widget.profile.tanggalLahir!);
    }

    _skills = List.from(widget.profile.skills);
    if (_skills.isEmpty) {
      _skills = ['Frontend Developer', 'UI/UX Designer']; // Default for demo
    }
    _experiences = List.from(widget.profile.experiences);
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

  void _saveProfile() {
    final updatedProfile = UserProfile(
      id: widget.profile.id,
      email: widget.profile.email,
      name: _nameController.text,
      photoUrl: widget.profile.photoUrl,
      tempatLahir: _tempatLahirController.text,
      tanggalLahir: _selectedTanggalLahir?.toIso8601String().split('T')[0],
      noKtp: _noKtpController.text,
      jenisKelamin: _selectedJenisKelamin,
      alamat: _alamatController.text,
      kota: _kotaController.text,
      kodePos: _kodePosController.text,
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
    );
    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text('Edit Profil', style: AppTextStyles.headlineMedium.copyWith(fontSize: 18)),
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
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui profil')));
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfilePhotoSection(),
                  const SizedBox(height: 24),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildContactInfoSection(),
                  const SizedBox(height: 24),
                  _buildPersonalDetailsSection(),
                  const SizedBox(height: 24),
                  _buildAcademicInfoSection(),
                  const SizedBox(height: 24),
                  _buildSkillsSection(),
                  const SizedBox(height: 24),
                  _buildExperienceSection(),
                ],
              ),
            ),
            // Sticky Bottom Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      blurRadius: 32,
                      offset: const Offset(0, -8),
                    ),
                  ],
                  border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.1))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.4), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Batal', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
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
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Simpan', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15), width: 1.5),
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

  Widget _buildProfilePhotoSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Foto Profil', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceContainerLowest, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: (widget.profile.photoUrl != null && widget.profile.photoUrl!.isNotEmpty)
                      ? Image.network(widget.profile.photoUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Image.asset('assets/images/dcc.png'))
                      : Image.asset('assets/images/dcc.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerLow,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Ubah Foto', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: AppColors.error, padding: EdgeInsets.zero, minimumSize: const Size(0, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('Hapus Foto', style: AppTextStyles.labelSmall.copyWith(color: AppColors.error)),
                    ),
                    const SizedBox(height: 4),
                    Text('Rekomendasi: Kotak, min 500x500px, bawah 2MB.', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Dasar', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField('Nama Lengkap', _nameController),
          _buildTextField('Email', TextEditingController(text: widget.profile.email), readOnly: true, helperText: 'Email tidak dapat diubah'),
          Row(
            children: [
              Expanded(child: _buildTextField('Tempat Lahir', _tempatLahirController)),
              const SizedBox(width: 16),
              Expanded(child: _buildDatePicker('Tanggal Lahir')),
            ],
          ),
          _buildDropdownField('Jenis Kelamin', ['Laki-laki', 'Perempuan'], _selectedJenisKelamin, (val) => setState(() => _selectedJenisKelamin = val)),
          _buildTextField('Kewarganegaraan', _kewarganegaraanController),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
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
              Expanded(child: _buildTextField('Kode Pos', _kodePosController, keyboardType: TextInputType.number)),
            ],
          ),
          _buildTextField('Telepon Rumah', _noTeleponController, keyboardType: TextInputType.phone),
          _buildTextField('Nomor Handphone', _noHandphoneController, keyboardType: TextInputType.phone),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Pribadi', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField('No KTP (NIK)', _noKtpController, keyboardType: TextInputType.number),
          Row(
            children: [
              Expanded(child: _buildDropdownField('Agama', ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'], _selectedAgama, (val) => setState(() => _selectedAgama = val))),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdownField('Status Perkawinan', ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati'], _selectedStatusPerkawinan, (val) => setState(() => _selectedStatusPerkawinan = val))),
            ],
          ),
          _buildTextField('Informasi Disabilitas', _disabilitasController),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Akademik', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 24),
          _buildTextField('Universitas / Institusi', TextEditingController(text: 'Universitas Dian Nuswantoro'), readOnly: true),
          _buildTextField('Bidang / Jurusan', _bidangController),
          Row(
            children: [
              Expanded(child: _buildTextField('NIM', _nimController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('IPK', _ipkController, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
            ],
          ),
          _buildDropdownField('Pendidikan Tertinggi', ['SMA', 'D3', 'D4', 'S1', 'S2', 'S3'], _selectedPendidikan, (val) => setState(() => _selectedPendidikan = val)),
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
                decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                child: Text('Max 5', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._skills.map((skill) => Chip(
                    label: Text(skill, style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                    backgroundColor: AppColors.primary,
                    deleteIconColor: Colors.white,
                    onDeleted: () {
                      setState(() {
                        _skills.remove(skill);
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.transparent)),
                  )),
              ActionChip(
                label: const Icon(Icons.add, size: 18, color: AppColors.primary),
                backgroundColor: AppColors.surfaceContainerHigh,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.transparent)),
                onPressed: () {
                  // Dialog to add skill
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
          decoration: const InputDecoration(hintText: 'Contoh: Flutter, UI/UX, Python'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
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
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                onPressed: _showAddExperienceDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_experiences.isEmpty)
            Text('Belum ada pengalaman ditambahkan.', style: AppTextStyles.bodySmall)
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
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
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
                          Text(exp.date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontSize: 10)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      onPressed: () {
                        setState(() {
                          _experiences.removeAt(index);
                        });
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

  void _showAddExperienceDialog() {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final dateController = TextEditingController();
    final descController = TextEditingController();
    bool isActive = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Tambah Pengalaman'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Posisi/Jabatan')),
                TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Perusahaan')),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Periode (Mth YYYY - Mth YYYY)')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 2),
                Row(
                  children: [
                    Checkbox(
                      value: isActive,
                      onChanged: (val) {
                        setStateDialog(() => isActive = val ?? false);
                      },
                    ),
                    const Text('Masih bekerja disini'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && companyController.text.isNotEmpty) {
                  setState(() {
                    _experiences.add(Experience(
                      title: titleController.text,
                      company: companyController.text,
                      date: dateController.text,
                      description: descController.text,
                      isActive: isActive,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1, bool readOnly = false, String? helperText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 12, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(helperText, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
          ),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: AppTextStyles.bodyMedium))).toList(),
            onChanged: onChanged,
            style: AppTextStyles.bodyMedium,
            icon: const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
          ),
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(24),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              child: Text(
                _selectedTanggalLahir == null ? 'Pilih Tanggal' : _selectedTanggalLahir!.toIso8601String().split('T')[0],
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
