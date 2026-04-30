import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Data Diri', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informasi Pribadi'),
              _buildTextField('Nama Lengkap', _nameController),
              _buildTextField('No KTP', _noKtpController, keyboardType: TextInputType.number),
              Row(
                children: [
                  Expanded(child: _buildTextField('Tempat Lahir', _tempatLahirController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Tanggal Lahir')),
                ],
              ),
              _buildDropdownField('Jenis Kelamin', ['Laki-laki', 'Perempuan'], _selectedJenisKelamin, (val) => setState(() => _selectedJenisKelamin = val)),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Kontak'),
              _buildTextField('Alamat', _alamatController, maxLines: 3),
              Row(
                children: [
                  Expanded(child: _buildTextField('Kota', _kotaController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Kode Pos', _kodePosController, keyboardType: TextInputType.number)),
                ],
              ),
              _buildTextField('No Handphone', _noHandphoneController, keyboardType: TextInputType.phone),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Pendidikan & Lainnya'),
              _buildTextField('NIM', _nimController),
              _buildTextField('IPK', _ipkController, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _buildTextField('Bidang/Jurusan', _bidangController),
              _buildDropdownField('Pendidikan Tertinggi', ['SMA', 'D3', 'S1', 'S2', 'S3'], _selectedPendidikan, (val) => setState(() => _selectedPendidikan = val)),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
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
                    );
                    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Simpan Perubahan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            _selectedTanggalLahir == null ? 'Pilih Tanggal' : _selectedTanggalLahir!.toIso8601String().split('T')[0],
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

