class ApiConfig {
  static const String server = "http://10.38.231.186/pos/";
  static String get fetchStore => server + "api/store/fetch.php";
  static String get insertStore => server + "api/store/insert.php";
  static String get updateStore => server + "api/store/update.php";
  static String get deleteStore => server + "api/store/delete.php";
}
