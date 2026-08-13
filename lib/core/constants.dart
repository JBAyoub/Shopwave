class AppConstants {
  AppConstants._();
  // static final baseURL = "https://api.shopwave.com"; //prod
  static final baseURL = 'http://10.0.2.2:8082'; //dev
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String tokenKey = "auth_token";
  static const String userIdKey = "user_id";
  static const String loginRoute = "/login";
  static const String logoutRoute = "/logout";
  static const String homeRoute = "/home";
  static const String productsRoute = "/products";
  static const String productRoute = "/products";
  static const String orderRoute = "/orders";
  static const String profileRoute = "/profile";
}
