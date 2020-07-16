
///
/// Marvin Kagiso
/// 18:48 2020/06/16
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


import 'dart:io';
import 'package:flutter/foundation.dart';

import '../apis/abstract_app_api.dart';
import '../providers/logger.dart';
import '../.env.dart';
import '../models/country_info.dart';
import '../models/province_info.dart';
import '../models/province_timeline.dart';


/// For performing HTTP to the App Server requests.
class CoronaApi extends AbstractAppApi {
  CoronaApi() : super();

  /// Gets the Stats of a coutry.
  Future<CountryInfo> getCountryStats({@required String isoCode}) async {
    try {
      final url = Env.APP_BASE_URL + 'countries/' + isoCode;
      final result = await this.basicGet(url);
      
      if (result.statusCode == HttpStatus.ok) {
        final CountryInfo countryInfo = CountryInfo.fromJson(result.data);
        return countryInfo;
      }

      throw result.statusMessage;
    }
    catch (e, s) {
      // Already logged.

      return Future.error(e, s);
    }
  }


  /// Gets the Stats of a Province specified by [isoCode].
  Future<ProvinceInfo> getProvinceStats({@required String isoCode}) async {
    try {
      final url = Env.APP_BASE_URL + 'provinces/' + isoCode;
      final result = await this.basicGet(url);

      if (result.statusCode == HttpStatus.ok) {
        final ProvinceInfo provinceInfo = ProvinceInfo.fromJson(result.data);
        return provinceInfo;
      }

      throw result.statusMessage;
    }
    catch (e, s) {
      // Already logged.

      return Future.error(e, s);
    }
  }

  /// Gets the Stats of all Provinces of a Country specified by [isoCode].
  Future<List<ProvinceInfo>> getAllCountryProvinceStats({@required String isoCode}) async {
    try {
      final url = Env.APP_BASE_URL + 'countries/$isoCode/provinces';
      final result = await this.basicGet(url);
      List<ProvinceInfo> provincesList = List();

      if (result.statusCode == HttpStatus.ok && result.data['data'] is List) {
        final List<dynamic> provincesRaw = result.data['data'];

        for (int i = 0; i < provincesRaw.length; ++i) {
          final Map<String, dynamic> e = provincesRaw[i];
          final p = ProvinceInfo.fromJson(e);
          provincesList.add(p);
        }

        return provincesList;
      }

      throw result.statusMessage;
    }
    catch (e, s) {
      // Already logged.

      return Future.error(e, s);
    }
  }

  /// Gets the Stats of a Province specified by [isoCode].
  Future<List<ProvinceTimeline>> getProvinceTimelineMonths({@required String isoCode}) async {
    try {
      final url = Env.APP_BASE_URL + 'provinces/' + isoCode + '/timeline/months';
      final result = await this.basicGet(url);
      List<ProvinceTimeline> provinceData = List();

      if (result.statusCode == HttpStatus.ok) {
        final List<dynamic> provincesDataRaw = result.data;

        for (int i = 0; i < provincesDataRaw.length; ++i) {
          final Map<String, dynamic> e = provincesDataRaw[i];
          final p = ProvinceTimeline.fromJson(e);
          provinceData.add(p);
        }

        return provinceData;
      }

      throw result.statusMessage;
    }
    catch (e, s) {
      // Already logged.

      return Future.error(e, s);
    }
  }

  /// Gets the Day Stats of a Province specified by [isoCode], [year] and [month] specifiy which days data will be pulled.
  Future<List<ProvinceTimeline>> getProvinceTimelineMonthDays({@required String isoCode, @required int year, @required int month}) async {
    try {
      final url = Env.APP_BASE_URL + 'provinces/$isoCode/timeline/days/$year/$month';
      final result = await this.basicGet(url);
      List<ProvinceTimeline> provinceMonthDaysData = List();

      if (result.statusCode == HttpStatus.ok) {
        final List<dynamic> provincesDataRaw = result.data;

        for (int i = 0; i < provincesDataRaw.length; ++i) {
          final Map<String, dynamic> e = provincesDataRaw[i];
          provinceMonthDaysData.add(ProvinceTimeline.fromJson(e));
        }

        return provinceMonthDaysData;
      }

      throw result.statusMessage;
    }
    catch (e, s) {
      // Already logged.

      return Future.error(e, s);
    }
  }
}
