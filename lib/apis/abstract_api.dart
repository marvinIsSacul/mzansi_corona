
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
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'dart:convert';

import '../providers/logger.dart';


/// For performing HTTP requests.
class AbstractApi {

  /// The default HTTP client.
  final _http = Dio();

  /// Initializes the object.
  AbstractApi() {
    this.addInterceptors();
  }

  @protected
  void addInterceptors() {
    http.interceptors.add(InterceptorsWrapper (
      onRequest: (RequestOptions options) async {
        LoggerProvider.info(
          message: 'Sending HTTP request...\n'
            + 'URL: ${options.uri.toString()}\n'
            + "Headers: ${options.headers.toString()}\n"
            + 'Params: ' + options.queryParameters.toString(),
        );
        return options;
      },
      onResponse: (Response response) async {
        LoggerProvider.info(
          message: 'HTTP reponse Headers:\n' + response.headers.toString() + '\n'
            + 'HTTP response:\n' + (response.data.toString()) + '\n'
        );
        return response;
      },
      onError: (DioError error) async {
        // LoggerProvider.error(
        //   message: 'Request Error.',
        //   exception: error
        // );
        return error;
      }
    ));
  }

  /// Gets the HTTP options.
  @protected
  Future<Options> getOptions() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final Options options = Options(
      receiveTimeout: 1000 * 20,
      sendTimeout: 1000 * 20,
      validateStatus: (int status) => status < 500,
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
  Future<Response> basicGet(String url, [Map<String, dynamic> params]) async {
    try {
      final Response response = await http.get(url, queryParameters: params, options: await this.getOptions());
      return Future.value(response);
    }
    on DioError catch(e, s) {
      LoggerProvider.error(
        message: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicGet',
        stacktrace: s,
        exception: e,
      );
      return Future.error(e, s);
    }
    on FlutterError catch(e, s) {
      LoggerProvider.error(
        message: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicGet',
        stacktrace: s,
        //exception: e,
      );
      return Future.error(e, s);
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicGet',
        stacktrace: s,
        exception: e,
      );
      return Future.error(e, s);
    }
  }

  /// Does a basic POST request to endpoint specified by [url]
  /// With query params specified by [data].
  Future<Response> basicPost(String url, [Map<String, dynamic> data]) async {
    try {
      final Response response = await http.post(url, data: data, options: await this.getOptions());
      return Future.value(response.data);
    }
    on DioError catch(e, s) {
      LoggerProvider.error(
        message: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicPost',
        stacktrace: s,
        exception: e,
      );
      return Future.error(e, s);
    }
    on FlutterError catch(e, s) {
      LoggerProvider.error(
        message: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicPost',
        stacktrace: s,
        //exception: e,
      );
      return Future.error(e, s);
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Request Error.',
        className: this.runtimeType.toString(),
        methodName: 'basicPost',
        stacktrace: s,
        exception: e,
      );
      return Future.error(e, s);
    }
  }
}
