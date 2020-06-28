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


import 'package:flutter/foundation.dart';
import 'package:f_logs/f_logs.dart';
import 'package:logger/logger.dart';



/// LoggerProvider.
abstract class LoggerProvider {

  /// Logging to the Device.
  static const int LEVEL_DEVICE = 0x00000001;

  // Logging to the Console.
  static const int LEVEL_CONSOLE = 0x00000010;
  

  /// Whether logging to the device is enabled or not.
  static int _logLevel = LEVEL_CONSOLE | LEVEL_DEVICE;


  static final _log = Logger(
    printer: PrettyPrinter(
      methodCount: 3,       // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120,    // width of the output
      colors: true,       // Colorful log messages
      printEmojis: true,  // Print an emoji for each log message
      printTime: true    // Should each log print contain a timestamp
    ),
  );



  ///
  /// Sets or gets whether logging to the device is enabled or not.
  /// 
  static int isDeviceLogging([int logLevel]) {
    if (logLevel != null) {
      logLevel = _logLevel;
    }
    return _logLevel;
  }

  /// Logs information.
  static void info({
    @required String message,
    /*@required*/ String className,
    /*@required*/ String methodName,
    Exception exception,
    StackTrace stackTrace,
  })
  {
    if (_isLevelBitTurnedOn(LEVEL_CONSOLE)) {
      _log.i(message, exception, stackTrace);
    }
  }

  /// Logs an error.
  static void error({
    @required String message,
    /*@required*/ String className,
    /*@required*/ String methodName,
    Exception exception,
    StackTrace stacktrace,
  })
  {
    if (_isLevelBitTurnedOn(LEVEL_CONSOLE)) {
      _log.e(message, exception, stacktrace);
    }
    if (_isLevelBitTurnedOn(LEVEL_DEVICE)) {
      FLog.error(
        text: message,
        stacktrace: stacktrace,
        exception: exception,
        methodName: message,
        className: className,
      );
    }
  }

  /// Whether bit is turned on or not.
  static bool _isLevelBitTurnedOn(int bit) => _logLevel & bit != 0;

}
