import 'package:book_store/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addToCart(int productId, int quantity) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    http.Response response = await http.post(
      Uri.parse("$api/api/cart/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'item': productId.toString(),
        'quantity': quantity.toString(),
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> removeFromCart(int productId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    http.Response response = await http.post(
      Uri.parse("$api/api/remove-cart/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'product_id': productId.toString(),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addToWishlist(int productId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    http.Response response = await http.post(
      Uri.parse("$api/api/wishlist/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'item': productId.toString(),
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> removeFromWishlist(int productId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    http.Response response = await http.post(
      Uri.parse("$api/api/remove-wishlist/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'product_id': productId.toString(),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addToOrder(int productId, int quantity, double totalPrice) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    http.Response response = await http.post(
      Uri.parse("$api/api/orders/"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'item': productId.toString(),
        'quantity': quantity.toString(),
        'total_price': totalPrice.toString(),
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
