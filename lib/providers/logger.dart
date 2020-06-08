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


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:f_logs/f_logs.dart';
import 'dart:convert';
import 'package:logger/logger.dart';


/// LoggerProvider.
abstract class LoggerProvider {
  static final log = Logger(
    printer: PrettyPrinter(
      methodCount: 3,       // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120,    // width of the output
      colors: true,       // Colorful log messages
      printEmojis: true,  // Print an emoji for each log message
      printTime: true    // Should each log print contain a timestamp
    ),
  );

  /// Logs information.
  static void info({
    @required String message,
    /*@required*/ String className,
    /*@required*/ String methodName,
    Exception exception,
    StackTrace stackTrace,
  })
  {
    log.i(message, exception, stackTrace);
  }

  /// Logs an error.
  static void error({
    @required String message,
    /*@required*/ String className,
    /*@required*/ String methodName,
    Exception exception,
    StackTrace stackTrace,
  })
  {
    log.e(message, exception, stackTrace);
  }


}
