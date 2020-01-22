
import 'package:http/http.dart' as net;
import 'dart:convert';
import 'coin_data.dart';

const String url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class NetworkHelper {

    dynamic getData(String symbol) async {

        Map result = {};
        for(String coin in cryptoList) {
            var data = await net.get('$url$coin$symbol');
            if (data.statusCode == 200 && data.body != null) {
                var json = jsonDecode(data.body);
                result[coin] = json['last'].toString();
            }
        }
        return result;
    }
}