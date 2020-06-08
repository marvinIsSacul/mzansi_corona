
///
/// Marvin Kagiso
/// 18:10 2020/06/06
/// 
/// This file is part of mzansi_corona.

/// mzansi_corona is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.

/// mzansi_corona is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.

/// You should have received a copy of the GNU General Public License
/// along with mzansi_corona.  If not, see <https://www.gnu.org/licenses/>.


import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:f_logs/f_logs.dart';
import 'dart:convert';


/// Contains similar methods.
class AbstractApi {

  /// The default HTTP client.
  final _http = Dio();

  /// Initializes the object.
  AbstractApi() {
    this._addInterceptors();
  }

  void _addInterceptors() {
    http.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        FLog.debug(
          text: jsonEncode(options),
          className: this.runtimeType.toString(),
        );
        return options;
      },
      onResponse: (Response response) {
        FLog.debug(
          text: jsonEncode(response),
          className: this.runtimeType.toString(),
        );
        return response;
      },
      onError: (DioError error) {
        FLog.error(
          text: 'Request Error.',
          className: this.runtimeType.toString(),
         // methodName: 'basicGet',
          exception: error
        );
        return error;
      }
    ));
  }

  Future _getOptions() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final Options options = Options(
      receiveTimeout: 1000 * 30,
      sendTimeout: 1000 * 20,
      headers: {
        'User-Agent': '${info.appName}; ${info.version}'
      }
    );

    return options;
  }


  /// Gets the HTTP client.
  Dio get http => _http;
  
  /// Does a basic GET request to endpoint specified by [url]
  /// With query params specified by [params].
  Future basicGet(String url, [Map<String, dynamic> params]) async {
    try {
      final Response response = await http.get(url, queryParameters: params, options: await this._getOptions());
      return Future.value(response.data);
    }
    catch (e, s) {
      FLog.error(
        text: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicGet',
        stacktrace: s,
        exception: e,
      );
      return Future.error(e, s);
    }
  }
}
