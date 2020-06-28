///
/// Marvin Kagiso
/// 18:10 2020/06/16
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

import './logger.dart';


/// Encapsulates a Storage Box.
/// The app shall use one storage box, and store values with different keys.
abstract class StorageProvider {
  static const _boxName = 'mc_session';
  static Box _box;

  /// Initializes the Storage Box.
  static Future<void> init() async {
    try {
      _box = await Hive.openBox(_boxName);
      return Future.value();
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error initializing StorageProvider.',
        className: 'StorageProvider',
        methodName: 'init',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Writes a [value] to the box [key].
  static Future<void> putValue(String key, dynamic value) async {
    try {
      return await _box.put(key, value);
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error putAt StorageProvider.',
        className: 'StorageProvider',
        methodName: 'putValue',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Gets value stored at [key].
  static Future<dynamic> getValue(String key) async {
    try {
      return await _box.get(key);
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error getValueAsync StorageProvider.',
        className: 'StorageProvider',
        methodName: 'getValueAsync',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Closes the Storage Box.
  static dispose() async {
    try {
      _box?.close();
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error closing StorageProvider.',
        className: 'StorageProvider',
        methodName: 'dispose',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }

  /// Clears all the entires from the storage box.
  static clearAll() async {
    try {
      _box?.clear();
    }
    catch (e, s) {
      LoggerProvider.error(
        message: 'Error clearing all from StorageProvider.',
        className: 'StorageProvider',
        methodName: 'clearAll',
        exception: e,
        stacktrace: s
      );
      return Future.error(e);
    }
  }
}
