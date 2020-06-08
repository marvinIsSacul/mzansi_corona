
///
/// Marvin Kagiso
/// 18:10 2020/06/06
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


/// The Province's Corona Info.
class ProvinceInfo {
  String name;
  int numInfections;
  int numDeaths;
  int numRecovered;
  int numTests;

  Color colour;
  String imageUrlSm;
  String imageUrlMd;

  ProvinceInfo({
    this.name,
    this.numDeaths,
    this.numInfections,
    this.numRecovered,
    this.numTests,
    this.imageUrlSm,
    this.imageUrlMd,
    this.colour,
  });
}
