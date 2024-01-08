import 'dart:convert';
// import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:http/http.dart' as http;

String apikey = YOUR_API_KEY;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selected = "USD";
  int first = 45060;
  int second = 2263;
  int third = 65;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $first $selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $second $selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
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
                  '1 LTC = $third $selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS?getCupertinoPicker():getDropdownButton(),
            child: getDropdownButton(),
          ),
        ],
      ),
    );
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    // Dropdown Menu
    for (var i = 0; i < currenciesList.length; i++) {
      dropdownItems.add(DropdownMenuItem(
        value: currenciesList[i],
        child: Text(currenciesList[i]),
      ));
    }

    return DropdownButton<String>(
      dropdownColor: Colors.lightBlue,
      value: selected,
      items: dropdownItems,
      onChanged: (value) async {
        setState(() {
          selected = value!;
        });
        var data1 = await getBitcoinValue(selected);
        var data2 = await getEtheriumValue(selected);
        var data3 = await getLitecoinValue(selected);
        setState(() {
          first = data1;
          second = data2;
          third = data3;
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> dropdownItems = [];

    // Dropdown Menu
    for (var i = 0; i < currenciesList.length; i++) {
      dropdownItems.add(Text(currenciesList[i]));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (value) async {
        setState(() {
          selected = currenciesList[value];
        });
        var data1 = await getBitcoinValue(selected);
        var data2 = await getEtheriumValue(selected);
        var data3 = await getLitecoinValue(selected);
        setState(() {
          first = data1;
          second = data2;
          third = data3;
        });
      },
      children: dropdownItems,
    );
  }

  Future<int> getBitcoinValue(String currency) async {
    var url = Uri.https(
      'rest.coinapi.io',
      'v1/exchangerate/BTC/$currency',
      {
        'apikey': apikey,
      },
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var rate = jsonResponse["rate"].toInt();
      return rate;
    } else {
      return -1;
    }
  }

  Future<int> getEtheriumValue(String currency) async {
    var url = Uri.https(
      'rest.coinapi.io',
      'v1/exchangerate/ETH/$currency',
      {
        'apikey': apikey,
      },
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse["rate"].toInt();
    } else {
      return -1;
    }
  }

  Future<int> getLitecoinValue(String currency) async {
    var url = Uri.https(
      'rest.coinapi.io',
      'v1/exchangerate/LTC/$currency',
      {
        'apikey': apikey,
      },
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse["rate"].toInt();
    } else {
      return -1;
    }
  }
}
