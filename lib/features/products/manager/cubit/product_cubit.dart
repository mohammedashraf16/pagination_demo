import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pagination_demo/features/apis/api_service.dart';
import 'package:pagination_demo/features/products/models/sub_models/products.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  late final StreamSubscription<List<ConnectivityResult>>
  connectivitySubscription;
  ProductCubit() : super(ProductInitial()) {
    monitorInternetConnection();
  }
  final apiService = ApiService();
  final int limit = 10;
  int skip = 0;
  List<Product> products = [];

  void monitorInternetConnection() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final isConnected =
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);

      if (isConnected &&
          (state is ProductNoNetwork || state is ProductInitial)) {
        getProducts();
      }
    });
  }

  Future<void> getProducts({bool isLoadMore = false}) async {
    final bool hasInternet = await InternetConnection().hasInternetAccess;
    if (!hasInternet) {
      emit(ProductNoNetwork());
      return;
    }
    if (!isLoadMore) {
      skip = 0;
      products.clear();
      emit(ProductLoading());
    } else {
      emit(ProductScuccess(product: products, isLoadingMore: true));
    }
    try {
      final response = await apiService.fetchProducts(limit: limit, skip: skip);
      if (response.products.isNotEmpty) {
        products.addAll(response.products);
        skip += limit;
        emit(ProductLoading());
      }
      final hasReachedMax =
          response.products.isEmpty || response.products.length < limit;
      emit(
        ProductScuccess(
          product: products,
          isLoadingMore: false,
          hasReachedMax: hasReachedMax,
        ),
      );
    } catch (e) {
      emit(ProductFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    connectivitySubscription.cancel();
    return super.close();
  }
}
