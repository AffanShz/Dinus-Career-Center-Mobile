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

  /// Faculty code → letter, keyed by the numeric prefix used in the email
  /// username. The conversion follows alphabet position (A=1, B=2, … G=7),
  /// except Pascasarjana which uses P=16 — a TWO-digit prefix. So keys here may
  /// be one or two characters; the parser tries the longer prefix first.
  static const Map<String, String> _facultyCodeToLetter = {
    '1': 'A',
    '2': 'B',
    '3': 'C',
    '4': 'D',
    '5': 'E',
    '6': 'F',
    '7': 'G',
    '16': 'P',
  };

  static Map<String, String?> parse(String email) {
    if (!email.endsWith('@mhs.dinus.ac.id')) {
      return {'nim': null, 'bidang': null};
    }

    final localPart = email.split('@')[0];

    // Expected username layout (digits only):
    //   <faculty><program(2)><year(4)><sequence>
    // The faculty prefix is normally 1 digit (A=1 … G=7) but Pascasarjana
    // uses P=16, a 2-digit prefix. Examples:
    //   S1: 111202301234 -> 1 |11|2023|01234 -> A11.2023.01234
    //   S2: 1632202301111 -> 16|32|2023|01111 -> P32.2023.01111
    // So a valid username has at least 1 (or 2) + 2 + 4 + 1 = 8+ digits.
    if (localPart.length < 8 || int.tryParse(localPart) == null) {
      return {'nim': null, 'bidang': null};
    }

    // The faculty prefix is normally 1 digit but Pascasarjana uses P=16 (2
    // digits), so '16...' must not be mis-read as '1' (FIK) + '6...'. We make
    // two passes over the candidate prefix lengths [2, 1]:
    //   Pass 1 accepts only a split that yields a KNOWN program — this resolves
    //          the 2-digit-vs-1-digit ambiguity in favour of the real prodi.
    //   Pass 2 accepts the first structurally valid faculty prefix even if the
    //          program is unmapped (e.g. D22), preserving best-effort parsing.
    for (final requireKnownProdi in [true, false]) {
      for (final prefixLength in [2, 1]) {
        if (localPart.length < prefixLength + 6) continue;

        final facultyCode = localPart.substring(0, prefixLength);
        final letter = _facultyCodeToLetter[facultyCode];
        if (letter == null) continue;

        final programDigits =
            localPart.substring(prefixLength, prefixLength + 2);
        final yearDigits =
            localPart.substring(prefixLength + 2, prefixLength + 6);
        final sequenceDigits = localPart.substring(prefixLength + 6);

        final prodiCode = '$letter$programDigits';
        final bidang = _prodiMap[prodiCode];
        if (requireKnownProdi && bidang == null) continue;

        final nim = '$prodiCode.$yearDigits.$sequenceDigits';
        return {'nim': nim, 'bidang': bidang};
      }
    }

    return {'nim': null, 'bidang': null};
  }
}
