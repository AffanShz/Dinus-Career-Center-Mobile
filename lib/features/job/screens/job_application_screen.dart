import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/job_application_service.dart';

class JobApplicationScreen extends StatefulWidget {
  final String lowonganId;

  const JobApplicationScreen({Key? key, required this.lowonganId})
      : super(key: key);

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  final JobApplicationService _service = JobApplicationService();

  File? _pasFoto;
  File? _cv;
  File? _portofolioFile;
  String? _portofolioLink;
  File? _transkripNilai;
  File? _suratLamaran;
  
  final TextEditingController _linkController = TextEditingController();
  bool _isLoading = false;
  bool _isPortfolioLink = false;

  Future<void> _pickFile(Function(File?) onPicked, {List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          onPicked(File(result.files.single.path!));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _submitApplication() async {
    if (_cv == null || _pasFoto == null || _transkripNilai == null || _suratLamaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua berkas wajib')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await _service.submitApplication(
      lowonganId: widget.lowonganId,
      pasFoto: _pasFoto,
      cv: _cv,
      portofolioFile: _isPortfolioLink ? null : _portofolioFile,
      portofolioLink: _isPortfolioLink ? _linkController.text : null,
      transkipNilai: _transkripNilai,
      suratLamaran: _suratLamaran,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lamaran berhasil dikirim')),
      );
      Navigator.pop(context, true); // Go back with success result
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim lamaran. Pastikan profil lengkap atau periksa koneksi Anda.')),
      );
    }
  }

  String _getFileSize(File file) {
    int bytes = file.lengthSync();
    if (bytes <= 0) return "0 B";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2C6D3).withOpacity(0.15), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _buildDashedUploadArea({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    File? currentFile,
    VoidCallback? onRemove,
  }) {
    if (currentFile != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC2C6D3), width: 2, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF00519E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.description, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentFile.path.split('/').last,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF001B3D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getFileSize(currentFile),
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF424751),
                    ),
                  ),
                ],
              ),
            ),
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF727782)),
                onPressed: onRemove,
              ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC2C6D3), width: 2), // Simulate dashed by using a lighter border or dashed package. Standard border here.
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF727782)),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF191C1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF424751),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB).withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF191C1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lamaran',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: const Color(0xFF001B3D),
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lengkapi berkas lamaran Anda di bawah ini. Pastikan file yang diunggah sesuai dengan ketentuan.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: const Color(0xFF424751),
                  ),
                ),
                const SizedBox(height: 24),

                // Pas Foto
                Row(
                  children: [
                    Text(
                      'Pas Foto',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF001B3D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E8EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Wajib', style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF424751))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGlassCard(
                  child: InkWell(
                    onTap: () => _pickFile((f) => _pasFoto = f, allowedExtensions: ['jpg', 'jpeg', 'png']),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFC2C6D3), width: 2),
                      ),
                      child: Column(
                        children: [
                          if (_pasFoto != null)
                            ClipRVM(
                              radius: BorderRadius.circular(32),
                              child: Image.file(_pasFoto!, width: 64, height: 64, fit: BoxFit.cover),
                            )
                          else
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0E3E5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, color: Color(0xFF727782), size: 32),
                            ),
                          const SizedBox(height: 12),
                          Text(
                            _pasFoto != null ? 'Ubah Foto' : 'Unggah Foto',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xFF003A75),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Format JPG/PNG, maks 2MB',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: const Color(0xFF424751),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // CV
                Row(
                  children: [
                    Text(
                      'CV',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF001B3D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E8EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Wajib', style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF424751))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGlassCard(
                  child: _buildDashedUploadArea(
                    icon: Icons.description_outlined,
                    title: 'Unggah CV',
                    subtitle: 'PDF maks 5MB',
                    currentFile: _cv,
                    onTap: () => _pickFile((f) => _cv = f, allowedExtensions: ['pdf']),
                    onRemove: () => setState(() => _cv = null),
                  ),
                ),
                const SizedBox(height: 24),

                // Portofolio
                Row(
                  children: [
                    Text(
                      'Portofolio',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF001B3D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Opsional', style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF424751))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _isPortfolioLink = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: !_isPortfolioLink ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: !_isPortfolioLink
                                          ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Upload File',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: !_isPortfolioLink ? const Color(0xFF003A75) : const Color(0xFF424751),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _isPortfolioLink = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isPortfolioLink ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: _isPortfolioLink
                                          ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tautan / Link',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _isPortfolioLink ? const Color(0xFF003A75) : const Color(0xFF424751),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (!_isPortfolioLink)
                          _buildDashedUploadArea(
                            icon: Icons.cloud_upload_outlined,
                            title: 'Unggah Portofolio',
                            subtitle: 'PDF maks 10MB',
                            currentFile: _portofolioFile,
                            onTap: () => _pickFile((f) => _portofolioFile = f, allowedExtensions: ['pdf']),
                            onRemove: () => setState(() => _portofolioFile = null),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _linkController,
                              style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFF191C1E)),
                              decoration: InputDecoration(
                                hintText: 'Masukkan URL portofolio (mis. Behance, Dribbble)',
                                hintStyle: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: const Color(0xFF424751).withOpacity(0.5),
                                ),
                                prefixIcon: const Icon(Icons.link, color: Color(0xFF727782)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: const Color(0xFFC2C6D3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFF003A75)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Transkrip Nilai
                Row(
                  children: [
                    Text(
                      'Transkrip Nilai',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF001B3D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E8EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Wajib', style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF424751))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGlassCard(
                  child: _buildDashedUploadArea(
                    icon: Icons.upload_file_outlined,
                    title: 'Pilih File Transkrip',
                    subtitle: 'PDF maks 5MB',
                    currentFile: _transkripNilai,
                    onTap: () => _pickFile((f) => _transkripNilai = f, allowedExtensions: ['pdf']),
                    onRemove: () => setState(() => _transkripNilai = null),
                  ),
                ),
                const SizedBox(height: 24),

                // Surat Lamaran
                Row(
                  children: [
                    Text(
                      'Surat Lamaran',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF001B3D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E8EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Wajib', style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF424751))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildGlassCard(
                  child: _buildDashedUploadArea(
                    icon: Icons.mark_email_read_outlined,
                    title: 'Unggah Surat Lamaran',
                    subtitle: 'PDF maks 5MB',
                    currentFile: _suratLamaran,
                    onTap: () => _pickFile((f) => _suratLamaran = f, allowedExtensions: ['pdf']),
                    onRemove: () => setState(() => _suratLamaran = null),
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Button Action
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFF7F9FB),
                    const Color(0xFFF7F9FB).withOpacity(0.9),
                    const Color(0xFFF7F9FB).withOpacity(0.0),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF003A75).withOpacity(0.2),
                  backgroundColor: Colors.transparent, // to use gradient via Ink
                ).copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF003A75), Color(0xFF4C56AF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    height: 56, // Match HTML button height
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Kirim Lamaran',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.send, color: Colors.white, size: 20),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClipRVM extends StatelessWidget {
  final BorderRadius radius;
  final Widget child;
  const ClipRVM({Key? key, required this.radius, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: child,
    );
  }
}
