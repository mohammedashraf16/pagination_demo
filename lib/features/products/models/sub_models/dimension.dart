import 'package:equatable/equatable.dart';

class Dimensions extends Equatable {
  const Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  final num? width;
  final num? height;
  final num? depth;

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json["width"],
      height: json["height"],
      depth: json["depth"],
    );
  }

  @override
  List<Object?> get props => [width, height, depth];
}
