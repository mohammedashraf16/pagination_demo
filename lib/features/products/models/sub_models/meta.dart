import 'package:equatable/equatable.dart';

class Meta extends Equatable {
  const Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? barcode;
  final String? qrCode;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      barcode: json["barcode"],
      qrCode: json["qrCode"],
    );
  }

  @override
  List<Object?> get props => [createdAt, updatedAt, barcode, qrCode];
}
