import 'package:equatable/equatable.dart';
import 'package:pagination_demo/features/products/models/sub_models/products.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Product> products;
  final int? total;
  final int? skip;
  final int? limit;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      products: json["products"] == null
          ? []
          : List<Product>.from(
              json["products"]!.map((x) => Product.fromJson(x)),
            ),
      total: json["total"],
      skip: json["skip"],
      limit: json["limit"],
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}
