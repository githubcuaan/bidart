enum SkillLevel {
  kI(rank: 1, code: 'K/I', displayName: 'Nhập môn', description: 'Người mới bắt đầu, chưa quen với bàn bida.'),
  h(rank: 2, code: 'H', displayName: 'Sơ cấp yếu', description: 'Biết cầm cơ nhưng kỹ thuật còn yếu.'),
  g(rank: 3, code: 'G', displayName: 'Phong trào phổ thông', description: 'Chơi được ở mức phong trào, biết cơ bản.'),
  f(rank: 4, code: 'F', displayName: 'Phong trào khá', description: 'Chơi khá, có thể tham gia giải phong trào.'),
  e(rank: 5, code: 'E', displayName: 'Bán chuyên sơ cấp', description: 'Trình độ bán chuyên, kỹ thuật ổn định.'),
  d(rank: 6, code: 'D', displayName: 'Tay cơ cứng', description: 'Tay cơ cứng, có kinh nghiệm thi đấu.'),
  c(rank: 7, code: 'C', displayName: 'Trình độ xuất sắc', description: 'Trình độ xuất sắc, thi đấu tốt.'),
  b(rank: 8, code: 'B', displayName: 'Bán chuyên cao cấp', description: 'Bán chuyên cao cấp,接近 chuyên nghiệp.'),
  a(rank: 9, code: 'A', displayName: 'Chuyên nghiệp', description: 'Trình độ chuyên nghiệp, thi đấu cấp quốc gia/quốc tế.');

  const SkillLevel({
    required this.rank,
    required this.code,
    required this.displayName,
    required this.description,
  });

  final int rank;
  final String code;
  final String displayName;
  final String description;

  bool isHigherThan(SkillLevel other) => rank > other.rank;

  int rankDistance(SkillLevel other) => (rank - other.rank).abs();
}
