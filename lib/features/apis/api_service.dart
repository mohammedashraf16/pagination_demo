import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pagination_demo/features/products/models/product_model.dart';

class ApiService {
  final dio = Dio();

  Future<ProductModel> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final String baseUrl = "https://dummyjson.com/products";
    Map<String, dynamic> queryParameters = {"limit": limit, "skip": skip};
    final isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      throw Exception("No Internet connection , please check your network");
    }
    try {
      final response = await dio.get(
        "https://dummyjson.com/products",
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception("products not found");
      }
    } on DioException catch (e) {
      throw Exception("Network Error : $e");
    } on Exception catch (e) {
      throw Exception("Error: $e");
    }
  }
}
