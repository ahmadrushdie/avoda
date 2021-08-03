import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:http/http.dart';

enum RequestType { GET, POST, DELETE, PATCH }

class NetworkClient {
  // 1
  static NetworkClient client;
  static const String _baseUrl = BASE_URL;
  // 2
  final Client _client;
  NetworkClient(this._client);
  // 3
  static Map<dynamic, dynamic> headers;
  static NetworkClient getInstance() {
    headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": User.authToken
    };

    // if (client == null) {
    return NetworkClient(Client());
    // } else {
    //   return client;
    // }
  }

  Future<Response> request(
      {@required RequestType requestType,
      @required String path,
      dynamic parameter}) async {
    switch (requestType) {
      case RequestType.GET:
        if (parameter != null) {
          var uri = Uri.https(_baseUrl, path, parameter);
          return _client.get(uri, headers: headers);
        } else {
          return _client.get(Uri.https(_baseUrl, path), headers: headers);
        }
        break;
      case RequestType.POST:
        if (parameter != null) {
          return _client.post(Uri.https(_baseUrl, path),
              headers: headers, body: jsonEncode(parameter));
        } else {
          return _client.post(Uri.https(_baseUrl, path), headers: headers);
        }

        break;
      case RequestType.PATCH:
        return _client.patch(Uri.https(_baseUrl, path),
            headers: headers, body: jsonEncode(parameter));

      case RequestType.DELETE:
        if (parameter != null) {
          return _client.delete(Uri.https(_baseUrl, path),
              headers: headers, body: jsonEncode(parameter));
        } else {
          return _client.delete(Uri.https(_baseUrl, path), headers: headers);
        }
        break;
      default:
    }
  }
}
