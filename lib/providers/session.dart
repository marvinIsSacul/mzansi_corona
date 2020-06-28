
///
/// Marvin Kagiso
/// 18:10 2020/06/06
// 
// This file is part of mzansi_corona.

// mzansi_corona is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// mzansi_corona is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with mzansi_corona.  If not, see <https://www.gnu.org/licenses/>.
// 


import 'package:hive/hive.dart';
import 'dart:convert';

import '../providers/logger.dart';
import '../entities/user.dart';


/// SessionProvider.
abstract class SessionProvider {
  static Box _box;
  static const _boxName = 'mc_session';
  static const _key = 'data';


  /// Initializes the box.
  static Future<void> init() async {
    try {
      _box = await Hive.openBox(_boxName);
      return Future.value();
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error initializing UserSession.',
        className: 'SessionProvider',
        methodName: 'clearUserSession',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Closes the box.
  static Future<void> dispose() async {
    try {
      await _box.close();
      return Future.value();
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error disposing UserSession.',
        className: 'SessionProvider',
        methodName: 'dispose',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Whether user is logged in or not.
  /// Always resolves to [true] or [false].
  static Future<bool> isLoggedIn() async {
    try {
      final user = await getUserSession();
      return Future.value(user != null);
    }
    catch (e) {
      // Already logged the error.
      return Future.value(false);
    }
  }

  /// Deletes the User session.
  static Future<void> clearUserSession() async {
    try {
      await _box.delete(_key);
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error clearing UserSession.',
        className: 'SessionProvider',
        methodName: 'clearUserSession',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  ///
  /// Saves the User session.
  /// 
  static Future<void> saveUserSession(User user) async {
    try {
      await _box.put(_key, jsonEncode(user));
      return Future.value();
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error saving UserSession.',
        className: 'SessionProvider',
        methodName: 'saveUserSession',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Gets the previously saved UserSession. Or null if there isn't.
  static Future<User> getUserSession() async {
    try {
      final String json = _box.get(_key);
      if (json != null) {
        final User user = User.fromJson(jsonDecode(json));
        return Future.value(user);
      }
      return Future.value(null);
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error getting UserSession.',
        className: 'SessionProvider',
        methodName: 'getUserSession',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }
}
