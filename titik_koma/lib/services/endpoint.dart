class Endpoint {
  static String baseUrl = 'http://192.168.137.26:8000/api';

  static String authLogin = '$baseUrl/login';

  // URL USER
  static String login = '$baseUrl/login';
  static String resetPassword = '$baseUrl/reset-password';

  // URL MENU
  static String getMenu = '$baseUrl/menu';

  // URL ORDER MENU
  static String getOrderMenu = '$baseUrl/order-menu';
  static String getProsesPesanan = '$baseUrl/pesan';
  static String getSelesaikanPesanan = '$baseUrl/selesaikan-pesanan';

  // URL ORDER MENU DETAIL
  static String getOrderMenuDetail = '$baseUrl/order-menu-detail';

  // URL JENIS MENU
  static String getJenisMenu = '$baseUrl/jenis-menu';
}
