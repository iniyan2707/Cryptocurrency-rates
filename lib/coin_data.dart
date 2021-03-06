import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  CoinData({required this.stringUrl});
  final String stringUrl;
  Future getCoinData() async {
    Uri url = Uri.parse(stringUrl);

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      var coinData = jsonDecode(data);
      var r = coinData['rate'];

      return r.toStringAsFixed(0);
    } else {
      print(response.statusCode);

      return 'Price not available';
    }
  }
}
