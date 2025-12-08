import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pagination_demo/features/products/models/product_model.dart';

class ApiService {
  final Dio dio = Dio();
  final String baseUrl = 'https://dummyjson.com/products';
  Future<ProductModel> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final Map<String, dynamic> parameters = {'limit': limit, 'skip': skip};
    final bool isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      throw Exception('No internet connection. Please check your network.');
    }

    try {
      final response = await dio.get(baseUrl, queryParameters: parameters);
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
