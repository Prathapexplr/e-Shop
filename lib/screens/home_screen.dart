// ignore_for_file: unused_local_variable

import 'package:eshop/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/remote_config_provider.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final remoteConfigProvider = Provider.of<RemoteConfigProvider>(context, listen: false);
      
      await Future.wait([
        productProvider.fetchProducts(),
        remoteConfigProvider.fetchRemoteConfig(),
      ]);

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error fetching data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final remoteConfigProvider = Provider.of<RemoteConfigProvider>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColors.lightGrey,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        leadingWidth: 100,
        leading: Row(
          children: [
            SizedBox(
              width: width / 15,
            ),
            Text(
              "e-Shop",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _hasError
              ? Center(
                  child: Text(
                    _errorMessage ?? 'An unexpected error occurred.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: productProvider.products.length,
                  itemBuilder: (ctx, i) => ProductItem(
                    product: productProvider.products[i],
                    showDiscountedPrice: remoteConfigProvider.showDiscountedPrice,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 5.6,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                ),
    );
  }
}
