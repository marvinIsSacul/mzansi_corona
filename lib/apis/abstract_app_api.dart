
///
/// Marvin Kagiso
/// 02:10 2020/06/15
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
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../entities/user.dart';
import '../apis/abstract_api.dart';
import '../providers/logger.dart';
import '../providers/session.dart';


/// Adds Authorization to the requests. 
class AbstractAppApi extends AbstractApi {
  AbstractAppApi() : super();

  /// Gets the options.
  @protected
  @override
  Future<Options> getOptions() async {
    final Options options = await super.getOptions();
    String username = '';
    String password = '';

    try {
      final User user = await SessionProvider.getUserSession();
      if (user != null) {
        username = user.id;
        password = user.token;
      }
    }
    catch (e) {
      // already logged.
    }
    
    options.headers['Authorization'] = 'Basic ' + base64.encode(utf8.encode(username + ':' + password));
    return options;
  }

  /// Does a basic GET request to endpoint specified by [url]
  /// With query params specified by [params].
  @override
  Future<Response> basicGet(String url, [Map<String, dynamic> params]) async {
    return super.basicGet(url, params);
  }

  /// Does a basic POST request to endpoint specified by [url]
  /// With query params specified by [data].
  @override
  Future<Response> basicPost(String url, [Map<String, dynamic> data]) async {
    return super.basicPost(url, data);
  }
}
