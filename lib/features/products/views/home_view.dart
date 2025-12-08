import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_demo/features/products/manager/cubit/product_cubit.dart';
import 'package:pagination_demo/features/products/views/widgets/product_card_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..getProducts(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("All Products", style: TextStyle(fontSize: 22)),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductFailure) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            } else if (state is ProductNoNetwork) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.signal_wifi_off, color: Colors.red, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'No Internet Connection\nPlease check your network',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final products = state is ProductScuccess ? state.product : [];
            final hasReachedMax =
                state is ProductScuccess && state.hasReachedMax;
            final isLoadingMore =
                state is ProductScuccess && state.isLoadingMore;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: NotificationListener(
                onNotification: (ScrollNotification scrollNotification) {
                  if (scrollNotification.metrics.pixels >=
                          scrollNotification.metrics.maxScrollExtent &&
                      !hasReachedMax &&
                      !isLoadingMore) {
                    context.read<ProductCubit>().getProducts(isLoadMore: true);
                  }
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: () => context.read<ProductCubit>().getProducts(),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.84,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = products[index];
                            return ProductCardItem(product: product);
                          }, childCount: products.length),
                        ),
                      ),
                      if (isLoadingMore && !hasReachedMax)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (hasReachedMax && products.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No More Data',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
