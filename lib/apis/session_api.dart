
///
/// Marvin Kagiso
/// 02:22 2020/06/15
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


import 'dart:convert';
import 'dart:io' show HttpStatus, Platform;
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

import '../providers/session.dart';
import '../apis/abstract_app_api.dart';
import '../providers/logger.dart';
import '../entities/user.dart';
import '../.env.dart';


/// For performing HTTP to the App Server requests.
class SessionApi extends AbstractAppApi {
  SessionApi() : super();

  /// Creates an anonymous account.
  Future<User> createAccount() async {
    final url = Env.APP_BASE_URL + '';

    try {
      final User userInfo = await this._getDeviceInfo();
      final result = await this.basicGet(url, userInfo.toJson());

      if (result.statusCode == HttpStatus.created) {
        final Map json = result.data;
        final createdUser = User.fromJson(json);
        await SessionProvider.saveUserSession(createdUser);
        return Future.value(createdUser);
      }
      else {
        throw Exception();
      }
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Could not create account',
        exception: e,
        className: this.runtimeType.toString(),
        methodName: 'createAccount',
        stacktrace: s
      );

      return Future.error(e);
    }
  }

  /// Gets the device info. The calling method should handle the exceptions.
  Future<User> _getDeviceInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo android = await deviceInfo.androidInfo;
    final IosDeviceInfo ios = await deviceInfo.iosInfo;
    final Function getPlatform = (onAndroid, onIos) => Platform.isAndroid ? onAndroid : onIos;

    return User(
      appVersion: packageInfo.version,
      firstAppVersion: packageInfo.version,
      token: getPlatform(android.androidId, ios.identifierForVendor),
      deviceBaseOS: getPlatform('android', 'ios'),
      deviceOsVersion: getPlatform(android.version, ios.systemVersion),
      deviceOEM: getPlatform(android.manufacturer, 'Apple'),
      deviceRawInfo: {
        'package': packageInfo.packageName,
        'model': getPlatform(android.model, ios.utsname.machine),
        'isPhysicalDevice': getPlatform(android.isPhysicalDevice, ios.isPhysicalDevice),
       // 'isPhysicalDevice': getPlatform(android.board, ios.utsname.sysname),
      },
    );
  }
}
