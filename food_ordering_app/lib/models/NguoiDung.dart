class NguoiDung {
  final int maNguoiDung;
  final String tenDangNhap;
  final String matKhau;
  final String hoTen;
  final String email;
  final String soDienThoai;
  final String diaChi;
  final DateTime ngayTao;

  const NguoiDung({
    required this.maNguoiDung,
    required this.tenDangNhap,
    required this.matKhau,
    required this.hoTen,
    required this.email,
    required this.soDienThoai,
    required this.diaChi,
    required this.ngayTao,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) => NguoiDung(
    maNguoiDung: json['maNguoiDung'],
    tenDangNhap: json['tenDangNhap'],
    matKhau: json['matKhau'],
    hoTen: json['hoTen'],
    email: json['email'],
    soDienThoai: json['soDienThoai'],
    diaChi: json['diaChi'],
    ngayTao: DateTime.parse(json['ngayTao']),
  );

  Map<String, dynamic> toJson() => {
    "maNguoiDung": maNguoiDung,
    "tenDangNhap": tenDangNhap,
    "matKhau": matKhau,
    "hoTen": hoTen,
    "email": email,
    "soDienThoai": soDienThoai,
    "diaChi": diaChi,
    "ngayTao": ngayTao.toIso8601String(),
  };
}
