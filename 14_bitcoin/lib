// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

const apikey = '55E7414B-9BD8-4F17-ABF3-C47F59B51B66';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String exchangeCurrency = '?';
  Map<String, String> coinValueMap = {};

  @override
  void initState() {
    // getExchange(selectedCurrency); // my implementation
    getData2(selectedCurrency);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getElements(),
              // children: [
              //   ExchangeElement(sourceCurrency: 'test', exchangeCurrency: exchangeCurrency, selectedCurrency: selectedCurrency),
              // ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCuptertinoPicker() : getDropDownButton()
            // child: CupertinoPicker(
            //   backgroundColor: Colors.lightBlue,
            //   scrollController: FixedExtentScrollController(initialItem: 19),
            //   itemExtent: 32,
            //   onSelectedItemChanged: (index) {
            //     print(index);
            //   },
            //   children: generateCupertinoList(),
            // )
            // child: DropdownButton<String>(
            //   items: generateList(),
            //   onChanged: (value) {
            //     print('selected $value');
            //     setState(() {
            //       selectedCurrency = value.toString();
            //     });
            //   },
            //   value: selectedCurrency, // sets default value
            // ),
          ),
        ],
      ),
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getCuptertinoPicker();
    } else if (Platform.isAndroid) {
      return getDropDownButton();
    } else {
      return Text('error');
    }
  }

  // generate Material variant of selector
  DropdownButton<String> getDropDownButton() {
    List<DropdownMenuItem<String>> temp = [];
    for (String s in currenciesList) {
      temp.add(DropdownMenuItem(child: Text(s), value: s));
    }

    return DropdownButton<String>(
      items: temp,
      onChanged: (value) {
        print('selected $value');
        setState(() {
          selectedCurrency = value.toString();
          getData(selectedCurrency);
        });
      },
      value: selectedCurrency, // sets default value
    );
  }

  // generate Cupertino variant of selector
  CupertinoPicker getCuptertinoPicker() {
    List<Text> temp = [];
    for (String s in currenciesList) {
      temp.add(Text(s));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      scrollController: FixedExtentScrollController(initialItem: 19),
      itemExtent: 32,
      onSelectedItemChanged: (index) {
        print(index);
      },
      children: temp,
    );
  }

  Future<String> getExchange(String v_currency) async {
    http.Response response = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$v_currency?apikey=$apikey'));
    
    if (response.statusCode == 200) {
      String data = response.body;
      Map json = jsonDecode(data);
      print(data);
      setState(() {
        exchangeCurrency = json['rate'].round().toString();
      });
      return json['rate'].round().toString();
    }
    return '';
  }

  List<ExchangeElement> getElements() {
    List<ExchangeElement> list = [];

    for (String s in cryptoList) {
      // var data = getData2(s, selectedCurrency);
      if (coinValueMap[s] == null) {
        coinValueMap[s] = '?';
      }
      ExchangeElement t = ExchangeElement(sourceCurrency: s, exchangeCurrency: coinValueMap[s]!, selectedCurrency: selectedCurrency);
      list.add(t);
    }

    return list;
  }

  void getData(String v_selectedCurrency) async {
    try {
      double data = await CoinData().getCoinData(v_selectedCurrency);
      setState(() {
        exchangeCurrency = data.toStringAsFixed(0);
      });
    } catch(e) {
      print(e);
    }
  }

  void getData2(String v_selectedCurrency) async {
    try {
      Map<String, String> data = await CoinData().getCoinData2(v_selectedCurrency);
      setState(() {
        coinValueMap = data;
      });
      // return exchangeCurrency = data.toStringAsFixed(0);
    } catch(e) {
      print(e);
    }
  }

  // List<DropdownMenuItem<String>> generateList() {
  //   List<DropdownMenuItem<String>> temp = [];
  //   for (String s in currenciesList) {
  //     temp.add(DropdownMenuItem(child: Text(s), value: s));
  //   }
  //   return temp;
  // }

  // generate Cupertino variant of selector
  // List<Text> generateCupertinoList() {
  //   List<Text> temp = [];
  //   for (String s in currenciesList) {
  //     temp.add(Text(s));
  //   }
  //   return temp;
  // }
}

class ExchangeElement extends StatelessWidget {
  const ExchangeElement({
    Key? key,
    required this.sourceCurrency,
    required this.exchangeCurrency,
    required this.selectedCurrency,
  }) : super(key: key);

  final String exchangeCurrency;
  final String selectedCurrency;
  final String sourceCurrency;

  

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $sourceCurrency = $exchangeCurrency $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CoinData {
  Future getCoinData(v_selectedCurrency) async {

    Map<String, String> prices = {};

    for (String s in cryptoList) {
      http.Response response = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/$s/$v_selectedCurrency?apikey=$apikey'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var lastPrice = data['rate'];
        prices[s] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'problem with GET';
      }
    }

    return prices;



    // http.Response response = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$v_selectedCurrency?apikey=$apikey'));

    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body);
    //   var lastPrice = data['rate'];
    //   return lastPrice;
    // } else {
    //   print(response.statusCode);
    //   throw 'problem with GET';
    // }
  }

  Future<Map<String, String>> getCoinData2(v_selectedCurrency) async {
    Map<String, String> prices = {};

    for (String s in cryptoList) {
      http.Response response = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/$s/$v_selectedCurrency?apikey=$apikey'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var lastPrice = data['rate'];
        prices[s] = lastPrice.toStringAsFixed(2);
      } else {
        print(response.statusCode);
        throw 'problem with GET';
      }
    }

    return prices;
  }
}

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
  'DOGE'
];
