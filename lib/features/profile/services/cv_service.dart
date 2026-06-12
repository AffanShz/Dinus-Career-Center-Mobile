import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/profile_model.dart';

enum CVTemplateType { modern, classic, professional }

class CVService {
  Future<Uint8List> generateCV(UserProfile profile, CVTemplateType template) async {
    final pdf = pw.Document();

    switch (template) {
      case CVTemplateType.modern:
        _addModernTemplate(pdf, profile);
        break;
      case CVTemplateType.classic:
        _addClassicTemplate(pdf, profile);
        break;
      case CVTemplateType.professional:
        _addProfessionalTemplate(pdf, profile);
        break;
    }

    return pdf.save();
  }

  void _addModernTemplate(pw.Document pdf, UserProfile profile) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column (Contact & Skills)
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(profile.name,
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text(profile.bidang ?? '',
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 24),
                    _buildModernSectionTitle('KONTAK'),
                    pw.Text(profile.email, style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(profile.noHandphone ?? '', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(profile.alamat ?? '', style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 24),
                    _buildModernSectionTitle('KEAHLIAN'),
                    ...profile.skills.map((skill) => pw.Bullet(text: skill, style: const pw.TextStyle(fontSize: 10))),
                  ],
                ),
              ),
              pw.SizedBox(width: 32),
              // Right Column (Experience & Education)
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildModernSectionTitle('PENGALAMAN'),
                    ...profile.experiences.map((exp) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(exp.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                            pw.Text(exp.company, style: const pw.TextStyle(fontSize: 10)),
                            pw.Text(exp.date, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
                            pw.Text(exp.description, style: const pw.TextStyle(fontSize: 10)),
                            pw.SizedBox(height: 12),
                          ],
                        )),
                    pw.SizedBox(height: 24),
                    _buildModernSectionTitle('PENDIDIKAN'),
                    ...profile.education.map((edu) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                            pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
                            pw.Text(edu.period, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
                            pw.SizedBox(height: 8),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildModernSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: PdfColors.blueAccent700)),
        pw.Divider(color: PdfColors.blueAccent700, thickness: 1),
        pw.SizedBox(height: 8),
      ],
    );
  }

  void _addClassicTemplate(pw.Document pdf, UserProfile profile) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(48),
        build: (context) => [
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(profile.name.toUpperCase(),
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('${profile.email} | ${profile.noHandphone} | ${profile.kota}',
                    style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
          pw.SizedBox(height: 24),
          _buildClassicSection('PENDIDIKAN'),
          ...profile.education.map((edu) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Text(edu.period, style: const pw.TextStyle(fontSize: 10)),
            ],
          )),
          pw.SizedBox(height: 16),
          _buildClassicSection('PENGALAMAN'),
          ...profile.experiences.map((exp) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(exp.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(exp.date, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Text(exp.company, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10)),
              pw.Bullet(text: exp.description, style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 8),
            ],
          )),
          pw.SizedBox(height: 16),
          _buildClassicSection('KEAHLIAN'),
          pw.Text(profile.skills.join(', '), style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildClassicSection(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.Divider(thickness: 1),
        pw.SizedBox(height: 8),
      ],
    );
  }

  void _addProfessionalTemplate(pw.Document pdf, UserProfile profile) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Row(
            children: [
              // Sidebar
              pw.Container(
                width: 200,
                color: PdfColors.blueGrey900,
                padding: const pw.EdgeInsets.all(24),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(profile.name, style: pw.TextStyle(color: PdfColors.white, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text(profile.bidang ?? '', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                    pw.SizedBox(height: 32),
                    pw.Text('KONTAK', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.SizedBox(height: 8),
                    pw.Text(profile.email, style: pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                    pw.Text(profile.noHandphone ?? '', style: pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                    pw.SizedBox(height: 32),
                    pw.Text('KEAHLIAN', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.SizedBox(height: 8),
                    ...profile.skills.map((skill) => pw.Text(skill, style: pw.TextStyle(color: PdfColors.white, fontSize: 9))),
                  ],
                ),
              ),
              // Main Content
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(32),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('PROFIL PROFESIONAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      pw.SizedBox(height: 8),
                      pw.Text('Lulusan ${profile.pendidikanTertinggi ?? ''} dengan fokus pada ${profile.bidang ?? ''}. Memiliki IPK ${profile.ipk ?? '0.0'}.', style: const pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 24),
                      pw.Text('PENGALAMAN KERJA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      pw.SizedBox(height: 8),
                      ...profile.experiences.map((exp) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(exp.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                          pw.Text(exp.company, style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(exp.date, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                          pw.SizedBox(height: 4),
                          pw.Text(exp.description, style: const pw.TextStyle(fontSize: 10)),
                          pw.SizedBox(height: 12),
                        ],
                      )),
                      pw.SizedBox(height: 24),
                      pw.Text('RIWAYAT PENDIDIKAN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      pw.SizedBox(height: 8),
                      ...profile.education.map((edu) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(edu.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                          pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(edu.period, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                          pw.SizedBox(height: 8),
                        ],
                      )),
                    ],
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
