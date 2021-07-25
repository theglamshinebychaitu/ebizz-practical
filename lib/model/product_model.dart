
import 'package:meta/meta.dart';

class ProductModel {
  String productId;
  String productName;
  bool isLiked;
  bool isCart;

  ProductModel( {
    this.productId,
    this.productName,
    this.isLiked,
    this.isCart,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'isLiked': isLiked,
    'isCart' : isCart,
  };
}