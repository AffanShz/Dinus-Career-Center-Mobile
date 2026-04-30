class DinusEmailParser {
  static const Map<String, String> _prodiMap = {
    'A11': 'Teknik Informatika (S1)',
    'A12': 'Sistem Informasi (S1)',
    'A13': 'Teknik Komputer (S1)',
    'A14': 'Desain Komunikasi Visual (S1)',
    'A15': 'Penyiaran (D4)',
    'A16': 'Film dan Televisi (D4)',
    'A17': 'Animasi (D4)',
    'A22': 'Teknik Informatika (D3)',
    'A23': 'Manajemen Informatika (D3)',
    'P31': 'Magister Teknik Informatika (S2)',
    'B11': 'Manajemen (S1)',
    'B12': 'Akuntansi (S1)',
    'B21': 'Akuntansi (D3)',
    'B22': 'Manajemen Keuangan (D3)',
    'P32': 'Magister Manajemen (S2)',
    'P33': 'Magister Akuntansi (S2)',
    'C11': 'Bahasa Inggris (S1)',
    'C12': 'Sastra Jepang (S1)',
    'C21': 'Manajemen Perhotelan (D3)',
    'G11': 'Kesehatan Masyarakat (S1)',
    'G21': 'Rekam Medis dan Informasi Kesehatan (D3)',
    'G22': 'Kesehatan Lingkungan (D3)',
    'E11': 'Teknik Elektro (S1)',
    'E12': 'Teknik Industri (S1)',
    'E13': 'Teknik Biomedis (S1)',
  };

  static const Map<String, String> _facultyCodeToLetter = {
    '1': 'A',
    '2': 'B',
    '3': 'C',
    '5': 'E',
    '7': 'G',
    // P is typically not parsed this way, but included here based on standard faculty mapping
  };

  static Map<String, String?> parse(String email) {
    if (!email.endsWith('@mhs.dinus.ac.id')) {
      return {'nim': null, 'bidang': null};
    }

    final localPart = email.split('@')[0];
    
    // Expected local format (at least 12 digits): 111202412345
    // 1st digit: Faculty code (1 -> A)
    // 2nd-3rd digits: Program code (11)
    // 4th-7th digits: Year (2024)
    // 8th onwards: Sequence (12345)
    
    if (localPart.length >= 12 && int.tryParse(localPart) != null) {
      final facultyDigit = localPart.substring(0, 1);
      final programDigits = localPart.substring(1, 3);
      final yearDigits = localPart.substring(3, 7);
      final sequenceDigits = localPart.substring(7);

      final letter = _facultyCodeToLetter[facultyDigit];
      if (letter != null) {
        final prodiCode = '$letter$programDigits';
        final nim = '$prodiCode.$yearDigits.$sequenceDigits';
        final bidang = _prodiMap[prodiCode];

        return {'nim': nim, 'bidang': bidang};
      }
    }
    
    return {'nim': null, 'bidang': null};
  }
}
