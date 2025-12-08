part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductScuccess extends ProductState {
  final List<Product> product;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ProductScuccess({
    required this.product,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });
}

final class ProductFailure extends ProductState {
  final String errorMessage;

  const ProductFailure({required this.errorMessage});
}

final class ProductNoNetwork extends ProductState {}
