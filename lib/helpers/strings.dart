///
/// Marvin Kagiso
/// 18:36 2020/06/06
/// 
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


import 'package:intl/intl.dart';


/// String methods
abstract class StringsHelper {
  /// Converts the String [dateTime] to DateTime.
  static DateTime dateTimeFromString(String dateTime) => DateTime.parse(dateTime);

  /// Converts the [dateTime] into a String.
  static String stringFromDateTime(DateTime dateTime) {
    final df = DateFormat.yMMMMEEEEd();
    return df.format(dateTime);
  }
}
