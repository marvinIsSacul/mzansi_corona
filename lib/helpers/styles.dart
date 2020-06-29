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


import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/province_info.dart';


///
/// Styles.
/// 
abstract class Styles {
	static const Color kColourGauteng = Colors.amber;
	static const Color kColourEasternCape = Colors.lightGreen;
	static const Color kColourWesternCape = Colors.lightBlue;
	static const Color kColourLimpopo = Colors.brown;
	static const Color kColourMpumalanga = const Color(0xFFE46472);
	static const Color kColourNorthenCape = Colors.deepOrange;
	static const Color kColourFreeState = const Color(0xFFF9BE7C);
	static const Color kColourNorthWest = Colors.black45;
	static const Color kColourKZN = const Color(0xFF309397);

	static const Color kColourAppPrimary = Colors.deepPurple;
	static const Color kColourAppSecondary = Colors.deepOrange;
	static const Color kColourAppTextPrimary = const Color(0xffffffdd);

  static const Color kColourInfections = Colors.amberAccent;
  static const Color kColourTests = Colors.lightBlueAccent;
  static const Color kColourDeaths = Colors.redAccent;
  static const Color kColourRecoveries = Colors.greenAccent;

  /// Gets the [province] image.
  static String provinceImage(ProvinceInfo province) {
    final String code = province.isoCode.toLowerCase().split('-').elementAt(1);
    return 'assets/images/$code-bg.jpg';
  }

  /// Gets the [province] colour.
  static Color provinceColour(ProvinceInfo province) {
    final String code = province.isoCode.toLowerCase();
    switch (code) {
      case 'za-gp':
        return Styles.kColourGauteng;
      case 'za-ec':
        return Styles.kColourEasternCape;
      case 'za-wc':
        return Styles.kColourWesternCape;
      case 'za-nc':
        return Styles.kColourNorthenCape;
      case 'za-nw':
        return Styles.kColourNorthWest;
      case 'za-kzn':
        return Styles.kColourKZN;
      case 'za-mp':
        return Styles.kColourMpumalanga;
      case 'za-lp':
        return Styles.kColourLimpopo;
      case 'za-fs':
        return Styles.kColourFreeState;
      default:
        throw 'Unknown Province Colour: ' + code;
    }
  }
}
