import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '2E004014-2AC2-4B77-BBD3-5700EA47CE04';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  String rate = '?';
  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getAllData();
          },
        );
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getAllData();
        });
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getAllData() async {
    isWaiting = true;
    Map<String, String> prices = {};
    for (String crypto in cryptoList) {
      prices[crypto] = await getData(selectedCurrency, crypto);
    }
    isWaiting = false;
    setState(() {
      coinValues = prices;
    });
  }

  Future<String> getData(String? currency, String cryptocurrency) async {
    CoinData coin = CoinData(
        stringUrl: '$coinAPIURL/$cryptocurrency/$currency?apiKey=$apiKey');

    String price = await coin.getCoinData();

    return price;
  }

  List<CryptoCard> getCryptoCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      CryptoCard cr = CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          rate: isWaiting ? '?' : coinValues[crypto]);
      cryptoCards.add(cr);
    }

    return cryptoCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCryptoCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard(
      {required this.cryptoCurrency,
      required this.selectedCurrency,
      required this.rate});
  final String? rate;
  final String? selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
