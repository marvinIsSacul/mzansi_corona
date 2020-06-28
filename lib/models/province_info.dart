
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
import 'package:json_annotation/json_annotation.dart';

part 'province_info.g.dart';

/// The Province's Corona Info.
@JsonSerializable(explicitToJson: true)
class ProvinceInfo {
  @JsonKey(name: 'name', nullable: false, required: true)
  String name;

  @JsonKey(name: 'iso_code', nullable: false, required: true)
  String isoCode;

  @JsonKey(name: 'infections', nullable: true)
  int numInfections;

  @JsonKey(name: 'deaths', nullable: true)
  int numDeaths;

  @JsonKey(name: 'recoveries', nullable: true)
  int numRecovered;

  @JsonKey(name: 'tests', nullable: true)
  int numTests;

  ProvinceInfo({
    this.name,
    this.isoCode,
    this.numDeaths,
    this.numInfections,
    this.numRecovered,
    this.numTests,
  });

  factory ProvinceInfo.fromJson(Map<String, dynamic> json) => _$ProvinceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ProvinceInfoToJson(this);
}
