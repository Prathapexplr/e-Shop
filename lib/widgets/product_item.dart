// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final bool showDiscountedPrice;

  const ProductItem(
      {super.key, required this.product, required this.showDiscountedPrice});

  @override
  Widget build(BuildContext context) {
    final price = showDiscountedPrice ? product.discountedPrice : product.price;
    final oldPrice = showDiscountedPrice ? product.price : null;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: height / 80),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height / 80),
                Text(
                  product.description,
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 95, 95, 95),
                  ),
                ),
                SizedBox(height: height / 80),
                Row(
                  children: [
                    if (oldPrice != null)
                      Text(
                        '\$${oldPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(width: 5),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 102, 103, 102),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    if (showDiscountedPrice)
                      Text(
                        '${product.discountPercentage}% off',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
