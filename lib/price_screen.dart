import 'dart:math';

import 'package:bitcoin_ticker/network_helper.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var selectedCurrency = 'INR';
  Map map = {};

  @override
  void initState() {
    super.initState();

    refreshData(selectedCurrency);
  }

  void refreshData(String selectedCurrency) async {

    setState(() {
      this.map = {};
    });
    this.selectedCurrency = selectedCurrency;
    var map = await NetworkHelper().getData(selectedCurrency);
    setState(() {
      this.map = map;
    });
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
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }

  Column makeCards() {
    List<Widget> widgets = [];
    for(String coinName in cryptoList) {
      widgets.add(CryptoCard(coinName: coinName, currency: selectedCurrency, value: map[coinName],));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets,);
  }

  Widget getIOSPicker() {
    List<Text> dropDownMenuItems = [];
    for (String currency in currenciesList) {
      dropDownMenuItems.add(
          Text(currency)
      );
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (index) {
        refreshData(currenciesList[index]);
      },
      children: dropDownMenuItems,
      backgroundColor: Colors.lightBlue,
    );
  }

  Widget getAndroidPicker() {

    List<DropdownMenuItem<String>> dropDownMenuItems = [];
    for (String currency in currenciesList) {
      dropDownMenuItems.add(
          DropdownMenuItem(
            value: currency,
            child: Text(currency),
          ));
    }
    return DropdownButton(items: dropDownMenuItems, onChanged: (selectedCurrency) async {

      refreshData(selectedCurrency);
    },
      value: selectedCurrency,);
  }

  Widget getPicker() {
    if (Platform.isIOS)
      return getIOSPicker();
    else
      return getAndroidPicker();
  }
}

class CryptoCard extends StatelessWidget {

  final String coinName;
  final String currency;
  final String value;

  const CryptoCard({this.coinName, this.currency, this.value});

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
          '1 $coinName = ${value != null ? value : "Fetching..."} $currency',
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
